Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbaHVQxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:53:49 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:55004 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaHVQxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:53:44 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/15] percpu: indent the population block in pcpu_alloc()
Date: Fri, 22 Aug 2014 12:53:14 -0400
Message-Id: <1408726399-4436-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next patch will conditionalize the population block in
pcpu_alloc() which will end up making a rather large indentation
change obfuscating the actual logic change.  This patch puts the block
under "if (true)" so that the next patch can avoid indentation
changes.  The defintions of the local variables which are used only in
the block are moved into the block.

This patch is purely cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 7f2858c..7a012d4 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -742,7 +742,6 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 	struct pcpu_chunk *chunk;
 	const char *err;
 	int slot, off, new_alloc, cpu, ret;
-	int page_start, page_end, rs, re;
 	unsigned long flags;
 	void __percpu *ptr;
 
@@ -847,27 +846,32 @@ area_found:
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	/* populate if not all pages are already there */
-	mutex_lock(&pcpu_alloc_mutex);
-	page_start = PFN_DOWN(off);
-	page_end = PFN_UP(off + size);
+	if (true) {
+		int page_start, page_end, rs, re;
 
-	pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
-		WARN_ON(chunk->immutable);
+		mutex_lock(&pcpu_alloc_mutex);
 
-		ret = pcpu_populate_chunk(chunk, rs, re);
+		page_start = PFN_DOWN(off);
+		page_end = PFN_UP(off + size);
 
-		spin_lock_irqsave(&pcpu_lock, flags);
-		if (ret) {
-			mutex_unlock(&pcpu_alloc_mutex);
-			pcpu_free_area(chunk, off);
-			err = "failed to populate";
-			goto fail_unlock;
+		pcpu_for_each_unpop_region(chunk, rs, re, page_start, page_end) {
+			WARN_ON(chunk->immutable);
+
+			ret = pcpu_populate_chunk(chunk, rs, re);
+
+			spin_lock_irqsave(&pcpu_lock, flags);
+			if (ret) {
+				mutex_unlock(&pcpu_alloc_mutex);
+				pcpu_free_area(chunk, off);
+				err = "failed to populate";
+				goto fail_unlock;
+			}
+			bitmap_set(chunk->populated, rs, re - rs);
+			spin_unlock_irqrestore(&pcpu_lock, flags);
 		}
-		bitmap_set(chunk->populated, rs, re - rs);
-		spin_unlock_irqrestore(&pcpu_lock, flags);
-	}
 
-	mutex_unlock(&pcpu_alloc_mutex);
+		mutex_unlock(&pcpu_alloc_mutex);
+	}
 
 	/* clear the areas and return address relative to base address */
 	for_each_possible_cpu(cpu)
-- 
1.9.3

