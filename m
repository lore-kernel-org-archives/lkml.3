Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3CZV03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:26:29 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51420 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3CZV00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:26:26 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: airlied@gmail.com
Cc: alexander.deucher@amd.com, skeggsb@gmail.com, linux-kernel@vger.kernel.org,
        seth.forshee@canonical.com, bhelgaas@google.com, grawity@gmail.com,
        torvalds@linux-foundation.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 3/3] radeon: Attempt to use platform-provided ROM image
Date: Tue, 26 Mar 2013 17:25:56 -0400
Message-Id: <1364333156-4530-3-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
References: <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
 <1364333156-4530-1-git-send-email-matthew.garrett@nebula.com>
X-cavan-blacklisted-at: zen.spamhaus.org
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 208.54.36.151
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms only provide their PCI ROM via a platform-specific interface.
Fall back to attempting that if all other sources fail.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/gpu/drm/radeon/radeon_bios.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index b801591..fa3c56f 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -99,6 +99,29 @@ static bool radeon_read_bios(struct radeon_device *rdev)
 	return true;
 }
 
+static bool radeon_read_platform_bios(struct radeon_device *rdev)
+{
+	uint8_t __iomem *bios;
+	size_t size;
+
+	rdev->bios = NULL;
+
+	bios = pci_platform_rom(rdev->pdev, &size);
+	if (!bios) {
+		return false;
+	}
+
+	if (size == 0 || bios[0] != 0x55 || bios[1] != 0xaa) {
+		return false;
+	}
+	rdev->bios = kmemdup(bios, size, GFP_KERNEL);
+	if (rdev->bios == NULL) {
+		return false;
+	}
+
+	return true;
+}
+
 #ifdef CONFIG_ACPI
 /* ATRM is used to get the BIOS on the discrete cards in
  * dual-gpu systems.
@@ -620,6 +643,9 @@ bool radeon_get_bios(struct radeon_device *rdev)
 	if (r == false) {
 		r = radeon_read_disabled_bios(rdev);
 	}
+	if (r == false) {
+		r = radeon_read_platform_bios(rdev);
+	}
 	if (r == false || rdev->bios == NULL) {
 		DRM_ERROR("Unable to locate a BIOS ROM\n");
 		rdev->bios = NULL;
-- 
1.8.1.2

