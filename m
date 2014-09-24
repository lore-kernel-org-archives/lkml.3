Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaIXVCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:02:22 -0400
Received: from mail-bn1on0141.outbound.protection.outlook.com ([157.56.110.141]:27712
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750891AbaIXVCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:02:20 -0400
X-Greylist: delayed 924 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 17:02:19 EDT
X-WSS-ID: 0NCFB1U-08-8EU-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 03/23] drm/radeon: Report doorbell configuration to amdkfd
Date: Wed, 24 Sep 2014 23:45:17 +0300
Message-ID: <1411591537-31636-4-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(68736004)(47776003)(97736003)(76482002)(85852003)(81342003)(31966008)(21056001)(19580395003)(50466002)(64706001)(80022003)(104166001)(101416001)(62966002)(92566001)(74502003)(19580405001)(50986999)(107046002)(83322001)(46102003)(120916001)(92726001)(84676001)(74662003)(99396003)(77982003)(87286001)(89996001)(36756003)(50226001)(77096002)(44976005)(83072002)(86362001)(85306004)(229853001)(20776003)(81542003)(33646002)(4396001)(76176999)(90102001)(79102003)(87936001)(102836001)(95666004)(93916002)(77156001)(105586002)(48376002)(10300001)(88136002)(106466001)(129583001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Forefront-PRVS: 03449D5DD1
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
index bb75e57..67d249a 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -697,6 +697,10 @@ struct radeon_doorbell {
 
 int radeon_doorbell_get(struct radeon_device *rdev, u32 *page);
 void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell);
+void radeon_doorbell_get_kfd_info(struct radeon_device *rdev,
+				  phys_addr_t *aperture_base,
+				  size_t *aperture_size,
+				  size_t *start_offset);
 
 /*
  * IRQS.
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index e84a76e..da3035f 100644
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

