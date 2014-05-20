Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaETQuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:50:19 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:24289 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825AbaETQuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:50:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEWAEeHe1NbsnsG/2dsb2JhbABZgwarCAQBAQEBAQEFAYM6lm4CAoEcF3SCUxM/GIECJBOIRQHUJoVViHmERwEDjzyKKwGTIIM6O4ExIg
Date: Tue, 20 May 2014 18:50:16 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: jack <jack@suse.cz>, akpm <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 1/1] fs/jbd/revoke.c: replace shift loop by ilog2
Message-Id: <20140520185016.b3f3d5bfe3ad6fc832d8c792@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

journal_init_revoke_table is only called with positive hash_size
(JOURNAL_REVOKE_DEFAULT_HASH) so we can replace loop shift by ilog2

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jbd/revoke.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 25c713e..8898bbd 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -231,19 +231,15 @@ record_cache_failure:
 
 static struct jbd_revoke_table_s *journal_init_revoke_table(int hash_size)
 {
-	int shift = 0;
-	int tmp = hash_size;
+	int i;
 	struct jbd_revoke_table_s *table;
 
 	table = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
 	if (!table)
 		goto out;
 
-	while((tmp >>= 1UL) != 0UL)
-		shift++;
-
 	table->hash_size = hash_size;
-	table->hash_shift = shift;
+	table->hash_shift = ilog2(hash_size);
 	table->hash_table =
 		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
 	if (!table->hash_table) {
@@ -252,8 +248,8 @@ static struct jbd_revoke_table_s *journal_init_revoke_table(int hash_size)
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

