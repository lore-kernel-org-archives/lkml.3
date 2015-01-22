Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbbAVIud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:50:33 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:34812 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbbAVIuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:50:24 -0500
Date: Thu, 22 Jan 2015 09:50:28 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Shaohua Li <shaohua.li@intel.com>
Cc: linux-acpi@vger.kernel.org, devel@acpica.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ACPI: Convert non-returned local variable to boolean
 when relevant
Message-ID: <20150122085028.GA14674@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was produced using Coccinelle. A simplified version of the
semantic patch is:

@r exists@
identifier f;
local idexpression u8 x;
identifier xname;
@@

f(...) {
...when any
(
  x@xname = 1;
|
  x@xname = 0;
)
...when any
}

@bad exists@
identifier r.f;
local idexpression u8 r.x
expression e1 != {0, 1}, e2;
@@

f(...) {
...when any
(
  x = e1;
|
  x + e2
)
...when any
}

@depends on !bad@
identifier r.f;
local idexpression u8 r.x;
identifier r.xname;
@@

f(...) {
...
++ bool xname;
- int xname;
<...
(
  x =
- 1
+ true
|
  x =
- -1
+ false
)
...>

}

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/acpi/acpica/utstring.c | 10 +++++-----
 drivers/acpi/dock.c            |  4 ++--
 drivers/acpi/pci_link.c        |  4 ++--
 drivers/acpi/scan.c            |  4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/acpica/utstring.c b/drivers/acpi/acpica/utstring.c
index 6dc54b3..a74374b 100644
--- a/drivers/acpi/acpica/utstring.c
+++ b/drivers/acpi/acpica/utstring.c
@@ -178,8 +178,8 @@ acpi_status acpi_ut_strtoul64(char *string, u32 base, u64 *ret_integer)
 	u32 to_integer_op = (base == ACPI_ANY_BASE);
 	u32 mode32 = (acpi_gbl_integer_byte_width == 4);
 	u8 valid_digits = 0;
-	u8 sign_of0x = 0;
-	u8 term = 0;
+	bool sign_of0x = false;
+	bool term = false;
 
 	ACPI_FUNCTION_TRACE_STR(ut_stroul64, string);
 
@@ -212,7 +212,7 @@ acpi_status acpi_ut_strtoul64(char *string, u32 base, u64 *ret_integer)
 		 * We need to determine if it is decimal or hexadecimal.
 		 */
 		if ((*string == '0') && (ACPI_TOLOWER(*(string + 1)) == 'x')) {
-			sign_of0x = 1;
+			sign_of0x = true;
 			base = 16;
 
 			/* Skip over the leading '0x' */
@@ -250,7 +250,7 @@ acpi_status acpi_ut_strtoul64(char *string, u32 base, u64 *ret_integer)
 
 			/* Digit is out of range; possible in to_integer case only */
 
-			term = 1;
+			term = true;
 		} else {
 			this_digit = (u8)ACPI_TOUPPER(*string);
 			if (ACPI_IS_XDIGIT((char)this_digit)) {
@@ -259,7 +259,7 @@ acpi_status acpi_ut_strtoul64(char *string, u32 base, u64 *ret_integer)
 
 				this_digit = this_digit - 'A' + 10;
 			} else {
-				term = 1;
+				term = true;
 			}
 		}
 
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index d9339b4..6cfced6 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -445,7 +445,7 @@ int dock_notify(struct acpi_device *adev, u32 event)
 {
 	acpi_handle handle = adev->handle;
 	struct dock_station *ds = find_dock_station(handle);
-	int surprise_removal = 0;
+	bool surprise_removal = false;
 
 	if (!ds)
 		return -ENODEV;
@@ -488,7 +488,7 @@ int dock_notify(struct acpi_device *adev, u32 event)
 		if (dock_present(ds) || dock_in_progress(ds))
 			break;
 		/* This is a surprise removal */
-		surprise_removal = 1;
+		surprise_removal = true;
 		event = ACPI_NOTIFY_EJECT_REQUEST;
 		/* Fall back */
 	case ACPI_NOTIFY_EJECT_REQUEST:
diff --git a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
index cfd7581..b62b35c 100644
--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -693,7 +693,7 @@ static int acpi_pci_link_add(struct acpi_device *device,
 	int result;
 	struct acpi_pci_link *link;
 	int i;
-	int found = 0;
+	bool found = false;
 
 	link = kzalloc(sizeof(struct acpi_pci_link), GFP_KERNEL);
 	if (!link)
@@ -717,7 +717,7 @@ static int acpi_pci_link_add(struct acpi_device *device,
 	for (i = 0; i < link->irq.possible_count; i++) {
 		if (link->irq.active == link->irq.possible[i]) {
 			printk(KERN_CONT " *%d", link->irq.possible[i]);
-			found = 1;
+			found = true;
 		} else
 			printk(KERN_CONT " %d", link->irq.possible[i]);
 	}
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index dc4d896..06de4b5 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1306,7 +1306,7 @@ int acpi_device_add(struct acpi_device *device,
 {
 	int result;
 	struct acpi_device_bus_id *acpi_device_bus_id, *new_bus_id;
-	int found = 0;
+	bool found = false;
 
 	if (device->handle) {
 		acpi_status status;
@@ -1348,7 +1348,7 @@ int acpi_device_add(struct acpi_device *device,
 		if (!strcmp(acpi_device_bus_id->bus_id,
 			    acpi_device_hid(device))) {
 			acpi_device_bus_id->instance_no++;
-			found = 1;
+			found = true;
 			kfree(new_bus_id);
 			break;
 		}
-- 
1.9.1

