Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaLZV1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 16:27:25 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54585 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLZV1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 16:27:23 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hans de Goede <hdegoede@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH] nouveau: fix ambiguous backlight controls
Date: Fri, 26 Dec 2014 13:26:27 -0800
Message-Id: <1419629187-13916-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a display supports backlight control using the nouveau driver, and
also supports standard ACPI backlight control, there will be two sets of
controls.

/sys/class/backlight/acpi_video0
/sys/class/backlight/nv_backlight

This creates ambiguity because these controls can be out of sync with
each other.  One could be at 100% while the other is at 0% and the
actual display brightness depends on which one was used last.  This also
creates anomalies in Powertop which will show two values for brightness
with potentially different values.

Fix this ambiguity by having the nouveau driver only enable its
backlight controls if the standard ACPI controls are not present.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_backlight.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index e566c5b..3a52bd4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -221,6 +221,11 @@ nouveau_backlight_init(struct drm_device *dev)
 	struct nvif_device *device = &drm->device;
 	struct drm_connector *connector;
 
+	if (acpi_video_backlight_support()) {
+		dev_info(dev->dev, "Standard ACPI backlight control supported, disabling local control.\n");
+		return 0;
+	}
+
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		if (connector->connector_type != DRM_MODE_CONNECTOR_LVDS &&
 		    connector->connector_type != DRM_MODE_CONNECTOR_eDP)
-- 
2.1.4

