Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab3DPM13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:27:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab3DPM11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:27:27 -0400
Date: Tue, 16 Apr 2013 14:26:53 +0200
From: Veaceslav Falico <vfalico@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, bhelgaas@google.com
Subject: Re: [PATCH] module: add kset_obj_exists() and use it
Message-ID: <20130416122653.GB31290@redhat.com>
References: <1365506529-8396-1-git-send-email-vfalico@redhat.com>
 <87y5cq6ei9.fsf@rustcorp.com.au>
 <20130411095537.GC21320@redhat.com>
 <87vc7o8r7o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87vc7o8r7o.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 11:56:03AM +0930, Rusty Russell wrote:
>Veaceslav Falico <vfalico@redhat.com> writes:
>> On Wed, Apr 10, 2013 at 04:47:34PM +0930, Rusty Russell wrote:
>>>That's a bug.  We should be cleaning up sysfs before we unlike the
>>>removed module from the list.
>>>
>>>Because the same thing applies to ddebug info, which is also keyed by
>>>module name.
>>>
>>>Something like this (untested!):
>>
>> Sorry for the late response - I wanted to test it for a longer time.
>>
>> Your patch works flawlessly and fixes this race, with just a small
>> addition, cause otherwise we could BUG() in show_initstate().
>>
>> Can you apply this patch or should I (re-)send it somehow?
>>
>> Thank you!
>>
>> diff --git a/kernel/module.c b/kernel/module.c
>> index d0afe23..8be6e97 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -1063,6 +1063,9 @@ static ssize_t show_initstate(struct module_attribute *mattr,
>>   	case MODULE_STATE_GOING:
>>   		state = "going";
>>   		break;
>> +	case MODULE_STATE_UNFORMED:
>> +		state = "unformed";
>> +		break;
>>   	default:
>>   		BUG();
>>   	}
>
>Prefer to remove from sysfs before marking it unformed, like so:
>
>diff --git a/kernel/module.c b/kernel/module.c
>index 2468fda..2e7189f 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -1862,12 +1862,12 @@ static void free_module(struct module *mod)
> {
> 	trace_module_free(mod);
>
>-	/* We leave it in list to prevent duplicate loads while we clean
>-	 * up sysfs, ddebug and any other external exposure. */
>-	mod->state = MODULE_STATE_UNFORMED;
>-
> 	mod_sysfs_teardown(mod);
>
>+	/* We leave it in list to prevent duplicate loads, but make sure
>+	 * that noone uses it while it's being deconstructed. */
>+	mod->state = MODULE_STATE_UNFORMED;
>+
> 	/* Remove dynamic debug info */
> 	ddebug_remove_module(mod->name);
>
>Here's the updated total patch:

Tested for a day on two reproducers on the latest upstream kernel, with the
recent kobject fix a49b7e82 ("kobject: fix kset_find_obj() race with
concurrent last kobject_put()") - it fixes the issue, no regressions met.

Without the patch (but with that kobject fix) it gives the following, for
parallel modprobe/rmmod of pch_gbe module (it's easier to reproduce on less
powerful boxes, like this one):

[  103.981925] ------------[ cut here ]------------
[  103.986902] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xab/0xd0()
[  103.993606] Hardware name: CrownBay Platform
[  103.998075] sysfs: cannot create duplicate filename '/module/pch_gbe'
[  104.004784] Modules linked in: pch_gbe(+) [last unloaded: pch_gbe]
[  104.011362] Pid: 3021, comm: modprobe Tainted: G        W    3.9.0-rc5+ #5
[  104.018662] Call Trace:
[  104.021286]  [<c103599d>] warn_slowpath_common+0x6d/0xa0
[  104.026933]  [<c1168c8b>] ? sysfs_add_one+0xab/0xd0
[  104.031986]  [<c1168c8b>] ? sysfs_add_one+0xab/0xd0
[  104.037000]  [<c1035a4e>] warn_slowpath_fmt+0x2e/0x30
[  104.042188]  [<c1168c8b>] sysfs_add_one+0xab/0xd0
[  104.046982]  [<c1168dbe>] create_dir+0x5e/0xa0
[  104.051633]  [<c1168e78>] sysfs_create_dir+0x78/0xd0
[  104.056774]  [<c1262bc3>] kobject_add_internal+0x83/0x1f0
[  104.062351]  [<c126daf6>] ? kvasprintf+0x46/0x60
[  104.067231]  [<c1262ebd>] kobject_add_varg+0x2d/0x50
[  104.072450]  [<c1262f07>] kobject_init_and_add+0x27/0x30
[  104.078075]  [<c1089240>] mod_sysfs_setup+0x80/0x540
[  104.083207]  [<c1260851>] ? module_bug_finalize+0x51/0xc0
[  104.088720]  [<c108ab29>] load_module+0x1429/0x18b0
[  104.093712]  [<c1088510>] ? free_notes_attrs+0x40/0x40
[  104.098973]  [<c126c588>] ? _copy_from_user+0x38/0x130
[  104.104225]  [<c108b0c3>] sys_init_module+0x93/0xb0
[  104.109211]  [<c16f22fa>] sysenter_do_call+0x12/0x22
[  104.114272] ---[ end trace aa239ae9897b5680 ]---
[  104.119029] ------------[ cut here ]------------
[  104.123901] WARNING: at lib/kobject.c:196 kobject_add_internal+0x1da/0x1f0()
[  104.131254] Hardware name: CrownBay Platform
[  104.135792] kobject_add_internal failed for pch_gbe with -EEXIST, don't try to register things with the same name in the same directory.
[  104.148539] Modules linked in: pch_gbe(+) [last unloaded: pch_gbe]
[  104.155256] Pid: 3021, comm: modprobe Tainted: G        W    3.9.0-rc5+ #5
[  104.162437] Call Trace:
[  104.165057]  [<c103599d>] warn_slowpath_common+0x6d/0xa0
[  104.170715]  [<c1262d1a>] ? kobject_add_internal+0x1da/0x1f0
[  104.176683]  [<c1262d1a>] ? kobject_add_internal+0x1da/0x1f0
[  104.182644]  [<c1035a4e>] warn_slowpath_fmt+0x2e/0x30
[  104.187937]  [<c1262d1a>] kobject_add_internal+0x1da/0x1f0
[  104.193750]  [<c1262ebd>] kobject_add_varg+0x2d/0x50
[  104.198891]  [<c1262f07>] kobject_init_and_add+0x27/0x30
[  104.204489]  [<c1089240>] mod_sysfs_setup+0x80/0x540
[  104.209706]  [<c1260851>] ? module_bug_finalize+0x51/0xc0
[  104.215362]  [<c108ab29>] load_module+0x1429/0x18b0
[  104.220530]  [<c1088510>] ? free_notes_attrs+0x40/0x40
[  104.226001]  [<c126c588>] ? _copy_from_user+0x38/0x130
[  104.231442]  [<c108b0c3>] sys_init_module+0x93/0xb0
[  104.236629]  [<c16f22fa>] sysenter_do_call+0x12/0x22
[  104.241855] ---[ end trace aa239ae9897b5681 ]---


With the patch it worked flawlessly for a day.

>
>diff --git a/kernel/module.c b/kernel/module.c
>index 69d2600..2e7189f 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -1862,12 +1862,12 @@ static void free_module(struct module *mod)
> {
> 	trace_module_free(mod);
>
>-	/* Delete from various lists */
>-	mutex_lock(&module_mutex);
>-	stop_machine(__unlink_module, mod, NULL);
>-	mutex_unlock(&module_mutex);
> 	mod_sysfs_teardown(mod);
>
>+	/* We leave it in list to prevent duplicate loads, but make sure
>+	 * that noone uses it while it's being deconstructed. */
>+	mod->state = MODULE_STATE_UNFORMED;
>+
> 	/* Remove dynamic debug info */
> 	ddebug_remove_module(mod->name);
>
>@@ -1880,6 +1880,11 @@ static void free_module(struct module *mod)
> 	/* Free any allocated parameters. */
> 	destroy_params(mod->kp, mod->num_kp);
>
>+	/* Now we can delete it from the lists */
>+	mutex_lock(&module_mutex);
>+	stop_machine(__unlink_module, mod, NULL);
>+	mutex_unlock(&module_mutex);
>+
> 	/* This may be NULL, but that's OK */
> 	unset_module_init_ro_nx(mod);
> 	module_free(mod, mod->module_init);
>
>Thanks,
>Rusty.
