Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab3EIWe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:34:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435Ab3EIWex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:34:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?David=20M=C3=BCller?= <d.mueller@elsoft.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 13/26] drm/i915: Fall back to bit banging mode for DVO transmitter detection
Date: Thu,  9 May 2013 15:34:27 -0700
Message-Id: <20130509223423.820785089@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509223422.368544659@linuxfoundation.org>
References: <20130509223422.368544659@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Müller <d.mueller@elsoft.ch>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dvo.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -370,6 +370,7 @@ void intel_dvo_init(struct drm_device *d
 		const struct intel_dvo_device *dvo = &intel_dvo_devices[i];
 		struct i2c_adapter *i2c;
 		int gpio;
+		bool dvoinit;
 
 		/* Allow the I2C driver info to specify the GPIO to be used in
 		 * special cases, but otherwise default to what's defined
@@ -389,7 +390,17 @@ void intel_dvo_init(struct drm_device *d
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


