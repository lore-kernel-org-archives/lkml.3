Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbaLJPzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:55:10 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:51084 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbaLJPxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:20 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH 07/12] xtensa: use {cpu|node}mask pr_cont and seq output functions
Date: Wed, 10 Dec 2014 10:52:49 -0500
Message-Id: <1418226774-30215-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418226774-30215-1-git-send-email-tj@kernel.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the existing user of cpu{mask|list}_scnprintf() and
node{mask|list}_scnprintf() which use them just to printk or
seq_printf() the resulting buffer to use the following functions
instead respectively.

* For printk: cpu{mask|list}_pr_cont() and node{mask|list}_pr_cont().

* For seq_file: seq_cpumask[_list]() and seq_nodemask[_list]().

Because these conversions usually break up a single output function
call into multiple, the reduction is LOC isn't too big but it removes
unnecessary complexity and/or arbitrary limit on the length printed.

This patch is dependent on the previous patch ("bitmap, cpumask,
nodemask: implement pr_cont variants of formatting functions") which
is planned to go through -mm.  It'd be the easiest to route this
together.  If this should go through the subsystem tree, please wait
till the forementioned patch is merged to mainline.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
---
 arch/xtensa/kernel/setup.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 06370cc..441f505 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -574,12 +574,12 @@ void machine_power_off(void)
 static int
 c_show(struct seq_file *f, void *slot)
 {
-	char buf[NR_CPUS * 5];
-
-	cpulist_scnprintf(buf, sizeof(buf), cpu_online_mask);
 	/* high-level stuff */
 	seq_printf(f, "CPU count\t: %u\n"
-		      "CPU list\t: %s\n"
+		      "CPU list\t: ",
+		      num_online_cpus());
+	seq_cpumask_list(f, cpu_online_mask);
+	seq_printf(f, "\n"
 		      "vendor_id\t: Tensilica\n"
 		      "model\t\t: Xtensa " XCHAL_HW_VERSION_NAME "\n"
 		      "core ID\t\t: " XCHAL_CORE_ID "\n"
@@ -587,8 +587,6 @@ c_show(struct seq_file *f, void *slot)
 		      "byte order\t: %s\n"
 		      "cpu MHz\t\t: %lu.%02lu\n"
 		      "bogomips\t: %lu.%02lu\n",
-		      num_online_cpus(),
-		      buf,
 		      XCHAL_BUILD_UNIQUE_ID,
 		      XCHAL_HAVE_BE ?  "big" : "little",
 		      ccount_freq/1000000,
-- 
2.1.0

