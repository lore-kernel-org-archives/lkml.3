Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3JCEOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:14:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab3JCEOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:14:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Meelis Roos <mroos@ut.ee>, Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 42/52] drm/i915: preserve pipe A quirk in i9xx_set_pipeconf
Date: Wed,  2 Oct 2013 21:06:00 -0700
Message-Id: <20131003040525.114430880@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 67c72a12254101d4e8d9b9f3a02646ba0be84a2d upstream.

This regression has been introduced in

commit 9f11a9e4e50006b615ba94722dfc33ced89664cf
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Jun 13 00:54:58 2013 +0200

    drm/i915: set up PIPECONF explicitly for i9xx/vlv platforms

Ville brough up the idea that this is just the pipe A quirk gone
wrong.

Note that after resume the bios might or might not have enabled pipe A
already.  We have a bit of magic to make sure that on resume we set up
a decent mode for pipe A, but I fear if I just smash pipe A to always
on we'd enable it in a bogus state and hang the hw. Hence the
readback.

v2: Clarify the logic a bit as suggested by Chris. Also amend the
commit message to clarify why we don't unconditionally enable the
pipe.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=66462
References: https://lkml.org/lkml/2013/8/26/238
Cc: Meelis Roos <mroos@ut.ee>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
[danvet: Use |= instead of = as suggested by Chris.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4564,6 +4564,10 @@ static void i9xx_set_pipeconf(struct int
 
 	pipeconf = I915_READ(PIPECONF(intel_crtc->pipe));
 
+	if (dev_priv->quirks & QUIRK_PIPEA_FORCE &&
+	    I915_READ(PIPECONF(intel_crtc->pipe)) & PIPECONF_ENABLE)
+		pipeconf |= PIPECONF_ENABLE;
+
 	if (intel_crtc->pipe == 0 && INTEL_INFO(dev)->gen < 4) {
 		/* Enable pixel doubling when the dot clock is > 90% of the (display)
 		 * core speed.


