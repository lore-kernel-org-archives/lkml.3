Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab3CINs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 08:48:57 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:51502 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3CINsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 08:48:55 -0500
MIME-Version: 1.0
In-Reply-To: <20130308204113.GA15334@kroah.com>
References: <CA+ydwtqqLZykdJXRPcd0_6UoNQJmTb2VeVKheHYDA+8-4wkW1g@mail.gmail.com>
	<20130308204113.GA15334@kroah.com>
Date: Sat, 9 Mar 2013 21:48:54 +0800
Message-ID: <CACVXFVP1_wXXw46KJCLhWy-TfGdnmSijnKGcycbZxS_0ZQUikg@mail.gmail.com>
Subject: Re: kernel BUG at fs/sysfs/group.c:65!
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tommi Rantala <tt.rantala@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 9, 2013 at 4:41 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Mar 08, 2013 at 09:35:17PM +0200, Tommi Rantala wrote:
>> Hello,
>>
>> Saw this while fuzzing with trinity:
>>
>> # ./trinity -q -l off -C20 --dangerous -c ioctl -V /dev
>> Trinity v1.2pre  Dave Jones <davej@redhat.com>
>> [3450] Marking 64-bit syscall 16 (ioctl) as enabled
>> [3450] Marking 32-bit syscall 54 (ioctl) as enabled
>> Enabling syscall ioctl
>> DANGER: RUNNING AS ROOT.
>> Unless you are running in a virtual machine, this could cause serious
>> problems such as overwriting CMOS
>> or similar which could potentially make this machine unbootable
>> without a firmware reset.
>>
>> ctrl-c now unless you really know what you are doing.
>> Initial random seed from time of day: 3240298905
>> Kernel was tainted on startup. Will keep running if trinity causes an oops.
>> [3451] Watchdog is alive
>> [3450] Started watchdog process, PID is 3451
>> [3452] Main thread is alive.
>> Generating file descriptors
>> Added 340 filenames from /dev
>> [3452] Random reseed: 291638642
>> [watchdog] 9738 iterations. [F:9195 S:542]
>> [watchdog] 22504 iterations. [F:21372 S:1131]
>> [watchdog] 33528 iterations. [F:31900 S:1627]
>> [watchdog] 43275 iterations. [F:41135 S:2139]
>> [watchdog] 53543 iterations. [F:50924 S:2618]
>> [watchdog] 64605 iterations. [F:61433 S:3171]
>> [watchdog] 74696 iterations. [F:71142 S:3553]
>> [watchdog] 84993 iterations. [F:80899 S:4092]
>> [  204.920235] ------------[ cut here ]------------
>> [  204.921507] WARNING: at
>> /home/ttrantal/git/linux-2.6/fs/sysfs/dir.c:536
>> sysfs_add_one+0xc0/0xf0()
>
> That's a warning.
>
>> [  204.923672] Hardware name: Bochs
>> [  204.924510] sysfs: cannot create duplicate filename
>> '/devices/virtual/bdi/7:0'
>
> What are you creating here?  Fuse devices?  loopback devices?  You just
> tried to create a duplicate one of what is in the kernel already,
> something should have stopped you before you got to sysfs, that's not
> good.
>
>> [  204.926312] Pid: 3487, comm: trinity-child14 Tainted: G        W
>> 3.9.0-rc1+ #102
>> [  204.928194] Call Trace:
>> [  204.928830]  [<ffffffff812229e0>] ? sysfs_add_one+0xc0/0xf0
>> [  204.930217]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
>> [  204.931702]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
>> [  204.933138]  [<ffffffff812229e0>] sysfs_add_one+0xc0/0xf0
>> [  204.934498]  [<ffffffff81222ba6>] create_dir+0x76/0xd0
>> [  204.935782]  [<ffffffff81222f52>] sysfs_create_dir+0xc2/0xf0
>> [  204.937195]  [<ffffffff8135ba7a>] kobject_add_internal+0xda/0x210
>> [  204.938709]  [<ffffffff81faaa85>] ? __mutex_unlock_slowpath+0x145/0x160
>> [  204.940355]  [<ffffffff8135bcdc>] kobject_add+0x9c/0xd0
>> [  204.941668]  [<ffffffff814de0cc>] device_add+0x11c/0x6d0
>> [  204.943013]  [<ffffffff814e821d>] ? device_pm_sleep_init+0x4d/0x80
>> [  204.944554]  [<ffffffff814de699>] device_register+0x19/0x20
>> [  204.945978]  [<ffffffff814dedab>] device_create_vargs+0xcb/0x120
>> [  204.947453]  [<ffffffff81170c37>] bdi_register+0x67/0x1d0
>> [  204.948815]  [<ffffffff8109136e>] ? kmemcheck_mark_initialized+0xe/0x10
>> [  204.950445]  [<ffffffff81170dc3>] bdi_register_dev+0x23/0x30
>> [  204.951859]  [<ffffffff8134c90b>] add_disk+0x1fb/0x4b0
>> [  204.953140]  [<ffffffff814f7a27>] loop_add+0x1d7/0x220
>> [  204.954430]  [<ffffffff814f9295>] loop_control_ioctl+0x65/0x170
>> [  204.955901]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
>> [  204.957265]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
>> [  204.958647]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
>> [  204.959913]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>> [  204.961482]  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b
>> [  204.962922] ---[ end trace e3673bd679957e4e ]---
>> [  204.964138] ------------[ cut here ]------------
>> [  204.965261] WARNING: at
>> /home/ttrantal/git/linux-2.6/lib/kobject.c:196
>> kobject_add_internal+0x172/0x210()
>> [  204.967502] Hardware name: Bochs
>> [  204.968300] kobject_add_internal failed for 7:0 with -EEXIST, don't
>> try to register things with the same name in the same directory.
>
> Same warning, that's fine.
>
>
>> [  204.971062] Pid: 3487, comm: trinity-child14 Tainted: G        W
>> 3.9.0-rc1+ #102
>> [  204.972873] Call Trace:
>> [  204.973489]  [<ffffffff8135bb12>] ? kobject_add_internal+0x172/0x210
>> [  204.975015]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
>> [  204.976474]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
>> [  204.977939]  [<ffffffff8135bb12>] kobject_add_internal+0x172/0x210
>> [  204.979484]  [<ffffffff81faaa85>] ? __mutex_unlock_slowpath+0x145/0x160
>> [  204.981221]  [<ffffffff8135bcdc>] kobject_add+0x9c/0xd0
>> [  204.982557]  [<ffffffff814de0cc>] device_add+0x11c/0x6d0
>> [  204.983972]  [<ffffffff814e821d>] ? device_pm_sleep_init+0x4d/0x80
>> [  204.985518]  [<ffffffff814de699>] device_register+0x19/0x20
>> [  204.986927]  [<ffffffff814dedab>] device_create_vargs+0xcb/0x120
>> [  204.988428]  [<ffffffff81170c37>] bdi_register+0x67/0x1d0
>> [  204.989799]  [<ffffffff8109136e>] ? kmemcheck_mark_initialized+0xe/0x10
>> [  204.991442]  [<ffffffff81170dc3>] bdi_register_dev+0x23/0x30
>> [  204.992867]  [<ffffffff8134c90b>] add_disk+0x1fb/0x4b0
>> [  204.994163]  [<ffffffff814f7a27>] loop_add+0x1d7/0x220
>> [  204.995463]  [<ffffffff814f9295>] loop_control_ioctl+0x65/0x170
>> [  204.996928]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
>> [  204.998307]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
>> [  204.999696]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
>> [  205.000981]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>> [  205.002576]  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b
>> [  205.004077] ---[ end trace e3673bd679957e4f ]---
>> [  205.006169] ------------[ cut here ]------------
>> [  205.007407] WARNING: at
>> /home/ttrantal/git/linux-2.6/fs/sysfs/dir.c:536
>> sysfs_add_one+0xc0/0xf0()
>> [  205.009612] Hardware name: Bochs
>> [  205.010460] sysfs: cannot create duplicate filename '/dev/block/7:0'
>
> Again you try to add it.
>
>> [  205.012042] Pid: 3487, comm: trinity-child14 Tainted: G        W
>> 3.9.0-rc1+ #102
>> [  205.013926] Call Trace:
>> [  205.014569]  [<ffffffff812229e0>] ? sysfs_add_one+0xc0/0xf0
>> [  205.015954]  [<ffffffff810975d6>] warn_slowpath_common+0x86/0xb0
>> [  205.017408]  [<ffffffff81097661>] warn_slowpath_fmt+0x41/0x50
>> [  205.018782]  [<ffffffff812229e0>] sysfs_add_one+0xc0/0xf0
>> [  205.020071]  [<ffffffff81223560>] sysfs_do_create_link_sd+0x110/0x220
>> [  205.021593]  [<ffffffff81363f30>] ? sprintf+0x40/0x50
>> [  205.022815]  [<ffffffff812236aa>] sysfs_create_link+0x2a/0x40
>> [  205.024195]  [<ffffffff814de180>] device_add+0x1d0/0x6d0
>> [  205.025465]  [<ffffffff814ddeac>] ? dev_set_name+0x3c/0x40
>> [  205.026784]  [<ffffffff8134c954>] add_disk+0x244/0x4b0
>> [  205.028024]  [<ffffffff814f7a27>] loop_add+0x1d7/0x220
>> [  205.029266]  [<ffffffff814f9295>] loop_control_ioctl+0x65/0x170
>> [  205.030669]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
>> [  205.031992]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
>> [  205.033341]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
>> [  205.034630]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>> [  205.036316]  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b
>> [  205.037850] ---[ end trace e3673bd679957e50 ]---
>> [  205.042116] ------------[ cut here ]------------
>> [  205.043027] kernel BUG at /home/ttrantal/git/linux-2.6/fs/sysfs/group.c:65!
>
> And now we crash.  For a loop device we are trying to add.
>
> Ick.
>
> I'm guessing that the caller of whom ever tried to create the duplicate
> sysfs device, didn't check the return value, and then tried to add a
> sysfs group to that object.

Right, the 'disk' device isn't added into sysfs because of duplicated
sysfs link in register_disk(),  then trigger the crash when creating
attribute group under the device's directory.

Looks add_disk() need to handle its failure path.

Tommi, I guess the blow patch may fix the crash, could you test it?
--
diff --git a/block/genhd.c b/block/genhd.c
index 3c001fb..05444d8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -502,13 +502,13 @@ static int exact_lock(dev_t devt, void *data)
 	return 0;
 }

-static void register_disk(struct gendisk *disk)
+static int register_disk(struct gendisk *disk)
 {
 	struct device *ddev = disk_to_dev(disk);
 	struct block_device *bdev;
 	struct disk_part_iter piter;
 	struct hd_struct *part;
-	int err;
+	int err = 0;

 	ddev->parent = disk->driverfs_dev;

@@ -517,14 +517,14 @@ static void register_disk(struct gendisk *disk)
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);

-	if (device_add(ddev))
-		return;
+	if ((err = device_add(ddev)))
+		return err;
 	if (!sysfs_deprecated) {
 		err = sysfs_create_link(block_depr, &ddev->kobj,
 					kobject_name(&ddev->kobj));
 		if (err) {
 			device_del(ddev);
-			return;
+			return err;
 		}
 	}

@@ -566,6 +566,7 @@ exit:
 	while ((part = disk_part_iter_next(&piter)))
 		kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
 	disk_part_iter_exit(&piter);
+	return 0;
 }

 /**
@@ -613,7 +614,11 @@ void add_disk(struct gendisk *disk)

 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
-	register_disk(disk);
+	retval = register_disk(disk);
+	if (retval) {
+		WARN_ON(retval);
+		return;
+	}
 	blk_register_queue(disk);

 	/*


Thanks,
-- 
Ming Lei
