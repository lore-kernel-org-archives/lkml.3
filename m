Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbaHEPcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:32:11 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:53705
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751885AbaHEPcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:32:09 -0400
X-WSS-ID: 0N9UB57-08-R0O-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@linux.ie>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>, <Andrew.Lewycky@amd.com>,
        <deathsimple@vodafone.de>, <michel.daenzer@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v3 03/23] drm/radeon: Report doorbell configuration to amdkfd
Date: Tue, 5 Aug 2014 18:30:31 +0300
Message-ID: <1407252651-3539-4-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(428002)(199002)(189002)(19580395003)(83072002)(86362001)(104166001)(229853001)(81542001)(81342001)(87286001)(84676001)(44976005)(92726001)(97736001)(83322001)(68736004)(92566001)(93916002)(85852003)(85306004)(19580405001)(88136002)(87936001)(89996001)(106466001)(95666004)(99396002)(105586002)(76176999)(50986999)(20776003)(101416001)(102836001)(64706001)(62966002)(74662001)(74502001)(79102001)(50466002)(46102001)(107046002)(77156001)(4396001)(21056001)(50226001)(33646002)(77096002)(47776003)(77982001)(76482001)(36756003)(31966008)(80022001)(48376002)(129583001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB045;H:atltwp02.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=none (sender IP is 165.204.84.222)
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
index 511191f..75bcc04 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -691,6 +691,10 @@ struct radeon_doorbell {
 
 int radeon_doorbell_get(struct radeon_device *rdev, u32 *page);
 void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell);
+void radeon_doorbell_get_kfd_info(struct radeon_device *rdev,
+				  phys_addr_t *aperture_base,
+				  size_t *aperture_size,
+				  size_t *start_offset);
 
 /*
  * IRQS.
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index c58f84f..827bcd1 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -373,6 +373,37 @@ void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell)
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

