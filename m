Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540AbaLDQTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:19:50 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:65118 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaLDQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:19:49 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] kernfs: Fix kernfs_name_compare
Date: Thu,  4 Dec 2014 17:19:34 +0100
Message-Id: <1417709976-31551-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the void pointers ns and kn->ns happen to differ by a multiple of
2^32, kernfs_name_compare returns 0, falsely reporting a match to the
caller.

If the return type was changed to long, returning ns - kn->ns would
still be wrong (see acbbe6fbb240 "kcmp: fix standard comparison bug"),
and it would also break the primary comparison of the hashes: The
expression hash - kn->hash has type unsigned int; on 64-bit, long is
perfectly capable of representing all unsigned int values, hence the
return value would always be positive if the hashes are
different. Since the latter is slightly subtle and since returning
hash - kn->hash in the first place is only ok because the hashes are
restricted to 31 bits, add a comment explaining that.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/kernfs/dir.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 1c771931bb60..64959716936d 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -201,10 +201,17 @@ static unsigned int kernfs_name_hash(const char *name, const void *ns)
 static int kernfs_name_compare(unsigned int hash, const char *name,
 			       const void *ns, const struct kernfs_node *kn)
 {
+	/*
+	 * This is ok because the hash values are restricted to [0,
+	 * 2^31-1] and because we are returning int (it would be wrong
+	 * had the return type been wider!).
+	 */
 	if (hash != kn->hash)
 		return hash - kn->hash;
-	if (ns != kn->ns)
-		return ns - kn->ns;
+	if (ns < kn->ns)
+		return -1;
+	if (ns > kn->ns)
+		return 1;
 	return strcmp(name, kn->name);
 }
 
-- 
2.0.4

