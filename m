Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3ETKw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:52:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55988 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab3ETKw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?David=20M=C3=BCller?= <d.mueller@elsoft.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 017/115] drm/i915: Fall back to bit banging mode for DVO transmitter detection
Date: Mon, 20 May 2013 11:50:17 +0100
Message-Id: <1369047116-9378-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?David=20M=C3=BCller=20=28ELSOFT=20AG=29?=

commit e4bfff54ed3f5de88f5358504c78c2cb037813aa upstream.

As discussed in this thread
http://lists.freedesktop.org/archives/dri-devel/2013-April/037411.html
GMBUS based DVO transmitter detection seems to be unreliable which could
result in an unusable DVO port.

The attached patch fixes this by falling back to bit banging mode for
the time DVO transmitter detection is in progress.

Signed-off-by: David Müller <d.mueller@elsoft.ch>
Tested-by: David Müller <d.mueller@elsoft.ch>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_dvo.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index 60ba50b9..35dc618 100644
--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -370,6 +370,7 @@ void intel_dvo_init(struct drm_device *dev)
 		const struct intel_dvo_device *dvo = &intel_dvo_devices[i];
 		struct i2c_adapter *i2c;
 		int gpio;
+		bool dvoinit;
 
 		/* Allow the I2C driver info to specify the GPIO to be used in
 		 * special cases, but otherwise default to what's defined
@@ -389,7 +390,17 @@ void intel_dvo_init(struct drm_device *dev)
 		i2c = intel_gmbus_get_adapter(dev_priv, gpio);
 
 		intel_dvo->dev = *dvo;
-		if (!dvo->dev_ops->init(&intel_dvo->dev, i2c))
+
+		/* GMBUS NAK handling seems to be unstable, hence let the
+		 * transmitter detection run in bit banging mode for now.
+		 */
+		intel_gmbus_force_bit(i2c, true);
+
+		dvoinit = dvo->dev_ops->init(&intel_dvo->dev, i2c);
+
+		intel_gmbus_force_bit(i2c, false);
+
+		if (!dvoinit)
 			continue;
 
 		intel_encoder->type = INTEL_OUTPUT_DVO;
-- 
1.8.1.2

