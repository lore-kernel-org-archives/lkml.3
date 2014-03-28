Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaC1Mzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 08:55:32 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40446 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaC1Mza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:55:30 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, tj@kernel.org, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH 1/2] mm/percpu.c: renew the max_contig if we merge the head and previous block
Date: Fri, 28 Mar 2014 20:55:21 +0800
Message-Id: <1396011321-19759-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, tj,
I've reworked the patches on top of percpu/for-3.15.

During pcpu_alloc_area(), we might merge the current head with the
previous block. Since we have calculated the max_contig using the
size of previous block before we skip it, and now we update the size
of previous block, so we should renew the max_contig.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/percpu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 202e104..63e24fb 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -473,9 +473,11 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int size, int align)
 		 * uncommon for percpu allocations.
 		 */
 		if (head && (head < sizeof(int) || !(p[-1] & 1))) {
+			*p = off += head;
 			if (p[-1] & 1)
 				chunk->free_size -= head;
-			*p = off += head;
+			else
+				max_contig = max(*p - p[-1], max_contig);
 			this_size -= head;
 			head = 0;
 		}
-- 
1.8.5.3

