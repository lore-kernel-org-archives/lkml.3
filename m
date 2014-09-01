Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaIAG1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:27:44 -0400
Received: from hgpmta01.sony.com.cn ([114.141.162.246]:39117 "EHLO
	hgpmta01.sony.com.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaIAG1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:27:42 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2014 02:27:41 EDT
From: "Su, Friendy" <Friendy.Su@sony.com.cn>
To: "joro@8bytes.org" <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 1 Sep 2014 14:17:44 +0800
Subject: [PATCH v1 1/1] iommu/amd: set iommu for early mapped ioapic/hpet
Thread-Topic: [PATCH v1 1/1] iommu/amd: set iommu for early mapped
 ioapic/hpet
Thread-Index: AQHPxaxxhKfKdvUa5USeUaXTXfrFXA==
Message-ID: <053191AD6E9023439BF3970DE870051856D1EF3AC4@APSHAXMS02.ap.sony.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Su Friendy <friendy.su@sony.com.cn>

The early mapped ioapic/hpet specified by kernel boot parameter
ivrs_ioapic[ID]/ivrs_hpet[ID] always override the ioapic/hpet with
same ID reported by ACPI IVRS table. Therefore, the early mapped
should be always controlled by iommu.

Current driver did not set iommu for the early mapped. This causes
ivrs_ioapic[ID]/ivrs_hpet[ID] actually are not controlled by iommu.
This patch fixes this problem by setting iommu for early mapped.

Signed-off-by: Su Friendy <friendy.su@sony.com.cn>
Signed-off-by: Saeki Shusuke <shusuke.saeki@jp.sony.com>
Signed-off-by: Tamori Masahiro <Masahiro.Tamori@jp.sony.com>
---
 drivers/iommu/amd_iommu_init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 3783e0b..148ab61 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -747,7 +747,7 @@ static int __init add_special_device(u8 type, u8 id, u16 devid, bool cmd_line)
 	return 0;
 }
 
-static int __init add_early_maps(void)
+static int __init add_early_maps(struct amd_iommu *iommu)
 {
 	int i, ret;
 
@@ -758,6 +758,11 @@ static int __init add_early_maps(void)
 					 early_ioapic_map[i].cmd_line);
 		if (ret)
 			return ret;
+		/*
+		 * early mapped ioapci overrides ACPI IVRS,
+		 * they should be always controlled by iommu.
+		 */
+		set_iommu_for_device(iommu, early_ioapic_map[i].devid);
 	}
 
 	for (i = 0; i < early_hpet_map_size; ++i) {
@@ -767,6 +772,11 @@ static int __init add_early_maps(void)
 					 early_hpet_map[i].cmd_line);
 		if (ret)
 			return ret;
+		/*
+		 * early mapped hpet overrides ACPI IVRS,
+		 * they should be always controlled by iommu.
+		 */
+		set_iommu_for_device(iommu, early_hpet_map[i].devid);
 	}
 
 	return 0;
@@ -811,7 +821,7 @@ static int __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	int ret;
 
 
-	ret = add_early_maps();
+	ret = add_early_maps(iommu);
 	if (ret)
 		return ret;
 
-- 
1.8.2.1

