Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743AbaEGNb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:31:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45438 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912AbaEGNOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>, airlied@gmail.com,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 20/70] drm/radeon: fix ATPX detection on non-VGA GPUs
Date: Wed,  7 May 2014 14:12:23 +0100
Message-Id: <1399468393-10140-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit e9a4099a59cc598a44006059dd775c25e422b772 upstream.

Some newer PX laptops have the pci device class
set to DISPLAY_OTHER rather than DISPLAY_VGA.  This
properly detects ATPX on those laptops.

Based on a patch from: Pali Rohár <pali.rohar@gmail.com>

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: airlied@gmail.com
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atpx_handler.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
index cbb06d7..8c44ef5 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -523,6 +523,13 @@ static bool radeon_atpx_detect(void)
 		has_atpx |= (radeon_atpx_pci_probe_handle(pdev) == true);
 	}
 
+	/* some newer PX laptops mark the dGPU as a non-VGA display device */
+	while ((pdev = pci_get_class(PCI_CLASS_DISPLAY_OTHER << 8, pdev)) != NULL) {
+		vga_count++;
+
+		has_atpx |= (radeon_atpx_pci_probe_handle(pdev) == true);
+	}
+
 	if (has_atpx && vga_count == 2) {
 		acpi_get_name(radeon_atpx_priv.atpx.handle, ACPI_FULL_PATHNAME, &buffer);
 		printk(KERN_INFO "VGA switcheroo: detected switching method %s handle\n",
-- 
1.9.1

