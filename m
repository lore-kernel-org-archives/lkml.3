Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3KYP0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:26:12 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:41053 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3KYP0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:26:08 -0500
Message-ID: <1385393160.4753.4.camel@phoenix>
Subject: ARM: nommu: Boot hang after VFS: Mounted root (ext2 filesystem) on
 device 1:0.
From: Axel Lin <axel.lin@ingics.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>
Date: Mon, 25 Nov 2013 23:26:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I got hangup at boot after "VFS: Mounted root (ext2 filesystem) on device 1:0.".
I'm using ext2 initrd as root.
It seems hangup after mount root, but in the progress of mounting devtmpfs.

After debug it, I found it hangs at calling page_cache_release.
Note, I'm testing on an nommu platform (arm7tdmi) using current Linus' tree
with patches for this SoC.

Breakpoint 3, ext2_inode_by_name (dir=<optimized out>, child=<optimized out>) at fs/ext2/dir.c:452
452                     ext2_put_page(page);
(gdb) bt
#0  ext2_inode_by_name (dir=<optimized out>, child=<optimized out>) at fs/ext2/dir.c:452
#1  0x000b0218 in ext2_lookup (dir=0x1cbf8e0, dentry=0x161d390, flags=<optimized out>) at fs/ext2/namei.c:66
#2  0x0006a160 in lookup_real (dir=<optimized out>, dentry=0x161d390, flags=<optimized out>) at fs/namei.c:1317
#3  0x0006a5fc in __lookup_hash (name=<optimized out>, base=0x161d228, flags=1) at fs/namei.c:1335
#4  0x0006b828 in lookup_slow (nd=0x1c19e58, path=0x1c19de0) at fs/namei.c:1446
#5  0x0006c914 in walk_component (follow=1, path=0x1c19dd8, nd=0x1c19e58) at fs/namei.c:1526
#6  lookup_last (path=0x1c19dd8, nd=0x1c19e58) at fs/namei.c:1904
#7  path_lookupat (dfd=<optimized out>, name=0x1640010 "dev", flags=<optimized out>, nd=0x1c19e58) at fs/namei.c:1939
#8  0x0006cf30 in filename_lookup (dfd=-100, name=0x1c19e30, flags=1, nd=0x1c19e58) at fs/namei.c:1981
#9  0x0006d000 in do_path_lookup (dfd=-100, name=0x1640010 "dev", flags=1, nd=0x1c19e58) at fs/namei.c:1998
#10 0x0006d218 in kern_path (name=<optimized out>, flags=<optimized out>, path=0x1c19ee0) at fs/namei.c:2027
#11 0x0007dbd0 in do_mount (dev_name=0x161d380 "devtmpfs", dir_name=0x1640010 "dev", type_page=0x161d340 "devtmpfs", flags=32768,
    data_page=0x0 <__vectors_start>) at fs/namespace.c:2363
#12 0x0007e71c in SYSC_mount (data=0x378620 <reset_devices>, flags=32768, type=<optimized out>, dir_name=<optimized out>,
    dev_name=0x30a0da "devtmpfs") at fs/namespace.c:2608
#13 SyS_mount (dev_name=<optimized out>, dir_name=<optimized out>, type=<optimized out>, flags=<optimized out>, data=0) at fs/namespace.c:2582
#14 0x00123444 in devtmpfs_mount (mntdir=<optimized out>) at drivers/base/devtmpfs.c:363
#15 0x0033a394 in prepare_namespace () at init/do_mounts.c:593
#16 0x00339cd0 in kernel_init_freeable () at init/main.c:935
#17 0x0028b7c0 in kernel_init (unused=<optimized out>) at init/main.c:844
#18 0x00009000 in ret_from_fork () at arch/arm/kernel/entry-common.S:91
#19 0x00009000 in ret_from_fork () at arch/arm/kernel/entry-common.S:91
Backtrace stopped: previous frame identical to this frame (corrupt stack?)
(gdb) s
ext2_put_page (page=<optimized out>) at fs/ext2/dir.c:70
70              page_cache_release(page);
(gdb) l
65      }
66
67      static inline void ext2_put_page(struct page *page)
68      {
69              kunmap(page);
70              page_cache_release(page);
71      }
72
73      static inline unsigned long dir_pages(struct inode *inode)
74      {
(gdb) s
ext2_inode_by_name (dir=<optimized out>, child=<optimized out>) at fs/ext2/dir.c:451
451                     res = le32_to_cpu(de->inode);
(gdb) s
452                     ext2_put_page(page);
(gdb) s
ext2_put_page (page=0xac4e0 <ext2_inode_by_name+12>) at fs/ext2/dir.c:70
70              page_cache_release(page);
(gdb) s         <<< HANG UP

I have no idea why it hangs at page_cache_release call.
I appreciate for comments and advices to debug this.

Thanks,
Axel

