Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbaEaXv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 19:51:27 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:2724
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756654AbaEaXvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 19:51:25 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "andreas.noever@gmail.com" <andreas.noever@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [PATCH v4 00/15] Thunderbolt driver for Apple MacBooks
Thread-Topic: [PATCH v4 00/15] Thunderbolt driver for Apple MacBooks
Thread-Index: AQHPfNyYVDcE17ZFH0KR3hCN8Vnny5tbXLiA
Date: Sat, 31 May 2014 23:51:22 +0000
Message-ID: <1401580281.7663.14.camel@x230>
References: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
In-Reply-To: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(51704005)(377424004)(24454002)(101416001)(92726001)(92566001)(33716001)(81342001)(19580395003)(83322001)(99286001)(99396002)(81542001)(76176999)(19580405001)(80022001)(79102001)(20776003)(54356999)(64706001)(76482001)(2656002)(87936001)(103116003)(77982001)(86362001)(33646001)(50986999)(4396001)(74502001)(74662001)(31966008)(21056001)(83072002)(85852003)(46102001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB421;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.garrett@nebula.com; 
Content-Type: text/plain; charset="utf-8"
Content-ID: <C62C4A26F617834BBB9693338C128309@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4VNpWD6023273

On Sat, 2014-05-31 at 16:27 +0200, Andreas Noever wrote:
> Hi
> 
> This is version 4 of my Thunderbolt driver for Apple hardware (see [1] for v3).
> 
> Changes since v3:
>  - Fix typos and style problems caught by Bjorn.
>  - Changed the #ifdef CONFIG_ACPI block to cover the whole pci quirk.

Hi Andreas,

This seems to be working well on my MBP. It appears to broadly work on
my Mac Pro, which has Thunderbolt 2 hardware - I added the PCI ID, and
loading the thunderbolt driver after the device is plugged in works, but
it won't recognise hotplug events. I don't appear to get any interrupts
from the Thunderbolt controller. Any idea what might be happening there?

As far as the quirks go - perhaps something like this would be
reasonable, rather than maintaining a list of machines?

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index c9d6b90..c3170d4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2993,35 +2993,6 @@ DECLARE_PCI_FIXUP_HEADER(0x1814, 0x0601, /*
Ralink RT2800 802.11n PCI */
 			 quirk_broken_intx_masking);
 
 #ifdef CONFIG_ACPI
-/* Apple systems with a Cactus Ridge Thunderbolt controller. */
-static struct dmi_system_id apple_thunderbolt_whitelist[] = {
-	{
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro9"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro10"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir5"),
-		},
-	},
-	{
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir6"),
-		},
-	},
-	{ }
-};
-
 /*
  * Apple: Shutdown Cactus Ridge Thunderbolt controller.
  *
@@ -3041,7 +3012,7 @@ static void
quirk_apple_poweroff_thunderbolt(struct pci_dev *dev)
 {
 	acpi_handle bridge, SXIO, SXFP, SXLV;
 
-	if (!dmi_check_system(apple_thunderbolt_whitelist))
+	if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc."))
 		return;
 	if (pci_pcie_type(dev) != PCI_EXP_TYPE_UPSTREAM)
 		return;
@@ -3084,7 +3055,7 @@ static void
quirk_apple_wait_for_thunderbolt(struct pci_dev *dev)
 	struct pci_dev *sibling = NULL;
 	struct pci_dev *nhi = NULL;
 
-	if (!dmi_check_system(apple_thunderbolt_whitelist))
+	if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc."))
 		return;
 	if (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)
 		return;


-- 
Matthew Garrett <matthew.garrett@nebula.com>
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
