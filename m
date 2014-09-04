Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaIDMOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:14:44 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:10584
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753777AbaIDMOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:14:42 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <alex.williamson@redhat.com>, <Emilian.Medve@freescale.com>,
        <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH v2] iommu/fsl: Fix warning resulting from adding PCI device twice
Date: Thu, 4 Sep 2014 17:08:45 +0530
Message-ID: <1409830725-4469-1-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(81542001)(95666004)(2201001)(86362001)(229853001)(31966008)(92566001)(26826002)(21056001)(74502001)(105606002)(44976005)(107046002)(87936001)(68736004)(575784001)(47776003)(92726001)(97736001)(81342001)(19580395003)(50986999)(93916002)(46102001)(74662001)(106466001)(89996001)(84676001)(85852003)(77982001)(79102001)(76482001)(4396001)(88136002)(48376002)(99396002)(50226001)(50466002)(104016003)(87286001)(80022001)(85306004)(6806004)(104166001)(77156001)(36756003)(19580405001)(83322001)(102836001)(64706001)(62966002)(20776003)(90102001)(83072002)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB468;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0324C2C0E2
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Varun.Sethi@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_group_get_for_dev determines the iommu group for the PCI device and adds
the device to the group.

In the PAMU driver we were again adding the device to the same group without checking
if the device already had an iommu group. This resulted in the following warning.

sysfs: cannot create duplicate filename '/devices/ffe200000.pcie/pci0000:00/0000:00:00.0/iommu_group'
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:31
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc3-00002-g7505cea-dirty #126
task: c0000001fe0a0000 ti: c0000001fe044000 task.ti: c0000001fe044000
NIP: c00000000018879c LR: c000000000188798 CTR: c00000000001ea50
REGS: c0000001fe047040 TRAP: 0700   Not tainted  (3.17.0-rc3-00002-g7505cea-dirty)
MSR: 0000000080029000 <CE,EE,ME>  CR: 24ad8e22  XER: 20000000
SOFTE: 1 
GPR00: c000000000188798 c0000001fe0472c0 c0000000009a52e0 0000000000000065 
GPR04: 0000000000000001 0000000000000000 3a30303a00000000 0000000027000000 
GPR08: 2f696f6d00000000 c0000000008d3830 c0000000009b3938 c0000000009bb3d0 
GPR12: 0000000028ad8e24 c00000000fff4000 c00000000000205c 0000000000000000 
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
GPR20: 0000000000000000 0000000000000000 0000000000000000 c0000000008a4c70 
GPR24: c0000000007e9010 c0000001fe0140a8 ffffffffffffffef 0000000000000001 
GPR28: c0000001fe22ebb8 c0000000007e9010 c00000000090bf10 c0000001fe220000 
NIP [c00000000018879c] .sysfs_warn_dup+0x74/0xa4
LR [c000000000188798] .sysfs_warn_dup+0x70/0xa4
Call Trace:
[c0000001fe0472c0] [c000000000188798] .sysfs_warn_dup+0x70/0xa4 (unreliable)
[c0000001fe047350] [c000000000188d34] .sysfs_do_create_link_sd.clone.2+0x168/0x174
[c0000001fe047400] [c0000000004b3cf8] .iommu_group_add_device+0x78/0x244
[c0000001fe0474b0] [c0000000004b6964] .fsl_pamu_add_device+0x88/0x1a8
[c0000001fe047570] [c0000000004b3960] .iommu_bus_notifier+0xdc/0x15c
[c0000001fe047600] [c000000000059848] .notifier_call_chain+0x8c/0xe8
[c0000001fe0476a0] [c000000000059d04] .__blocking_notifier_call_chain+0x58/0x84
[c0000001fe047750] [c00000000036619c] .device_add+0x464/0x5c8
[c0000001fe047820] [c000000000300ebc] .pci_device_add+0x14c/0x17c
[c0000001fe0478c0] [c000000000300fbc] .pci_scan_single_device+0xd0/0xf4
[c0000001fe047970] [c00000000030104c] .pci_scan_slot+0x6c/0x18c
[c0000001fe047a10] [c00000000030226c] .pci_scan_child_bus+0x40/0x114
[c0000001fe047ac0] [c000000000021974] .pcibios_scan_phb+0x240/0x2c8
[c0000001fe047b70] [c00000000085a970] .pcibios_init+0x64/0xc8
[c0000001fe047c00] [c000000000001884] .do_one_initcall+0xbc/0x224
[c0000001fe047d00] [c000000000852d50] .kernel_init_freeable+0x14c/0x21c
[c0000001fe047db0] [c000000000002078] .kernel_init+0x1c/0xfa4
[c0000001fe047e30] [c000000000000884] .ret_from_kernel_thread+0x58/0xd4
Instruction dump:
7c7f1b79 4182001c 7fe4fb78 7f83e378 38a01000 4bffc905 60000000 7c641b78 
e87e8008 7fa5eb78 48482ff5 60000000 <0fe00000> 7fe3fb78 4bf7bd39 60000000 



Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
v2 changes
- directly check for the device iommu_group

 drivers/iommu/fsl_pamu_domain.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
index 61d1daf..56feed7 100644
--- a/drivers/iommu/fsl_pamu_domain.c
+++ b/drivers/iommu/fsl_pamu_domain.c
@@ -984,7 +984,7 @@ static int fsl_pamu_add_device(struct device *dev)
 	struct iommu_group *group = ERR_PTR(-ENODEV);
 	struct pci_dev *pdev;
 	const u32 *prop;
-	int ret, len;
+	int ret = 0, len;
 
 	/*
 	 * For platform devices we allocate a separate group for
@@ -1007,7 +1007,13 @@ static int fsl_pamu_add_device(struct device *dev)
 	if (IS_ERR(group))
 		return PTR_ERR(group);
 
-	ret = iommu_group_add_device(group, dev);
+	/*
+	 * Check if device has already been added to an iommu group.
+	 * Group could have already been created for a PCI device in
+	 * the iommu_group_get_for_dev path.
+	 */
+	if (!dev->iommu_group)
+		ret = iommu_group_add_device(group, dev);
 
 	iommu_group_put(group);
 	return ret;
-- 
1.7.9.5

