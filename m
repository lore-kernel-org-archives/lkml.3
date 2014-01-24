Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaAXNea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:34:30 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:44747 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaAXNe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:34:28 -0500
Date: Fri, 24 Jan 2014 07:31:32 -0600
From: Andrew Ruder <andy@aeruder.net>
To: linux-mtd@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] reproducable ubifs reboot assert and corruption
Message-ID: <20140124133132.GA20804@gmail.com>
Mail-Followup-To: linux-mtd@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20140122051510.GB17284@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122051510.GB17284@gmail.com>
User-Agent: Mutt/1.5.21+155 (d3096e8796e7) (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just expanding distribution a little bit to see if anyone has any ideas.

On Tue, Jan 21, 2014 at 11:15:10PM -0600, Andrew Ruder wrote:
> Problem:
> ubifs corruption to the point where uboot can no longer deal with it and
> it takes multiple mounts to recover filesystem from Linux.
> 
> My hardware:
> NOR flash
> [    3.244397] 0.flash: Found 1 x16 devices at 0x0 in 16-bit bank. Manufacturer ID 0x000001 Chip ID 0x002301
> PXA270
> 
> My software:
> 3.12.0 with some patches (not mtd or ubi or flash related) to support my
> board.
> 
> I'm able to reproduce this fairly readily by the following sequence of
> commands.  I'm not able to trigger it with full debug messages enabled
> but possibly I could enable them for certain files within the ubifs
> driver if something specific would be helpful.  But basically it seems
> like if I reboot (or mount -o remount,ro) while ubifs is writing, it
> sometimes crashes and leaves the partition in a bad state.  Sorry about
> some of the strangeness of the commands, I am scripting this with expect
> and this is my lame attempt to give me something to pattern recognize
> off of.
> 
> I should also point out, I have not had any problems at all when I do an
> abrupt shutdown (either via pulling power or letting a hardware watchdog
> take care of the reset).
> 
> ==============================================================
> ==============================================================
> ==============================================================
> 
> Here's the log of ubifs driver crashing.
> 
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 3.12.0-00041-g7f12d39-dirty (andy@andrewruder-hplin) (gcc version 4.8.2 (Buildroot 2013.11-rc1-00028-gf388663) ) #210 PREEMPT Tue Jan 21 21:36:54 CST 2014
> [    0.000000] CPU: XScale-PXA270 [69054118] revision 8 (ARMv5TE), cr=0000397f
> ...
> [    3.211589] 0.flash: Found 1 x16 devices at 0x0 in 16-bit bank. Manufacturer ID 0x000001 Chip ID 0x002301
> [    3.322188] Amd/Fujitsu Extended Query Table at 0x0040
> [    3.327405]   Amd/Fujitsu Extended Query version 1.5.
> [    3.370661] number of CFI chips: 1
> [    3.378822] 5 cmdlinepart partitions found on MTD device 0.flash
> [    3.385273] Creating 5 MTD partitions on "0.flash":
> [    3.390212] 0x000000000000-0x000000080000 : "uboot"
> [    3.423423] 0x000000080000-0x0000000a0000 : "env"
> [    3.503423] 0x0000000a0000-0x0000000c0000 : "env_redund"
> [    3.603453] 0x0000000c0000-0x0000000e0000 : "env_default"
> [    3.674772] 0x0000000e0000-0x000004000000 : "data"
> ...
> Welcome to Buildroot
> buildroot login: root
> Password: 
> [root@buildroot ~]# echo 7 > /proc/sys/kernel/printk; a=$?; sleep 2 ; [ x$a = x0 ] || echo "@@FAIL@@"
> [root@buildroot ~]# ubiattach -m 4 -d 0; a=$?; sleep 2 ; [ x$a = x0 ] || echo "@@FAIL@@"
> [   10.055595] UBI: attaching mtd4 to ubi0
> [   10.107901] UBI: scanning is finished
> [   10.172362] UBI: attached mtd4 (name "data", size 63 MiB) to ubi0
> [   10.178509] UBI: PEB size: 131072 bytes (128 KiB), LEB size: 130944 bytes
> [   10.220887] UBI: min./max. I/O unit sizes: 1/512, sub-page size 1
> [   10.228545] UBI: VID header offset: 64 (aligned 64), data offset: 128
> [   10.240011] UBI: good PEBs: 505, bad PEBs: 0, corrupted PEBs: 0
> [   10.247227] UBI: user volume: 1, internal volumes: 1, max. volumes count: 128
> [   10.255658] UBI: max/mean erase counter: 42/22, WL threshold: 4096, image sequence number: 2104545903
> [   10.266343] UBI: available PEBs: 4, total reserved PEBs: 501, PEBs reserved for bad PEB handling: 0
> [   10.276740] UBI: background thread "ubi_bgt0d" started, PID 510
> UBI device number 0, total 505 LEBs (66126720 bytes, 63.1 MiB), available 4 LEBs (523776 bytes, 511.5 KiB), LEB size 130944 bytes (127.9 KiB)
> [root@buildroot ~]# mkdir -p /mnt; a=$?; sleep 2 ; [ x$a = x0 ] || echo "@@FAIL@@"
> [root@buildroot ~]# mount -t ubifs ubi0:rootfs /mnt; a=$?; sleep 2 ; [ x$a = x0 ] || echo "@@FAIL@@"
> [   14.463104] UBIFS: background thread "ubifs_bgt0_0" started, PID 516
> [   14.985636] UBIFS: mounted UBI device 0, volume 0, name "rootfs"
> [   14.991670] UBIFS: LEB size: 130944 bytes (127 KiB), min./max. I/O unit sizes: 8 bytes/512 bytes
> [   15.008984] UBIFS: FS size: 63769728 bytes (60 MiB, 487 LEBs), journal size 3142656 bytes (2 MiB, 24 LEBs)
> [   15.020052] UBIFS: reserved for root: 3012001 bytes (2941 KiB)
> [   15.027374] UBIFS: media format: w4/r0 (latest is w4/r0), UUID 567F5BCB-663D-4F84-BF34-3282E100D2D9, small LPT model
> [root@buildroot ~]# rm -fr /mnt/fsstress; a=$?; sleep 2 ; [ x$a = x0 ] || echo "@@FAIL@@"
> [root@buildroot ~]# mkdir -p /mnt/fsstress; a=$?; sleep 2 ; [ x$a = x0 ] || echo "@@FAIL@@"
> [root@buildroot ~]# (sleep 41 ; reboot) &
> [1] 522
> [root@buildroot ~]# fsstress -p 10 -n 10 -X -d /mnt/fsstress -l 0
> seed = 653587
> [   64.672770] UBIFS: background thread "ubifs_bgt0_0" stops
> The system is going down NOW!
> Sent SIGTERM to[   64.753793] UBIFS assert failed in reserve_space at 125 (pid 14)
>  all processes
> [   64.760886] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [1]+  Done                    ( [   64.773747] Workqueue: writeback bdi_writeback_workfnsleep 41; reboot (flush-ubifs_0_0) )
> Terminated
> 
> [   64.783579] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   64.792304] [<c00110c8>] (show_stack+0x10/0x14) from [<c00f2500>] (make_reservation+0x80/0x46c)
> [   64.801054] [<c00f2500>] (make_reservation+0x80/0x46c) from [<c00f3630>] (ubifs_jnl_write_inode+0x90/0x1dc)
> [root@buildroot [   64.811456] [<c00f3630>] (ubifs_jnl_write_inode+0x90/0x1dc) from [<c00f9f60>] (ubifs_write_inode+0xc0/0x140)
> ~]# [   64.822628] [<c00f9f60>] (ubifs_write_inode+0xc0/0x140) from [<c00b99a0>] (__writeback_single_inode+0xe8/0xfc)
> [   64.832988] [<c00b99a0>] (__writeback_single_inode+0xe8/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   64.843435] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   64.853547] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   64.863020] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   64.872487] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   64.882286] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   64.891555] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   64.899904] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   64.908159] UBIFS assert failed in ubifs_wbuf_write_nolock at 691 (pid 14)
> [   64.915120] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   64.923452] Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
> [   64.930177] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   64.938823] [<c00110c8>] (show_stack+0x10/0x14) from [<c00ffe10>] (ubifs_wbuf_write_nolock+0x244/0x7dc)
> [   64.948291] [<c00ffe10>] (ubifs_wbuf_write_nolock+0x244/0x7dc) from [<c00f2cfc>] (write_head.constprop.14+0x84/0xb0)
> [   64.958876] [<c00f2cfc>] (write_head.constprop.14+0x84/0xb0) from [<c00f3668>] (ubifs_jnl_write_inode+0xc8/0x1dc)
> [   64.969196] [<c00f3668>] (ubifs_jnl_write_inode+0xc8/0x1dc) from [<c00f9f60>] (ubifs_write_inode+0xc0/0x140)
> [   64.979089] [<c00f9f60>] (ubifs_write_inode+0xc0/0x140) from [<c00b99a0>] (__writeback_single_inode+0xe8/0xfc)
> [   64.989160] [<c00b99a0>] (__writeback_single_inode+0xe8/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   64.999487] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   65.009545] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   65.019000] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   65.028475] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   65.038284] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   65.047577] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   65.055909] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   65.064740] UBIFS assert failed in reserve_space at 125 (pid 14)
> [   65.070780] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   65.079212] Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
> [   65.085974] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   65.094584] [<c00110c8>] (show_stack+0x10/0x14) from [<c00f2500>] (make_reservation+0x80/0x46c)
> [   65.103362] [<c00f2500>] (make_reservation+0x80/0x46c) from [<c00f345c>] (ubifs_jnl_write_data+0x198/0x2dc)
> [   65.113174] [<c00f345c>] (ubifs_jnl_write_data+0x198/0x2dc) from [<c00f5048>] (do_writepage+0xc0/0x1fc)
> [   65.122630] [<c00f5048>] (do_writepage+0xc0/0x1fc) from [<c006d4ec>] (__writepage+0x14/0x5c)
> [   65.131099] [<c006d4ec>] (__writepage+0x14/0x5c) from [<c006db84>] (write_cache_pages+0x23c/0x330)
> [   65.140122] [<c006db84>] (write_cache_pages+0x23c/0x330) from [<c006dcb4>] (generic_writepages+0x3c/0x58)
> [   65.149751] [<c006dcb4>] (generic_writepages+0x3c/0x58) from [<c00b98ec>] (__writeback_single_inode+0x34/0xfc)
> [   65.159814] [<c00b98ec>] (__writeback_single_inode+0x34/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   65.170141] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   65.180205] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   65.189663] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   65.199127] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   65.208930] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   65.218227] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   65.226564] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   65.234798] UBIFS assert failed in ubifs_wbuf_write_nolock at 691 (pid 14)
> [   65.241702] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   65.250053] Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
> [   65.256797] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   65.265404] [<c00110c8>] (show_stack+0x10/0x14) from [<c00ffe10>] (ubifs_wbuf_write_nolock+0x244/0x7dc)
> [   65.274857] [<c00ffe10>] (ubifs_wbuf_write_nolock+0x244/0x7dc) from [<c00f34d8>] (ubifs_jnl_write_data+0x214/0x2dc)
> [   65.285346] [<c00f34d8>] (ubifs_jnl_write_data+0x214/0x2dc) from [<c00f5048>] (do_writepage+0xc0/0x1fc)
> [   65.294798] [<c00f5048>] (do_writepage+0xc0/0x1fc) from [<c006d4ec>] (__writepage+0x14/0x5c)
> [   65.303295] [<c006d4ec>] (__writepage+0x14/0x5c) from [<c006db84>] (write_cache_pages+0x23c/0x330)
> [   65.312310] [<c006db84>] (write_cache_pages+0x23c/0x330) from [<c006dcb4>] (generic_writepages+0x3c/0x58)
> [   65.321940] [<c006dcb4>] (generic_writepages+0x3c/0x58) from [<c00b98ec>] (__writeback_single_inode+0x34/0xfc)
> [   65.332008] [<c00b98ec>] (__writeback_single_inode+0x34/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   65.342330] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   65.352393] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   65.361818] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   65.371272] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   65.381070] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   65.390351] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   65.398679] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   65.407416] UBIFS assert failed in reserve_space at 125 (pid 14)
> [   65.413585] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   65.421910] Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
> [   65.428674] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   65.437276] [<c00110c8>] (show_stack+0x10/0x14) from [<c00f2500>] (make_reservation+0x80/0x46c)
> [   65.446041] [<c00f2500>] (make_reservation+0x80/0x46c) from [<c00f345c>] (ubifs_jnl_write_data+0x198/0x2dc)
> [   65.455839] [<c00f345c>] (ubifs_jnl_write_data+0x198/0x2dc) from [<c00f5048>] (do_writepage+0xc0/0x1fc)
> [   65.465290] [<c00f5048>] (do_writepage+0xc0/0x1fc) from [<c006d4ec>] (__writepage+0x14/0x5c)
> [   65.473786] [<c006d4ec>] (__writepage+0x14/0x5c) from [<c006db84>] (write_cache_pages+0x23c/0x330)
> [   65.482807] [<c006db84>] (write_cache_pages+0x23c/0x330) from [<c006dcb4>] (generic_writepages+0x3c/0x58)
> [   65.492439] [<c006dcb4>] (generic_writepages+0x3c/0x58) from [<c00b98ec>] (__writeback_single_inode+0x34/0xfc)
> [   65.502501] [<c00b98ec>] (__writeback_single_inode+0x34/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   65.512820] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   65.522883] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   65.532342] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   65.541781] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   65.551589] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   65.560880] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   65.569215] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   65.577442] UBIFS assert failed in ubifs_wbuf_write_nolock at 691 (pid 14)
> [   65.584389] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   65.592715] Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
> [   65.599412] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   65.608038] [<c00110c8>] (show_stack+0x10/0x14) from [<c00ffe10>] (ubifs_wbuf_write_nolock+0x244/0x7dc)
> [   65.617493] [<c00ffe10>] (ubifs_wbuf_write_nolock+0x244/0x7dc) from [<c00f34d8>] (ubifs_jnl_write_data+0x214/0x2dc)
> [   65.627984] [<c00f34d8>] (ubifs_jnl_write_data+0x214/0x2dc) from [<c00f5048>] (do_writepage+0xc0/0x1fc)
> [   65.637436] [<c00f5048>] (do_writepage+0xc0/0x1fc) from [<c006d4ec>] (__writepage+0x14/0x5c)
> [   65.645932] [<c006d4ec>] (__writepage+0x14/0x5c) from [<c006db84>] (write_cache_pages+0x23c/0x330)
> [   65.654964] [<c006db84>] (write_cache_pages+0x23c/0x330) from [<c006dcb4>] (generic_writepages+0x3c/0x58)
> [   65.664605] [<c006dcb4>] (generic_writepages+0x3c/0x58) from [<c00b98ec>] (__writeback_single_inode+0x34/0xfc)
> [   65.674680] [<c00b98ec>] (__writeback_single_inode+0x34/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   65.685002] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   65.695061] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   65.704514] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   65.713968] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   65.723770] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   65.733050] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   65.741349] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   65.749527] UBIFS assert failed in ubifs_leb_write at 122 (pid 14)
> [   65.755767] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   65.764086] Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
> [   65.770778] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   65.779391] [<c00110c8>] (show_stack+0x10/0x14) from [<c00feacc>] (ubifs_leb_write+0x4c/0x11c)
> Sent SIGKILL to[   65.790297] [<c00feacc>] (ubifs_leb_write+0x4c/0x11c) from [<c010002c>] (ubifs_wbuf_write_nolock+0x460/0x7dc)
> [   65.800424] [<c010002c>] (ubifs_wbuf_write_nolock+0x460/0x7dc) from [<c00f34d8>] (ubifs_jnl_write_data+0x214/0x2dc)
> [   65.811038] [<c00f34d8>] (ubifs_jnl_write_data+0x214/0x2dc) from [<c00f5048>] (do_writepage+0xc0/0x1fc)
> [   65.820627] [<c00f5048>] (do_writepage+0xc0/0x1fc) from [<c006d4ec>] (__writepage+0x14/0x5c)
> [   65.829195] [<c006d4ec>] (__writepage+0x14/0x5c) from [<c006db84>] (write_cache_pages+0x23c/0x330)
> [   65.838236] [<c006db84>] (write_cache_pages+0x23c/0x330) from [<c006dcb4>] (generic_writepages+0x3c/0x58)
> [   65.847988] [<c006dcb4>] (generic_writepages+0x3c/0x58) from [<c00b98ec>] (__writeback_single_inode+0x34/0xfc)
> [   65.858194] [<c00b98ec>] (__writeback_single_inode+0x34/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   65.868593] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   65.878679] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   65.888133] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   65.897596] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   65.907392] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   65.916685] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   65.925018] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   65.934393] UBIFS assert failed in reserve_space at 125 (pid 14)
> [   65.940435] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   65.948879] Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
> [   65.955654] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   65.964264] [<c00110c8>] (show_stack+0x10/0x14) from [<c00f2500>] (make_reservation+0x80/0x46c)
> [   65.973019] [<c00f2500>] (make_reservation+0x80/0x46c) from [<c00f345c>] (ubifs_jnl_write_data+0x198/0x2dc)
> [   65.982820] [<c00f345c>] (ubifs_jnl_write_data+0x198/0x2dc) from [<c00f5048>] (do_writepage+0xc0/0x1fc)
> [   65.992271] [<c00f5048>] (do_writepage+0xc0/0x1fc) from [<c006d4ec>] (__writepage+0x14/0x5c)
> [   66.000743] [<c006d4ec>] (__writepage+0x14/0x5c) from [<c006db84>] (write_cache_pages+0x23c/0x330)
> [   66.009760] [<c006db84>] (write_cache_pages+0x23c/0x330) from [<c006dcb4>] (generic_writepages+0x3c/0x58)
> [   66.019387] [<c006dcb4>] (generic_writepages+0x3c/0x58) from [<c00b98ec>] (__writeback_single_inode+0x34/0xfc)
> [   66.029460] [<c00b98ec>] (__writeback_single_inode+0x34/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   66.039783] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   66.049843] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   66.059303] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   66.068770] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   66.078568] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   66.087861] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   66.096199] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   66.104420] UBIFS assert failed in ubifs_wbuf_write_nolock at 691 (pid 14)
> [   66.111315] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   66.119654] Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
> [   66.126379] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   66.134988] [<c00110c8>] (show_stack+0x10/0x14) from [<c00ffe10>] (ubifs_wbuf_write_nolock+0x244/0x7dc)
> [   66.144452] [<c00ffe10>] (ubifs_wbuf_write_nolock+0x244/0x7dc) from [<c00f34d8>] (ubifs_jnl_write_data+0x214/0x2dc)
> [   66.154956] [<c00f34d8>] (ubifs_jnl_write_data+0x214/0x2dc) from [<c00f5048>] (do_writepage+0xc0/0x1fc)
> [   66.164415] [<c00f5048>] (do_writepage+0xc0/0x1fc) from [<c006d4ec>] (__writepage+0x14/0x5c)
> [   66.172904] [<c006d4ec>] (__writepage+0x14/0x5c) from [<c006db84>] (write_cache_pages+0x23c/0x330)
> [   66.181892] [<c006db84>] (write_cache_pages+0x23c/0x330) from [<c006dcb4>] (generic_writepages+0x3c/0x58)
> [   66.191527] [<c006dcb4>] (generic_writepages+0x3c/0x58) from [<c00b98ec>] (__writeback_single_inode+0x34/0xfc)
> [   66.201593] [<c00b98ec>] (__writeback_single_inode+0x34/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   66.211919] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   66.222000] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   66.231430] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   66.240898] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   66.250705] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   66.259989] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   66.268314] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   66.277052] UBIFS assert failed in reserve_space at 125 (pid 14)
> [   66.283220] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   66.291545] Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
> [   66.298329] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   66.306939] [<c00110c8>] (show_stack+0x10/0x14) from [<c00f2500>] (make_reservation+0x80/0x46c)
> [   66.315700] [<c00f2500>] (make_reservation+0x80/0x46c) from [<c00f345c>] (ubifs_jnl_write_data+0x198/0x2dc)
> [   66.325498] [<c00f345c>] (ubifs_jnl_write_data+0x198/0x2dc) from [<c00f5048>] (do_writepage+0xc0/0x1fc)
> [   66.334950] [<c00f5048>] (do_writepage+0xc0/0x1fc) from [<c006d4ec>] (__writepage+0x14/0x5c)
> [   66.343447] [<c006d4ec>] (__writepage+0x14/0x5c) from [<c006db84>] (write_cache_pages+0x23c/0x330)
> [   66.352458] [<c006db84>] (write_cache_pages+0x23c/0x330) from [<c006dcb4>] (generic_writepages+0x3c/0x58)
> [   66.362096] [<c006dcb4>] (generic_writepages+0x3c/0x58) from [<c00b98ec>] (__writeback_single_inode+0x34/0xfc)
> [   66.372167] [<c00b98ec>] (__writeback_single_inode+0x34/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   66.382495] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   66.392556] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   66.402011] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   66.411450] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   66.421264] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   66.430556] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   66.438895] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   66.447126] UBIFS assert failed in ubifs_wbuf_write_nolock at 691 (pid 14)
> [   66.454079] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   66.462399] Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
> [   66.469093] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   66.477706] [<c00110c8>] (show_stack+0x10/0x14) from [<c00ffe10>] (ubifs_wbuf_write_nolock+0x244/0x7dc)
> [   66.487162] [<c00ffe10>] (ubifs_wbuf_write_nolock+0x244/0x7dc) from [<c00f34d8>] (ubifs_jnl_write_data+0x214/0x2dc)
> [   66.497653] [<c00f34d8>] (ubifs_jnl_write_data+0x214/0x2dc) from [<c00f5048>] (do_writepage+0xc0/0x1fc)
> [   66.507103] [<c00f5048>] (do_writepage+0xc0/0x1fc) from [<c006d4ec>] (__writepage+0x14/0x5c)
> [   66.515593] [<c006d4ec>] (__writepage+0x14/0x5c) from [<c006db84>] (write_cache_pages+0x23c/0x330)
> [   66.524603] [<c006db84>] (write_cache_pages+0x23c/0x330) from [<c006dcb4>] (generic_writepages+0x3c/0x58)
> [   66.534228] [<c006dcb4>] (generic_writepages+0x3c/0x58) from [<c00b98ec>] (__writeback_single_inode+0x34/0xfc)
> [   66.544289] [<c00b98ec>] (__writeback_single_inode+0x34/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   66.554609] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   66.564671] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   66.574124] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   66.583579] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   66.593378] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   66.602658] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   66.610959] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   66.619785] UBIFS assert failed in reserve_space at 125 (pid 14)
> [   66.625961] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   66.634324] Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
> [   66.641055] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   66.649675] [<c00110c8>] (show_stack+0x10/0x14) from [<c00f2500>] (make_reservation+0x80/0x46c)
> [   66.658435] [<c00f2500>] (make_reservation+0x80/0x46c) from [<c00f345c>] (ubifs_jnl_write_data+0x198/0x2dc)
> [   66.668239] [<c00f345c>] (ubifs_jnl_write_data+0x198/0x2dc) from [<c00f5048>] (do_writepage+0xc0/0x1fc)
> [   66.677692] [<c00f5048>] (do_writepage+0xc0/0x1fc) from [<c006d4ec>] (__writepage+0x14/0x5c)
> [   66.686189] [<c006d4ec>] (__writepage+0x14/0x5c) from [<c006db84>] (write_cache_pages+0x23c/0x330)
> [   66.695206] [<c006db84>] (write_cache_pages+0x23c/0x330) from [<c006dcb4>] (generic_writepages+0x3c/0x58)
> [   66.704830] [<c006dcb4>] (generic_writepages+0x3c/0x58) from [<c00b98ec>] (__writeback_single_inode+0x34/0xfc)
> [   66.714893] [<c00b98ec>] (__writeback_single_inode+0x34/0xfc) from [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c)
> [   66.725213] [<c00ba5c0>] (writeback_sb_inodes+0x200/0x37c) from [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4)
> [   66.735272] [<c00ba7a4>] (__writeback_inodes_wb+0x68/0xa4) from [<c00ba8ec>] (wb_writeback+0x10c/0x1a4)
> [   66.744727] [<c00ba8ec>] (wb_writeback+0x10c/0x1a4) from [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304)
> [   66.754190] [<c00baaa4>] (bdi_writeback_workfn+0x78/0x304) from [<c0030db0>] (process_one_work+0x208/0x344)
> [   66.763988] [<c0030db0>] (process_one_work+0x208/0x344) from [<c00313a8>] (worker_thread+0x22c/0x36c)
> [   66.773279] [<c00313a8>] (worker_thread+0x22c/0x36c) from [<c0035d40>] (kthread+0xa0/0xac)
> [   66.781580] [<c0035d40>] (kthread+0xa0/0xac) from [<c000e0f0>] (ret_from_fork+0x14/0x24)
> [   66.789798] UBIFS assert failed in ubifs_wbuf_write_nolock at 691 (pid 14)
> [   66.797145] CPU: 0 PID: 14 Comm: kworker/u2:1 Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   66.808684] reboot: Restarting system
> 
> ==============================================================
> ==============================================================
> ==============================================================
> 
> Here's what happens if I then try to mount/load a file from u-boot.
> 
> U-Boot 2013.10-00014-gce4b76b (Nov 25 2013 - 17:12:39)
> 
> CPU: Marvell PXA27x rev. Unknown
> Checking SDRAM U16/U20 data
> pass
> Checking SDRAM U44/U45 data
> pass
> Checking SDRAM U16/U20 address
> pass
> Checking SDRAM U44/U45 address
> pass
> DRAM:  256 MiB
> WARNING: Caches not enabled
> Flash: 64 MiB
> MMC:   PXA MMC: 0
> In:    serial
> Out:   serial
> Err:   serial
> KSZ8895MQ REV0 found, configuring...done
> Net:   dm9000
> Warning: dm9000 using MAC address from net device
> 
> Hit any key to stop autoboot:  0 
> $ <INTERRUPT>
> $ <INTERRUPT>
> $ <INTERRUPT>
> $ ubi part data || echo FAIL ; ubifsmount ubi0:rootfs || echo FAIL ; ubifsload ${scratch} ${kernel.ubi.path} || echo FAIL
> UBI: attaching mtd1 to ubi0
> UBI: physical eraseblock size:   131072 bytes (128 KiB)
> UBI: logical eraseblock size:    130944 bytes
> UBI: smallest flash I/O unit:    1
> UBI: VID header offset:          64 (aligned 64)
> UBI: data offset:                128
> UBI: attached mtd1 to ubi0
> UBI: MTD device name:            "mtd=4"
> UBI: MTD device size:            63 MiB
> UBI: number of good PEBs:        505
> UBI: number of bad PEBs:         0
> UBI: max. allowed volumes:       128
> UBI: wear-leveling threshold:    4096
> UBI: number of internal volumes: 1
> UBI: number of user volumes:     1
> UBI: available PEBs:             4
> UBI: total number of reserved PEBs: 501
> UBI: number of PEBs reserved for bad PEB handling: 0
> UBI: max/mean erase counter: 42/22
> UBIFS error (pid 0): ubifs_check_node: bad CRC: calculated 0x5bfc9168, read 0x653f8e7
> UBIFS error (pid 0): ubifs_check_node: bad node at LEB 46:61392
> UBIFS error (pid 0): ubifs_scanned_corruption: corrupted data at LEB 46:61392
> UBIFS error (pid 0): ubifs_scan: LEB 46 scanning failed
> UBIFS error (pid 0): ubifs_mount: Error reading superblock on volume 'ubi0:rootfs' errno=-117!
> 
> ubifsmount - mount UBIFS volume
> 
> Usage:
> ubifsmount <volume-name>
>     - mount 'volume-name' volume
> FAIL
> UBIFS not mounted, use ubifs mount to mount volume first!
> ubifsload - load file from an UBIFS filesystem
> 
> Usage:
> ubifsload <addr> <filename> [bytes]
>     - load file 'filename' to address 'addr'
> FAIL
> $ We have corrupted our ubifs partition (Run #1)
>     while executing
> "return -level 1 -code error $errorMsg"
> 
> ==============================================================
> ==============================================================
> ==============================================================
> 
> Here's the recovery process from Linux.  Note that I mount twice to get
> a successful mount.
> 
> [root@buildroot ~]# echo 7 > /proc/sys/kernel/printk
> [root@buildroot ~]# ubiattach -m4 -d0
> [   45.556102] UBI: attaching mtd4 to ubi0
> [   45.608396] UBI: scanning is finished
> [   45.672433] UBI: attached mtd4 (name "data", size 63 MiB) to ubi0
> [   45.678581] UBI: PEB size: 131072 bytes (128 KiB), LEB size: 130944 bytes
> [   45.720983] UBI: min./max. I/O unit sizes: 1/512, sub-page size 1
> [   45.728883] UBI: VID header offset: 64 (aligned 64), data offset: 128
> [   45.740496] UBI: good PEBs: 505, bad PEBs: 0, corrupted PEBs: 0
> [   45.747679] UBI: user volume: 1, internal volumes: 1, max. volumes count: 128
> [   45.756101] UBI: max/mean erase counter: 42/22, WL threshold: 4096, image sequence number: 2104545903
> [   45.766843] UBI: available PEBs: 4, total reserved PEBs: 501, PEBs reserved for bad PEB handling: 0
> [   45.777256] UBI: background thread "ubi_bgt0d" started, PID 509
> UBI device number 0, total 505 LEBs (66126720 bytes, 63.1 MiB), available 4 LEBs (523776 bytes, 511.5 KiB), LEB size 130944 bytes (127.9 KiB)
> [root@buildroot ~]# mount -t ubifs ubi0:rootfs /mnt
> [   59.813152] UBIFS: background thread "ubifs_bgt0_0" started, PID 512
> [   60.436819] UBIFS error (pid 510): ubifs_check_node: bad CRC: calculated 0x5bfc9168, read 0x653f8e7
> [   60.470007] UBIFS error (pid 510): ubifs_check_node: bad node at LEB 46:61392
> [   60.491545]  magic          0x6101831
> [   60.495442]  crc            0x653f8e7
> [   60.499127]  node_type      1 (data node)
> [   60.503205]  group_type     0 (no node group)
> [   60.507577]  sqnum          32292
> [   60.510910]  len            92
> [   60.514016]  key            (3682, data, 174)
> [   60.518383]  size           4096
> [   60.521620]  compr_typ      1
> [   60.524648]  data size      44
> [   60.527712]  data:
> [   60.529753]  00000000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   60.540515]  00000020: ff ff ff ff ff ff ff ff ff ff ff ff
> [   60.553316] CPU: 0 PID: 510 Comm: mount Not tainted 3.12.0-00041-g7f12d39-dirty #210
> [   60.561188] [<c0013390>] (unwind_backtrace+0x0/0xe0) from [<c00110c8>] (show_stack+0x10/0x14)
> [   60.601841] [<c00110c8>] (show_stack+0x10/0x14) from [<c00ff15c>] (ubifs_check_node+0x27c/0x2b8)
> [   60.613301] [<c00ff15c>] (ubifs_check_node+0x27c/0x2b8) from [<c0105dd8>] (ubifs_scan_a_node+0x14c/0x290)
> [   60.624261] [<c0105dd8>] (ubifs_scan_a_node+0x14c/0x290) from [<c0106334>] (ubifs_scan+0x98/0x31c)
> [   60.634852] [<c0106334>] (ubifs_scan+0x98/0x31c) from [<c0107184>] (ubifs_replay_journal+0x8c0/0x1550)
> [   60.645449] [<c0107184>] (ubifs_replay_journal+0x8c0/0x1550) from [<c00fc10c>] (ubifs_mount+0xd30/0x1960)
> [   60.656319] [<c00fc10c>] (ubifs_mount+0xd30/0x1960) from [<c009d0d8>] (mount_fs+0x10/0xc0)
> [   60.665944] [<c009d0d8>] (mount_fs+0x10/0xc0) from [<c00b2d78>] (vfs_kern_mount+0x48/0xc4)
> [   60.675557] [<c00b2d78>] (vfs_kern_mount+0x48/0xc4) from [<c00b502c>] (do_mount+0x6fc/0x800)
> [   60.685354] [<c00b502c>] (do_mount+0x6fc/0x800) from [<c00b51b4>] (SyS_mount+0x84/0xb8)
> [   60.694719] [<c00b51b4>] (SyS_mount+0x84/0xb8) from [<c000e060>] (ret_fast_syscall+0x0/0x2c)
> [   60.704467] UBIFS error (pid 510): ubifs_scan: bad node
> [   60.709747] UBIFS error (pid 510): ubifs_scanned_corruption: corruption at LEB 46:61392
> [   60.719347] UBIFS error (pid 510): ubifs_scanned_corruption: first 8192 bytes from LEB 46:61392
> [   60.756438] UBIFS error (pid 510): ubifs_scan: LEB 46 scanning failed
> [   60.776467] UBIFS: background thread "ubifs_bgt0_0" stops
> mount: mounting ubi0:rootfs on /mnt failed: Structure needs cleaning
> [root@buildroot ~]# echo $?
> 255
> [root@buildroot ~]# mount -t ubifs ubi0:rootfs /mnt
> [   70.023360] UBIFS: background thread "ubifs_bgt0_0" started, PID 516
> [   70.305482] UBIFS: recovery needed
> [   71.169289] UBIFS: recovery completed
> [   71.180961] UBIFS: mounted UBI device 0, volume 0, name "rootfs"
> [   71.199497] UBIFS: LEB size: 130944 bytes (127 KiB), min./max. I/O unit sizes: 8 bytes/512 bytes
> [   71.226483] UBIFS: FS size: 63769728 bytes (60 MiB, 487 LEBs), journal size 3142656 bytes (2 MiB, 24 LEBs)
> [   71.254470] UBIFS: reserved for root: 3012001 bytes (2941 KiB)
> [   71.260366] UBIFS: media format: w4/r0 (latest is w4/r0), UUID 567F5BCB-663D-4F84-BF34-3282E100D2D9, small LPT model
> [root@buildroot ~]# echo $?
> 0
> ==============================================================
> ==============================================================
> ==============================================================
