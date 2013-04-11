Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936110Ab3DKUv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:51:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5406 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935929Ab3DKUtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:36 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ONCkIJdHNgAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5F6MauesJIUA:10 a=VwQbUJbxAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202555.895367580@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [ 059/171 ] ext4: fix data=journal fast mount/umount hang
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0059-ext4-fix-data-journal-fast-mount-umount-hang.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 2b405bfa84063bfa35621d2d6879f52693c614b0 ]

In data=journal mode, if we unmount the file system before a
transaction has a chance to complete, when the journal inode is being
evicted, we can end up calling into jbd2_log_wait_commit() for the
last transaction, after the journalling machinery has been shut down.

Arguably we should adjust ext4_should_journal_data() to return FALSE
for the journal inode, but the only place it matters is
ext4_evict_inode(), and so to save a bit of CPU time, and to make the
patch much more obviously correct by inspection(tm), we'll fix it by
explicitly not trying to waiting for a journal commit when we are
evicting the journal inode, since it's guaranteed to never succeed in
this case.

This can be easily replicated via:

     mount -t ext4 -o data=journal /dev/vdb /vdb ; umount /vdb

------------[ cut here ]------------
WARNING: at /usr/projects/linux/ext4/fs/jbd2/journal.c:542 __jbd2_log_start_commit+0xba/0xcd()
Hardware name: Bochs
JBD2: bad log_start_commit: 3005630206 3005630206 0 0
Modules linked in:
Pid: 2909, comm: umount Not tainted 3.8.0-rc3 #1020
Call Trace:
 [<c015c0ef>] warn_slowpath_common+0x68/0x7d
 [<c02b7e7d>] ? __jbd2_log_start_commit+0xba/0xcd
 [<c015c177>] warn_slowpath_fmt+0x2b/0x2f
 [<c02b7e7d>] __jbd2_log_start_commit+0xba/0xcd
 [<c02b8075>] jbd2_log_start_commit+0x24/0x34
 [<c0279ed5>] ext4_evict_inode+0x71/0x2e3
 [<c021f0ec>] evict+0x94/0x135
 [<c021f9aa>] iput+0x10a/0x110
 [<c02b7836>] jbd2_journal_destroy+0x190/0x1ce
 [<c0175284>] ? bit_waitqueue+0x50/0x50
 [<c028d23f>] ext4_put_super+0x52/0x294
 [<c020efe3>] generic_shutdown_super+0x48/0xb4
 [<c020f071>] kill_block_super+0x22/0x60
 [<c020f3e0>] deactivate_locked_super+0x22/0x49
 [<c020f5d6>] deactivate_super+0x30/0x33
 [<c0222795>] mntput_no_expire+0x107/0x10c
 [<c02233a7>] sys_umount+0x2cf/0x2e0
 [<c02233ca>] sys_oldumount+0x12/0x14
 [<c08096b8>] syscall_call+0x7/0xb
---[ end trace 6a954cc790501c1f ]---
jbd2_log_wait_commit: error: j_commit_request=-1289337090, tid=0

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2ce16af..5cf441c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -211,7 +211,8 @@ void ext4_evict_inode(struct inode *inode)
 		 * don't use page cache.
 		 */
 		if (ext4_should_journal_data(inode) &&
-		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
+		    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode)) &&
+		    inode->i_ino != EXT4_JOURNAL_INO) {
 			journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 			tid_t commit_tid = EXT4_I(inode)->i_datasync_tid;
 
-- 
1.7.10.4


