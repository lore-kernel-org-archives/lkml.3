Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaAFIWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:22:33 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:62332 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaAFIW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:22:28 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, hpa@zytor.com, ak@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, mingo@redhat.com, nico@linaro.org,
        x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/8] cpu: advertise CPU features over udev in a generic way
Date: Mon,  6 Jan 2014 09:22:11 +0100
Message-Id: <1388996536-27014-4-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a generic modalias 'cpu:type:...:feature:...'
which enables CPU feature flag based module loading in a generic way.
All the arch needs to do is enable CONFIG_ARCH_HAS_CPU_AUTOPROBE and
implement arch_print_cpu_modalias(). The modules need to declare the
CPU feature they depend on with MODULE_DEVICE_TABLE(cpu, ...)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/mod_devicetable.h   | 15 +++++++++++++++
 scripts/mod/devicetable-offsets.c |  3 +++
 scripts/mod/file2alias.c          | 10 ++++++++++
 3 files changed, 28 insertions(+)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 45e921401b06..3aad3c0f765c 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -564,6 +564,21 @@ struct x86_cpu_id {
 #define X86_MODEL_ANY  0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
+/*
+ * Generic table type for matching CPU features.
+ * @feature:	the bit number of the feature (0 - 65535)
+ *
+ * How the bit numbers map to actual CPU features is entirely up to the arch,
+ * although using the same ID space as hwcaps seems obvious.
+ */
+
+struct cpu_feature {
+	__u16	feature;
+};
+
+/* hwcap const are bit masks, so take the log when using them as feature IDs */
+#define CPU_FEATURE_HWCAP(x)	ilog2(x)
+
 #define IPACK_ANY_FORMAT 0xff
 #define IPACK_ANY_ID (~0)
 struct ipack_device_id {
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index bb5d115ca671..f282516acc7b 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -174,6 +174,9 @@ int main(void)
 	DEVID_FIELD(x86_cpu_id, model);
 	DEVID_FIELD(x86_cpu_id, vendor);
 
+	DEVID(cpu_feature);
+	DEVID_FIELD(cpu_feature, feature);
+
 	DEVID(mei_cl_device_id);
 	DEVID_FIELD(mei_cl_device_id, name);
 
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 23708636b05c..8a69005228d8 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1135,6 +1135,16 @@ static int do_x86cpu_entry(const char *filename, void *symval,
 }
 ADD_TO_DEVTABLE("x86cpu", x86_cpu_id, do_x86cpu_entry);
 
+/* LOOKS like cpu:type:*:feature:*FEAT* */
+static int do_cpu_entry(const char *filename, void *symval, char *alias)
+{
+	DEF_FIELD(symval, cpu_feature, feature);
+
+	sprintf(alias, "cpu:type:*:feature:*%04X*", feature);
+	return 1;
+}
+ADD_TO_DEVTABLE("cpu", cpu_feature, do_cpu_entry);
+
 /* Looks like: mei:S */
 static int do_mei_entry(const char *filename, void *symval,
 			char *alias)
-- 
1.8.3.2

