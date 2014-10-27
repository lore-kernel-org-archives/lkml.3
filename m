Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaJ0C7M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:59:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43343 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984AbaJ0C7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:59:11 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, Neil Zhang <zhangwm@marvell.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH V2] Driver cpu: update online when cpu_up/down besides sysfs
Date: Mon, 27 Oct 2014 10:59:08 +0800
Message-ID: <1414378748-8855-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-27_01:2014-10-24,2014-10-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410270034
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current per-cpu offline info won't be updated when we use
any other method besides sysfs to call cpu_up/down.
Thus the cpu/online can't reflect the real online status.

This patch is going to fix the issue introduced by commit
0902a9044fa5b7a0456ea4daacec2c2b3189ba8c (Driver core:
Use generic offline/online for CPU offline/online)

CC: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Dan Streetman <ddstreet@ieee.org>
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

