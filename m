Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbaLJQdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:33:11 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59058 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaLJQdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:33:09 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: hfs: Fix comparison bug in hfs_cat_keycmp
Date: Wed, 10 Dec 2014 17:32:44 +0100
Message-Id: <1418229164-4132-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418165449.5917.4.camel@ubuntu>
References: <1418165449.5917.4.camel@ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relying on the sign (after casting to int) of the difference of two
quantities for comparison is usually wrong. For example, should a-b
turn out to be 2^31, the return value of cmp(a,b) is -2^31; but that
would also be the return value from cmp(b, a). So a compares less than
b and b compares less than a. One can also easily find three values
a,b,c such that a compares less than b, b compares less than c, but a
does not compare less than c.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/hfs/catalog.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index ff0316b925a5..db458ee3a546 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -162,14 +162,16 @@ err2:
  */
 int hfs_cat_keycmp(const btree_key *key1, const btree_key *key2)
 {
-	int retval;
+	__be32 k1p, k2p;
 
-	retval = be32_to_cpu(key1->cat.ParID) - be32_to_cpu(key2->cat.ParID);
-	if (!retval)
-		retval = hfs_strcmp(key1->cat.CName.name, key1->cat.CName.len,
-				    key2->cat.CName.name, key2->cat.CName.len);
+	k1p = key1->cat.ParID;
+	k2p = key2->cat.ParID;
 
-	return retval;
+	if (k1p != k2p)
+		return be32_to_cpu(k1p) < be32_to_cpu(k2p) ? -1 : 1;
+
+	return hfs_strcmp(key1->cat.CName.name, key1->cat.CName.len,
+			  key2->cat.CName.name, key2->cat.CName.len);
 }
 
 /* Try to get a catalog entry for given catalog id */
-- 
2.1.3

