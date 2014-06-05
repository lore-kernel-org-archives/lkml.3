Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaFEFE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:04:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaFEEU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>, airlied@gmail.com
Subject: [PATCH 3.4 051/214] drm/radeon: fix ATPX detection on non-VGA GPUs
Date: Wed,  4 Jun 2014 21:16:54 -0700
Message-Id: <20140605041646.306255603@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit e9a4099a59cc598a44006059dd775c25e422b772 upstream.

Some newer PX laptops have the pci device class
set to DISPLAY_OTHER rather than DISPLAY_VGA.  This
properly detects ATPX on those laptops.

Based on a patch from: Pali Rohár <pali.rohar@gmail.com>

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -202,6 +202,13 @@ static bool radeon_atpx_detect(void)
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
 		acpi_get_name(radeon_atpx_priv.atpx_handle, ACPI_FULL_PATHNAME, &buffer);
 		printk(KERN_INFO "VGA switcheroo: detected switching method %s handle\n",


