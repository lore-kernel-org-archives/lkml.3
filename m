Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3KKKUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 05:20:13 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35049 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3KKKTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 05:19:45 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, catalin.marinas@arm.com, hpa@zytor.com,
        steve.capper@linaro.org, ak@linux.intel.com, dave.martin@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/4] x86: move arch_cpu_uevent() to generic code
Date: Mon, 11 Nov 2013 11:19:32 +0100
Message-Id: <1384165175-16134-2-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1384165175-16134-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1384165175-16134-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only x86 implements arch_cpu_uevent(), and there is nothing arch
specific about it, so move it to drivers/base/cpu.c.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/kernel/cpu/match.c | 11 -----------
 drivers/base/cpu.c          | 15 ++++++++++++++-
 include/linux/cpu.h         |  1 -
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 3656537..ab6082a 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -78,14 +78,3 @@ ssize_t arch_print_cpu_modalias(struct device *dev,
 	*buf++ = '\n';
 	return buf - bufptr;
 }
-
-int arch_cpu_uevent(struct device *dev, struct kobj_uevent_env *env)
-{
-	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (buf) {
-		arch_print_cpu_modalias(NULL, NULL, buf);
-		add_uevent_var(env, "MODALIAS=%s", buf);
-		kfree(buf);
-	}
-	return 0;
-}
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 848ebbd..49c6f4b 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -275,6 +275,19 @@ static void cpu_device_release(struct device *dev)
 	 */
 }
 
+#ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
+static int cpu_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (buf) {
+		arch_print_cpu_modalias(NULL, NULL, buf);
+		add_uevent_var(env, "MODALIAS=%s", buf);
+		kfree(buf);
+	}
+	return 0;
+}
+#endif
+
 /*
  * register_cpu - Setup a sysfs device for a CPU.
  * @cpu - cpu->hotpluggable field set to 1 will generate a control file in
@@ -296,7 +309,7 @@ int register_cpu(struct cpu *cpu, int num)
 	cpu->dev.offline = !cpu_online(num);
 	cpu->dev.of_node = of_get_cpu_node(num, NULL);
 #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
-	cpu->dev.bus->uevent = arch_cpu_uevent;
+	cpu->dev.bus->uevent = cpu_uevent;
 #endif
 	cpu->dev.groups = common_cpu_attr_groups;
 	if (cpu->hotpluggable)
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 801ff9e..c12ddd1 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -44,7 +44,6 @@ extern ssize_t arch_cpu_release(const char *, size_t);
 struct notifier_block;
 
 #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
-extern int arch_cpu_uevent(struct device *dev, struct kobj_uevent_env *env);
 extern ssize_t arch_print_cpu_modalias(struct device *dev,
 				       struct device_attribute *attr,
 				       char *bufptr);
-- 
1.8.3.2

