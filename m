Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbbAEMg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:36:27 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:43272 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbbAEMgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:36:25 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] kprobes: bugfix: set kprobes_all_disarmed earlier to enable re-optimization.
Date: Mon, 5 Jan 2015 20:31:15 +0800
Message-ID: <1420461075-27012-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.54AA8544.00B3,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 19ea364152f4af10c72bc9f89b317e5a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In original code, the probed instruction doesn't get optimized after

echo 0 > /sys/kernel/debug/kprobes/enabled
echo 1 > /sys/kernel/debug/kprobes/enabled

This is because original code checks kprobes_all_disarmed in
optimize_kprobe(), but this flag is turned off after calling that
function. Therefore, optimize_kprobe() will see
kprobes_all_disarmed == true and doesn't do the optimization.

This patch simply turns off kprobes_all_disarmed earlier to enable
optimization.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 kernel/kprobes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index bad4e95..b185464 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2320,6 +2320,12 @@ static void arm_all_kprobes(void)
 	if (!kprobes_all_disarmed)
 		goto already_enabled;
 
+	/*
+	 * optimize_kprobe() called by arm_kprobe() checks
+	 * kprobes_all_disarmed, so set kprobes_all_disarmed before
+	 * arm_kprobe.
+	 */
+	kprobes_all_disarmed = false;
 	/* Arming kprobes doesn't optimize kprobe itself */
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
@@ -2328,7 +2334,6 @@ static void arm_all_kprobes(void)
 				arm_kprobe(p);
 	}
 
-	kprobes_all_disarmed = false;
 	printk(KERN_INFO "Kprobes globally enabled\n");
 
 already_enabled:
-- 
1.8.4

