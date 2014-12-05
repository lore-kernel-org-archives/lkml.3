Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaLEWlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:41:50 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:50043 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLEWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:41:47 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] kernfs: Fix kernfs_name_compare
Date: Fri,  5 Dec 2014 23:41:33 +0100
Message-Id: <1417819295-18865-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417709976-31551-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417709976-31551-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Returning a difference from a comparison functions is usually wrong
(see acbbe6fbb240 "kcmp: fix standard comparison bug" for the long
story). Here there is the additional twist that if the void pointers
ns and kn->ns happen to differ by a multiple of 2^32,
kernfs_name_compare returns 0, falsely reporting a match to the
caller.

Technically 'hash - kn->hash' is ok since the hashes are restricted to
31 bits, but it's better to avoid that subtlety.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

Notes:
    v2: Also use explicit < > comparisons of the hashes.

 fs/kernfs/dir.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 1c771931bb60..bf9e2f44c3df 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -201,10 +201,14 @@ static unsigned int kernfs_name_hash(const char *name, const void *ns)
 static int kernfs_name_compare(unsigned int hash, const char *name,
 			       const void *ns, const struct kernfs_node *kn)
 {
-	if (hash != kn->hash)
-		return hash - kn->hash;
-	if (ns != kn->ns)
-		return ns - kn->ns;
+	if (hash < kn->hash)
+		return -1;
+	if (hash > kn->hash)
+		return 1;
+	if (ns < kn->ns)
+		return -1;
+	if (ns > kn->ns)
+		return 1;
 	return strcmp(name, kn->name);
 }
 
-- 
2.1.3

