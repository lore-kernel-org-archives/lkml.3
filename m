Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbbAXOLz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:11:55 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:36994 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbbAXOD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:03:59 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 07/32] s390: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:13 -0500
Message-Id: <1422108218-25398-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* Line termination only requires one extra space at the end of the
  buffer.  Use PAGE_SIZE - 1 instead of PAGE_SIZE - 2 when formatting.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/cache.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/cache.c b/arch/s390/kernel/cache.c
index c0b03c2..a026911 100644
--- a/arch/s390/kernel/cache.c
+++ b/arch/s390/kernel/cache.c
@@ -243,9 +243,12 @@ static ssize_t shared_cpu_map_func(struct kobject *kobj, int type, char *buf)
 	int len;
 
 	index = kobj_to_cache_index_dir(kobj);
-	len = type ?
-		cpulist_scnprintf(buf, PAGE_SIZE - 2, cpumask_of(index->cpu)) :
-		cpumask_scnprintf(buf, PAGE_SIZE - 2, cpumask_of(index->cpu));
+	if (type)
+		len = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
+				cpumask_pr_args(cpumask_of(index->cpu)));
+	else
+		len = scnprintf(buf, PAGE_SIZE - 1, "%*pb",
+				cpumask_pr_args(cpumask_of(index->cpu)));
 	len += sprintf(&buf[len], "\n");
 	return len;
 }
-- 
2.1.0

