Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaJTD3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 23:29:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11634 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbaJTD3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 23:29:16 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] drivers: base: update cpu offline info when do hotplug
Date: Mon, 20 Oct 2014 11:29:08 +0800
Message-ID: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-19_03:2014-10-17,2014-10-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410200037
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current per-cpu offline info won't be updated if it is
hotplugged in/out by a kernel governer.
Let's update it via cpu notifier.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/base/cpu.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 006b1bc..9d61824 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -418,10 +418,35 @@ static void __init cpu_dev_register_generic(void)
 #endif
 }
 
+static int device_hotplug_notifier(struct notifier_block *nfb,
+				      unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct device *dev = get_cpu_device(cpu);
+	int ret;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+		dev->offline = false;
+		ret = NOTIFY_OK;
+		break;
+	case CPU_DYING:
+		dev->offline = true;
+		ret = NOTIFY_OK;
+		break;
+	default:
+		ret = NOTIFY_DONE;
+		break;
+	}
+
+	return ret;
+}
+
 void __init cpu_dev_init(void)
 {
 	if (subsys_system_register(&cpu_subsys, cpu_root_attr_groups))
 		panic("Failed to register CPU subsystem");
 
 	cpu_dev_register_generic();
+	cpu_notifier(device_hotplug_notifier, 0);
 }
-- 
1.7.9.5

