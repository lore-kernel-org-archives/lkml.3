Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaERHpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 03:45:41 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:28896 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbaERHpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 03:45:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AooVAF5keFNbskAH/2dsb2JhbABZgwaDP6c1BAEBAgEBBQGaJwICgQoXdIJTEz8YgQIkE4hFAdEvhVWIe4RHAQOPL4oqAZMagzk7gTEi
Date: Sun, 18 May 2014 09:45:35 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        tytso <tytso@mit.edu>
Subject: [PATCH 1/1] fs/jbd2/revoke.c: replace shift loop by fls
Message-Id: <20140518094535.d9f0d55b5bc02ba63a327bfb@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jbd2_journal_init_revoke is only called with positive hash_size
(JOURNAL_REVOKE_DEFAULT_HASH) so we can replace loop shift by fls -1

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jbd2/revoke.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 198c9c1..811d14b 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -227,19 +227,15 @@ record_cache_failure:
 
 static struct jbd2_revoke_table_s *jbd2_journal_init_revoke_table(int hash_size)
 {
-	int shift = 0;
-	int tmp = hash_size;
+	int i;
 	struct jbd2_revoke_table_s *table;
 
 	table = kmem_cache_alloc(jbd2_revoke_table_cache, GFP_KERNEL);
 	if (!table)
 		goto out;
 
-	while((tmp >>= 1UL) != 0UL)
-		shift++;
-
 	table->hash_size = hash_size;
-	table->hash_shift = shift;
+	table->hash_shift = fls(hash_size) - 1;
 	table->hash_table =
 		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
 	if (!table->hash_table) {
@@ -248,8 +244,8 @@ static struct jbd2_revoke_table_s *jbd2_journal_init_revoke_table(int hash_size)
 		goto out;
 	}
 
-	for (tmp = 0; tmp < hash_size; tmp++)
-		INIT_LIST_HEAD(&table->hash_table[tmp]);
+	for (i = 0; i < hash_size; i++)
+		INIT_LIST_HEAD(&table->hash_table[i]);
 
 out:
 	return table;
-- 
1.8.4.5

