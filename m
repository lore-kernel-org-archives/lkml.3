Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030531Ab3HBKLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:11:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030385Ab3HBKLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Timo Aaltonen <tjaalton@ubuntu.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>, Egbert Eich <eich@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 78/99] drm/i915: Fix dereferencing invalid connectors in is_crtc_connector_off()
Date: Fri,  2 Aug 2013 18:08:31 +0800
Message-Id: <20130802100236.823464420@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 2e57f47d317dd035b18634b0c602272529368fcc upstream.

In commit e3de42b68478a8c95dd27520e9adead2af9477a5
Author: Imre Deak <imre.deak@intel.com>
Date:   Fri May 3 19:44:07 2013 +0200

    drm/i915: force full modeset if the connector is in DPMS OFF mode

a new function was added that walked over the set of connectors to see
if any of the currently associated CRTC was switched off. This function
walked an array of connectors, rather than the array of pointers to
connectors contained in the drm_mode_set - i.e. it was dereferencing far
past the end of the first connector. This only becomes an issue if we
attempt to use a clone mode (i.e. more than one connector per CRTC) such
that set->num_connectors > 1.

Reported-by: Timo Aaltonen <tjaalton@ubuntu.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=65927
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Egbert Eich <eich@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8146,15 +8146,20 @@ static void intel_set_config_restore_sta
 }
 
 static bool
-is_crtc_connector_off(struct drm_crtc *crtc, struct drm_connector *connectors,
-		      int num_connectors)
+is_crtc_connector_off(struct drm_mode_set *set)
 {
 	int i;
 
-	for (i = 0; i < num_connectors; i++)
-		if (connectors[i].encoder &&
-		    connectors[i].encoder->crtc == crtc &&
-		    connectors[i].dpms != DRM_MODE_DPMS_ON)
+	if (set->num_connectors == 0)
+		return false;
+
+	if (WARN_ON(set->connectors == NULL))
+		return false;
+
+	for (i = 0; i < set->num_connectors; i++)
+		if (set->connectors[i]->encoder &&
+		    set->connectors[i]->encoder->crtc == set->crtc &&
+		    set->connectors[i]->dpms != DRM_MODE_DPMS_ON)
 			return true;
 
 	return false;
@@ -8167,10 +8172,8 @@ intel_set_config_compute_mode_changes(st
 
 	/* We should be able to check here if the fb has the same properties
 	 * and then just flip_or_move it */
-	if (set->connectors != NULL &&
-	    is_crtc_connector_off(set->crtc, *set->connectors,
-				  set->num_connectors)) {
-			config->mode_changed = true;
+	if (is_crtc_connector_off(set)) {
+		config->mode_changed = true;
 	} else if (set->crtc->fb != set->fb) {
 		/* If we have no fb then treat it as a full mode set */
 		if (set->crtc->fb == NULL) {


