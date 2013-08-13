Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab3HMQg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:36:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32930 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604Ab3HMQ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:48 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=10wfW477xM8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vMInAEXWpJ8A:10 a=yPCof4ZbAAAA:8 a=IXr_WNlcAAAA:8 a=iox4zFpeAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=8GPG1bAHf7UBJ589fJsA:9 a=7DSvI1NPTFQA:10 a=T5ZRoNnfl4MA:10 a=n9GBPR9yFnkA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155836.005883694@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Junxiao Bi <junxiao.bi@oracle.com>, Jie Liu <jeff.liu@oracle.com>,
        Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>,
        Sunil Mushran <sunil.mushran@gmail.com>, <stable@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [78/88] ocfs2: xattr: fix inlined xattr reflink
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0078-ocfs2-xattr-fix-inlined-xattr-reflink.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

[ Upstream commit ef962df057aaafd714f5c22ba3de1be459571fdf ]

Inlined xattr shared free space of inode block with inlined data or data
extent record, so the size of the later two should be adjusted when
inlined xattr is enabled.  See ocfs2_xattr_ibody_init().  But this isn't
done well when reflink.  For inode with inlined data, its max inlined
data size is adjusted in ocfs2_duplicate_inline_data(), no problem.  But
for inode with data extent record, its record count isn't adjusted.  Fix
it, or data extent record and inlined xattr may overwrite each other,
then cause data corruption or xattr failure.

One panic caused by this bug in our test environment is the following:

  kernel BUG at fs/ocfs2/xattr.c:1435!
  invalid opcode: 0000 [#1] SMP
  Pid: 10871, comm: multi_reflink_t Not tainted 2.6.39-300.17.1.el5uek #1
  RIP: ocfs2_xa_offset_pointer+0x17/0x20 [ocfs2]
  RSP: e02b:ffff88007a587948  EFLAGS: 00010283
  RAX: 0000000000000000 RBX: 0000000000000010 RCX: 00000000000051e4
  RDX: ffff880057092060 RSI: 0000000000000f80 RDI: ffff88007a587a68
  RBP: ffff88007a587948 R08: 00000000000062f4 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000010
  R13: ffff88007a587a68 R14: 0000000000000001 R15: ffff88007a587c68
  FS:  00007fccff7f06e0(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
  CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 00000000015cf000 CR3: 000000007aa76000 CR4: 0000000000000660
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process multi_reflink_t
  Call Trace:
    ocfs2_xa_reuse_entry+0x60/0x280 [ocfs2]
    ocfs2_xa_prepare_entry+0x17e/0x2a0 [ocfs2]
    ocfs2_xa_set+0xcc/0x250 [ocfs2]
    ocfs2_xattr_ibody_set+0x98/0x230 [ocfs2]
    __ocfs2_xattr_set_handle+0x4f/0x700 [ocfs2]
    ocfs2_xattr_set+0x6c6/0x890 [ocfs2]
    ocfs2_xattr_user_set+0x46/0x50 [ocfs2]
    generic_setxattr+0x70/0x90
    __vfs_setxattr_noperm+0x80/0x1a0
    vfs_setxattr+0xa9/0xb0
    setxattr+0xc3/0x120
    sys_fsetxattr+0xa8/0xd0
    system_call_fastpath+0x16/0x1b

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Jie Liu <jeff.liu@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ocfs2/xattr.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 0ba9ea1..8abed46 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -6499,6 +6499,16 @@ static int ocfs2_reflink_xattr_inline(struct ocfs2_xattr_reflink *args)
 	}
 
 	new_oi = OCFS2_I(args->new_inode);
+	/*
+	 * Adjust extent record count to reserve space for extended attribute.
+	 * Inline data count had been adjusted in ocfs2_duplicate_inline_data().
+	 */
+	if (!(new_oi->ip_dyn_features & OCFS2_INLINE_DATA_FL) &&
+	    !(ocfs2_inode_is_fast_symlink(args->new_inode))) {
+		struct ocfs2_extent_list *el = &new_di->id2.i_list;
+		le16_add_cpu(&el->l_count, -(inline_size /
+					sizeof(struct ocfs2_extent_rec)));
+	}
 	spin_lock(&new_oi->ip_lock);
 	new_oi->ip_dyn_features |= OCFS2_HAS_XATTR_FL | OCFS2_INLINE_XATTR_FL;
 	new_di->i_dyn_features = cpu_to_le16(new_oi->ip_dyn_features);
-- 
1.7.10.4


