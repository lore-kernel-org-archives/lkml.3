Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbaC0LGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:06:11 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35336 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbaC0LGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:06:05 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, tj@kernel.org, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH 1/2] mm/percpu.c: renew the max_contig if we merge the head and previous block.
Date: Thu, 27 Mar 2014 19:05:43 +0800
Message-Id: <1395918343-6775-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During pcpu_alloc_area(), we might merge the current head with the
previous block. Since we have calculated the max_contig using the
size of previous block before we skip it, and now we update the size
of previous block, so we should renew the max_contig.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/percpu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 036cfe0..cfda29c 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -506,9 +506,11 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 		 * uncommon for percpu allocations.
 		 */
 		if (head && (head < sizeof(int) || chunk->map[i - 1] > 0)) {
-			if (chunk->map[i - 1] > 0)
+			if (chunk->map[i - 1] > 0) {
 				chunk->map[i - 1] += head;
-			else {
+				max_contig =
+					max(chunk->map[i - 1], max_contig);
+			} else {
 				chunk->map[i - 1] -= head;
 				chunk->free_size -= head;
 			}
-- 
1.8.5.3

