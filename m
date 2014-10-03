Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbaJDAzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:55:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaJCVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shobhit Kumar <shobhit.kumar@intel.com>,
        Rafael Barbalho <rafael.barbalho@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.16 024/357] drm/i915: Fix crash when failing to parse MIPI VBT
Date: Fri,  3 Oct 2014 14:26:50 -0700
Message-Id: <20141003212934.189784276@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael Barbalho <rafael.barbalho@intel.com>

commit ed3b6679936801fa2dab47e7a6ef74e383400ed9 upstream.

This particular nasty presented itself while trying to register the
intelfb device (intel_fbdev.c). During the process of registering the device
the driver will disable the crtc via i9xx_crtc_disable. These will
also disable the panel using the generic mipi panel functions in
dsi_mod_vbt_generic.c. The stale MIPI generic data sequence pointers would
cause a crash within those functions. However, all of this is happening
while console_lock is held from do_register_framebuffer inside fbcon.c. Which
means that you got kernel log and just the device appearing to reboot/hang for
no apparent reason.

The fault started from the FB_EVENT_FB_REGISTERED event using the
fb_notifier_call_chain call in fbcon.c.

This regression has been introduced in

commit d3b542fcfc72d7724585e3fd2c5e75351bc3df47
Author: Shobhit Kumar <shobhit.kumar@intel.com>
Date:   Mon Apr 14 11:00:34 2014 +0530

    drm/i915: Add parsing support for new MIPI blocks in VBT

Cc: Shobhit Kumar <shobhit.kumar@intel.com>
Signed-off-by: Rafael Barbalho <rafael.barbalho@intel.com>
Reviewed-by: Shobhit Kumar <shobhit.kumar@intel.com>
[danvet: Add regression citation.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_bios.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -877,7 +877,7 @@ err:
 
 	/* error during parsing so set all pointers to null
 	 * because of partial parsing */
-	memset(dev_priv->vbt.dsi.sequence, 0, MIPI_SEQ_MAX);
+	memset(dev_priv->vbt.dsi.sequence, 0, sizeof(dev_priv->vbt.dsi.sequence));
 }
 
 static void parse_ddi_port(struct drm_i915_private *dev_priv, enum port port,


