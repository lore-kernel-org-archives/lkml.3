Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaKHSjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:39:10 -0500
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:56060
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753914AbaKHSjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:39:08 -0500
X-WSS-ID: 0NEQH4Z-08-GCB-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v5 03/24] drm/radeon: Report doorbell configuration to amdkfd
Date: Sat, 8 Nov 2014 20:37:24 +0200
Message-ID: <1415471865-1893-4-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(76176999)(48376002)(19580405001)(4396001)(101416001)(64706001)(31966008)(107046002)(53416004)(86362001)(105586002)(62966003)(92726001)(120916001)(95666004)(50466002)(47776003)(46102003)(50226001)(99396003)(68736004)(19580395003)(20776003)(84676001)(21056001)(102836001)(44976005)(93916002)(33646002)(104166001)(97736003)(229853001)(89996001)(87286001)(106466001)(77096003)(77156002)(50986999)(36756003)(88136002)(92566001)(87936001)(129583001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radeon and amdkfd share the doorbell aperture.
radeon sets it up, takes the doorbells required for its own rings
and reports the setup to amdkfd.
radeon reserved doorbells are at the start of the doorbell aperture.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon.h        |  4 ++++
 drivers/gpu/drm/radeon/radeon_device.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 1805067..1eef22a 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -712,6 +712,10 @@ struct radeon_doorbell {
 
 int radeon_doorbell_get(struct radeon_device *rdev, u32 *page);
 void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell);
+void radeon_doorbell_get_kfd_info(struct radeon_device *rdev,
+				  phys_addr_t *aperture_base,
+				  size_t *aperture_size,
+				  size_t *start_offset);
 
 /*
  * IRQS.
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index ea26769..0b41f5e 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -377,6 +377,37 @@ void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell)
 		__clear_bit(doorbell, rdev->doorbell.used);
 }
 
+/**
+ * radeon_doorbell_get_kfd_info - Report doorbell configuration required to
+ *                                setup KFD
+ *
+ * @rdev: radeon_device pointer
+ * @aperture_base: output returning doorbell aperture base physical address
+ * @aperture_size: output returning doorbell aperture size in bytes
+ * @start_offset: output returning # of doorbell bytes reserved for radeon.
+ *
+ * Radeon and the KFD share the doorbell aperture. Radeon sets it up,
+ * takes doorbells required for its own rings and reports the setup to KFD.
+ * Radeon reserved doorbells are at the start of the doorbell aperture.
+ */
+void radeon_doorbell_get_kfd_info(struct radeon_device *rdev,
+				  phys_addr_t *aperture_base,
+				  size_t *aperture_size,
+				  size_t *start_offset)
+{
+	/* The first num_doorbells are used by radeon.
+	 * KFD takes whatever's left in the aperture. */
+	if (rdev->doorbell.size > rdev->doorbell.num_doorbells * sizeof(u32)) {
+		*aperture_base = rdev->doorbell.base;
+		*aperture_size = rdev->doorbell.size;
+		*start_offset = rdev->doorbell.num_doorbells * sizeof(u32);
+	} else {
+		*aperture_base = 0;
+		*aperture_size = 0;
+		*start_offset = 0;
+	}
+}
+
 /*
  * radeon_wb_*()
  * Writeback is the the method by which the the GPU updates special pages
-- 
2.1.0

