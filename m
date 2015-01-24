Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbbAXOJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:09:42 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:39756 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbbAXOEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:08 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
Subject: [PATCH 12/32] arm: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:18 -0500
Message-Id: <1422108218-25398-13-git-send-email-tj@kernel.org>
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
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
---
 drivers/bus/arm-cci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index 0ce5e2d..84fd660 100644
--- a/drivers/bus/arm-cci.c
+++ b/drivers/bus/arm-cci.c
@@ -806,8 +806,8 @@ static int cci_pmu_event_init(struct perf_event *event)
 static ssize_t pmu_attr_cpumask_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
-	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &pmu->cpus);
-
+	int n = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
+			  cpumask_pr_args(&pmu->cpus));
 	buf[n++] = '\n';
 	buf[n] = '\0';
 	return n;
-- 
2.1.0

