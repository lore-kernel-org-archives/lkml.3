Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaKVTnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 14:43:50 -0500
Received: from mail0.toppoint.de ([217.70.197.20]:43083 "EHLO
	mail0.toppoint.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaKVTns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 14:43:48 -0500
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Nov 2014 14:43:48 EST
Date: Sat, 22 Nov 2014 19:30:26 +0000
From: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH] radeon: acquire BIOS via firmware subsystem if everything
 else failed
Message-ID: <20141122193025.GA5782@kaos.lebenslange-mailadresse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@linux.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least Apple's MacBook Pro 8,2 booting EFI -> GRUB2 -> Linux (without
BIOS emulation) seems to have no Radeon BIOS accessible via conventional
means. Loading one via firmware system previously dumped (with
"dd if=/dev/mem of=/lib/firmware/radeon/vbios.bin bs=65536 skip=12 count=1")
when booted with BIOS emulation works. I carry this patch around since
about 3.8 and never had any problems, not even with several dozen cycles
of suspend2ram and resume. Also, I tested every new release if this patch
was still necessary, and it always was.

Thanks to Stefan Dösinger and others at 
https://www.libreoffice.org/bugzilla/show_bug.cgi?id=26891

Signed-off-by: Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>

---

Note: I'm not subscribed to dri-devel@lists.freedesktop.org, please cc:
me if replying there.

diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 63ccb8f..cf55e0e 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -29,6 +29,7 @@
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "atom.h"
+#include <linux/firmware.h>
 
 #include <linux/vga_switcheroo.h>
 #include <linux/slab.h>
@@ -74,6 +75,44 @@ static bool igp_read_bios_from_vram(struct radeon_device *rdev)
 	return true;
 }
 
+static bool radeon_read_bios_from_firmware(struct radeon_device *rdev)
+{
+	const uint8_t __iomem *bios;
+	resource_size_t size;
+	const struct firmware *fw = NULL;
+	char *err = NULL;
+
+	request_firmware(&fw, "radeon/vbios.bin", rdev->dev);
+	if (!fw) {
+		err = "firmware request returned NULL\n";
+		goto out;
+	}
+	size = fw->size;
+	bios = fw->data;
+
+	if (size == 0 || !bios) {
+		err = "firmware request returned zero sized or NULL data\n";
+		goto out;
+	}
+
+	if (bios[0] != 0x55 || bios[1] != 0xaa) {
+		err = "wrong signature on firmware\n";
+		goto out;
+	}
+	rdev->bios = kmalloc(size, GFP_KERNEL);
+	if (rdev->bios == NULL) {
+		err = "failed to kmalloc() memory for firmware\n";
+		goto out;
+	}
+	memcpy(rdev->bios, bios, size);
+out:
+	if (err)
+		DRM_ERROR(err);
+	if (fw)
+		release_firmware(fw);
+	return !err;
+}
+
 static bool radeon_read_bios(struct radeon_device *rdev)
 {
 	uint8_t __iomem *bios;
@@ -662,6 +701,8 @@ bool radeon_get_bios(struct radeon_device *rdev)
 		r = radeon_read_disabled_bios(rdev);
 	if (r == false)
 		r = radeon_read_platform_bios(rdev);
+	if (r == false)
+		r = radeon_read_bios_from_firmware(rdev);
 	if (r == false || rdev->bios == NULL) {
 		DRM_ERROR("Unable to locate a BIOS ROM\n");
 		rdev->bios = NULL;

