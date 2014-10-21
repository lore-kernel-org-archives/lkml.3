Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbaJUUoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:44:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46014 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842AbaJUUoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:44:10 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org, jack@suse.cz
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        a.ryabinin@samsung.com, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] fs, jbd: use a more generic hash function
Date: Tue, 21 Oct 2014 16:43:55 -0400
Message-Id: <1413924235-26276-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the hash function used by the revoke hashtable is good somewhere else,
it's not really good here.

The default hash shift (8) means that one third of the hashing function
gets lost (and is undefined anyways (8 - 12 = negative shift)):

	"(block << (hash_shift - 12))) & (table->hash_size - 1)"

Instead, just use the kernel's generic hash function that gets used everywhere
else.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/jbd/revoke.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 8898bbd..dcead63 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -93,6 +93,7 @@
 #include <linux/bio.h>
 #endif
 #include <linux/log2.h>
+#include <linux/hash.h>
 
 static struct kmem_cache *revoke_record_cache;
 static struct kmem_cache *revoke_table_cache;
@@ -129,15 +130,11 @@ static void flush_descriptor(journal_t *, struct journal_head *, int, int);
 
 /* Utility functions to maintain the revoke table */
 
-/* Borrowed from buffer.c: this is a tried and tested block hash function */
 static inline int hash(journal_t *journal, unsigned int block)
 {
 	struct jbd_revoke_table_s *table = journal->j_revoke;
-	int hash_shift = table->hash_shift;
 
-	return ((block << (hash_shift - 6)) ^
-		(block >> 13) ^
-		(block << (hash_shift - 12))) & (table->hash_size - 1);
+	return hash_32(block, table->hash_shift);
 }
 
 static int insert_revoke_hash(journal_t *journal, unsigned int blocknr,
-- 
1.7.10.4

