Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaCSSfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:35:47 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:32981 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaCSSfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:35:44 -0400
MIME-Version: 1.0
Date: Thu, 20 Mar 2014 00:05:44 +0530
Message-ID: <CAMbOQaVjS3Gzg0iJrxjyb3SD5sA1mm-gZeGEqaTG_B5z4-_pGg@mail.gmail.com>
Subject: Page cache corruption with mount/unmount of USB with Fat file system
From: Nilesh More <nilesh99999@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

First of all sorry for the lengthy mail but I did not want to miss out
on any details.

The following issue that I am reporting occurs when I plugin the USB
drive on android tablet with USB mount support. Please note that this
issue may or may not occur the first time I hotplug the USB drive. It
might require couple of hotplug/hotunplug to see this issue. If
anybody has/gets any clue about the possible root cause, please let me
know.

1. After the add_disk call and before the do_mount call for USB drive,
there are many pages and their corresponding buffers (buffer_head)
which get invalidated.

Call stack taken while the allocated pages in add_disk are getting invalidated.

[  157.862294] [<c0012e94>] (show_stack+0x18/0x1c) from [<c01749cc>]
(block_invalidatepage+0x1f4/0x228)
[  157.871428] [<c01749cc>] (block_invalidatepage+0x1f4/0x228) from
[<c0112cc4>] (truncate_inode_page+0xb0/0xb8)
[  157.881346] [<c0112cc4>] (truncate_inode_page+0xb0/0xb8) from
[<c0112de0>] (truncate_inode_pages_range+0x114/0x344)
[  157.891775] [<c0112de0>] (truncate_inode_pages_range+0x114/0x344)
from [<c011310c>] (truncate_inode_pages+0x20/0x28)
[  157.902299] [<c011310c>] (truncate_inode_pages+0x20/0x28) from
[<c0178144>] (kill_bdev+0x40/0x50)
[  157.911161] [<c0178144>] (kill_bdev+0x40/0x50) from [<c01789cc>]
(__blkdev_put+0x70/0x174)
[  157.919417] [<c01789cc>] (__blkdev_put+0x70/0x174) from
[<c02b3758>] (add_disk+0x3ec/0x4a8)
[  157.927764] [<c02b3758>] (add_disk+0x3ec/0x4a8) from [<c044f660>]
(sd_probe_async+0x110/0x1cc)
[  157.936369] [<c044f660>] (sd_probe_async+0x110/0x1cc) from
[<c008afc8>] (async_run_entry_fn+0x48/0x188)
[  157.945767] [<c008afc8>] (async_run_entry_fn+0x48/0x188) from
[<c007e12c>] (process_one_work+0x13c/0x41c)
[  157.955329] [<c007e12c>] (process_one_work+0x13c/0x41c) from
[<c007e820>] (worker_thread+0x140/0x384)
[  157.964538] [<c007e820>] (worker_thread+0x140/0x384) from
[<c0084458>] (kthread+0xc4/0xd0)
[  157.972796] [<c0084458>] (kthread+0xc4/0xd0) from [<c000f018>]
(ret_from_fork+0x14/0x20)


Call stack of page invalidation between add_disk and do_mount. We have
confirmed that this call stack is for USB block device page
invalidatons.
I haven't yet figured out why these invalidation occur and when
exactly these pages were allocated ? Does anybody know ? When we
disable page invalidations in the following call stack, we don't see
Fat access violations.

[  322.643036] [<c0016ae8>] (unwind_backtrace+0x0/0x140) from
[<c0012e94>] (show_stack+0x18/0x1c)
[  322.651634] [<c0012e94>] (show_stack+0x18/0x1c) from [<c01716ac>]
(block_invalidatepage+0x1dc/0x20c)
[  322.660752] [<c01716ac>] (block_invalidatepage+0x1dc/0x20c) from
[<c0112cc4>] (truncate_inode_page+0xb0/0xb8)
[  322.670659] [<c0112cc4>] (truncate_inode_page+0xb0/0xb8) from
[<c0112de0>] (truncate_inode_pages_range+0x114/0x344)
[  322.681124] [<c0112de0>] (truncate_inode_pages_range+0x114/0x344)
from [<c011310c>] (truncate_inode_pages+0x20/0x28)
[  322.691756] [<c011310c>] (truncate_inode_pages+0x20/0x28) from
[<c0178ac4>] (__blkdev_put+0x74/0x1c8)
[  322.701002] [<c0178ac4>] (__blkdev_put+0x74/0x1c8) from
[<c0178d8c>] (blkdev_close+0x3c/0x70)
[  322.712908] [<c0178d8c>] (blkdev_close+0x3c/0x70) from [<c0145dbc>]
(__fput+0x94/0x20c)
[  322.721922] [<c0145dbc>] (__fput+0x94/0x20c) from [<c008129c>]
(task_work_run+0xb8/0xf4)
[  322.735041] [<c008129c>] (task_work_run+0xb8/0xf4) from
[<c00126c4>] (do_work_pending+0x214/0x4a4)
[  322.744024] [<c00126c4>] (do_work_pending+0x214/0x4a4) from
[<c000efc0>] (work_pending+0xc/0x20)

do_mount call stack.
[   40.065835] [<c01478b0>] (mount_bdev+0x16c/0x1a0) from [<c0230cb4>]
(vfat_mount+0x20/0x28)
[   40.074207] [<c0230cb4>] (vfat_mount+0x20/0x28) from [<c0148244>]
(mount_fs+0x4c/0x180)
[   40.074238] [<c0148244>] (mount_fs+0x4c/0x180) from [<c0160478>]
(vfs_kern_mount+0x54/0xc8)
[   40.074270] [<c0160478>] (vfs_kern_mount+0x54/0xc8) from
[<c01625d4>] (do_mount+0x1cc/0x868)
[   40.074299] [<c01625d4>] (do_mount+0x1cc/0x868) from [<c0162cfc>]
(SyS_mount+0x8c/0xc0)
[   40.074350] [<c0162cfc>] (SyS_mount+0x8c/0xc0) from [<c000ef80>]
(ret_fast_syscall+0x0/0x30)


2. These invalidation of pages from call stack #2 above results into
fat entry access violations.
Following is the call stack at the time of access violation error :

[  72.558649] FAT-fs (sda1): error, invalid access to FAT (entry 0x35005080)

[  72.558654] CPU: 3 PID: 1649 Comm: sdcard Not tainted
3.10.24-g2649606-dirty #24
[  72.558663] [<c0016ae8>] (unwind_backtrace+0x0/0x140) from
[<c0012e94>] (show_stack+0x18/0x1c)
[  72.558669] [<c0012e94>] (show_stack+0x18/0x1c) from [<c022bb7c>]
(fat_ent_read+0x218/0x224)
[  72.558675] [<c022bb7c>](fat_ent_read+0x218/0x224) from [<c0227e34>]
(fat_get_cluster+0x1a8/0x334)
[  72.558681] [<c0227e34>] (fat_get_cluster+0x1a8/0x334) from
[<c022dd08>] (fat_calc_dir_size+0x50/0x7c)
[  72.558687] [<c022dd08>] (fat_calc_dir_size+0x50/0x7c) from
[<c022f834>] (fat_fill_inode+0x2dc/0x3f4)
[  72.558693] [<c022f834>] (fat_fill_inode+0x2dc/0x3f4) from
[<c022fa00>] (fat_build_inode+0xb4/0xe8)
[  72.558698] [<c022fa00>](fat_build_inode+0xb4/0xe8) from
[<c0232054>] (vfat_lookup+0x70/0x15c)
[  72.558703] [<c0232054>] (vfat_lookup+0x70/0x15c) from [<c014db90>]
(lookup_real+0x28/0x58)
[  72.558708] [<c014db90>] (lookup_real+0x28/0x58) from [<c014e4e0>]
(__lookup_hash+0x3c/0x4c)
[  72.558714] [<c014e4e0>] (__lookup_hash+0x3c/0x4c) from [<c014e530>]
(lookup_slow+0x40/0xa0)
[  72.558720] [<c014e530>] (lookup_slow+0x40/0xa0) from [<c0150c7c>]
(path_lookupat+0x7a8/0x7d8)
[  72.558725] [<c0150c7c>] (path_lookupat+0x7a8/0x7d8) from
[<c0150cd4>] (filename_lookup+0x28/0xc4)
[  72.558747] [<c01493ac>] (vfs_fstatat+0x50/0x9c) from [<c01496b4>]
(SyS_lstat64+0x1c/0x38)
[  72.558753] [<c01496b4>] (SyS_lstat64+0x1c/0x38) from [<c000ef80>]
(ret_fast_syscall+0x0/0x30)


3. We have verified that preventing the invalidation of pages/buffers
in step #1 makes these fat errors go away. We have also noticed that
whenever these fat errors occur, ext4 file system corruption occurs.

The logs as below:
[ 413.607849] usb 2-1.1: USB disconnect, device number 12
[ 414.022630] EXT4-fs error (device mmcblk0p20): ext4_readdir:227:
inode #81827: block 328308: comm installd: path
/data/data/com.android.nfc/shared_prefs: bad entry in directory:
rec_len is smaller than minimal- offset=0(0), inode=0, rec_len=0,
name_len=0
[ 414.045204] Aborting journal on device mmcblk0p20-8.
[ 414.051217] Kernel panic- not syncing: EXT4-fs (device mmcblk0p20):
panic forced after error
[ 414.051217]
[ 414.061199] CPU: 0 PID: 150 Comm: installd Not tainted
3.10.24-gfe0c16e-dirty #1
[ 414.068586] [<c0016ae8>] (unwind_backtrace+0x0/0x140) from
[<c0012e94>] (show_stack+0x18/0x1c)
[ 414.077181] [<c0012e94>] (show_stack+0x18/0x1c) from [<c0853b7c>]
(panic+0x94/0x1ec)
[ 414.084909] [<c0853b7c>] (panic+0x94/0x1ec) from [<c01eb634>]
(ext4_handle_error+0x70/0xac)
[ 414.093241] [<c01eb634>] (ext4_handle_error+0x70/0xac) from
[<c01eb7d4>] (ext4_error_file+0xc8/0x128)
[ 414.102443] [<c01eb7d4>] (ext4_error_file+0xc8/0x128) from
[<c01cbcdc>] (__ext4_check_dir_entry+0xe8/0x188)
[ 414.112163] [<c01cbcdc>] (__ext4_check_dir_entry+0xe8/0x188) from
[<c01cc130>] (ext4_readdir+0x3b4/0x800)
[ 414.121709] [<c01cc130>] (ext4_readdir+0x3b4/0x800) from
[<c0155514>] (vfs_readdir+0x98/0xbc)
[ 414.130215] [<c0155514>] (vfs_readdir+0x98/0xbc) from [<c0155678>]
(SyS_getdents64+0x6c/0xd4)
[ 414.138721] [<c0155678>] (SyS_getdents64+0x6c/0xd4) from
[<c000ef80>] (ret_fast_syscall+0x0/0x30)

4. While we were trying our experiments, we put a work around to
prevent the invalidation of pages but with another USB drive, this
work around results into another issue
which indicates the buffer heads are still mapped to the disk. Error
prints and call stack below -
I am trying to figure out why this issue occurs with specific USB drives.

 [   88.766125] __find_get_block_slow() failed. block=1, b_blocknr=0
[   88.766134] b_state=0x00000029, b_size=4096
[   88.766144] device sda1 blocksize: 512

[   39.974514] [<c0012e94>] (show_stack+0x18/0x1c) from [<c0170d8c>]
(__find_get_block_slow+0x188/0x19c)
[   39.983976] [<c0170d8c>] (__find_get_block_slow+0x188/0x19c) from
[<c0172c8c>] (__find_get_block+0x10c/0x298)
[   39.994041] [<c0172c8c>] (__find_get_block+0x10c/0x298) from
[<c0172e3c>] (__getblk+0x24/0x34c)
[   40.002913] [<c0172e3c>] (__getblk+0x24/0x34c) from [<c01731f4>]
(__breadahead+0x1c/0x50)
[   40.011293] [<c01731f4>] (__breadahead+0x1c/0x50) from [<c0228efc>]
(fat__get_entry+0x170/0x27c)
[   40.020182] [<c0228efc>] (fat__get_entry+0x170/0x27c) from
[<c02290bc>] (fat_get_short_entry+0xb4/0xc8)
[   40.029724] [<c02290bc>] (fat_get_short_entry+0xb4/0xc8) from
[<c022b22c>] (fat_subdirs+0x5c/0x80)
[   40.038859] [<c022b22c>] (fat_subdirs+0x5c/0x80) from [<c022f014>]
(fat_fill_super+0xe30/0xff8)
[   40.047716] [<c022f014>] (fat_fill_super+0xe30/0xff8) from
[<c0230ce0>] (vfat_fill_super+0x24/0x2c)
[   40.056982] [<c0230ce0>] (vfat_fill_super+0x24/0x2c) from
[<c01478b0>] (mount_bdev+0x16c/0x1a0)
[   40.065835] [<c01478b0>] (mount_bdev+0x16c/0x1a0) from [<c0230cb4>]
(vfat_mount+0x20/0x28)
[   40.074207] [<c0230cb4>] (vfat_mount+0x20/0x28) from [<c0148244>]
(mount_fs+0x4c/0x180)
[   40.074238] [<c0148244>] (mount_fs+0x4c/0x180) from [<c0160478>]
(vfs_kern_mount+0x54/0xc8)
[   40.074270] [<c0160478>] (vfs_kern_mount+0x54/0xc8) from
[<c01625d4>] (do_mount+0x1cc/0x868)
[   40.074299] [<c01625d4>] (do_mount+0x1cc/0x868) from [<c0162cfc>]
(SyS_mount+0x8c/0xc0)
[   40.074350] [<c0162cfc>] (SyS_mount+0x8c/0xc0) from [<c000ef80>]
(ret_fast_syscall+0x0/0x30)


Thank you,
Nilesh
