Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3J3QhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:37:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3J3QhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:37:23 -0400
Date: Wed, 30 Oct 2013 12:37:04 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Alasdair G Kergon <agk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>,
        Neil Brown <neilb@suse.de>,
        =?ISO-8859-1?Q?Fr=EF=BF=BDd=EF=BF=BDric_Weisbecker?= 
	<fweisbec@gmail.com>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>, Greg KH <greg@kroah.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: FW: Re: [dm-devel] [BUG 3.12.rc4] Oops: unable to handle kernel
 paging request during shutdown
In-Reply-To: <20131028140015.GA14612@agk-dp.fab.redhat.com>
Message-ID: <alpine.LRH.2.02.1310301133180.4090@file01.intranet.prod.int.rdu2.redhat.com>
References: <20131028140015.GA14612@agk-dp.fab.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.LRH.2.02.1310301134311.4090@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Oct 2013, Alasdair G Kergon wrote:

> On Fri, Oct 25, 2013 at 11:48 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Yes, but nobody has actually been able to trigger it with those. It's
> > pretty rare, and the debug options are so expensive that they aren't
> > reasonable to enable generally...
> >
> > So we need to try to figure out how to trigger it, or narrow things
> > down some way..
> 
> Ok, still trying to figure this out, and I do have another bug as a
> result. I don't think this one is really the fundamental one either
> that caused my crash during "yum upgrade", nor necessarily Knut's
> problem during shutdown, but I'll keep looking.
> 
> And who knows.. Maybe this *does* explain Knut's issue.
> 
> Appended is a warning I get with DEBUG_TIMER_OBJECTS. Seems to be a
> device-mapper issue. Alasdair, Neil, comments? It looks like
> dm_destroy() is freeing an delayed_work entry that is still active...
> 
> I don't know exactly which field in the 'struct mapped_device' has
> that delayed-work thing, but I assume it's the kobject.. Somebody who
> knows this code better, please take a look!
>
>                    Linus

No field in device mapper has 'struct delayed_work' in it --- except 
struct kobject:
#ifdef CONFIG_DEBUG_KOBJECT_RELEASE
        struct delayed_work     release;
#endif

- so this is kobject manipulation bug. Dm calls dm_sysfs_exit, which calls 
kobject_put. Dm then frees the structure that contained the kobject with 
kfree and it triggers this warning.

Documentation/kobject.txt says that kobjects shouldn't be used this way - 
that the structure should be freed from the release method. However, using 
the API the correct way is impossible.

Unloading of a device driver is supposed to work like this:
1) you call the unload routine
2) it calls kobject_put (but the kobject may still be referenced by other 
kernel code release method will be called when the references are dropped)
3) you don't free the driver structure
4) you exit the unload routing

...

5) the other references to kobject are dropped
6) release method is called, it calls kfree on the driver routine
7) the release method exits

Now, the problem is that between steps 4) and 5), someone may unload the 
module and trigger the crash. It is impossible to protect against it. 

Another problem is that between steps 4) and 5), the driver is essentially 
dead, but it must still respond to attr_show and attr_store methods on the 
kobect - it is possible to handle it correctly, but it is not easy to test 
- there is a possibility of a lot of bugs in drivers.


I suggest that you implement a function kobject_put_free, that decrements 
the kobject reference count and waits until others stop using the kobject 
and the reference count drops to zero. Then, you change drivers to use 
kobject_put_free instead of kobject_put in their unload routine - that 
will fix this sort of module unload races.

Mikulas


> ---
> [    8.258139] ------------[ cut here ]------------
> [    8.258145] WARNING: CPU: 1 PID: 257 at lib/debugobjects.c:260
> debug_print_object+0x83/0xa0()
> [    8.258150] ODEBUG: free active (active state 0) object type:
> timer_list hint: delayed_work_timer_fn+0x0/0x20
> [    8.258153] Modules linked in: dm_crypt crc32_pclmul crc32c_intel
> i915 i2c_algo_bit drm_kms_helper ghash_clmulni_intel drm i2c_core
> video
> [    8.258164] CPU: 1 PID: 257 Comm: systemd-cryptse Not tainted
> 3.12.0-rc6-00331-ga2ff82065b5b #2
> [    8.258166] Hardware name: Sony Corporation SVP11213CXB/VAIO, BIOS
> R0270V7 05/17/2013
> [    8.258168]  0000000000000009 ffff8800d65f3b28 ffffffff8160d4a2
> ffff8800d65f3b70
> [    8.258172]  ffff8800d65f3b60 ffffffff810514e8 ffff8800372cb078
> ffffffff81c365e0
> [    8.258176]  ffffffff819f9133 ffffffff81f3d3f0 0000000000000003
> ffff8800d65f3bc0
> [    8.258180] Call Trace:
> [    8.258186]  [<ffffffff8160d4a2>] dump_stack+0x45/0x56
> [    8.258191]  [<ffffffff810514e8>] warn_slowpath_common+0x78/0xa0
> [    8.258195]  [<ffffffff81051557>] warn_slowpath_fmt+0x47/0x50
> [    8.258198]  [<ffffffff812f8883>] debug_print_object+0x83/0xa0
> [    8.258202]  [<ffffffff8106aa90>] ? execute_in_process_context+0x90/0x90
> [    8.258205]  [<ffffffff812f99fb>] debug_check_no_obj_freed+0x20b/0x250
> [    8.258210]  [<ffffffff814b564c>] ? __dm_destroy+0x1ec/0x250
> [    8.258214]  [<ffffffff8115db59>] kfree+0x89/0x160
> [    8.258217]  [<ffffffff814b564c>] __dm_destroy+0x1ec/0x250
> [    8.258221]  [<ffffffff814b626e>] dm_destroy+0xe/0x10
> [    8.258224]  [<ffffffff814bba6a>] dev_remove+0x9a/0x130
> [    8.258226]  [<ffffffff814bb9d0>] ? __hash_remove+0xd0/0xd0
> [    8.258229]  [<ffffffff814bbed0>] ctl_ioctl+0x250/0x500
> [    8.258234]  [<ffffffff81184201>] ? do_last+0x511/0x1220
> [    8.258238]  [<ffffffff814bc18e>] dm_ctl_ioctl+0xe/0x20
> [    8.258242]  [<ffffffff811879ad>] do_vfs_ioctl+0x2cd/0x4a0
> [    8.258246]  [<ffffffff81177419>] ? ____fput+0x9/0x10
> [    8.258249]  [<ffffffff81187c01>] SyS_ioctl+0x81/0xa0
> [    8.258254]  [<ffffffff8161b9a2>] system_call_fastpath+0x16/0x1b
> [    8.258256] ---[ end trace 25f53c192da70824 ]---
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> ----- End forwarded message -----
> 
