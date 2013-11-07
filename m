Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3KGRRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:17:53 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45897 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3KGRRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:17:49 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, catalin.marinas@arm.com, will.deacon@arm.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 3/4] scripts/mod: add generic CPU features as module alias
Date: Thu,  7 Nov 2013 18:17:36 +0100
Message-Id: <1383844657-17487-4-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements the changes needed to turn CPU features
declared as being depended upon by modules into module aliases
in the .ko metadata.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/mod_devicetable.h   | 11 +++++++++++
 scripts/mod/devicetable-offsets.c |  3 +++
 scripts/mod/file2alias.c          | 10 ++++++++++
 3 files changed, 24 insertions(+)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 45e9214..e481796 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -564,6 +564,17 @@ struct x86_cpu_id {
 #define X86_MODEL_ANY  0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
+/*
+ * Generic table type for tracking CPU features.
+ * @feature:	the bit number of the feature (0 - 31)
+ *
+ * How the bit numbers map to actual CPU features is entirely up to the arch
+ */
+
+struct cpu_feature {
+	__u8	feature;
+};
+
 #define IPACK_ANY_FORMAT 0xff
 #define IPACK_ANY_ID (~0)
 struct ipack_device_id {
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index bb5d115..f282516 100644
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
index 2370863..209cdb2 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1135,6 +1135,16 @@ static int do_x86cpu_entry(const char *filename, void *symval,
 }
 ADD_TO_DEVTABLE("x86cpu", x86_cpu_id, do_x86cpu_entry);
 
+/* LOOKS like cpu:feature:*FEAT* */
+static int do_cpu_entry(const char *filename, void *symval, char *alias)
+{
+	DEF_FIELD(symval, cpu_feature, feature);
+
+	sprintf(alias, "cpu:feature:*%02X*", feature);
+	return 1;
+}
+ADD_TO_DEVTABLE("cpu", cpu_feature, do_cpu_entry);
+
 /* Looks like: mei:S */
 static int do_mei_entry(const char *filename, void *symval,
 			char *alias)
-- 
1.8.3.2

