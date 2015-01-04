Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189AbbADG2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 01:28:24 -0500
Received: from mx1.mxmail.xiaomi.com ([58.68.235.87]:41887 "EHLO
	mx1.mxmail.xiaomi.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750829AbbADG2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 01:28:23 -0500
From: Hui Zhu <zhuhui@xiaomi.com>
To: <linux-kernel@vger.kernel.org>
CC: <teawater@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>
Subject: [PATCH] samples: hw_breakpoint: check the return value of kallsyms_lookup_name
Date: Sun, 4 Jan 2015 14:27:38 +0800
Message-ID: <1420352858-3825-1-git-send-email-zhuhui@xiaomi.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.27.14.101]
X-ClientProxiedBy: CNCAS3.mioffice.cn (10.237.8.133) To cnbox3.mioffice.cn
 (10.237.8.143)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

data_breakpoint.ko can insert successful but cannot catch any change of
the data in my part because kallsyms_lookup_name rerurn 0 each time.
So add code to check the return value of kallsyms_lookup_name.

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
---
 samples/hw_breakpoint/data_breakpoint.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index ef7f322..4fbf93b 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -52,27 +52,30 @@ static void sample_hbp_handler(struct perf_event *bp,
 
 static int __init hw_break_module_init(void)
 {
-	int ret;
+	int ret = 0;
 	struct perf_event_attr attr;
 
 	hw_breakpoint_init(&attr);
 	attr.bp_addr = kallsyms_lookup_name(ksym_name);
+	if (!attr.bp_addr) {
+		ret = -ENXIO;
+		printk(KERN_INFO "Get address for %s failed\n", ksym_name);
+		goto out;
+	}
+
 	attr.bp_len = HW_BREAKPOINT_LEN_4;
 	attr.bp_type = HW_BREAKPOINT_W | HW_BREAKPOINT_R;
 
 	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler, NULL);
 	if (IS_ERR((void __force *)sample_hbp)) {
 		ret = PTR_ERR((void __force *)sample_hbp);
-		goto fail;
+		printk(KERN_INFO "Breakpoint registration failed\n");
+		goto out;
 	}
 
 	printk(KERN_INFO "HW Breakpoint for %s write installed\n", ksym_name);
 
-	return 0;
-
-fail:
-	printk(KERN_INFO "Breakpoint registration failed\n");
-
+out:
 	return ret;
 }
 
-- 
1.9.1

