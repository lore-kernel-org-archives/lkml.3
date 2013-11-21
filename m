Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3KUPnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:43:41 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49295 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3KUPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:42:50 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        catalin.marinas@arm.com, hpa@zytor.com, ak@linux.intel.com,
        mingo@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 4/4] arm64: advertise CPU features for modalias matching
Date: Thu, 21 Nov 2013 16:42:32 +0100
Message-Id: <1385048552-12528-5-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385048552-12528-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1385048552-12528-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the generic implementation in drivers/base/cpu.c
that allows modules to be loaded automatically based on the
optional features supported (and advertised over udev) by the
CPU.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig        |  3 +++
 arch/arm64/kernel/setup.c | 20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c044548..50cd97f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -202,6 +202,9 @@ config ARCH_WANT_HUGE_PMD_SHARE
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	def_bool y
 
+config ARCH_HAS_CPU_AUTOPROBE
+	def_bool y
+
 source "mm/Kconfig"
 
 config XEN_DOM0
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 055cfb8..775a531 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -366,3 +366,23 @@ const struct seq_operations cpuinfo_op = {
 	.stop	= c_stop,
 	.show	= c_show
 };
+
+ssize_t arch_print_cpu_modalias(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	unsigned int caps;
+	ssize_t n;
+	int i;
+
+	/*
+	 * With 32 features maximum (taking 5 bytes each to print), we don't
+	 * need to worry about overrunning the PAGE_SIZE sized buffer.
+	 */
+	n = sprintf(buf, "cpu:type:%s:feature:", ELF_PLATFORM);
+	for (caps = elf_hwcap, i = 0; caps; caps >>= 1, i++)
+		if (caps & 1)
+			n += sprintf(&buf[n], ",%04X", i);
+	buf[n++] = '\n';
+	return n;
+}
-- 
1.8.3.2

