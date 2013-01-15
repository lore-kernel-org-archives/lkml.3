Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700Ab3AOWwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:52:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:46855 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3AOWwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Julien Cristau <jcristau@debian.org>
Subject: [ 129/171] drm/i915: call drm_handle_vblank before finish_page_flip
Date: Tue, 15 Jan 2013 14:44:54 -0800
Message-Id: <20130115224322.646359554@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 74d44445afb9f50126eba052adeb89827cee88f3 upstream.

... since finish_page_flip needs the vblank timestamp generated
in drm_handle_vblank. Somehow all the gmch platforms get it right,
but all the pch platform irq handlers get is wrong. Hooray for copy&
pasting!

Currently this gets papered over by a gross hack in finish_page_flip.
A second patch will remove that.

Note that without this, the new timestamp sanity checks in flip_test
occasionally get tripped up, hence the cc: stable tag.

Reviewed-by: mario.kleiner@tuebingen.mpg.de
Tested-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: no loop over pipes in ivybridge_irq_handler(),
 so make a similar change to that in ironlake_irq_handler()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Julien Cristau <jcristau@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_irq.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -530,6 +530,12 @@ static irqreturn_t ivybridge_irq_handler
 	if (de_iir & DE_GSE_IVB)
 		intel_opregion_gse_intr(dev);
 
+	if (de_iir & DE_PIPEA_VBLANK_IVB)
+		drm_handle_vblank(dev, 0);
+
+	if (de_iir & DE_PIPEB_VBLANK_IVB)
+		drm_handle_vblank(dev, 1);
+
 	if (de_iir & DE_PLANEA_FLIP_DONE_IVB) {
 		intel_prepare_page_flip(dev, 0);
 		intel_finish_page_flip_plane(dev, 0);
@@ -540,12 +546,6 @@ static irqreturn_t ivybridge_irq_handler
 		intel_finish_page_flip_plane(dev, 1);
 	}
 
-	if (de_iir & DE_PIPEA_VBLANK_IVB)
-		drm_handle_vblank(dev, 0);
-
-	if (de_iir & DE_PIPEB_VBLANK_IVB)
-		drm_handle_vblank(dev, 1);
-
 	/* check event from PCH */
 	if (de_iir & DE_PCH_EVENT_IVB) {
 		if (pch_iir & SDE_HOTPLUG_MASK_CPT)
@@ -622,6 +622,12 @@ static irqreturn_t ironlake_irq_handler(
 	if (de_iir & DE_GSE)
 		intel_opregion_gse_intr(dev);
 
+	if (de_iir & DE_PIPEA_VBLANK)
+		drm_handle_vblank(dev, 0);
+
+	if (de_iir & DE_PIPEB_VBLANK)
+		drm_handle_vblank(dev, 1);
+
 	if (de_iir & DE_PLANEA_FLIP_DONE) {
 		intel_prepare_page_flip(dev, 0);
 		intel_finish_page_flip_plane(dev, 0);
@@ -632,12 +638,6 @@ static irqreturn_t ironlake_irq_handler(
 		intel_finish_page_flip_plane(dev, 1);
 	}
 
-	if (de_iir & DE_PIPEA_VBLANK)
-		drm_handle_vblank(dev, 0);
-
-	if (de_iir & DE_PIPEB_VBLANK)
-		drm_handle_vblank(dev, 1);
-
 	/* check event from PCH */
 	if (de_iir & DE_PCH_EVENT) {
 		if (pch_iir & hotplug_mask)


