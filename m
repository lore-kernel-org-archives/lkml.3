Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbbAEVLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:11:39 -0500
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:22688
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753922AbbAEVLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:11:36 -0500
X-WSS-ID: 0NHQ2V5-08-U80-02
X-M-MSG: 
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
To: <rjw@rjwysocki.net>, <lenb@kernel.org>, <hdegoede@redhat.com>,
        <tj@kernel.org>, <arnd@arndb.de>, <mjg59@srcf.ucam.org>,
        <grant.likely@linaro.org>
CC: <hanjun.guo@linaro.org>, <al.stone@linaro.org>,
        <graeme.gregory@linaro.org>, <leo.duran@amd.com>,
        <linux-ide@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-acpi@lists.linaro.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [V2 PATCH 0/2] Introduce ACPI support for ahci_platform driver
Date: Mon, 5 Jan 2015 15:11:13 -0600
Message-ID: <1420492275-6878-1-git-send-email-Suravee.Suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(209900001)(189002)(199003)(31966008)(97736003)(87936001)(20776003)(46102003)(47776003)(48376002)(64706001)(53416004)(84676001)(89996001)(105586002)(36756003)(86362001)(106466001)(2201001)(77156002)(92566001)(62966003)(229853001)(4396001)(15395725005)(50226001)(107046002)(19300405004)(99396003)(19580395003)(50466002)(77096005)(101416001)(120916001)(15975445007)(21056001)(50986999)(19273905006)(68736005)(562404015)(563064011)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR02MB198;
X-Forefront-PRVS: 0447DB1C71
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 21:11:33.3693
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduce ACPI support for non-PCI AHCI platform driver.
Existing ACPI support for AHCI assumes the device controller is a PCI device.

Also, since there is no ACPI _HID/_CID for generic AHCI controller, the driver
could not use them for matching devices. Therefore, this patch introduces
a mechanism for drivers to match devices using ACPI _CLS method.

This patch series is rebased from and tested with:

    http://git.linaro.org/leg/acpi/acpi.git acpi-5.1-v7

This topic was discussed earlier here (as part of introducing support for
AMD Seattle SATA controller):

    http://marc.info/?l=linux-arm-kernel&m=141083492521584&w=2

NOTE:
	* PATCH 2/2 has already been Acked-by Tejun Heo in V1. I only made
	  a minor renaming of the acpi_cls to acpi_match_cls for clarity
	  in V2. It probably should be routed together with the PATCH 1/2
	  (once acked) since it defines the new member in the struct.

Changes V1 (https://lkml.org/lkml/2014/12/19/345)
	* Rebased to 3.19.0-rc2
	* Change from acpi_cls in device_driver to acpi_match_cls (Hanjun comment)
	* Change the matching logic in acpi_driver_match_device() due to the new
	  special PRP0001 _HID.
	* Simplify the return type of acpi_match_device_cls() to boolean.

Changes from RFC (https://lkml.org/lkml/2014/12/17/446)
	* Remove #ifdef and make non-ACPI version of the acpi_match_device_cls
	  as inline. (per Arnd)
	* Simplify logic to retrieve and evaluate _CLS handle. (per Hanjun)

Suravee Suthikulpanit (2):
  ACPI / scan: Add support for ACPI _CLS device matching
  ata: ahci_platform: Add ACPI _CLS matching

 drivers/acpi/scan.c             | 79 +++++++++++++++++++++++++++++++++++++++--
 drivers/ata/Kconfig             |  2 +-
 drivers/ata/ahci_platform.c     |  3 ++
 include/acpi/acnames.h          |  1 +
 include/linux/acpi.h            | 10 ++++++
 include/linux/device.h          |  1 +
 include/linux/mod_devicetable.h |  6 ++++
 7 files changed, 98 insertions(+), 4 deletions(-)

-- 
1.9.3

