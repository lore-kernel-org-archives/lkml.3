Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3FIXCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 19:02:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45792 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3FIXB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 19:01:59 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-acpi@vger.kernel.org
Cc: seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 3/3] i915: Don't provide ACPI backlight interface if firmware expects Windows 8
Date: Sun,  9 Jun 2013 19:01:39 -0400
Message-Id: <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows 8 leaves backlight control up to individual graphics drivers rather
than making ACPI calls itself. There's plenty of evidence to suggest that
the Intel driver for Windows doesn't use the ACPI interface, including the
fact that it's broken on a bunch of machines when the OS claims to support
Windows 8. The simplest thing to do appears to be to disable the ACPI
backlight interface on these systems.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 3b315ba..23b6292 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1661,6 +1661,9 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 		/* Must be done after probing outputs */
 		intel_opregion_init(dev);
 		acpi_video_register();
+		/* Don't use ACPI backlight functions on Windows 8 platforms */
+		if (acpi_osi_version() >= ACPI_OSI_WIN_8)
+			acpi_video_backlight_unregister();
 	}
 
 	if (IS_GEN5(dev))
-- 
1.8.2.1

