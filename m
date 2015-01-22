Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbbAVIvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:51:10 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:35784 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbbAVIvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:51:06 -0500
Date: Thu, 22 Jan 2015 09:51:10 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Shaohua Li <shaohua.li@intel.com>
Cc: linux-acpi@vger.kernel.org, devel@acpica.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ACPI: Convert int variable to bool and propagate to
 function parameters
Message-ID: <20150122085110.GA14699@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/acpi/acpi_processor.c   |  5 +++--
 drivers/acpi/acpica/acutils.h   |  3 ++-
 drivers/acpi/acpica/utaddress.c |  3 ++-
 drivers/acpi/acpica/utxface.c   |  2 +-
 drivers/acpi/osl.c              |  4 ++--
 drivers/acpi/processor_core.c   | 12 ++++++------
 drivers/acpi/processor_pdc.c    |  5 +++--
 7 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 1020b1b..e4fecfd 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -215,7 +215,8 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	union acpi_object object = { 0 };
 	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
 	struct acpi_processor *pr = acpi_driver_data(device);
-	int phys_id, cpu_index, device_declaration = 0;
+	bool device_declaration = false;
+	int phys_id, cpu_index;
 	acpi_status status = AE_OK;
 	static int cpu0_initialized;
 	unsigned long long value;
@@ -258,7 +259,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
 				status);
 			return -ENODEV;
 		}
-		device_declaration = 1;
+		device_declaration = true;
 		pr->acpi_id = value;
 	}
 
diff --git a/drivers/acpi/acpica/acutils.h b/drivers/acpi/acpica/acutils.h
index 486d342..7708c74 100644
--- a/drivers/acpi/acpica/acutils.h
+++ b/drivers/acpi/acpica/acutils.h
@@ -718,7 +718,8 @@ acpi_ut_remove_address_range(acpi_adr_space_type space_id,
 
 u32
 acpi_ut_check_address_range(acpi_adr_space_type space_id,
-			    acpi_physical_address address, u32 length, u8 warn);
+			    acpi_physical_address address, u32 length,
+			    bool warn);
 
 void acpi_ut_delete_address_lists(void);
 
diff --git a/drivers/acpi/acpica/utaddress.c b/drivers/acpi/acpica/utaddress.c
index a1acec9..8164912 100644
--- a/drivers/acpi/acpica/utaddress.c
+++ b/drivers/acpi/acpica/utaddress.c
@@ -203,7 +203,8 @@ acpi_ut_remove_address_range(acpi_adr_space_type space_id,
 
 u32
 acpi_ut_check_address_range(acpi_adr_space_type space_id,
-			    acpi_physical_address address, u32 length, u8 warn)
+			    acpi_physical_address address, u32 length,
+			    bool warn)
 {
 	struct acpi_address_range *range_info;
 	acpi_physical_address end_address;
diff --git a/drivers/acpi/acpica/utxface.c b/drivers/acpi/acpica/utxface.c
index 49c873c..06b1d74 100644
--- a/drivers/acpi/acpica/utxface.c
+++ b/drivers/acpi/acpica/utxface.c
@@ -473,7 +473,7 @@ acpi_status acpi_update_interfaces(u8 action)
 u32
 acpi_check_address_range(acpi_adr_space_type space_id,
 			 acpi_physical_address address,
-			 acpi_size length, u8 warn)
+			 acpi_size length, bool warn)
 {
 	u32 overlaps;
 	acpi_status status;
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index f9eeae8..9f0e4ec 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1629,7 +1629,7 @@ int acpi_check_resource_conflict(const struct resource *res)
 {
 	acpi_adr_space_type space_id;
 	acpi_size length;
-	u8 warn = 0;
+	bool warn = false;
 	int clash = 0;
 
 	if (acpi_enforce_resources == ENFORCE_RESOURCES_NO)
@@ -1644,7 +1644,7 @@ int acpi_check_resource_conflict(const struct resource *res)
 
 	length = resource_size(res);
 	if (acpi_enforce_resources != ENFORCE_RESOURCES_NO)
-		warn = 1;
+		warn = true;
 	clash = acpi_check_address_range(space_id, res->start, length, warn);
 
 	if (clash) {
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 02e4839..b71579a 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -29,7 +29,7 @@ static int map_lapic_id(struct acpi_subtable_header *entry,
 }
 
 static int map_x2apic_id(struct acpi_subtable_header *entry,
-			 int device_declaration, u32 acpi_id, int *apic_id)
+			 bool device_declaration, u32 acpi_id, int *apic_id)
 {
 	struct acpi_madt_local_x2apic *apic =
 		container_of(entry, struct acpi_madt_local_x2apic, header);
@@ -46,7 +46,7 @@ static int map_x2apic_id(struct acpi_subtable_header *entry,
 }
 
 static int map_lsapic_id(struct acpi_subtable_header *entry,
-		int device_declaration, u32 acpi_id, int *apic_id)
+			 bool device_declaration, u32 acpi_id, int *apic_id)
 {
 	struct acpi_madt_local_sapic *lsapic =
 		container_of(entry, struct acpi_madt_local_sapic, header);
@@ -64,7 +64,7 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
 	return 0;
 }
 
-static int map_madt_entry(int type, u32 acpi_id)
+static int map_madt_entry(bool type, u32 acpi_id)
 {
 	unsigned long madt_end, entry;
 	static struct acpi_table_madt *madt;
@@ -105,7 +105,7 @@ static int map_madt_entry(int type, u32 acpi_id)
 	return phys_id;
 }
 
-static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
+static int map_mat_entry(acpi_handle handle, bool type, u32 acpi_id)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
@@ -137,7 +137,7 @@ exit:
 	return phys_id;
 }
 
-int acpi_get_phys_id(acpi_handle handle, int type, u32 acpi_id)
+int acpi_get_phys_id(acpi_handle handle, bool type, u32 acpi_id)
 {
 	int phys_id;
 
@@ -194,7 +194,7 @@ int acpi_map_cpuid(int phys_id, u32 acpi_id)
 	return -1;
 }
 
-int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
+int acpi_get_cpuid(acpi_handle handle, bool type, u32 acpi_id)
 {
 	int phys_id;
 
diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
index e5dd808..8c35244 100644
--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -20,7 +20,8 @@ ACPI_MODULE_NAME("processor_pdc");
 
 static bool __init processor_physically_present(acpi_handle handle)
 {
-	int cpuid, type;
+	bool type;
+	int cpuid;
 	u32 acpi_id;
 	acpi_status status;
 	acpi_object_type acpi_type;
@@ -49,7 +50,7 @@ static bool __init processor_physically_present(acpi_handle handle)
 		return false;
 	}
 
-	type = (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0;
+	type = (acpi_type == ACPI_TYPE_DEVICE) ? true : false;
 	cpuid = acpi_get_cpuid(handle, type, acpi_id);
 
 	if (cpuid == -1)
-- 
1.9.1

