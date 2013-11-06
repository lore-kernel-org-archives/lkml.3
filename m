Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3KFVai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:30:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:6846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab3KFVah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:30:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="404694690"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Chen Gong <gong.chen@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <CA+8MBb+EBHPeB6ND4BjvaziuriAqjs-XxJyNCpBKK0b4SQptxQ@mail.gmail.com>
Subject: [PATCHv2] Changes to the ACPI/APEI/EINJ debugfs interface
Date: Wed, 06 Nov 2013 13:30:36 -0800
Message-Id: <527ab4fc137573aa28@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I added support for ACPI5 I made the assumption that
injected processor errors would just need to know the APICID,
memory errors just the address and mask, and PCIe errors just the
segment/bus/device/function. So I had the code check the type of injection
and multiplex the "param1" value appropriately.

This was not a good assumption :-(

There are injection scenarios where we need to specify more than one of
these items. E.g. injecting a cache error we need to specify an APICID
of the cpu that owns the cache, and also an address (so that we can trip
the error by accessing the address).

Add a "flags" file to give the user direct access to specify which items
are valid in the ACPI SET_ERROR_TYPE_WITH_ADDRESS structure. Also add
new files param3 and param4 to hold all these values.

For backwards compatability with old injection scripts we maintain the
old behaviour if flags remains set at zero (or is reset to 0).

Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>

---
v2: simplify test for whether we need to validate the memory address - Thanks Naveen

diff --git a/Documentation/acpi/apei/einj.txt b/Documentation/acpi/apei/einj.txt
index a58b63da1a36..f51861bcb07b 100644
--- a/Documentation/acpi/apei/einj.txt
+++ b/Documentation/acpi/apei/einj.txt
@@ -45,11 +45,22 @@ directory apei/einj. The following files are provided.
   injection. Before this, please specify all necessary error
   parameters.
 
+- flags
+  Present for kernel version 3.13 and above. Used to specify which
+  of param{1..4} are valid and should be used by BIOS during injection.
+  Value is a bitmask as specified in ACPI5.0 spec for the
+  SET_ERROR_TYPE_WITH_ADDRESS data structure:
+	Bit 0 - Processor APIC field valid (see param3 below)
+	Bit 1 - Memory address and mask valid (param1 and param2)
+	Bit 2 - PCIe (seg,bus,dev,fn) valid (param4 below)
+  If set to zero, legacy behaviour is used where the type of injection
+  specifies just one bit set, and param1 is multiplexed.
+
 - param1
   This file is used to set the first error parameter value. Effect of
   parameter depends on error_type specified. For example, if error
   type is memory related type, the param1 should be a valid physical
-  memory address.
+  memory address. [Unless "flag" is set - see above]
 
 - param2
   This file is used to set the second error parameter value. Effect of
@@ -58,6 +69,12 @@ directory apei/einj. The following files are provided.
   address mask. Linux requires page or narrower granularity, say,
   0xfffffffffffff000.
 
+- param3
+  Used when the 0x1 bit is set in "flag" to specify the APIC id
+
+- param4
+  Used when the 0x4 bit is set in "flag" to specify target PCIe device
+
 - notrigger
   The EINJ mechanism is a two step process. First inject the error, then
   perform some actions to trigger it. Setting "notrigger" to 1 skips the
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index fb57d03e698b..c76674e2a01f 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -416,7 +416,8 @@ out:
 	return rc;
 }
 
-static int __einj_error_inject(u32 type, u64 param1, u64 param2)
+static int __einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
+			       u64 param3, u64 param4)
 {
 	struct apei_exec_context ctx;
 	u64 val, trigger_paddr, timeout = FIRMWARE_TIMEOUT;
@@ -446,6 +447,12 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 				break;
 			}
 			v5param->flags = vendor_flags;
+		} else if (flags) {
+				v5param->flags = flags;
+				v5param->memory_address = param1;
+				v5param->memory_address_range = param2;
+				v5param->apicid = param3;
+				v5param->pcie_sbdf = param4;
 		} else {
 			switch (type) {
 			case ACPI_EINJ_PROCESSOR_CORRECTABLE:
@@ -514,11 +521,17 @@ static int __einj_error_inject(u32 type, u64 param1, u64 param2)
 }
 
 /* Inject the specified hardware error */
-static int einj_error_inject(u32 type, u64 param1, u64 param2)
+static int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
+			     u64 param3, u64 param4)
 {
 	int rc;
 	unsigned long pfn;
 
+	/* If user manually set "flags", make sure it is legal */
+	if (flags && (flags &
+		~(SETWA_FLAGS_APICID|SETWA_FLAGS_MEM|SETWA_FLAGS_PCIE_SBDF)))
+		return -EINVAL;
+
 	/*
 	 * We need extra sanity checks for memory errors.
 	 * Other types leap directly to injection.
@@ -532,7 +545,7 @@ static int einj_error_inject(u32 type, u64 param1, u64 param2)
 	if (type & ACPI5_VENDOR_BIT) {
 		if (vendor_flags != SETWA_FLAGS_MEM)
 			goto inject;
-	} else if (!(type & MEM_ERROR_MASK))
+	} else if (!(type & MEM_ERROR_MASK) && !(flags & SETWA_FLAGS_MEM))
 		goto inject;
 
 	/*
@@ -546,15 +559,18 @@ static int einj_error_inject(u32 type, u64 param1, u64 param2)
 
 inject:
 	mutex_lock(&einj_mutex);
-	rc = __einj_error_inject(type, param1, param2);
+	rc = __einj_error_inject(type, flags, param1, param2, param3, param4);
 	mutex_unlock(&einj_mutex);
 
 	return rc;
 }
 
 static u32 error_type;
+static u32 error_flags;
 static u64 error_param1;
 static u64 error_param2;
+static u64 error_param3;
+static u64 error_param4;
 static struct dentry *einj_debug_dir;
 
 static int available_error_type_show(struct seq_file *m, void *v)
@@ -648,7 +664,8 @@ static int error_inject_set(void *data, u64 val)
 	if (!error_type)
 		return -EINVAL;
 
-	return einj_error_inject(error_type, error_param1, error_param2);
+	return einj_error_inject(error_type, error_flags, error_param1, error_param2,
+		error_param3, error_param4);
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(error_inject_fops, NULL,
@@ -729,6 +746,10 @@ static int __init einj_init(void)
 	rc = -ENOMEM;
 	einj_param = einj_get_parameter_address();
 	if ((param_extension || acpi5) && einj_param) {
+		fentry = debugfs_create_x32("flags", S_IRUSR | S_IWUSR,
+					    einj_debug_dir, &error_flags);
+		if (!fentry)
+			goto err_unmap;
 		fentry = debugfs_create_x64("param1", S_IRUSR | S_IWUSR,
 					    einj_debug_dir, &error_param1);
 		if (!fentry)
@@ -737,6 +758,14 @@ static int __init einj_init(void)
 					    einj_debug_dir, &error_param2);
 		if (!fentry)
 			goto err_unmap;
+		fentry = debugfs_create_x64("param3", S_IRUSR | S_IWUSR,
+					    einj_debug_dir, &error_param3);
+		if (!fentry)
+			goto err_unmap;
+		fentry = debugfs_create_x64("param4", S_IRUSR | S_IWUSR,
+					    einj_debug_dir, &error_param4);
+		if (!fentry)
+			goto err_unmap;
 
 		fentry = debugfs_create_x32("notrigger", S_IRUSR | S_IWUSR,
 					    einj_debug_dir, &notrigger);
