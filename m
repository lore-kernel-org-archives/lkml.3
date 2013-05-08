Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3EHUCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:02:38 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:40935 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3EHUCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:02:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alex Elder <elder@inktank.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] rbd: Use min_t() to fix comparison of distinct pointer types warning
Date: Wed,  8 May 2013 22:02:33 +0200
Message-Id: <1368043353-21896-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/block/rbd.c: In function ‘zero_pages’:
drivers/block/rbd.c:1102: warning: comparison of distinct pointer types lacks a cast

Remove the hackish casts and use min_t() to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/block/rbd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 22ffd5d..1318c6b 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1098,8 +1098,8 @@ static void zero_pages(struct page **pages, u64 offset, u64 end)
 		unsigned long flags;
 		void *kaddr;
 
-		page_offset = (size_t)(offset & ~PAGE_MASK);
-		length = min(PAGE_SIZE - page_offset, (size_t)(end - offset));
+		page_offset = offset & ~PAGE_MASK;
+		length = min_t(size_t, PAGE_SIZE - page_offset, end - offset);
 		local_irq_save(flags);
 		kaddr = kmap_atomic(*page);
 		memset(kaddr + page_offset, 0, length);
-- 
1.7.0.4

