Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab3CIQgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 11:36:55 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:46013 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760352Ab3CIQgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 11:36:53 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVP1_wXXw46KJCLhWy-TfGdnmSijnKGcycbZxS_0ZQUikg@mail.gmail.com>
References: <CA+ydwtqqLZykdJXRPcd0_6UoNQJmTb2VeVKheHYDA+8-4wkW1g@mail.gmail.com>
	<20130308204113.GA15334@kroah.com>
	<CACVXFVP1_wXXw46KJCLhWy-TfGdnmSijnKGcycbZxS_0ZQUikg@mail.gmail.com>
Date: Sat, 9 Mar 2013 18:36:52 +0200
Message-ID: <CA+ydwtqHtwizg1=-KeLOjUUr+tzoFSPWRaeitE=10sm+pOYYKw@mail.gmail.com>
Subject: Re: kernel BUG at fs/sysfs/group.c:65!
From: Tommi Rantala <tt.rantala@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/9 Ming Lei <tom.leiming@gmail.com>:
> On Sat, Mar 9, 2013 at 4:41 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Fri, Mar 08, 2013 at 09:35:17PM +0200, Tommi Rantala wrote:
>>> Hello,
>>>
>>> Saw this while fuzzing with trinity:
>>>
>>> # ./trinity -q -l off -C20 --dangerous -c ioctl -V /dev
>>> Trinity v1.2pre  Dave Jones <davej@redhat.com>
>>> [3450] Marking 64-bit syscall 16 (ioctl) as enabled
>>> [3450] Marking 32-bit syscall 54 (ioctl) as enabled
>>> Enabling syscall ioctl
>>> DANGER: RUNNING AS ROOT.
>>> Unless you are running in a virtual machine, this could cause serious
>>> problems such as overwriting CMOS
>>> or similar which could potentially make this machine unbootable
>>> without a firmware reset.
>>>
>>> ctrl-c now unless you really know what you are doing.
>>> Initial random seed from time of day: 3240298905
>>> Kernel was tainted on startup. Will keep running if trinity causes an oops.
>>> [3451] Watchdog is alive
>>> [3450] Started watchdog process, PID is 3451
>>> [3452] Main thread is alive.
>>> Generating file descriptors
>>> Added 340 filenames from /dev
>>> [3452] Random reseed: 291638642
>>> [watchdog] 9738 iterations. [F:9195 S:542]
>>> [watchdog] 22504 iterations. [F:21372 S:1131]
>>> [watchdog] 33528 iterations. [F:31900 S:1627]
>>> [watchdog] 43275 iterations. [F:41135 S:2139]
>>> [watchdog] 53543 iterations. [F:50924 S:2618]
>>> [watchdog] 64605 iterations. [F:61433 S:3171]
>>> [watchdog] 74696 iterations. [F:71142 S:3553]
>>> [watchdog] 84993 iterations. [F:80899 S:4092]
>>> [  204.920235] ------------[ cut here ]------------
>>> [  204.921507] WARNING: at
>>> /home/ttrantal/git/linux-2.6/fs/sysfs/dir.c:536
>>> sysfs_add_one+0xc0/0xf0()
>>
>> That's a warning.
>>
>>> [  204.923672] Hardware name: Bochs
>>> [  204.924510] sysfs: cannot create duplicate filename
>>> '/devices/virtual/bdi/7:0'
>>
>> What are you creating here?  Fuse devices?  loopback devices?  You just
>> tried to create a duplicate one of what is in the kernel already,
>> something should have stopped you before you got to sysfs, that's not
>> good.
>>
>>> [  204.926312] Pid: 3487, comm: trinity-child14 Tainted: G        W
>>> 3.9.0-rc1+ #102
>>> [  204.928194] Call Trace:
>>> [  204.928830]  [<ffffffff812229e0>] ? sysfs_add_one+0xc0/0xf0
>>> [  204.930217]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
>>> [  204.931702]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
>>> [  204.933138]  [<ffffffff812229e0>] sysfs_add_one+0xc0/0xf0
>>> [  204.934498]  [<ffffffff81222ba6>] create_dir+0x76/0xd0
>>> [  204.935782]  [<ffffffff81222f52>] sysfs_create_dir+0xc2/0xf0
>>> [  204.937195]  [<ffffffff8135ba7a>] kobject_add_internal+0xda/0x210
>>> [  204.938709]  [<ffffffff81faaa85>] ? __mutex_unlock_slowpath+0x145/0x160
>>> [  204.940355]  [<ffffffff8135bcdc>] kobject_add+0x9c/0xd0
>>> [  204.941668]  [<ffffffff814de0cc>] device_add+0x11c/0x6d0
>>> [  204.943013]  [<ffffffff814e821d>] ? device_pm_sleep_init+0x4d/0x80
>>> [  204.944554]  [<ffffffff814de699>] device_register+0x19/0x20
>>> [  204.945978]  [<ffffffff814dedab>] device_create_vargs+0xcb/0x120
>>> [  204.947453]  [<ffffffff81170c37>] bdi_register+0x67/0x1d0
>>> [  204.948815]  [<ffffffff8109136e>] ? kmemcheck_mark_initialized+0xe/0x10
>>> [  204.950445]  [<ffffffff81170dc3>] bdi_register_dev+0x23/0x30
>>> [  204.951859]  [<ffffffff8134c90b>] add_disk+0x1fb/0x4b0
>>> [  204.953140]  [<ffffffff814f7a27>] loop_add+0x1d7/0x220
>>> [  204.954430]  [<ffffffff814f9295>] loop_control_ioctl+0x65/0x170
>>> [  204.955901]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
>>> [  204.957265]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
>>> [  204.958647]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
>>> [  204.959913]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>> [  204.961482]  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b
>>> [  204.962922] ---[ end trace e3673bd679957e4e ]---
>>> [  204.964138] ------------[ cut here ]------------
>>> [  204.965261] WARNING: at
>>> /home/ttrantal/git/linux-2.6/lib/kobject.c:196
>>> kobject_add_internal+0x172/0x210()
>>> [  204.967502] Hardware name: Bochs
>>> [  204.968300] kobject_add_internal failed for 7:0 with -EEXIST, don't
>>> try to register things with the same name in the same directory.
>>
>> Same warning, that's fine.
>>
>>
>>> [  204.971062] Pid: 3487, comm: trinity-child14 Tainted: G        W
>>> 3.9.0-rc1+ #102
>>> [  204.972873] Call Trace:
>>> [  204.973489]  [<ffffffff8135bb12>] ? kobject_add_internal+0x172/0x210
>>> [  204.975015]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
>>> [  204.976474]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
>>> [  204.977939]  [<ffffffff8135bb12>] kobject_add_internal+0x172/0x210
>>> [  204.979484]  [<ffffffff81faaa85>] ? __mutex_unlock_slowpath+0x145/0x160
>>> [  204.981221]  [<ffffffff8135bcdc>] kobject_add+0x9c/0xd0
>>> [  204.982557]  [<ffffffff814de0cc>] device_add+0x11c/0x6d0
>>> [  204.983972]  [<ffffffff814e821d>] ? device_pm_sleep_init+0x4d/0x80
>>> [  204.985518]  [<ffffffff814de699>] device_register+0x19/0x20
>>> [  204.986927]  [<ffffffff814dedab>] device_create_vargs+0xcb/0x120
>>> [  204.988428]  [<ffffffff81170c37>] bdi_register+0x67/0x1d0
>>> [  204.989799]  [<ffffffff8109136e>] ? kmemcheck_mark_initialized+0xe/0x10
>>> [  204.991442]  [<ffffffff81170dc3>] bdi_register_dev+0x23/0x30
>>> [  204.992867]  [<ffffffff8134c90b>] add_disk+0x1fb/0x4b0
>>> [  204.994163]  [<ffffffff814f7a27>] loop_add+0x1d7/0x220
>>> [  204.995463]  [<ffffffff814f9295>] loop_control_ioctl+0x65/0x170
>>> [  204.996928]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
>>> [  204.998307]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
>>> [  204.999696]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
>>> [  205.000981]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>> [  205.002576]  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b
>>> [  205.004077] ---[ end trace e3673bd679957e4f ]---
>>> [  205.006169] ------------[ cut here ]------------
>>> [  205.007407] WARNING: at
>>> /home/ttrantal/git/linux-2.6/fs/sysfs/dir.c:536
>>> sysfs_add_one+0xc0/0xf0()
>>> [  205.009612] Hardware name: Bochs
>>> [  205.010460] sysfs: cannot create duplicate filename '/dev/block/7:0'
>>
>> Again you try to add it.
>>
>>> [  205.012042] Pid: 3487, comm: trinity-child14 Tainted: G        W
>>> 3.9.0-rc1+ #102
>>> [  205.013926] Call Trace:
>>> [  205.014569]  [<ffffffff812229e0>] ? sysfs_add_one+0xc0/0xf0
>>> [  205.015954]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
>>> [  205.017408]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
>>> [  205.018782]  [<ffffffff812229e0>] sysfs_add_one+0xc0/0xf0
>>> [  205.020071]  [<ffffffff81223560>] sysfs_do_create_link_sd+0x110/0x220
>>> [  205.021593]  [<ffffffff81363f30>] ? sprintf+0x40/0x50
>>> [  205.022815]  [<ffffffff812236aa>] sysfs_create_link+0x2a/0x40
>>> [  205.024195]  [<ffffffff814de180>] device_add+0x1d0/0x6d0
>>> [  205.025465]  [<ffffffff814ddeac>] ? dev_set_name+0x3c/0x40
>>> [  205.026784]  [<ffffffff8134c954>] add_disk+0x244/0x4b0
>>> [  205.028024]  [<ffffffff814f7a27>] loop_add+0x1d7/0x220
>>> [  205.029266]  [<ffffffff814f9295>] loop_control_ioctl+0x65/0x170
>>> [  205.030669]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
>>> [  205.031992]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
>>> [  205.033341]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
>>> [  205.034630]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>> [  205.036316]  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b
>>> [  205.037850] ---[ end trace e3673bd679957e50 ]---
>>> [  205.042116] ------------[ cut here ]------------
>>> [  205.043027] kernel BUG at /home/ttrantal/git/linux-2.6/fs/sysfs/group.c:65!
>>
>> And now we crash.  For a loop device we are trying to add.
>>
>> Ick.
>>
>> I'm guessing that the caller of whom ever tried to create the duplicate
>> sysfs device, didn't check the return value, and then tried to add a
>> sysfs group to that object.
>
> Right, the 'disk' device isn't added into sysfs because of duplicated
> sysfs link in register_disk(),  then trigger the crash when creating
> attribute group under the device's directory.
>
> Looks add_disk() need to handle its failure path.
>
> Tommi, I guess the blow patch may fix the crash, could you test it?

With this patch applied (and the Greg's BUG_ON() change), I see:

Trinity v1.2pre  Dave Jones <davej@redhat.com>
[3404] Marking 64-bit syscall 16 (ioctl) as enabled
[3404] Marking 32-bit syscall 54 (ioctl) as enabled
Enabling syscall ioctl
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious
problems such as overwriting CMOS
or similar which could potentially make this machine unbootable
without a firmware reset.

ctrl-c now unless you really know what you are doing.
Initial random seed from time of day: 1245403482
[3405] Watchdog is alive
[3404] Started watchdog process, PID is 3405
[3406] Main thread is alive.
Generating file descriptors
Added 1 filenames from /dev/loop-control
[3406] Random reseed: 3728217717
[watchdog] 4131 iterations. [F:3657 S:473]
[watchdog] 8380 iterations. [F:7349 S:1030]
[watchdog] 12189 iterations. [F:10692 S:1496]
[watchdog] 15832 iterations. [F:13893 S:1938]
[watchdog] 19369 iterations. [F:17012 S:2356]
[watchdog] 22897 iterations. [F:20141 S:2755]
[watchdog] 25823 iterations. [F:22686 S:3136]
[   39.839210] ------------[ cut here ]------------
[   39.840164] WARNING: at
/home/ttrantal/git/linux-2.6/fs/sysfs/dir.c:536
sysfs_add_one+0xc0/0xf0()
[   39.841877] Hardware name: Bochs
[   39.842683] sysfs: cannot create duplicate filename
'/devices/virtual/bdi/7:0'
[   39.844112] Pid: 3477, comm: trinity-child19 Not tainted 3.9.0-rc1+ #107
[   39.845530] Call Trace:
[   39.845974]  [<ffffffff812229e0>] ? sysfs_add_one+0xc0/0xf0
[   39.846988]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
[   39.848192]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
[   39.849455]  [<ffffffff812229e0>] sysfs_add_one+0xc0/0xf0
[   39.850436]  [<ffffffff81222ba6>] create_dir+0x76/0xd0
[   39.851482]  [<ffffffff81222f52>] sysfs_create_dir+0xc2/0xf0
[   39.852510]  [<ffffffff8135baaa>] kobject_add_internal+0xda/0x210
[   39.853856]  [<ffffffff81faaab5>] ? __mutex_unlock_slowpath+0x145/0x160
[   39.855498]  [<ffffffff8135bd0c>] kobject_add+0x9c/0xd0
[   39.856795]  [<ffffffff814de0fc>] device_add+0x11c/0x6d0
[   39.857955]  [<ffffffff814e824d>] ? device_pm_sleep_init+0x4d/0x80
[   39.859059]  [<ffffffff814de6c9>] device_register+0x19/0x20
[   39.860170]  [<ffffffff814deddb>] device_create_vargs+0xcb/0x120
[   39.861242]  [<ffffffff81170c37>] bdi_register+0x67/0x1d0
[   39.862250]  [<ffffffff8109136e>] ? kmemcheck_mark_initialized+0xe/0x10
[   39.863562]  [<ffffffff81170dc3>] bdi_register_dev+0x23/0x30
[   39.864581]  [<ffffffff8134c914>] add_disk+0x204/0x4e0
[   39.865619]  [<ffffffff814f7a57>] loop_add+0x1d7/0x220
[   39.866562]  [<ffffffff814f92c5>] loop_control_ioctl+0x65/0x170
[   39.867723]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
[   39.868715]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
[   39.869813]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
[   39.870735]  [<ffffffff8136642e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   39.871993]  [<ffffffff81faeda9>] system_call_fastpath+0x16/0x1b
[   39.873072] ---[ end trace c506c3563256809a ]---
[   39.874072] ------------[ cut here ]------------
[   39.874928] WARNING: at
/home/ttrantal/git/linux-2.6/lib/kobject.c:196
kobject_add_internal+0x172/0x210()
[   39.876733] Hardware name: Bochs
[   39.877446] kobject_add_internal failed for 7:0 with -EEXIST, don't
try to register things with the same name in the same directory.
[   39.879756] Pid: 3477, comm: trinity-child19 Tainted: G        W
3.9.0-rc1+ #107
[   39.881113] Call Trace:
[   39.881656]  [<ffffffff8135bb42>] ? kobject_add_internal+0x172/0x210
[   39.882745]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
[   39.883892]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
[   39.884887]  [<ffffffff8135bb42>] kobject_add_internal+0x172/0x210
[   39.886353]  [<ffffffff81faaab5>] ? __mutex_unlock_slowpath+0x145/0x160
[   39.888049]  [<ffffffff8135bd0c>] kobject_add+0x9c/0xd0
[   39.889395]  [<ffffffff814de0fc>] device_add+0x11c/0x6d0
[   39.890713]  [<ffffffff814e824d>] ? device_pm_sleep_init+0x4d/0x80
[   39.892226]  [<ffffffff814de6c9>] device_register+0x19/0x20
[   39.893730]  [<ffffffff814deddb>] device_create_vargs+0xcb/0x120
[   39.895209]  [<ffffffff81170c37>] bdi_register+0x67/0x1d0
[   39.896554]  [<ffffffff8109136e>] ? kmemcheck_mark_initialized+0xe/0x10
[   39.898168]  [<ffffffff81170dc3>] bdi_register_dev+0x23/0x30
[   39.899504]  [<ffffffff8134c914>] add_disk+0x204/0x4e0
[   39.900547]  [<ffffffff814f7a57>] loop_add+0x1d7/0x220
[   39.901584]  [<ffffffff814f92c5>] loop_control_ioctl+0x65/0x170
[   39.902648]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
[   39.903737]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
[   39.904840]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
[   39.905861]  [<ffffffff8136642e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   39.907123]  [<ffffffff81faeda9>] system_call_fastpath+0x16/0x1b
[   39.908410] ---[ end trace c506c3563256809b ]---
[   39.967103] ------------[ cut here ]------------
[   39.967994] WARNING: at
/home/ttrantal/git/linux-2.6/fs/sysfs/dir.c:536
sysfs_add_one+0xc0/0xf0()
[   39.969835] Hardware name: Bochs
[   39.970571] sysfs: cannot create duplicate filename '/dev/block/7:0'
[   39.971720] Pid: 3477, comm: trinity-child19 Tainted: G        W
3.9.0-rc1+ #107
[   39.973181] Call Trace:
[   39.973633]  [<ffffffff812229e0>] ? sysfs_add_one+0xc0/0xf0
[   39.974748]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
[   39.975827]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
[   39.976978]  [<ffffffff812229e0>] sysfs_add_one+0xc0/0xf0
[   39.978060]  [<ffffffff81223560>] sysfs_do_create_link_sd+0x110/0x220
[   39.979436]  [<ffffffff81363f60>] ? sprintf+0x40/0x50
[   39.980468]  [<ffffffff812236aa>] sysfs_create_link+0x2a/0x40
[   39.981508]  [<ffffffff814de1b0>] device_add+0x1d0/0x6d0
[   39.982583]  [<ffffffff814ddedc>] ? dev_set_name+0x3c/0x40
[   39.983577]  [<ffffffff8134c95d>] add_disk+0x24d/0x4e0
[   39.984618]  [<ffffffff814f7a57>] loop_add+0x1d7/0x220
[   39.985656]  [<ffffffff814f92c5>] loop_control_ioctl+0x65/0x170
[   39.986837]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
[   39.987828]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
[   39.988936]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
[   39.989856]  [<ffffffff8136642e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   39.991115]  [<ffffffff81faeda9>] system_call_fastpath+0x16/0x1b
[   39.992212] ---[ end trace c506c3563256809c ]---
[   39.995084] ------------[ cut here ]------------
[   39.996338] WARNING: at
/home/ttrantal/git/linux-2.6/block/genhd.c:619 add_disk+0x4c1/0x4e0()
[   39.998353] Hardware name: Bochs
[   39.998958] Pid: 3477, comm: trinity-child19 Tainted: G        W
3.9.0-rc1+ #107
[   40.000489] Call Trace:
[   40.000934]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
[   40.002066]  [<ffffffff810976c5>] warn_slowpath_null+0x15/0x20
[   40.003212]  [<ffffffff8134cbd1>] add_disk+0x4c1/0x4e0
[   40.004200]  [<ffffffff814f7a57>] loop_add+0x1d7/0x220
[   40.005191]  [<ffffffff814f92c5>] loop_control_ioctl+0x65/0x170
[   40.006487]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
[   40.007584]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
[   40.008654]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
[   40.009663]  [<ffffffff8136642e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   40.010828]  [<ffffffff81faeda9>] system_call_fastpath+0x16/0x1b
[   40.011981] ---[ end trace c506c3563256809d ]---
[   40.035636] ------------[ cut here ]------------
[   40.036937] WARNING: at
/home/ttrantal/git/linux-2.6/fs/sysfs/inode.c:324
sysfs_hash_and_remove+0x3c/0xb0()
[   40.039313] Hardware name: Bochs
[   40.040131] sysfs: can not remove 'bdi', no directory
[   40.041381] Pid: 3432, comm: trinity-child7 Tainted: G        W
3.9.0-rc1+ #107
[   40.043305] Call Trace:
[   40.043938]  [<ffffffff81220c1c>] ? sysfs_hash_and_remove+0x3c/0xb0
[   40.045515]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
[   40.047032]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
[   40.048473]  [<ffffffff811a9892>] ? get_super+0xb2/0xd0
[   40.049806]  [<ffffffff81220c1c>] sysfs_hash_and_remove+0x3c/0xb0
[   40.051294]  [<ffffffff812237b1>] sysfs_remove_link+0x21/0x30
[   40.052708]  [<ffffffff8134d3fc>] del_gendisk+0xec/0x250
[   40.054023]  [<ffffffff814f66b8>] loop_remove+0x18/0x40
[   40.055333]  [<ffffffff814f9369>] loop_control_ioctl+0x109/0x170
[   40.056810]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
[   40.058162]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
[   40.059537]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
[   40.060781]  [<ffffffff8136642e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   40.062353]  [<ffffffff81faeda9>] system_call_fastpath+0x16/0x1b
[   40.063841] ---[ end trace c506c3563256809e ]---
[   40.088208] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000090
[   40.089036] IP: [<ffffffff81222c11>] sysfs_find_dirent+0x11/0x100
[   40.089036] PGD 76b62067 PUD 76b63067 PMD 0
[   40.089036] Oops: 0000 [#1] SMP
[   40.089036] CPU 0
[   40.089036] Pid: 3432, comm: trinity-child7 Tainted: G        W
3.9.0-rc1+ #107 Bochs Bochs
[   40.089036] RIP: 0010:[<ffffffff81222c11>]  [<ffffffff81222c11>]
sysfs_find_dirent+0x11/0x100
[   40.089036] RSP: 0000:ffff880076b61d38  EFLAGS: 00010296
[   40.089036] RAX: ffff88007739c520 RBX: 0000000000000000 RCX: 2222222222222222
[   40.089036] RDX: ffffffff8252db37 RSI: 0000000000000000 RDI: 0000000000000000
[   40.089036] RBP: ffff880076b61d58 R08: 2222222222222222 R09: 0000000000000000
[   40.089036] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   40.089036] R13: ffffffff8252db37 R14: 0000000000000000 R15: 0000000000000007
[   40.089036] FS:  00007ff0874f4700(0000) GS:ffff88007f800000(0000)
knlGS:0000000000000000
[   40.089036] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   40.089036] CR2: 0000000000000090 CR3: 0000000076b5a000 CR4: 00000000000006f0
[   40.089036] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   40.089036] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   40.089036] Process trinity-child7 (pid: 3432, threadinfo
ffff880076b60000, task ffff88007739c520)
[   40.089036] Stack:
[   40.089036]  0000000000000000 0000000000000000 ffffffff8252db37
ffff88007857a398
[   40.089036]  ffff880076b61d88 ffffffff81222e29 ffff880076b61da8
ffff88007857a080
[   40.089036]  0000000000000000 ffffffff82849980 ffff880076b61db8
ffffffff81224ad9
[   40.089036] Call Trace:
[   40.089036]  [<ffffffff81222e29>] sysfs_get_dirent+0x39/0x80
[   40.089036]  [<ffffffff81224ad9>] sysfs_remove_group+0x29/0x100
[   40.089036]  [<ffffffff8113f2c4>] blk_trace_remove_sysfs+0x14/0x20
[   40.089036]  [<ffffffff813453ae>] blk_unregister_queue+0x5e/0x90
[   40.089036]  [<ffffffff8134d417>] del_gendisk+0x107/0x250
[   40.089036]  [<ffffffff814f66b8>] loop_remove+0x18/0x40
[   40.089036]  [<ffffffff814f9369>] loop_control_ioctl+0x109/0x170
[   40.089036]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
[   40.089036]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
[   40.089036]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
[   40.089036]  [<ffffffff8136642e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   40.089036]  [<ffffffff81faeda9>] system_call_fastpath+0x16/0x1b
[   40.089036] Code: d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d
f8 c9 c3 0f 1f 80 00 00 00 00 55 48 89 e5 41 56 49 89 f6 41 55 49 89
d5 41 54 53 <0f> b7 87 90 00 00 00 48 8b 9f 88 00 00 00 f6 c4 0f 0f 95
c0 48
[   40.089036] RIP  [<ffffffff81222c11>] sysfs_find_dirent+0x11/0x100
[   40.089036]  RSP <ffff880076b61d38>
[   40.089036] CR2: 0000000000000090
[   40.141131] ---[ end trace c506c3563256809f ]---
[3406] Random reseed: 2579687274
[watchdog] 27757 iterations. [F:24388 S:3368]
[watchdog] kernel became tainted! Last seed was 2579687274



> --
> diff --git a/block/genhd.c b/block/genhd.c
> index 3c001fb..05444d8 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -502,13 +502,13 @@ static int exact_lock(dev_t devt, void *data)
>         return 0;
>  }
>
> -static void register_disk(struct gendisk *disk)
> +static int register_disk(struct gendisk *disk)
>  {
>         struct device *ddev = disk_to_dev(disk);
>         struct block_device *bdev;
>         struct disk_part_iter piter;
>         struct hd_struct *part;
> -       int err;
> +       int err = 0;
>
>         ddev->parent = disk->driverfs_dev;
>
> @@ -517,14 +517,14 @@ static void register_disk(struct gendisk *disk)
>         /* delay uevents, until we scanned partition table */
>         dev_set_uevent_suppress(ddev, 1);
>
> -       if (device_add(ddev))
> -               return;
> +       if ((err = device_add(ddev)))
> +               return err;
>         if (!sysfs_deprecated) {
>                 err = sysfs_create_link(block_depr, &ddev->kobj,
>                                         kobject_name(&ddev->kobj));
>                 if (err) {
>                         device_del(ddev);
> -                       return;
> +                       return err;
>                 }
>         }
>
> @@ -566,6 +566,7 @@ exit:
>         while ((part = disk_part_iter_next(&piter)))
>                 kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
>         disk_part_iter_exit(&piter);
> +       return 0;
>  }
>
>  /**
> @@ -613,7 +614,11 @@ void add_disk(struct gendisk *disk)
>
>         blk_register_region(disk_devt(disk), disk->minors, NULL,
>                             exact_match, exact_lock, disk);
> -       register_disk(disk);
> +       retval = register_disk(disk);
> +       if (retval) {
> +               WARN_ON(retval);
> +               return;
> +       }
>         blk_register_queue(disk);
>
>         /*
>
>
> Thanks,
> --
> Ming Lei
