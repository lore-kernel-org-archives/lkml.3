Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3CHUki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:40:38 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55711 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3CHUkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:40:37 -0500
Date: Fri, 8 Mar 2013 12:41:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: kernel BUG at fs/sysfs/group.c:65!
Message-ID: <20130308204113.GA15334@kroah.com>
References: <CA+ydwtqqLZykdJXRPcd0_6UoNQJmTb2VeVKheHYDA+8-4wkW1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ydwtqqLZykdJXRPcd0_6UoNQJmTb2VeVKheHYDA+8-4wkW1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 09:35:17PM +0200, Tommi Rantala wrote:
> Hello,
> 
> Saw this while fuzzing with trinity:
> 
> # ./trinity -q -l off -C20 --dangerous -c ioctl -V /dev
> Trinity v1.2pre  Dave Jones <davej@redhat.com>
> [3450] Marking 64-bit syscall 16 (ioctl) as enabled
> [3450] Marking 32-bit syscall 54 (ioctl) as enabled
> Enabling syscall ioctl
> DANGER: RUNNING AS ROOT.
> Unless you are running in a virtual machine, this could cause serious
> problems such as overwriting CMOS
> or similar which could potentially make this machine unbootable
> without a firmware reset.
> 
> ctrl-c now unless you really know what you are doing.
> Initial random seed from time of day: 3240298905
> Kernel was tainted on startup. Will keep running if trinity causes an oops.
> [3451] Watchdog is alive
> [3450] Started watchdog process, PID is 3451
> [3452] Main thread is alive.
> Generating file descriptors
> Added 340 filenames from /dev
> [3452] Random reseed: 291638642
> [watchdog] 9738 iterations. [F:9195 S:542]
> [watchdog] 22504 iterations. [F:21372 S:1131]
> [watchdog] 33528 iterations. [F:31900 S:1627]
> [watchdog] 43275 iterations. [F:41135 S:2139]
> [watchdog] 53543 iterations. [F:50924 S:2618]
> [watchdog] 64605 iterations. [F:61433 S:3171]
> [watchdog] 74696 iterations. [F:71142 S:3553]
> [watchdog] 84993 iterations. [F:80899 S:4092]
> [  204.920235] ------------[ cut here ]------------
> [  204.921507] WARNING: at
> /home/ttrantal/git/linux-2.6/fs/sysfs/dir.c:536
> sysfs_add_one+0xc0/0xf0()

That's a warning.

> [  204.923672] Hardware name: Bochs
> [  204.924510] sysfs: cannot create duplicate filename
> '/devices/virtual/bdi/7:0'

What are you creating here?  Fuse devices?  loopback devices?  You just
tried to create a duplicate one of what is in the kernel already,
something should have stopped you before you got to sysfs, that's not
good.

> [  204.926312] Pid: 3487, comm: trinity-child14 Tainted: G        W
> 3.9.0-rc1+ #102
> [  204.928194] Call Trace:
> [  204.928830]  [<ffffffff812229e0>] ? sysfs_add_one+0xc0/0xf0
> [  204.930217]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
> [  204.931702]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
> [  204.933138]  [<ffffffff812229e0>] sysfs_add_one+0xc0/0xf0
> [  204.934498]  [<ffffffff81222ba6>] create_dir+0x76/0xd0
> [  204.935782]  [<ffffffff81222f52>] sysfs_create_dir+0xc2/0xf0
> [  204.937195]  [<ffffffff8135ba7a>] kobject_add_internal+0xda/0x210
> [  204.938709]  [<ffffffff81faaa85>] ? __mutex_unlock_slowpath+0x145/0x160
> [  204.940355]  [<ffffffff8135bcdc>] kobject_add+0x9c/0xd0
> [  204.941668]  [<ffffffff814de0cc>] device_add+0x11c/0x6d0
> [  204.943013]  [<ffffffff814e821d>] ? device_pm_sleep_init+0x4d/0x80
> [  204.944554]  [<ffffffff814de699>] device_register+0x19/0x20
> [  204.945978]  [<ffffffff814dedab>] device_create_vargs+0xcb/0x120
> [  204.947453]  [<ffffffff81170c37>] bdi_register+0x67/0x1d0
> [  204.948815]  [<ffffffff8109136e>] ? kmemcheck_mark_initialized+0xe/0x10
> [  204.950445]  [<ffffffff81170dc3>] bdi_register_dev+0x23/0x30
> [  204.951859]  [<ffffffff8134c90b>] add_disk+0x1fb/0x4b0
> [  204.953140]  [<ffffffff814f7a27>] loop_add+0x1d7/0x220
> [  204.954430]  [<ffffffff814f9295>] loop_control_ioctl+0x65/0x170
> [  204.955901]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
> [  204.957265]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
> [  204.958647]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
> [  204.959913]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [  204.961482]  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b
> [  204.962922] ---[ end trace e3673bd679957e4e ]---
> [  204.964138] ------------[ cut here ]------------
> [  204.965261] WARNING: at
> /home/ttrantal/git/linux-2.6/lib/kobject.c:196
> kobject_add_internal+0x172/0x210()
> [  204.967502] Hardware name: Bochs
> [  204.968300] kobject_add_internal failed for 7:0 with -EEXIST, don't
> try to register things with the same name in the same directory.

Same warning, that's fine.


> [  204.971062] Pid: 3487, comm: trinity-child14 Tainted: G        W
> 3.9.0-rc1+ #102
> [  204.972873] Call Trace:
> [  204.973489]  [<ffffffff8135bb12>] ? kobject_add_internal+0x172/0x210
> [  204.975015]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
> [  204.976474]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
> [  204.977939]  [<ffffffff8135bb12>] kobject_add_internal+0x172/0x210
> [  204.979484]  [<ffffffff81faaa85>] ? __mutex_unlock_slowpath+0x145/0x160
> [  204.981221]  [<ffffffff8135bcdc>] kobject_add+0x9c/0xd0
> [  204.982557]  [<ffffffff814de0cc>] device_add+0x11c/0x6d0
> [  204.983972]  [<ffffffff814e821d>] ? device_pm_sleep_init+0x4d/0x80
> [  204.985518]  [<ffffffff814de699>] device_register+0x19/0x20
> [  204.986927]  [<ffffffff814dedab>] device_create_vargs+0xcb/0x120
> [  204.988428]  [<ffffffff81170c37>] bdi_register+0x67/0x1d0
> [  204.989799]  [<ffffffff8109136e>] ? kmemcheck_mark_initialized+0xe/0x10
> [  204.991442]  [<ffffffff81170dc3>] bdi_register_dev+0x23/0x30
> [  204.992867]  [<ffffffff8134c90b>] add_disk+0x1fb/0x4b0
> [  204.994163]  [<ffffffff814f7a27>] loop_add+0x1d7/0x220
> [  204.995463]  [<ffffffff814f9295>] loop_control_ioctl+0x65/0x170
> [  204.996928]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
> [  204.998307]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
> [  204.999696]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
> [  205.000981]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [  205.002576]  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b
> [  205.004077] ---[ end trace e3673bd679957e4f ]---
> [  205.006169] ------------[ cut here ]------------
> [  205.007407] WARNING: at
> /home/ttrantal/git/linux-2.6/fs/sysfs/dir.c:536
> sysfs_add_one+0xc0/0xf0()
> [  205.009612] Hardware name: Bochs
> [  205.010460] sysfs: cannot create duplicate filename '/dev/block/7:0'

Again you try to add it.

> [  205.012042] Pid: 3487, comm: trinity-child14 Tainted: G        W
> 3.9.0-rc1+ #102
> [  205.013926] Call Trace:
> [  205.014569]  [<ffffffff812229e0>] ? sysfs_add_one+0xc0/0xf0
> [  205.015954]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
> [  205.017408]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
> [  205.018782]  [<ffffffff812229e0>] sysfs_add_one+0xc0/0xf0
> [  205.020071]  [<ffffffff81223560>] sysfs_do_create_link_sd+0x110/0x220
> [  205.021593]  [<ffffffff81363f30>] ? sprintf+0x40/0x50
> [  205.022815]  [<ffffffff812236aa>] sysfs_create_link+0x2a/0x40
> [  205.024195]  [<ffffffff814de180>] device_add+0x1d0/0x6d0
> [  205.025465]  [<ffffffff814ddeac>] ? dev_set_name+0x3c/0x40
> [  205.026784]  [<ffffffff8134c954>] add_disk+0x244/0x4b0
> [  205.028024]  [<ffffffff814f7a27>] loop_add+0x1d7/0x220
> [  205.029266]  [<ffffffff814f9295>] loop_control_ioctl+0x65/0x170
> [  205.030669]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
> [  205.031992]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
> [  205.033341]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
> [  205.034630]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [  205.036316]  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b
> [  205.037850] ---[ end trace e3673bd679957e50 ]---
> [  205.042116] ------------[ cut here ]------------
> [  205.043027] kernel BUG at /home/ttrantal/git/linux-2.6/fs/sysfs/group.c:65!

And now we crash.  For a loop device we are trying to add.

Ick.

I'm guessing that the caller of whom ever tried to create the duplicate
sysfs device, didn't check the return value, and then tried to add a
sysfs group to that object.

So we crashed, as I'm betting sysfs_create_group() was called with a
NULL kobject.

I think that BUG() for such a stupid thing is flat out wrong, we should
be returning an error instead, so I'll go fix that.  If you change the
line that this BUG() call is, from:
	BUG_ON(!kobj || (!update && !kobj->sd));
to
	BUG_ON(!update && !kobj->sd);

does it still crash?

I'd rather just warn there anyway, sysfs shouldn't be calling BUG on
anything, it should always be able to recover and just return errors.

thanks,

greg k-h
