Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbaA2Fb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 00:31:29 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:45399 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaA2Fb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 00:31:27 -0500
Date: Tue, 28 Jan 2014 23:32:38 -0600
From: Andrew Ruder <andy@aeruder.net>
To: Richard Weinberger <richard.weinberger@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] reproducable ubifs reboot assert and corruption
Message-ID: <20140129053238.GA6035@gmail.com>
Mail-Followup-To: Richard Weinberger <richard.weinberger@gmail.com>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20140122051510.GB17284@gmail.com>
 <CAFLxGvwmzftdQKSjjjwpFLS8g3EJqMrQ2gU2scBsh2MvG7Wyyw@mail.gmail.com>
 <20140127163939.GA27809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140127163939.GA27809@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I've got some more useful information.  I have been adding
a multitude of WARN_ON's and prink's all over the remount code and have
come up with the attached log.

A little bit of explanation:

Line 1: sync_filesystem (from do_remount_sb)
Line 188: sync_filesystem ends
Line 43, 64, 81, 98, 114, 135, 156, 173: write operations that occur
during sync_filesystem.  Before each warning I print the inode pointer.
Line 197: read-only remount has completely finished (this message is
from userspace post remount)
Line 199: a sync is called, there are apparently dirty inodes in our
now-readonly ubifs filesystem
Line 215: failed assert that occurs because the writeback triggers for
inode 0xd75b9450 (see line 41, it got in with a sys_write while we were
running our sync_filesystem in do_remount_sb)

Does this help?  It looks like there is a race condition between the
writeback code and the remount read-only.  Nothing is done to lock out
writes during the first half of the do_remount_sb and some stuff makes
it into the writeback worker queue while we are busy syncing the
filesystem only to trigger later when ubifs has decided it is
read-only...

Note: I only barely know what I am talking about - filesystems still not
my forte :)

Thanks,
Andy


  1: pre sync_filesystem
  2: ------------[ cut here ]------------
  3: WARNING: CPU: 0 PID: 645 at fs/fs-writeback.c:98 bdi_queue_work+0xc8/0x130()
  4: Modules linked in:
  5: CPU: 0 PID: 645 Comm: mount Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
  6: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
  7: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
  8: [<c0348590>] (dump_stack+0x20/0x28) from [<c0020874>] (warn_slowpath_common+0x78/0x98)
  9: [<c0020874>] (warn_slowpath_common+0x78/0x98) from [<c0020950>] (warn_slowpath_null+0x2c/0x34)
 10: [<c0020950>] (warn_slowpath_null+0x2c/0x34) from [<c00f4f00>] (bdi_queue_work+0xc8/0x130)
 11: [<c00f4f00>] (bdi_queue_work+0xc8/0x130) from [<c00f58cc>] (writeback_inodes_sb_nr+0xb4/0xd4)
 12: [<c00f58cc>] (writeback_inodes_sb_nr+0xb4/0xd4) from [<c00f591c>] (writeback_inodes_sb+0x30/0x34)
 13: [<c00f591c>] (writeback_inodes_sb+0x30/0x34) from [<c00fa3fc>] (sync_filesystem+0x50/0xbc)
 14: [<c00fa3fc>] (sync_filesystem+0x50/0xbc) from [<c00d3bf4>] (do_remount_sb+0xb8/0x1fc)
 15: [<c00d3bf4>] (do_remount_sb+0xb8/0x1fc) from [<c00ee3d0>] (do_mount+0x2e8/0x81c)
 16: [<c00ee3d0>] (do_mount+0x2e8/0x81c) from [<c00ee998>] (SyS_mount+0x94/0xc8)
 17: [<c00ee998>] (SyS_mount+0x94/0xc8) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
 18: ---[ end trace c6e04f3813781dc3 ]---
 19: Adding tail
 20: writeback_workfn d781c110 d700fe8c
 21: inode: d75a2c30
 22: inode: d75b8c30
 23: ------------[ cut here ]------------
 24: WARNING: CPU: 0 PID: 645 at fs/fs-writeback.c:98 bdi_queue_work+0xc8/0x130()
 25: Modules linked in:
 26: CPU: 0 PID: 645 Comm: mount Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
 27: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
 28: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
 29: [<c0348590>] (dump_stack+0x20/0x28) from [<c0020874>] (warn_slowpath_common+0x78/0x98)
 30: [<c0020874>] (warn_slowpath_common+0x78/0x98) from [<c0020950>] (warn_slowpath_null+0x2c/0x34)
 31: [<c0020950>] (warn_slowpath_null+0x2c/0x34) from [<c00f4f00>] (bdi_queue_work+0xc8/0x130)
 32: [<c00f4f00>] (bdi_queue_work+0xc8/0x130) from [<c00f59dc>] (sync_inodes_sb+0xbc/0x1bc)
 33: [<c00f59dc>] (sync_inodes_sb+0xbc/0x1bc) from [<c00fa434>] (sync_filesystem+0x88/0xbc)
 34: [<c00fa434>] (sync_filesystem+0x88/0xbc) from [<c00d3bf4>] (do_remount_sb+0xb8/0x1fc)
 35: [<c00d3bf4>] (do_remount_sb+0xb8/0x1fc) from [<c00ee3d0>] (do_mount+0x2e8/0x81c)
 36: [<c00ee3d0>] (do_mount+0x2e8/0x81c) from [<c00ee998>] (SyS_mount+0x94/0xc8)
 37: [<c00ee998>] (SyS_mount+0x94/0xc8) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
 38: ---[ end trace c6e04f3813781dc4 ]---
 39: Adding tail
 40: writeback_workfn d781c110 d700fe9c
 41: inode: d75b9450
 42: ------------[ cut here ]------------
 43: WARNING: CPU: 0 PID: 651 at fs/fs-writeback.c:1215 __mark_inode_dirty+0x2dc/0x32c()
 44: Modules linked in:
 45: CPU: 0 PID: 651 Comm: fsstress Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
 46: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
 47: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
 48: [<c0348590>] (dump_stack+0x20/0x28) from [<c0020874>] (warn_slowpath_common+0x78/0x98)
 49: [<c0020874>] (warn_slowpath_common+0x78/0x98) from [<c0020950>] (warn_slowpath_null+0x2c/0x34)
 50: [<c0020950>] (warn_slowpath_null+0x2c/0x34) from [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c)
 51: [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c) from [<c009dc70>] (__set_page_dirty_nobuffers+0xf4/0x110)
 52: [<c009dc70>] (__set_page_dirty_nobuffers+0xf4/0x110) from [<c0138a48>] (ubifs_write_end+0x1c8/0x294)
 53: [<c0138a48>] (ubifs_write_end+0x1c8/0x294) from [<c009504c>] (generic_file_buffered_write+0x17c/0x260)
 54: [<c009504c>] (generic_file_buffered_write+0x17c/0x260) from [<c0096ce8>] (__generic_file_aio_write+0x420/0x448)
 55: [<c0096ce8>] (__generic_file_aio_write+0x420/0x448) from [<c0096d78>] (generic_file_aio_write+0x68/0xac)
 56: [<c0096d78>] (generic_file_aio_write+0x68/0xac) from [<c0139880>] (ubifs_aio_write+0x17c/0x18c)
 57: [<c0139880>] (ubifs_aio_write+0x17c/0x18c) from [<c00d0290>] (do_sync_write+0x7c/0xa0)
 58: [<c00d0290>] (do_sync_write+0x7c/0xa0) from [<c00d09e4>] (vfs_write+0xe4/0x194)
 59: [<c00d09e4>] (vfs_write+0xe4/0x194) from [<c00d0f94>] (SyS_write+0x4c/0x7c)
 60: [<c00d0f94>] (SyS_write+0x4c/0x7c) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
 61: ---[ end trace c6e04f3813781dc5 ]---
 62: inode: d75a3248
 63: ------------[ cut here ]------------
 64: WARNING: CPU: 0 PID: 656 at fs/fs-writeback.c:1215 __mark_inode_dirty+0x2dc/0x32c()
 65: Modules linked in:
 66: CPU: 0 PID: 656 Comm: fsstress Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
 67: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
 68: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
 69: [<c0348590>] (dump_stack+0x20/0x28) from [<c0020874>] (warn_slowpath_common+0x78/0x98)
 70: [<c0020874>] (warn_slowpath_common+0x78/0x98) from [<c0020950>] (warn_slowpath_null+0x2c/0x34)
 71: [<c0020950>] (warn_slowpath_null+0x2c/0x34) from [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c)
 72: [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c) from [<c0138184>] (ubifs_setattr+0x40c/0x49c)
 73: [<c0138184>] (ubifs_setattr+0x40c/0x49c) from [<c00e9634>] (notify_change+0x204/0x2e8)
 74: [<c00e9634>] (notify_change+0x204/0x2e8) from [<c00ce888>] (chown_common.isra.14+0x80/0x98)
 75: [<c00ce888>] (chown_common.isra.14+0x80/0x98) from [<c00cf820>] (SyS_fchownat+0x8c/0xd4)
 76: [<c00cf820>] (SyS_fchownat+0x8c/0xd4) from [<c00cf8e8>] (SyS_lchown+0x3c/0x44)
 77: [<c00cf8e8>] (SyS_lchown+0x3c/0x44) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
 78: ---[ end trace c6e04f3813781dc6 ]---
 79: inode: d75a7040
 80: ------------[ cut here ]------------
 81: WARNING: CPU: 0 PID: 652 at fs/fs-writeback.c:1215 __mark_inode_dirty+0x2dc/0x32c()
 82: Modules linked in:
 83: CPU: 0 PID: 652 Comm: fsstress Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
 84: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
 85: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
 86: [<c0348590>] (dump_stack+0x20/0x28) from [<c0020874>] (warn_slowpath_common+0x78/0x98)
 87: [<c0020874>] (warn_slowpath_common+0x78/0x98) from [<c0020950>] (warn_slowpath_null+0x2c/0x34)
 88: [<c0020950>] (warn_slowpath_null+0x2c/0x34) from [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c)
 89: [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c) from [<c0138184>] (ubifs_setattr+0x40c/0x49c)
 90: [<c0138184>] (ubifs_setattr+0x40c/0x49c) from [<c00e9634>] (notify_change+0x204/0x2e8)
 91: [<c00e9634>] (notify_change+0x204/0x2e8) from [<c00ce888>] (chown_common.isra.14+0x80/0x98)
 92: [<c00ce888>] (chown_common.isra.14+0x80/0x98) from [<c00cf820>] (SyS_fchownat+0x8c/0xd4)
 93: [<c00cf820>] (SyS_fchownat+0x8c/0xd4) from [<c00cf8e8>] (SyS_lchown+0x3c/0x44)
 94: [<c00cf8e8>] (SyS_lchown+0x3c/0x44) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
 95: ---[ end trace c6e04f3813781dc7 ]---
 96: inode: d75b9c70
 97: ------------[ cut here ]------------
 98: WARNING: CPU: 0 PID: 647 at fs/fs-writeback.c:1215 __mark_inode_dirty+0x2dc/0x32c()
 99: Modules linked in:
100: CPU: 0 PID: 647 Comm: fsstress Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
101: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
102: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
103: [<c0348590>] (dump_stack+0x20/0x28) from [<c0020874>] (warn_slowpath_common+0x78/0x98)
104: [<c0020874>] (warn_slowpath_common+0x78/0x98) from [<c0020950>] (warn_slowpath_null+0x2c/0x34)
105: [<c0020950>] (warn_slowpath_null+0x2c/0x34) from [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c)
106: [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c) from [<c013b8ac>] (ubifs_rename+0x4a4/0x600)
107: [<c013b8ac>] (ubifs_rename+0x4a4/0x600) from [<c00de80c>] (vfs_rename+0x280/0x3f4)
108: [<c00de80c>] (vfs_rename+0x280/0x3f4) from [<c00df4ac>] (SyS_renameat+0x18c/0x218)
109: [<c00df4ac>] (SyS_renameat+0x18c/0x218) from [<c00df564>] (SyS_rename+0x2c/0x30)
110: [<c00df564>] (SyS_rename+0x2c/0x30) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
111: ---[ end trace c6e04f3813781dc8 ]---
112: inode: d75a6e38
113: ------------[ cut here ]------------
114: WARNING: CPU: 0 PID: 650 at fs/fs-writeback.c:1215 __mark_inode_dirty+0x2dc/0x32c()
115: Modules linked in:
116: CPU: 0 PID: 650 Comm: fsstress Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
117: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
118: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
119: [<c0348590>] (dump_stack+0x20/0x28) from [<c0020874>] (warn_slowpath_common+0x78/0x98)
120: [<c0020874>] (warn_slowpath_common+0x78/0x98) from [<c0020950>] (warn_slowpath_null+0x2c/0x34)
121: [<c0020950>] (warn_slowpath_null+0x2c/0x34) from [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c)
122: [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c) from [<c009dc70>] (__set_page_dirty_nobuffers+0xf4/0x110)
123: [<c009dc70>] (__set_page_dirty_nobuffers+0xf4/0x110) from [<c0138a48>] (ubifs_write_end+0x1c8/0x294)
124: [<c0138a48>] (ubifs_write_end+0x1c8/0x294) from [<c009504c>] (generic_file_buffered_write+0x17c/0x260)
125: [<c009504c>] (generic_file_buffered_write+0x17c/0x260) from [<c0096ce8>] (__generic_file_aio_write+0x420/0x448)
126: [<c0096ce8>] (__generic_file_aio_write+0x420/0x448) from [<c0096d78>] (generic_file_aio_write+0x68/0xac)
127: [<c0096d78>] (generic_file_aio_write+0x68/0xac) from [<c0139880>] (ubifs_aio_write+0x17c/0x18c)
128: [<c0139880>] (ubifs_aio_write+0x17c/0x18c) from [<c00d0290>] (do_sync_write+0x7c/0xa0)
129: [<c00d0290>] (do_sync_write+0x7c/0xa0) from [<c00d09e4>] (vfs_write+0xe4/0x194)
130: [<c00d09e4>] (vfs_write+0xe4/0x194) from [<c00d0f94>] (SyS_write+0x4c/0x7c)
131: [<c00d0f94>] (SyS_write+0x4c/0x7c) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
132: ---[ end trace c6e04f3813781dc9 ]---
133: inode: d75a2e38
134: ------------[ cut here ]------------
135: WARNING: CPU: 0 PID: 651 at fs/fs-writeback.c:1215 __mark_inode_dirty+0x2dc/0x32c()
136: Modules linked in:
137: CPU: 0 PID: 651 Comm: fsstress Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
138: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
139: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
140: [<c0348590>] (dump_stack+0x20/0x28) from [<c0020874>] (warn_slowpath_common+0x78/0x98)
141: [<c0020874>] (warn_slowpath_common+0x78/0x98) from [<c0020950>] (warn_slowpath_null+0x2c/0x34)
142: [<c0020950>] (warn_slowpath_null+0x2c/0x34) from [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c)
143: [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c) from [<c009dc70>] (__set_page_dirty_nobuffers+0xf4/0x110)
144: [<c009dc70>] (__set_page_dirty_nobuffers+0xf4/0x110) from [<c0138a48>] (ubifs_write_end+0x1c8/0x294)
145: [<c0138a48>] (ubifs_write_end+0x1c8/0x294) from [<c009504c>] (generic_file_buffered_write+0x17c/0x260)
146: [<c009504c>] (generic_file_buffered_write+0x17c/0x260) from [<c0096ce8>] (__generic_file_aio_write+0x420/0x448)
147: [<c0096ce8>] (__generic_file_aio_write+0x420/0x448) from [<c0096d78>] (generic_file_aio_write+0x68/0xac)
148: [<c0096d78>] (generic_file_aio_write+0x68/0xac) from [<c0139880>] (ubifs_aio_write+0x17c/0x18c)
149: [<c0139880>] (ubifs_aio_write+0x17c/0x18c) from [<c00d0290>] (do_sync_write+0x7c/0xa0)
150: [<c00d0290>] (do_sync_write+0x7c/0xa0) from [<c00d09e4>] (vfs_write+0xe4/0x194)
151: [<c00d09e4>] (vfs_write+0xe4/0x194) from [<c00d0f94>] (SyS_write+0x4c/0x7c)
152: [<c00d0f94>] (SyS_write+0x4c/0x7c) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
153: ---[ end trace c6e04f3813781dca ]---
154: inode: d75a2410
155: ------------[ cut here ]------------
156: WARNING: CPU: 0 PID: 653 at fs/fs-writeback.c:1215 __mark_inode_dirty+0x2dc/0x32c()
157: Modules linked in:
158: CPU: 0 PID: 653 Comm: fsstress Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
159: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
160: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
161: [<c0348590>] (dump_stack+0x20/0x28) from [<c0020874>] (warn_slowpath_common+0x78/0x98)
162: [<c0020874>] (warn_slowpath_common+0x78/0x98) from [<c0020950>] (warn_slowpath_null+0x2c/0x34)
163: [<c0020950>] (warn_slowpath_null+0x2c/0x34) from [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c)
164: [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c) from [<c0138184>] (ubifs_setattr+0x40c/0x49c)
165: [<c0138184>] (ubifs_setattr+0x40c/0x49c) from [<c00e9634>] (notify_change+0x204/0x2e8)
166: [<c00e9634>] (notify_change+0x204/0x2e8) from [<c00ce888>] (chown_common.isra.14+0x80/0x98)
167: [<c00ce888>] (chown_common.isra.14+0x80/0x98) from [<c00cf820>] (SyS_fchownat+0x8c/0xd4)
168: [<c00cf820>] (SyS_fchownat+0x8c/0xd4) from [<c00cf8e8>] (SyS_lchown+0x3c/0x44)
169: [<c00cf8e8>] (SyS_lchown+0x3c/0x44) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
170: ---[ end trace c6e04f3813781dcb ]---
171: inode: d75a6410
172: ------------[ cut here ]------------
173: WARNING: CPU: 0 PID: 653 at fs/fs-writeback.c:1215 __mark_inode_dirty+0x2dc/0x32c()
174: Modules linked in:
175: CPU: 0 PID: 653 Comm: fsstress Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
176: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
177: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
178: [<c0348590>] (dump_stack+0x20/0x28) from [<c0020874>] (warn_slowpath_common+0x78/0x98)
179: [<c0020874>] (warn_slowpath_common+0x78/0x98) from [<c0020950>] (warn_slowpath_null+0x2c/0x34)
180: [<c0020950>] (warn_slowpath_null+0x2c/0x34) from [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c)
181: [<c00f57c8>] (__mark_inode_dirty+0x2dc/0x32c) from [<c0138184>] (ubifs_setattr+0x40c/0x49c)
182: [<c0138184>] (ubifs_setattr+0x40c/0x49c) from [<c00e9634>] (notify_change+0x204/0x2e8)
183: [<c00e9634>] (notify_change+0x204/0x2e8) from [<c00ce888>] (chown_common.isra.14+0x80/0x98)
184: [<c00ce888>] (chown_common.isra.14+0x80/0x98) from [<c00cf820>] (SyS_fchownat+0x8c/0xd4)
185: [<c00cf820>] (SyS_fchownat+0x8c/0xd4) from [<c00cf8e8>] (SyS_lchown+0x3c/0x44)
186: [<c00cf8e8>] (SyS_lchown+0x3c/0x44) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
187: ---[ end trace c6e04f3813781dcc ]---
188: post sync_filesystem
189: preparing
190: done preparing
191: success
192: In remount_ro
193: UBIFS: background thread "ubifs_bgt0_0" stops
194: thread stopped
195: ending 1 d781c110 d781c110
196: remount done 1
197:  remount
198: ------------[ cut here ]------------
199: WARNING: CPU: 0 PID: 661 at fs/fs-writeback.c:98 bdi_queue_work+0xc8/0x130()
200: Modules linked in:
201: CPU: 0 PID: 661 Comm: fsstress Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
202: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
203: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
204: [<c0348590>] (dump_stack+0x20/0x28) from [<c0020874>] (warn_slowpath_common+0x78/0x98)
205: [<c0020874>] (warn_slowpath_common+0x78/0x98) from [<c0020950>] (warn_slowpath_null+0x2c/0x34)
206: [<c0020950>] (warn_slowpath_null+0x2c/0x34) from [<c00f4f00>] (bdi_queue_work+0xc8/0x130)
207: [<c00f4f00>] (bdi_queue_work+0xc8/0x130) from [<c00f5e48>] (__bdi_start_writeback+0x114/0x128)
208: [<c00f5e48>] (__bdi_start_writeback+0x114/0x128) from [<c00f70fc>] (wakeup_flusher_threads+0x70/0x90)
209: [<c00f70fc>] (wakeup_flusher_threads+0x70/0x90) from [<c00fa49c>] (sys_sync+0x34/0xa4)
210: [<c00fa49c>] (sys_sync+0x34/0xa4) from [<c000e820>] (ret_fast_syscall+0x0/0x2c)
211: ---[ end trace c6e04f3813781dcd ]---
212: Adding tail
213: writeback_workfn d781c110 d7b970d8
214: inode: d75b9450
215: UBIFS assert failed in reserve_space at 125 (pid 6)
216: CPU: 0 PID: 6 Comm: kworker/u2:0 Tainted: G        W    3.12.0-00041-g7f12d39-dirty #236
217: Workqueue: writeback bdi_writeback_workfn (flush-ubifs_0_0)
218: [<c0014fb4>] (unwind_backtrace+0x0/0x128) from [<c0012394>] (show_stack+0x20/0x24)
219: [<c0012394>] (show_stack+0x20/0x24) from [<c0348590>] (dump_stack+0x20/0x28)
220: [<c0348590>] (dump_stack+0x20/0x28) from [<c0134b84>] (make_reservation+0x8c/0x560)
221: [<c0134b84>] (make_reservation+0x8c/0x560) from [<c0135ed8>] (ubifs_jnl_write_inode+0xbc/0x214)
222: [<c0135ed8>] (ubifs_jnl_write_inode+0xbc/0x214) from [<c013d168>] (ubifs_write_inode+0xec/0x17c)
223: [<c013d168>] (ubifs_write_inode+0xec/0x17c) from [<c01391d8>] (ubifs_writepage+0x180/0x288)
224: [<c01391d8>] (ubifs_writepage+0x180/0x288) from [<c009d2dc>] (__writepage+0x24/0x6c)
225: [<c009d2dc>] (__writepage+0x24/0x6c) from [<c009d89c>] (write_cache_pages+0x2e8/0x3e8)
226: [<c009d89c>] (write_cache_pages+0x2e8/0x3e8) from [<c009d9e8>] (generic_writepages+0x4c/0x68)
227: [<c009d9e8>] (generic_writepages+0x4c/0x68) from [<c009f040>] (do_writepages+0x3c/0x48)
228: [<c009f040>] (do_writepages+0x3c/0x48) from [<c00f518c>] (__writeback_single_inode+0xf8/0x37c)
229: [<c00f518c>] (__writeback_single_inode+0xf8/0x37c) from [<c00f60f0>] (writeback_sb_inodes+0x1f8/0x3dc)
230: [<c00f60f0>] (writeback_sb_inodes+0x1f8/0x3dc) from [<c00f6354>] (__writeback_inodes_wb+0x80/0xc0)
231: [<c00f6354>] (__writeback_inodes_wb+0x80/0xc0) from [<c00f6548>] (wb_writeback+0x1b4/0x364)
232: [<c00f6548>] (wb_writeback+0x1b4/0x364) from [<c00f6c74>] (bdi_writeback_workfn+0xbc/0x4d4)
233: [<c00f6c74>] (bdi_writeback_workfn+0xbc/0x4d4) from [<c0038454>] (process_one_work+0x298/0x44c)
234: [<c0038454>] (process_one_work+0x298/0x44c) from [<c0038b04>] (worker_thread+0x240/0x380)
235: [<c0038b04>] (worker_thread+0x240/0x380) from [<c003e1a8>] (kthread+0xbc/0xc8)
236: [<c003e1a8>] (kthread+0xbc/0xc8) from [<c000e8b0>] (ret_from_fork+0x14/0x20)
