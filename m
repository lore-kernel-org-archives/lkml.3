Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaIXSQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:16:11 -0400
Received: from [62.141.66.39] ([62.141.66.39]:40344 "EHLO beacon.altlinux.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbaIXSQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:16:09 -0400
From: Mikhail Efremov <sem@altlinux.org>
To: linux-kernel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>, Mikhail Efremov <sem@altlinux.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Date: Wed, 24 Sep 2014 22:14:33 +0400
Message-Id: <1411582473-29184-1-git-send-email-sem@altlinux.org>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only exchange source and destination filenames
if flags contain RENAME_EXCHANGE.
In case if executable file was running and replaced by
other file /proc/PID/exe should still show correct file name,
not the old name of the file by which it was replaced.

The scenario when this bug manifests itself was like this:
* ALT Linux uses rpm and start-stop-daemon;
* during a package upgrade rpm creates a temporary file
  for an executable to rename it upon successful unpacking;
* start-stop-daemon is run subsequently and it obtains
  the (nonexistant) temporary filename via /proc/PID/exe
  thus failing to identify the running process.

Note that "long" filenames (> DNAiME_INLINE_LEN) are still
exchanged without RENAME_EXCHANGE and this behaviour exists
long enough (should be fixed too apparently).
So this patch is just an interim workaround that restores
behavior for "short" names as it was before changes
introduced by commit da1ce0670c14 ("vfs: add cross-rename").

See https://lkml.org/lkml/2014/9/7/6 for details.

Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: da1ce0670c14 "vfs: add cross-rename"
Signed-off-by: Mikhail Efremov <sem@altlinux.org>
---
 fs/dcache.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 7a5b514..3218570 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2372,7 +2372,8 @@ void dentry_update_name_case(struct dentry *dentry, struct qstr *name)
 }
 EXPORT_SYMBOL(dentry_update_name_case);
 
-static void switch_names(struct dentry *dentry, struct dentry *target)
+static void switch_names(struct dentry *dentry, struct dentry *target,
+			 bool exchange)
 {
 	if (dname_external(target)) {
 		if (dname_external(dentry)) {
@@ -2404,11 +2405,21 @@ static void switch_names(struct dentry *dentry, struct dentry *target)
 			/*
 			 * Both are internal.
 			 */
-			unsigned int i;
-			BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
-			for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
-				swap(((long *) &dentry->d_iname)[i],
-				     ((long *) &target->d_iname)[i]);
+			if (exchange) {
+				unsigned int i;
+
+				BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN,
+							 sizeof(long)));
+				for (i = 0; i < DNAME_INLINE_LEN / sizeof(long);
+									i++) {
+					swap(((long *) &dentry->d_iname)[i],
+					     ((long *) &target->d_iname)[i]);
+				}
+			} else {
+				memcpy(dentry->d_iname, target->d_name.name,
+						target->d_name.len + 1);
+				dentry->d_name.len = target->d_name.len;
+				return;
 			}
 		}
 	}
@@ -2510,7 +2521,7 @@ static void __d_move(struct dentry *dentry, struct dentry *target,
 	list_del(&target->d_u.d_child);
 
 	/* Switch the names.. */
-	switch_names(dentry, target);
+	switch_names(dentry, target, exchange);
 	swap(dentry->d_name.hash, target->d_name.hash);
 
 	/* ... and switch the parents */
@@ -2649,7 +2660,7 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 
 	dparent = dentry->d_parent;
 
-	switch_names(dentry, anon);
+	switch_names(dentry, anon, false);
 	swap(dentry->d_name.hash, anon->d_name.hash);
 
 	dentry->d_parent = dentry;
-- 
1.8.5.5

