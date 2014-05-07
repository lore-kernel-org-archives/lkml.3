Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaEGGGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:06:10 -0400
Received: from hgpmta02.sony.com.cn ([114.141.162.247]:42722 "EHLO
	hgpmta02.sony.com.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbaEGGEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:04:47 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2014 02:04:46 EDT
From: "Su, Friendy" <Friendy.Su@sony.com.cn>
To: "joro@8bytes.org" <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 7 May 2014 13:54:52 +0800
Subject: [PATCH v1 1/1] iommu/amd: fix enabling exclusion range for an exact
 device
Thread-Topic: [PATCH v1 1/1] iommu/amd: fix enabling exclusion range for an
 exact device
Thread-Index: AQHPabjdSJGpMQvTiE6Rzl1Anarhvw==
Message-ID: <053191AD6E9023439BF3970DE87005185086D31DA3@APSHAXMS02.ap.sony.com>
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

set_device_exclusion_range(u16 devid, struct ivmd_header *m) enables
exclusion range for ONE device. IOMMU does not translate the access
to the exclusion range from the device.

The device is specified by input argument 'devid'. But 'devid' is not
passed to the actual set function set_dev_entry_bit(), instead
'm->devid' is passed. 'm->devid' does not specify the exact device
which needs enable the exclusion range. 'm->devid' represents DeviceID
field of IVMD, which has different meaning depends on IVMD type.

The caller init_exclusion_range() sets 'devid' for ONE device. When
m->type is equal to ACPI_IVMD_TYPE_ALL or ACPI_IVMD_TYPE_RANGE,
'm->devid' is not equal to 'devid'.

This patch fixes 'm->devid' to 'devid'.

Signed-off-by: Su Friendy <friendy.su@sony.com.cn>
Signed-off-by: Tamori Masahiro <Masahiro.Tamori@jp.sony.com>
---
 drivers/iommu/amd_iommu_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index b76c58d..0e08545 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -788,7 +788,7 @@ static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
 		 * per device. But we can enable the exclusion range per
 		 * device. This is done here
 		 */
-		set_dev_entry_bit(m->devid, DEV_ENTRY_EX);
+		set_dev_entry_bit(devid, DEV_ENTRY_EX);
 		iommu->exclusion_start = m->range_start;
 		iommu->exclusion_length = m->range_length;
 	}
-- 
1.8.2.1

