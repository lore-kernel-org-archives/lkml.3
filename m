Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbbALSuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:50:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbbALSaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Imre Deak <imre.deak@intel.com>, Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 164/216] drm/i915: vlv: fix IRQ masking when uninstalling interrupts
Date: Mon, 12 Jan 2015 18:29:02 +0000
Message-Id: <1421087394-2712-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit c352d1ba1e1e2c8a96af660944a58e86b12ac4af upstream.

irq_mask should include all IRQ bits that we want to mask, but atm we
set it incorrectly to the inverse of this. If the mask is used
subsequently to enable/disable some IRQ bits, we may unintentionally
unmask unrelated IRQs. I can't see any way that this can lead to a real
problem in the current -nightly code, since the first place the mask
will be used next (after a suspend/resume cycle) is in
valleyview_irq_postinstall(), but the mask is reset there to its proper
value.

This causes a problem in the upstream kernel though, where - due to another
issue - the mask is used in the above way to disable only the display IRQs.
This other issue is fixed by:

commit 950eabaf5a87257040e0c207be09487954113f54
Author: Imre Deak <imre.deak@intel.com>
Date:   Mon Sep 8 15:21:09 2014 +0300

    drm/i915: vlv: fix display IRQ enable/disable

Interestingly, even with the above two bugs, we shouldn't in theory have
any real problems (arguably a famous last sentence:). That's because
even if we unmask something unintentionally via the VLV_IMR/VLV_IER
register the master IRQ masking bit in VLV_MASTER_IER is still set and
should prevent all i915 interrupts. According to my testing on an ASUS
T100 with DSI output this isn't the case at least with the
MIPIA_INTERRUPT. Leaving this one unmasked in IMR/IER, while having
VLV_MASTER_IER set to 0 may lead to a lockup during system suspend as
shown in the bugzilla ticket below. This fix should get rid of the
problem reported there in upstream and older kernels.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=85920
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index c05c84f3f091..b54f8563ebbb 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -3591,7 +3591,7 @@ static void valleyview_irq_uninstall(struct drm_device *dev)
 		valleyview_display_irqs_uninstall(dev_priv);
 	spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
 
-	dev_priv->irq_mask = 0;
+	dev_priv->irq_mask = ~0;
 
 	I915_WRITE(VLV_IIR, 0xffffffff);
 	I915_WRITE(VLV_IMR, 0xffffffff);
-- 
2.1.4

