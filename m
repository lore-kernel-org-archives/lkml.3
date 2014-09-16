Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaIPMHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 08:07:55 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:2506 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaIPMHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 08:07:52 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-metag@vger.kernel.org>
Subject: [PATCH] vfs: workaround gcc <4.6 build error in link_path_walk()
Date: Tue, 16 Sep 2014 13:07:35 +0100
Message-ID: <1410869255-8506-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d6bb3e9075bb (vfs: simplify and shrink stack frame of
link_path_walk()) introduced build problems with GCC versions older than
4.6 due to the initialisation of a member of an anonymous union in
struct qstr without enclosing braces.

This hits GCC bug 10676 [1] (which was fixed in GCC 4.6 by [2]), and
causes the following build error:
  fs/namei.c: In function 'link_path_walk':
  fs/namei.c:1778: error: unknown field 'hash_len' specified in initializer

This is worked around by adding explicit braces.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=10676
[2] https://gcc.gnu.org/viewcvs/gcc?view=revision&revision=159206

Fixes: d6bb3e9075bb (vfs: simplify and shrink stack frame of link_path_walk())
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-metag@vger.kernel.org
---
At least for metag it's feasible to fix the compiler, since backporting
the fix to GCC 4.2.4 isn't actually very difficult. I don't know about
other users of GCC <4.6 though.
---
 fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 01d03892316c..a7b05bf82d31 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1775,7 +1775,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 			struct dentry *parent = nd->path.dentry;
 			nd->flags &= ~LOOKUP_JUMPED;
 			if (unlikely(parent->d_flags & DCACHE_OP_HASH)) {
-				struct qstr this = { .hash_len = hash_len, .name = name };
+				struct qstr this = { { .hash_len = hash_len }, .name = name };
 				err = parent->d_op->d_hash(parent, &this);
 				if (err < 0)
 					break;
-- 
1.8.5.5

