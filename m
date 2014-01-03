Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaACAHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:07:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23704 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaACAHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:07:45 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <lenb@kernel.org>
Subject: [PATCH v2 05/10] ACPI: Add acpi_run_dsm()
Date: Thu,  2 Jan 2014 16:08:12 -0800
Message-Id: <1388707697-16800-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
References: <1388707697-16800-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will need to use that get dmar entries for hotplug

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/bus.c   | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h | 10 +++++++
 2 files changed, 87 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index bba9b72..14d18d3 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -283,6 +283,83 @@ out_kfree:
 }
 EXPORT_SYMBOL(acpi_run_osc);
 
+static void acpi_print_dsm_error(acpi_handle handle,
+	struct acpi_dsm_context *context, char *error)
+{
+	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER};
+
+	if (ACPI_FAILURE(acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer)))
+		printk(KERN_DEBUG "%s for idx %x\n", error, context->func_idx);
+	else {
+		printk(KERN_DEBUG "%s:%s for idx %x\n",
+			(char *)buffer.pointer, error, context->func_idx);
+		kfree(buffer.pointer);
+	}
+}
+
+acpi_status acpi_run_dsm(acpi_handle handle, struct acpi_dsm_context *context)
+{
+	acpi_status status;
+	struct acpi_object_list input;
+	union acpi_object in_params[4];
+	union acpi_object *out_obj;
+	u8 uuid[16];
+	struct acpi_buffer output = {ACPI_ALLOCATE_BUFFER, NULL};
+
+	if (!context)
+		return AE_ERROR;
+	if (ACPI_FAILURE(acpi_str_to_uuid(context->uuid_str, uuid)))
+		return AE_ERROR;
+	context->ret.length = ACPI_ALLOCATE_BUFFER;
+	context->ret.pointer = NULL;
+
+	/* Setting up input parameters */
+	input.count = 4;
+	input.pointer = in_params;
+	in_params[0].type		= ACPI_TYPE_BUFFER;
+	in_params[0].buffer.length	= 16;
+	in_params[0].buffer.pointer	= uuid;
+	in_params[1].type		= ACPI_TYPE_INTEGER;
+	in_params[1].integer.value	= context->rev;
+	in_params[2].type		= ACPI_TYPE_INTEGER;
+	in_params[2].integer.value	= context->func_idx;
+	in_params[3].type		= ACPI_TYPE_PACKAGE;
+	in_params[3].package.count	= context->func_argc;
+	in_params[3].package.elements	= context->func_argv;
+
+	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
+	if (ACPI_FAILURE(status))
+		return status;
+
+	if (!output.length)
+		return AE_NULL_OBJECT;
+
+	out_obj = output.pointer;
+	if (out_obj->type != ACPI_TYPE_BUFFER) {
+		acpi_print_dsm_error(handle, context,
+			"_DSM evaluation returned wrong type");
+		status = AE_TYPE;
+		goto out_kfree;
+	}
+
+	context->ret.length = out_obj->buffer.length;
+	context->ret.pointer = kmalloc(context->ret.length, GFP_KERNEL);
+	if (!context->ret.pointer) {
+		status =  AE_NO_MEMORY;
+		goto out_kfree;
+	}
+	memcpy(context->ret.pointer, out_obj->buffer.pointer,
+		context->ret.length);
+	status =  AE_OK;
+
+out_kfree:
+	kfree(output.pointer);
+	if (status != AE_OK)
+		context->ret.pointer = NULL;
+	return status;
+}
+EXPORT_SYMBOL(acpi_run_dsm);
+
 bool osc_sb_apei_support_acked;
 static u8 sb_uuid_str[] = "0811B06E-4A27-44F9-8D60-3CBBC22E7B48";
 static void acpi_bus_osc_support(void)
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 762980a..02daa9c 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -323,6 +323,16 @@ void __init acpi_nvs_nosave(void);
 void __init acpi_nvs_nosave_s3(void);
 #endif /* CONFIG_PM_SLEEP */
 
+struct acpi_dsm_context {
+	char *uuid_str; /* uuid string */
+	int rev;
+	int func_idx;	/* function index */
+	int func_argc;
+	union acpi_object *func_argv;
+	struct acpi_buffer ret; /* free by caller if success */
+};
+acpi_status acpi_run_dsm(acpi_handle handle, struct acpi_dsm_context *context);
+
 struct acpi_osc_context {
 	char *uuid_str;			/* UUID string */
 	int rev;
-- 
1.8.4

