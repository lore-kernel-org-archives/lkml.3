Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3EJOVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57227 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755586Ab3EJOVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "=?UTF-8?q?" David=20M=C3=BCller=20 (ELSOFT=20AG) "?=" 
	<d.mueller@elsoft.ch>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.58461170@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [043/118] drm/i915: Fall back to bit banging mode for DVO
 transmitter detection
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "David Müller (ELSOFT AG)" <d.mueller@elsoft.ch>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_dvo.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -371,6 +371,7 @@ void intel_dvo_init(struct drm_device *d
 		const struct intel_dvo_device *dvo = &intel_dvo_devices[i];
 		struct i2c_adapter *i2c;
 		int gpio;
+		bool dvoinit;
 
 		/* Allow the I2C driver info to specify the GPIO to be used in
 		 * special cases, but otherwise default to what's defined
@@ -390,7 +391,17 @@ void intel_dvo_init(struct drm_device *d
 		i2c = &dev_priv->gmbus[gpio].adapter;
 
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

