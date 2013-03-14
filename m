Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab3CNKzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:55:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51875 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab3CNKh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olaf Hering <olaf@aepfle.de>, Jeff Garzik <jgarzik@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 36/88] ata_piix: reenable MS Virtual PC guests
Date: Thu, 14 Mar 2013 10:35:29 +0000
Message-Id: <1363257381-15900-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olaf Hering <olaf@aepfle.de>

commit d9904344fc4052fbe7e4dc137eba0dcdadf326bd upstream.

An earlier commit cd006086fa5d91414d8ff9ff2b78fbb593878e3c ("ata_piix:
defer disks to the Hyper-V drivers by default") broke MS Virtual PC
guests. Hyper-V guests and Virtual PC guests have nearly identical DMI
info. As a result the driver does currently ignore the emulated hardware
in Virtual PC guests and defers the handling to hv_blkvsc. Since Virtual
PC does not offer paravirtualized drivers no disks will be found in the
guest.

One difference in the DMI info is the product version. This patch adds a
match for MS Virtual PC 2007 and "unignores" the emulated hardware.

This was reported for openSuSE 12.1 in bugzilla:
https://bugzilla.novell.com/show_bug.cgi?id=737532

Here is a detailed list of DMI info from example guests:

hwinfo --bios:

virtual pc guest:

  System Info: #1
    Manufacturer: "Microsoft Corporation"
    Product: "Virtual Machine"
    Version: "VS2005R2"
    Serial: "3178-9905-1533-4840-9282-0569-59"
    UUID: undefined, but settable
    Wake-up: 0x06 (Power Switch)
  Board Info: #2
    Manufacturer: "Microsoft Corporation"
    Product: "Virtual Machine"
    Version: "5.0"
    Serial: "3178-9905-1533-4840-9282-0569-59"
  Chassis Info: #3
    Manufacturer: "Microsoft Corporation"
    Version: "5.0"
    Serial: "3178-9905-1533-4840-9282-0569-59"
    Asset Tag: "7188-3705-6309-9738-9645-0364-00"
    Type: 0x03 (Desktop)
    Bootup State: 0x03 (Safe)
    Power Supply State: 0x03 (Safe)
    Thermal State: 0x01 (Other)
    Security Status: 0x01 (Other)

win2k8 guest:

  System Info: #1
    Manufacturer: "Microsoft Corporation"
    Product: "Virtual Machine"
    Version: "7.0"
    Serial: "9106-3420-9819-5495-1514-2075-48"
    UUID: undefined, but settable
    Wake-up: 0x06 (Power Switch)
  Board Info: #2
    Manufacturer: "Microsoft Corporation"
    Product: "Virtual Machine"
    Version: "7.0"
    Serial: "9106-3420-9819-5495-1514-2075-48"
  Chassis Info: #3
    Manufacturer: "Microsoft Corporation"
    Version: "7.0"
    Serial: "9106-3420-9819-5495-1514-2075-48"
    Asset Tag: "7076-9522-6699-1042-9501-1785-77"
    Type: 0x03 (Desktop)
    Bootup State: 0x03 (Safe)
    Power Supply State: 0x03 (Safe)
    Thermal State: 0x01 (Other)
    Security Status: 0x01 (Other)

win2k12 guest:

  System Info: #1
    Manufacturer: "Microsoft Corporation"
    Product: "Virtual Machine"
    Version: "7.0"
    Serial: "8179-1954-0187-0085-3868-2270-14"
    UUID: undefined, but settable
    Wake-up: 0x06 (Power Switch)
  Board Info: #2
    Manufacturer: "Microsoft Corporation"
    Product: "Virtual Machine"
    Version: "7.0"
    Serial: "8179-1954-0187-0085-3868-2270-14"
  Chassis Info: #3
    Manufacturer: "Microsoft Corporation"
    Version: "7.0"
    Serial: "8179-1954-0187-0085-3868-2270-14"
    Asset Tag: "8374-0485-4557-6331-0620-5845-25"
    Type: 0x03 (Desktop)
    Bootup State: 0x03 (Safe)
    Power Supply State: 0x03 (Safe)
    Thermal State: 0x01 (Other)
    Security Status: 0x01 (Other)

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/ata_piix.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 3c809bf..36b5276 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1577,12 +1577,31 @@ static void piix_ignore_devices_quirk(struct ata_host *host)
 		},
 		{ }	/* terminate list */
 	};
-	const struct dmi_system_id *dmi = dmi_first_match(ignore_hyperv);
+	static const struct dmi_system_id allow_virtual_pc[] = {
+		{
+			/* In MS Virtual PC guests the DMI ident is nearly
+			 * identical to a Hyper-V guest. One difference is the
+			 * product version which is used here to identify
+			 * a Virtual PC guest. This entry allows ata_piix to
+			 * drive the emulated hardware.
+			 */
+			.ident = "MS Virtual PC 2007",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR,
+						"Microsoft Corporation"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
+				DMI_MATCH(DMI_PRODUCT_VERSION, "VS2005R2"),
+			},
+		},
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *ignore = dmi_first_match(ignore_hyperv);
+	const struct dmi_system_id *allow = dmi_first_match(allow_virtual_pc);
 
-	if (dmi && prefer_ms_hyperv) {
+	if (ignore && !allow && prefer_ms_hyperv) {
 		host->flags |= ATA_HOST_IGNORE_ATA;
 		dev_info(host->dev, "%s detected, ATA device ignore set\n",
-			dmi->ident);
+			ignore->ident);
 	}
 #endif
 }
-- 
1.8.1.2

