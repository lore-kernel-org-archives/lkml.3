Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3KGRSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:18:24 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64698 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3KGRRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:17:48 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, catalin.marinas@arm.com, will.deacon@arm.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 2/4] cpu: advertise CPU features over udev in a generic way
Date: Thu,  7 Nov 2013 18:17:35 +0100
Message-Id: <1383844657-17487-3-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a generic modalias 'cpu:feature:...' which
enables CPU feature flag based module loading in a generic way.
All the arch needs to do is enable CONFIG_ARCH_HAS_CPU_AUTOPROBE
and export a u32 called 'cpu_features'. (What each bit actually
means is irrelevant on this level.)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/base/cpu.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 49c6f4b..a661d31 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -276,6 +276,30 @@ static void cpu_device_release(struct device *dev)
 }
 
 #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
+ssize_t print_cpu_modalias(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	extern u32 __weak cpu_features;
+	ssize_t n;
+	int i;
+	u32 f;
+
+	/*
+	 * With 32 features maximum (taking 3 bytes each to print), we don't
+	 * need to worry about overrunning the PAGE_SIZE sized buffer.
+	 */
+	n = sprintf(buf, "cpu:feature:");
+	for (f = cpu_features, i = 0; f; f >>= 1, i++)
+		if (f & 1)
+			n += sprintf(&buf[n], ",%02X", i);
+	buf[n++] = '\n';
+	return n;
+}
+
+ssize_t __attribute__((weak, alias("print_cpu_modalias")))
+arch_print_cpu_modalias(struct device *, struct device_attribute *, char *);
+
 static int cpu_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	char *buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-- 
1.8.3.2

