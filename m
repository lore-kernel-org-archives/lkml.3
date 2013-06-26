Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab3FZFQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:16:04 -0400
Received: from intranet.asianux.com ([58.214.24.6]:7290 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3FZFQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:16:01 -0400
X-Spam-Score: -100.8
Message-ID: <51CA476B.3080208@asianux.com>
Date: Wed, 26 Jun 2013 09:44:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        cornelia.huck@de.ibm.com, mtosatti@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: s390: kernel: reset 'c->hotpluggable' when failure
 occurs
References: <51C8F685.6000209@asianux.com> <20130625064832.GA4999@osiris> <51C94599.1020707@asianux.com> <20130625090928.GA8981@osiris> <51C9636F.1050709@asianux.com>
In-Reply-To: <51C9636F.1050709@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 05:31 PM, Chen Gang wrote:
> On 06/25/2013 05:09 PM, Heiko Carstens wrote:
>> On Tue, Jun 25, 2013 at 03:24:09PM +0800, Chen Gang wrote:
>>> On 06/25/2013 02:48 PM, Heiko Carstens wrote:
>>>> On Tue, Jun 25, 2013 at 09:46:45AM +0800, Chen Gang wrote:
>>>>>> When smp_add_present_cpu() fails, it has reset all things excluding
>>>>>> 'c->hotpluggable', so need reset it as original state completely.
>>>>>>
>>>>>> +	c->hotpluggable = 0;
>>>>>>  	return rc;
>>>> No, that doesn't make sense. All cpus on s390 are always hotplugable.
>>>> It really doesn't matter if the value of this field is 0 or 1 after
>>>> an error.
>>>>
>>>
>>> If so, is it better to set 'c->hotpluggable' for all cpus on s390 during
>>> initializing ?
>>
> No, just leave the code as it is.
>>
> 

Please help check the diff below whether is valuable, thanks.


For architectures which may support 'hotpluggable', can loop all cpus
during subsys_initcall().

The caller will skip the return value of subsys_initcall(), so can only
return 0.

--------------------------------diff begin------------------------------

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 15a016c..147cc18 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -1065,8 +1065,9 @@ static int __init s390_smp_init(void)
 #endif
 	for_each_present_cpu(cpu) {
 		rc = smp_add_present_cpu(cpu);
-		if (rc)
-			return rc;
+		if (unlikely(rc))
+			printk(KERN_WARNING "%s: register_cpu %d failed (%d)\n",
+			       __func__, cpu, rc);
 	}
 	return 0;
 }

--------------------------------diff end--------------------------------


> Currently we have 3 possible states for 'struct cpu':
>   initialized, and set hotplugable.
>   unitialized, and set hotplugable.
>   unitialized, and unset hotplugable.
> 
> Either 2nd or 3rd is inconsistent.
> 
> The cpu_is_hotplugable() will be used in kernel/rcutorture.c. I do not
> know whether it will cause issue or not, but it seems dangerous when
> __smp_rescan_cpus() has already called, and has some unsucessfull call
> of smp_add_present_cpu().
> 
> Please help check.
> 
> Thanks.
> 


-- 
Chen Gang

Asianux Corporation
