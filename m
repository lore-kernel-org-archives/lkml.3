Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaA2QvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:51:16 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56833 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaA2QvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:51:10 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/5] cpu: move arch_cpu_uevent() to generic code
Date: Wed, 29 Jan 2014 17:50:42 +0100
Message-Id: <1391014246-9715-2-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391014246-9715-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1391014246-9715-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only x86 implements arch_cpu_uevent(), and there is nothing arch
specific about it, so move it to drivers/base/cpu.c and rename
it to cpu_uevent().

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/kernel/cpu/match.c | 11 -----------
 drivers/base/cpu.c          | 15 ++++++++++++++-
 include/linux/cpu.h         |  1 -
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 36565373af87..ab6082a9020e 100644
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
index f48370dfc908..270649012e64 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -286,6 +286,19 @@ static void cpu_device_release(struct device *dev)
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
@@ -307,7 +320,7 @@ int register_cpu(struct cpu *cpu, int num)
 	cpu->dev.offline = !cpu_online(num);
 	cpu->dev.of_node = of_get_cpu_node(num, NULL);
 #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
-	cpu->dev.bus->uevent = arch_cpu_uevent;
+	cpu->dev.bus->uevent = cpu_uevent;
 #endif
 	cpu->dev.groups = common_cpu_attr_groups;
 	if (cpu->hotpluggable)
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 03e235ad1bba..dcc4a0d9c45f 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -47,7 +47,6 @@ extern ssize_t arch_cpu_release(const char *, size_t);
 struct notifier_block;
 
 #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
-extern int arch_cpu_uevent(struct device *dev, struct kobj_uevent_env *env);
 extern ssize_t arch_print_cpu_modalias(struct device *dev,
 				       struct device_attribute *attr,
 				       char *bufptr);
-- 
1.8.3.2

