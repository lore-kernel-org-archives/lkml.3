Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbaD3TSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:18:40 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:18066 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758938AbaD3TSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:18:39 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMGAIlLYVNXQ3IO/2dsb2JhbABZgwbFcIEgF3SCZhwjGIECJBOIRQHJSI5RhEABA48TihMBkmuDMzs
Date: Wed, 30 Apr 2014 21:18:36 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Seth Jennings <sjennings@variantweb.net>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] MM/ZBUD: make size unsigned like unique callsite
Message-Id: <20140430211836.a6ab920079485e8d1cc01121@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zbud_alloc is only called by zswap_frontswap_store with unsigned int len.
Change function parameter + update  >= 0 check.

Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 include/linux/zbud.h | 2 +-
 mm/zbud.c            | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/zbud.h b/include/linux/zbud.h
index 2571a5c..13af0d4 100644
--- a/include/linux/zbud.h
+++ b/include/linux/zbud.h
@@ -11,7 +11,7 @@ struct zbud_ops {
 
 struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops);
 void zbud_destroy_pool(struct zbud_pool *pool);
-int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
+int zbud_alloc(struct zbud_pool *pool, unsigned int size, gfp_t gfp,
 	unsigned long *handle);
 void zbud_free(struct zbud_pool *pool, unsigned long handle);
 int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries);
diff --git a/mm/zbud.c b/mm/zbud.c
index 9451361..01df13a 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -247,7 +247,7 @@ void zbud_destroy_pool(struct zbud_pool *pool)
  * gfp arguments are invalid or -ENOMEM if the pool was unable to allocate
  * a new page.
  */
-int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
+int zbud_alloc(struct zbud_pool *pool, unsigned int size, gfp_t gfp,
 			unsigned long *handle)
 {
 	int chunks, i, freechunks;
@@ -255,7 +255,7 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 	enum buddy bud;
 	struct page *page;
 
-	if (size <= 0 || gfp & __GFP_HIGHMEM)
+	if (!size || (gfp & __GFP_HIGHMEM))
 		return -EINVAL;
 	if (size > PAGE_SIZE - ZHDR_SIZE_ALIGNED - CHUNK_SIZE)
 		return -ENOSPC;
-- 
1.9.1

