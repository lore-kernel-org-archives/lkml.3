Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbaGQNbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:31:40 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:54725
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932139AbaGQNbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:31:37 -0400
X-WSS-ID: 0N8UYWJ-07-BXG-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Oded Gabbay" <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 04/25] drm/radeon: Report doorbell configuration to amdkfd
Date: Thu, 17 Jul 2014 16:29:11 +0300
Message-ID: <1405603773-32688-5-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(44976005)(31966008)(85306003)(48376002)(64706001)(95666004)(81542001)(68736004)(77156001)(99396002)(47776003)(20776003)(92566001)(101416001)(77096002)(80022001)(36756003)(77982001)(50466002)(105586002)(4396001)(85852003)(92726001)(89996001)(74502001)(81342001)(76482001)(97736001)(19580395003)(74662001)(83322001)(19580405001)(104166001)(106466001)(87936001)(87286001)(229853001)(76176999)(21056001)(50986999)(83072002)(107046002)(50226001)(84676001)(33646002)(62966002)(46102001)(86362001)(102836001)(79102001)(93916002)(88136002)(129583001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radeon and amdkfd share the doorbell aperture.
radeon sets it up, takes the doorbells required for its own rings
and reports the setup to amdkfd.
radeon reserved doorbells are at the start of the doorbell aperture.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon.h        |  4 ++++
 drivers/gpu/drm/radeon/radeon_device.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 7cda75d..4e7e41f 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -676,6 +676,10 @@ struct radeon_doorbell {
 
 int radeon_doorbell_get(struct radeon_device *rdev, u32 *page);
 void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell);
+void radeon_doorbell_get_kfd_info(struct radeon_device *rdev,
+				  phys_addr_t *aperture_base,
+				  size_t *aperture_size,
+				  size_t *start_offset);
 
 /*
  * IRQS.
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 03686fa..98538d2 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -328,6 +328,37 @@ void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell)
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
1.9.1

