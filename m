Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaAFIXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:23:52 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62502 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaAFIWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:22:32 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, hpa@zytor.com, ak@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, mingo@redhat.com, nico@linaro.org,
        x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 5/8] arm64: advertise CPU features for modalias matching
Date: Mon,  6 Jan 2014 09:22:13 +0100
Message-Id: <1388996536-27014-6-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
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
index cb9421b540c8..74650b68d575 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -214,6 +214,9 @@ config ARCH_WANT_HUGE_PMD_SHARE
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	def_bool y
 
+config ARCH_HAS_CPU_AUTOPROBE
+	def_bool y
+
 source "mm/Kconfig"
 
 config XEN_DOM0
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index bb33fff09ba2..5ed082bbd61c 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -379,3 +379,23 @@ const struct seq_operations cpuinfo_op = {
 	.stop	= c_stop,
 	.show	= c_show
 };
+
+ssize_t arch_print_cpu_modalias(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	unsigned long caps;
+	ssize_t n;
+	int i;
+
+	/*
+	 * With 64 features maximum (taking 5 bytes each to print), we don't
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

