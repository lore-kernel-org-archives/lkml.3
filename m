Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3FIJm2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 05:42:28 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61204 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3FIJm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 05:42:27 -0400
Message-ID: <51B44DF9.5040705@gmail.com>
Date: Sun, 09 Jun 2013 17:42:17 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Liao <samuelliao@tencent.com>,
        Lin Feng <linfeng@cn.fujitsu.com>, hpa@linux.intel.com,
        yinghai@kernel.org, Kernel-Maillist <linux-kernel@vger.kernel.org>
CC: davidshan <davidshan@tencent.com>
Subject: [PATCH buf-fix] kernel, range: fix broken mtrr_cleanup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Liao <samuelliao@tencent.com>


commit fbe06b7bae7c9cf6ab05168fce5ee93b2f4bae7c broken the mtrr_cleanup
due to return incorrect merged range. this patch remove the empty range
by swapping with the last.

Error messages:
Jun  9 14:06:18 kernel: [    0.000000] *BAD*gran_size: 64K   chunk_size: 64K         num_reg: 4      lose cover RAM: -0G
Jun  9 14:06:18 kernel: [    0.000000] *BAD*gran_size: 64K   chunk_size: 128K        num_reg: 4      lose cover RAM: -0G
Jun  9 14:06:18 kernel: [    0.000000] *BAD*gran_size: 64K   chunk_size: 256K        num_reg: 4      lose cover RAM: -0G
Jun  9 14:06:18 kernel: [    0.000000] *BAD*gran_size: 64K   chunk_size: 512K        num_reg: 4      lose cover RAM: -0G


Signed-off-by: Samuel Liao <samuelliao@tencent.com>
---
 kernel/range.c | 15 ++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/range.c b/kernel/range.c
index eb911db..b723697 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -48,11 +48,18 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
 		final_start = min(range[i].start, start);
 		final_end = max(range[i].end, end);
 
+		if (final_start == range[i].start && final_end == range[i].end)
+			return nr_range;
+
 		/* clear it and add it back for further merge */
-		range[i].start = 0;
-		range[i].end =  0;
-		return add_range_with_merge(range, az, nr_range,
-			final_start, final_end);
+		nr_range -= 1;
+		if (i != nr_range) {
+			range[i].start = range[nr_range].start;
+			range[i].end = range[nr_range].end;
+		}
+		range[nr_range].start = 0;
+		range[nr_range].end =  0;
+		i = -1;
 	}
 
 	/* Need to add it: */
-- 
1.8.2.1

