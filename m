Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3GJDCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:02:51 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:65420 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3GJDCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:02:50 -0400
Message-ID: <51DCCE96.9050600@gmail.com>
Date: Wed, 10 Jul 2013 11:01:42 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, khali@linux-fr.org,
        David.Woodhouse@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/params.c: print failure information instead of
 'KOBJ_ADD' to user space, when sysfs_create_file() fails.
References: <51DB8597.4090101@asianux.com> <87y59gcg17.fsf@rustcorp.com.au> <51DCC426.3010606@gmail.com> <51DCC867.70408@asianux.com>
In-Reply-To: <51DCC867.70408@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 10:35 AM, Chen Gang wrote:
> On 07/10/2013 10:17 AM, Chen Gang F T wrote:
>> On 07/09/2013 04:07 PM, Rusty Russell wrote:
>>> Chen Gang <gang.chen@asianux.com> writes:
>>>> When sysfs_create_file() fails, recommend to print the related failure
>>>> information. And it is useless to still 'KOBJ_ADD' to user space.
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>
>>> sysfs_create_file() should not fail during boot, should it?
>>>
>>
>> Hmm..., please reference locate_module_kobject() in "kernel/params.c",
>> which is an '__init' function, and also call sysfs_create_file(), it
>> processes the related error.
>>
>> So I recommend to get the check too in version_sysfs_builtin().
>>
> 
> Oh, also for locate_module_kobject(), if !CONFIG_MODULES, when error
> occurs, it still print the information about "Adding module".
> 


> Hmm..., do we need call kobject_get() before kobject_put() in failure
> processing block ?
> 

Oh, sorry for what I said for kobject_get/put() items above, it is
incorrect.

What about the diff below for kobject_get() ?

-------------------------------diff begin-------------------------------

diff --git a/kernel/params.c b/kernel/params.c
index 440e65d..ef8d720 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -754,11 +754,11 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
 				name, err);
 			return NULL;
 		}
-
-		/* So that we hold reference in both cases. */
-		kobject_get(&mk->kobj);
 	}
 
+	/* So that we hold reference in both cases. */
+	kobject_get(&mk->kobj);
+
 	return mk;
 }

-------------------------------diff end---------------------------------

And it also need add additional kobject_put(), if we really need
process the failure in version_sysfs_builtin().

Thanks.

> 
> 740                 mk = kzalloc(sizeof(struct module_kobject), GFP_KERNEL);
> 741                 BUG_ON(!mk);
> 742 
> 743                 mk->mod = THIS_MODULE;
> 744                 mk->kobj.kset = module_kset;
> 745                 err = kobject_init_and_add(&mk->kobj, &module_ktype, NULL,
> 746                                            "%s", name);
> 747 #ifdef CONFIG_MODULES
> 748                 if (!err)
> 749                         err = sysfs_create_file(&mk->kobj, &module_uevent.attr);
> 750 #endif
> 751                 if (err) {
> 752                         kobject_put(&mk->kobj);
> 753                         pr_crit("Adding module '%s' to sysfs failed (%d), the system may be unstable.\n",
> 754                                 name, err);
> 755                         return NULL;
> 756                 }
> 757 
> 758                 /* So that we hold reference in both cases. */
> 759                 kobject_get(&mk->kobj);
> 760         }
> 761 
> 762         return mk;
> 763 }
> 
> 
>> Thanks.
>>
>>> Cheers,
>>> Rusty.
>>>
>>>> ---
>>>>  kernel/params.c |    8 +++++++-
>>>>  1 files changed, 7 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/kernel/params.c b/kernel/params.c
>>>> index 440e65d..f5299c1 100644
>>>> --- a/kernel/params.c
>>>> +++ b/kernel/params.c
>>>> @@ -845,7 +845,13 @@ static void __init version_sysfs_builtin(void)
>>>>  		mk = locate_module_kobject(vattr->module_name);
>>>>  		if (mk) {
>>>>  			err = sysfs_create_file(&mk->kobj, &vattr->mattr.attr);
>>>> -			kobject_uevent(&mk->kobj, KOBJ_ADD);
>>>> +			if (err)
>>>> +				printk(KERN_WARNING
>>>> +				       "%s (%d): sysfs_create_file fail for %s, err: %d\n",
>>>> +				       __FILE__, __LINE__,
>>>> +				       vattr->module_name, err);
>>>> +			else
>>>> +				kobject_uevent(&mk->kobj, KOBJ_ADD);
>>>>  			kobject_put(&mk->kobj);
>>>>  		}
>>>>  	}
>>>> -- 
>>>> 1.7.7.6
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>>
> 
> 


-- 
Chen Gang
