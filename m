Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbaIPU7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:59:53 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:50879 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbaIPUwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:01 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/22] block: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:16 +0200
Message-Id: <1410900696-6481-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 block/partitions/mac.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/partitions/mac.c b/block/partitions/mac.c
index 76d8ba6..c2c48ec 100644
--- a/block/partitions/mac.c
+++ b/block/partitions/mac.c
@@ -81,7 +81,7 @@ int mac_partition(struct parsed_partitions *state)
 			be32_to_cpu(part->start_block) * (secsize/512),
 			be32_to_cpu(part->block_count) * (secsize/512));
 
-		if (!strnicmp(part->type, "Linux_RAID", 10))
+		if (!strncasecmp(part->type, "Linux_RAID", 10))
 			state->parts[slot].flags = ADDPART_FLAG_RAID;
 #ifdef CONFIG_PPC_PMAC
 		/*
@@ -100,7 +100,7 @@ int mac_partition(struct parsed_partitions *state)
 				goodness++;
 
 			if (strcasecmp(part->type, "Apple_UNIX_SVR2") == 0
-			    || (strnicmp(part->type, "Linux", 5) == 0
+			    || (strncasecmp(part->type, "Linux", 5) == 0
 			        && strcasecmp(part->type, "Linux_swap") != 0)) {
 				int i, l;
 
@@ -109,13 +109,13 @@ int mac_partition(struct parsed_partitions *state)
 				if (strcmp(part->name, "/") == 0)
 					goodness++;
 				for (i = 0; i <= l - 4; ++i) {
-					if (strnicmp(part->name + i, "root",
+					if (strncasecmp(part->name + i, "root",
 						     4) == 0) {
 						goodness += 2;
 						break;
 					}
 				}
-				if (strnicmp(part->name, "swap", 4) == 0)
+				if (strncasecmp(part->name, "swap", 4) == 0)
 					goodness--;
 			}
 
-- 
2.0.4

