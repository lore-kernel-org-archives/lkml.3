Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaBVAO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:14:58 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36628 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbaBVAO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:14:57 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Olof Johansson <olof@lixom.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Wang Dongsheng <dongsheng.wang@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH] powerpc: warn users of smt-snooze-delay that the API isn't there anymore
Date: Fri, 21 Feb 2014 16:14:31 -0800
Message-Id: <1393028074-26797-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022200-5806-0000-0000-00002431D16A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/sys/devices/system/cpu/cpu*/smt-snooze-delay was converted into a NOP
in commit 3fa8cad82b94d0bed002571bd246f2299ffc876b, and now does
nothing. Add a pr_warn() to convince any users that they should stop
using it.

The commit message from the removing commit notes that this
functionality should move into the cpuidle driver, essentially by
adjusting target_residency to the specified value. At the moment,
target_residency is not exposed by cpuidle's sysfs, so there isn't a
drop in replacement for this.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 97e1dc9..84097b4 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -50,6 +50,9 @@ static ssize_t store_smt_snooze_delay(struct device *dev,
 	if (ret != 1)
 		return -EINVAL;
 
+	pr_warn_ratelimited("%s (%d): /sys/devices/system/cpu/cpu%d/smt-snooze-delay is deprecated and is a NOP\n",
+		  current->comm, task_pid_nr(current), cpu->dev.id);
+
 	per_cpu(smt_snooze_delay, cpu->dev.id) = snooze;
 	return count;
 }
@@ -60,6 +63,9 @@ static ssize_t show_smt_snooze_delay(struct device *dev,
 {
 	struct cpu *cpu = container_of(dev, struct cpu, dev);
 
+	pr_warn_ratelimited("%s (%d): /sys/devices/system/cpu/cpu%d/smt-snooze-delay is deprecated and is a NOP\n",
+		  current->comm, task_pid_nr(current), cpu->dev.id);
+
 	return sprintf(buf, "%ld\n", per_cpu(smt_snooze_delay, cpu->dev.id));
 }
 
-- 
1.9.0

