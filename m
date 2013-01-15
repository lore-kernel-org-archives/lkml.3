Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779Ab3AOXaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:30:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:46762 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933495Ab3AOWwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Julien Cristau <jcristau@debian.org>
Subject: [ 122/171] drm/i915: add some barriers when changing DIPs
Date: Tue, 15 Jan 2013 14:44:47 -0800
Message-Id: <20130115224322.153468296@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit 9d9740f099f2eaf309c4c9cbc0d732507140db28 upstream.

On IVB and older, we basically have two registers: the control and the
data register. We write a few consecutitve times to the control
register, and we need these writes to arrive exactly in the specified
order.

Also, when we're changing the data register, we need to guarantee that
anything written to the control register already arrived (since
changing the control register can change where the data register
points to). Also, we need to make sure all the writes to the data
register happen exactly in the specified order, and we also *can't*
read the data register during this process, since reading and/or
writing it will change the place it points to.

So invoke the "better safe than sorry" rule and just be careful and
put barriers everywhere :)

On HSW we still have a control register that we write many times, but
we have many data registers.

Demanded-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2:
 - There are only two write_infoframe functions to be modified
 - The other VIDEO_DIP_CTL writes are in entirely different functions]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Julien Cristau <jcristau@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_hdmi.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -138,14 +138,17 @@ static void i9xx_write_infoframe(struct
 
 	I915_WRITE(VIDEO_DIP_CTL, VIDEO_DIP_ENABLE | val | port | flags);
 
+	mmiowb();
 	for (i = 0; i < len; i += 4) {
 		I915_WRITE(VIDEO_DIP_DATA, *data);
 		data++;
 	}
+	mmiowb();
 
 	flags |= intel_infoframe_flags(frame);
 
 	I915_WRITE(VIDEO_DIP_CTL, VIDEO_DIP_ENABLE | val | port | flags);
+	POSTING_READ(VIDEO_DIP_CTL);
 }
 
 static void ironlake_write_infoframe(struct drm_encoder *encoder,
@@ -168,14 +171,17 @@ static void ironlake_write_infoframe(str
 
 	I915_WRITE(reg, VIDEO_DIP_ENABLE | val | flags);
 
+	mmiowb();
 	for (i = 0; i < len; i += 4) {
 		I915_WRITE(TVIDEO_DIP_DATA(intel_crtc->pipe), *data);
 		data++;
 	}
+	mmiowb();
 
 	flags |= intel_infoframe_flags(frame);
 
 	I915_WRITE(reg, VIDEO_DIP_ENABLE | val | flags);
+	POSTING_READ(reg);
 }
 static void intel_set_infoframe(struct drm_encoder *encoder,
 				struct dip_infoframe *frame)
@@ -549,10 +555,13 @@ void intel_hdmi_init(struct drm_device *
 	if (!HAS_PCH_SPLIT(dev)) {
 		intel_hdmi->write_infoframe = i9xx_write_infoframe;
 		I915_WRITE(VIDEO_DIP_CTL, 0);
+		POSTING_READ(VIDEO_DIP_CTL);
 	} else {
 		intel_hdmi->write_infoframe = ironlake_write_infoframe;
-		for_each_pipe(i)
+		for_each_pipe(i) {
 			I915_WRITE(TVIDEO_DIP_CTL(i), 0);
+			POSTING_READ(TVIDEO_DIP_CTL(i));
+		}
 	}
 
 	drm_encoder_helper_add(&intel_encoder->base, &intel_hdmi_helper_funcs);


