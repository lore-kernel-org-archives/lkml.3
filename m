Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3FVPD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 11:03:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34455 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3FVPDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 11:03:23 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH RFC v3] media: OF: add video sync endpoint property
Date: Sat, 22 Jun 2013 20:33:03 +0530
Message-Id: <1371913383-25088-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch adds video sync properties as part of endpoint
properties and also support to parse them in the parser.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 This patch has 10 warnings for line over 80 characters
 for which I think can be ignored.
 
 RFC v2 https://patchwork.kernel.org/patch/2578091/
 RFC V1 https://patchwork.kernel.org/patch/2572341/
 Changes for v3:
 1: Fixed review comments pointed by Laurent and Sylwester.
 
 .../devicetree/bindings/media/video-interfaces.txt |    1 +
 drivers/media/v4l2-core/v4l2-of.c                  |   20 ++++++++++++++++++
 include/dt-bindings/media/video-interfaces.h       |   17 +++++++++++++++
 include/media/v4l2-mediabus.h                      |   22 +++++++++++---------
 4 files changed, 50 insertions(+), 10 deletions(-)
 create mode 100644 include/dt-bindings/media/video-interfaces.h

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index e022d2d..2081278 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -101,6 +101,7 @@ Optional endpoint properties
   array contains only one entry.
 - clock-noncontinuous: a boolean property to allow MIPI CSI-2 non-continuous
   clock mode.
+- video-sync: property indicating to sync the video on a signal in RGB.
 
 
 Example
diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index aa59639..1a54530 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -100,6 +100,26 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 	if (!of_property_read_u32(node, "data-shift", &v))
 		bus->data_shift = v;
 
+	if (!of_property_read_u32(node, "video-sync", &v)) {
+		switch (v) {
+		case V4L2_MBUS_VIDEO_SEPARATE_SYNC:
+			flags |= V4L2_MBUS_VIDEO_SEPARATE_SYNC;
+			break;
+		case V4L2_MBUS_VIDEO_COMPOSITE_SYNC:
+			flags |= V4L2_MBUS_VIDEO_COMPOSITE_SYNC;
+			break;
+		case V4L2_MBUS_VIDEO_SYNC_ON_COMPOSITE:
+			flags |= V4L2_MBUS_VIDEO_SYNC_ON_COMPOSITE;
+			break;
+		case V4L2_MBUS_VIDEO_SYNC_ON_GREEN:
+			flags |= V4L2_MBUS_VIDEO_SYNC_ON_GREEN;
+			break;
+		case V4L2_MBUS_VIDEO_SYNC_ON_LUMINANCE:
+			flags |= V4L2_MBUS_VIDEO_SYNC_ON_LUMINANCE;
+			break;
+		}
+	}
+
 	bus->flags = flags;
 
 }
diff --git a/include/dt-bindings/media/video-interfaces.h b/include/dt-bindings/media/video-interfaces.h
new file mode 100644
index 0000000..1a083dd
--- /dev/null
+++ b/include/dt-bindings/media/video-interfaces.h
@@ -0,0 +1,17 @@
+/*
+ * This header provides constants for video interface.
+ *
+ */
+
+#ifndef _DT_BINDINGS_VIDEO_INTERFACES_H
+#define _DT_BINDINGS_VIDEO_INTERFACES_H
+
+#define V4L2_MBUS_VIDEO_SEPARATE_SYNC		(1 << 2)
+#define V4L2_MBUS_VIDEO_COMPOSITE_SYNC		(1 << 3)
+#define V4L2_MBUS_VIDEO_SYNC_ON_COMPOSITE	(1 << 4)
+#define V4L2_MBUS_VIDEO_SYNC_ON_GREEN		(1 << 5)
+#define V4L2_MBUS_VIDEO_SYNC_ON_LUMINANCE	(1 << 6)
+
+#define V4L2_MBUS_VIDEO_INTERFACES_END		6
+
+#endif
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 83ae07e..a4676dd 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -11,6 +11,8 @@
 #ifndef V4L2_MEDIABUS_H
 #define V4L2_MEDIABUS_H
 
+#include <dt-bindings/media/video-interfaces.h>
+
 #include <linux/v4l2-mediabus.h>
 
 /* Parallel flags */
@@ -28,18 +30,18 @@
  * V4L2_MBUS_[HV]SYNC* flags should be also used for specifying
  * configuration of hardware that uses [HV]REF signals
  */
-#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
-#define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
-#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
-#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 5)
-#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 6)
-#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
-#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
-#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
+#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 1))
+#define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 2))
+#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 3))
+#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 4))
+#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 5))
+#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 6))
+#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 7))
+#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 8))
 /* FIELD = 0/1 - Field1 (odd)/Field2 (even) */
-#define V4L2_MBUS_FIELD_EVEN_HIGH		(1 << 10)
+#define V4L2_MBUS_FIELD_EVEN_HIGH		(1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 9))
 /* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
-#define V4L2_MBUS_FIELD_EVEN_LOW		(1 << 11)
+#define V4L2_MBUS_FIELD_EVEN_LOW		(1 << (V4L2_MBUS_VIDEO_INTERFACES_END + 10))
 
 /* Serial flags */
 /* How many lanes the client can use */
-- 
1.7.9.5

