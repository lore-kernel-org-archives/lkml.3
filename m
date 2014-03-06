Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaCFUJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:09:56 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:37347 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaCFUJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:09:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAMbOQaUW7K=FBESVeo=BOXfYU6cuqthjnmMR6jmeNFnx8PcvuQ@mail.gmail.com>
References: <CAMbOQaUW7K=FBESVeo=BOXfYU6cuqthjnmMR6jmeNFnx8PcvuQ@mail.gmail.com>
Date: Fri, 7 Mar 2014 01:39:45 +0530
Message-ID: <CAMbOQaU-jX8Dvmjj_iQJGBhDesMyFj02epaROFfW+ae+BDg_tA@mail.gmail.com>
Subject: Re: Reporting a bug - Memory corruption in Linux kernel
From: Nilesh More <nilesh99999@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am working on android bug wherein directory entries of ext4 file
system get corrupted when USB is hotplugged (with auto mount support
enabled).

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


While I tried to root cause this issue -  at the time of USB disk
mount, I see lot of block_invalidatepage calls through the call stack
:
add_disk->register_disk->blkdev_put->kill_bdev->truncate_inode_page-->block_invalidatepage

If I prevent kill_bdev from invalidating pages, I see a No-Repro for
this bug. Also there are no prints saying invalid access to FAT
entry(which were present when bug reproduces). Earlier we had no-repro
when added delay(1) before _getblk.

This points out to the loss of sync between _getblk and kill_bdev and
ALSO looks like kill_bdev inadvertently invalidates pages which are
Ext4 owned.

I am going to debug further to try and get to root cause. Before that
wanted to ask if is this  A KNOWN ISSUE ?  If not, any suggestions
that would help me to quickly root cause this ?

Thank you for your help,
Nilesh

On Fri, Mar 7, 2014 at 1:35 AM, Nilesh More <nilesh99999@gmail.com> wrote:
> Hi all,
>
> I am working on android bug wherein directory entries of ext4 file system
> get corrupted when USB is hotplugged (with auto mount support enabled).
>
> The logs as below:
> [ 413.607849] usb 2-1.1: USB disconnect, device number 12
> [ 414.022630] EXT4-fs error (device mmcblk0p20): ext4_readdir:227: inode
> #81827: block 328308: comm installd: path
> /data/data/com.android.nfc/shared_prefs: bad entry in directory: rec_len is
> smaller than minimal- offset=0(0), inode=0, rec_len=0, name_len=0
> [ 414.045204] Aborting journal on device mmcblk0p20-8.
> [ 414.051217] Kernel panic- not syncing: EXT4-fs (device mmcblk0p20): panic
> forced after error
> [ 414.051217]
> [ 414.061199] CPU: 0 PID: 150 Comm: installd Not tainted
> 3.10.24-gfe0c16e-dirty #1
> [ 414.068586] [<c0016ae8>] (unwind_backtrace+0x0/0x140) from [<c0012e94>]
> (show_stack+0x18/0x1c)
> [ 414.077181] [<c0012e94>] (show_stack+0x18/0x1c) from [<c0853b7c>]
> (panic+0x94/0x1ec)
> [ 414.084909] [<c0853b7c>] (panic+0x94/0x1ec) from [<c01eb634>]
> (ext4_handle_error+0x70/0xac)
> [ 414.093241] [<c01eb634>] (ext4_handle_error+0x70/0xac) from [<c01eb7d4>]
> (ext4_error_file+0xc8/0x128)
> [ 414.102443] [<c01eb7d4>] (ext4_error_file+0xc8/0x128) from [<c01cbcdc>]
> (__ext4_check_dir_entry+0xe8/0x188)
> [ 414.112163] [<c01cbcdc>] (__ext4_check_dir_entry+0xe8/0x188) from
> [<c01cc130>] (ext4_readdir+0x3b4/0x800)
> [ 414.121709] [<c01cc130>] (ext4_readdir+0x3b4/0x800) from [<c0155514>]
> (vfs_readdir+0x98/0xbc)
> [ 414.130215] [<c0155514>] (vfs_readdir+0x98/0xbc) from [<c0155678>]
> (SyS_getdents64+0x6c/0xd4)
> [ 414.138721] [<c0155678>] (SyS_getdents64+0x6c/0xd4) from [<c000ef80>]
> (ret_fast_syscall+0x0/0x30)
>
>
> While I tried to root cause this issue -  at the time of USB disk mount, I
> see lot of block_invalidatepage calls through the call stack :
> add_disk->register_disk->blkdev_put->kill_bdev->truncate_inode_page-->block_invalidatepage
>
> If I prevent kill_bdev from invalidating pages, I see a No-Repro for this
> bug. Also there are no prints saying invalid access to FAT entry(which were
> present when bug reproduces). Earlier we had no-repro when added delay(1)
> before _getblk.
>
> This points out to the loss of sync between _getblk and kill_bdev and ALSO
> looks like kill_bdev inadvertently invalidates pages which are Ext4 owned.
>
> I am going to debug further to try and get to root cause. Before that wanted
> to ask if is this  A KNOWN ISSUE ?  If not, any suggestions that would help
> me to quickly root cause this ?
>
> Thank you for your help,
> Nilesh
