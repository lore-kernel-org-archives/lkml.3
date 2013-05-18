Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab3ERDO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:14:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab3ERDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:14 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=vsAY3MO6lyMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mZ1LCQoEiewA:10 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=QXbzxznKplSgLJnbAhQA:9 a=VRge421-rs0A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021700.121002596@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?David=20M=C3=BCller?= <d.mueller@elsoft.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 115/136 ] drm/i915: Fall back to bit banging mode for DVO transmitter
 detection
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0115-drm-i915-Fall-back-to-bit-banging-mode-for-DVO-trans.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?"David=20M=C3=BCller=20(ELSOFT=20AG)"?= <d.mueller@elsoft.ch>

[ Upstream commit e4bfff54ed3f5de88f5358504c78c2cb037813aa ]

As discussed in this thread
http://lists.freedesktop.org/archives/dri-devel/2013-April/037411.html
GMBUS based DVO transmitter detection seems to be unreliable which could
result in an unusable DVO port.

The attached patch fixes this by falling back to bit banging mode for
the time DVO transmitter detection is in progress.

Signed-off-by: David Müller <d.mueller@elsoft.ch>
Tested-by: David Müller <d.mueller@elsoft.ch>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/intel_dvo.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index 36c542e..5f1d7ef 100644
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
1.7.10.4


