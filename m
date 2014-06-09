Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaFIJJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:09:10 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58469 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754920AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>, airlied@gmail.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 046/146] drm/radeon: fix ATPX detection on non-VGA GPUs
Date: Mon,  9 Jun 2014 10:49:41 +0200
Message-Id: <1dadef4ce20d6f16ebd1003f9d903a4028861a3b.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e9a4099a59cc598a44006059dd775c25e422b772 upstream.

Some newer PX laptops have the pci device class
set to DISPLAY_OTHER rather than DISPLAY_VGA.  This
properly detects ATPX on those laptops.

Based on a patch from: Pali Rohár <pali.rohar@gmail.com>

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: airlied@gmail.com
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_atpx_handler.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
index b8db0d7b5089..7c6e3fd70e65 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -525,6 +525,13 @@ static bool radeon_atpx_detect(void)
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
1.9.3

