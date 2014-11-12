Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472AbaKLBxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:53:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32920 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966333AbaKLBxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:53:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.10 067/123] ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT
Date: Wed, 12 Nov 2014 10:17:13 +0900
Message-Id: <20141112011722.057648519@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 3e67cfad22230ebed85c56cbe413876f33fea82b upstream.

Otherwise this provokes complain like follows:
WARNING: CPU: 12 PID: 5795 at fs/ext4/ext4_jbd2.c:48 ext4_journal_check_start+0x4e/0xa0()
Modules linked in: brd iTCO_wdt lpc_ich mfd_core igb ptp dm_mirror dm_region_hash dm_log dm_mod
CPU: 12 PID: 5795 Comm: python Not tainted 3.17.0-rc2-00175-gae5344f #158
Hardware name: Intel Corporation W2600CR/W2600CR, BIOS SE5C600.86B.99.99.x028.061320111235 06/13/2011
 0000000000000030 ffff8808116cfd28 ffffffff815c7dfc 0000000000000030
 0000000000000000 ffff8808116cfd68 ffffffff8106ce8c ffff8808116cfdc8
 ffff880813b16000 ffff880806ad6ae8 ffffffff81202008 0000000000000000
Call Trace:
 [<ffffffff815c7dfc>] dump_stack+0x51/0x6d
 [<ffffffff8106ce8c>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff81202008>] ? ext4_ioctl+0x9e8/0xeb0
 [<ffffffff8106ceda>] warn_slowpath_null+0x1a/0x20
 [<ffffffff8122867e>] ext4_journal_check_start+0x4e/0xa0
 [<ffffffff81228c10>] __ext4_journal_start_sb+0x90/0x110
 [<ffffffff81202008>] ext4_ioctl+0x9e8/0xeb0
 [<ffffffff8107b0bd>] ? ptrace_stop+0x24d/0x2f0
 [<ffffffff81088530>] ? alloc_pid+0x480/0x480
 [<ffffffff8107b1f2>] ? ptrace_do_notify+0x92/0xb0
 [<ffffffff81186545>] do_vfs_ioctl+0x4e5/0x550
 [<ffffffff815cdbcb>] ? _raw_spin_unlock_irq+0x2b/0x40
 [<ffffffff81186603>] SyS_ioctl+0x53/0x80
 [<ffffffff815ce2ce>] tracesys+0xd0/0xd5

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ioctl.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -549,9 +549,17 @@ group_add_out:
 	}
 
 	case EXT4_IOC_SWAP_BOOT:
+	{
+		int err;
 		if (!(filp->f_mode & FMODE_WRITE))
 			return -EBADF;
-		return swap_inode_boot_loader(sb, inode);
+		err = mnt_want_write_file(filp);
+		if (err)
+			return err;
+		err = swap_inode_boot_loader(sb, inode);
+		mnt_drop_write_file(filp);
+		return err;
+	}
 
 	case EXT4_IOC_RESIZE_FS: {
 		ext4_fsblk_t n_blocks_count;


