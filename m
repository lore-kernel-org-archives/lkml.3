Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbbAOPWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:22:15 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54943 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbbAOPWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:22:14 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Amir Vadai <amirv@mellanox.com>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] cpumask: kill loop in cpumask_next_and()
Date: Fri, 16 Jan 2015 00:22:41 +0900
Message-Id: <1421335361-1752-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpumask_next_and() does cpumask_next() src1 in a loop and tests if found
cpu is alsop present in src2. remove that loop and perform cpumask_and()
of src1 and src2 first and use to find cpumask_next() intead.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 lib/cpumask.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/cpumask.c b/lib/cpumask.c
index b6513a9..5ab1553 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -37,10 +37,11 @@ EXPORT_SYMBOL(__next_cpu_nr);
 int cpumask_next_and(int n, const struct cpumask *src1p,
 		     const struct cpumask *src2p)
 {
-	while ((n = cpumask_next(n, src1p)) < nr_cpu_ids)
-		if (cpumask_test_cpu(n, src2p))
-			break;
-	return n;
+	struct cpumask tmp;
+
+	if (cpumask_and(&tmp, src1p, src2p))
+		return cpumask_next(n, &tmp);
+	return nr_cpu_ids;
 }
 EXPORT_SYMBOL(cpumask_next_and);
 
-- 
2.2.2

