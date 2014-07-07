Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaGHA1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:27:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbaGGXyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.14 85/94] drm/i915: fix display power sw state reporting
Date: Mon,  7 Jul 2014 16:58:15 -0700
Message-Id: <20140707235759.277075415@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit b8c000d9bf23e7c1155ef421f595d1cbc25262da upstream.

Atm, we refcount both power domains and power wells and
intel_display_power_enabled_sw() returns the power domain refcount. What
the callers are really interested in though is the sw state of the
underlying power wells. Due to this we will report incorrectly that a
given power domain is off if its power wells were enabled via another
power domain, for example POWER_DOMAIN_INIT which enables all power
wells.

As a fix return instead the state based on the refcount of all power
wells included in the passed in power domain.

References: https://bugs.freedesktop.org/show_bug.cgi?id=79505
References: https://bugs.freedesktop.org/show_bug.cgi?id=79038
Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_pm.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5138,10 +5138,25 @@ bool intel_display_power_enabled_sw(stru
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct i915_power_domains *power_domains;
+	struct i915_power_well *power_well;
+	bool is_enabled;
+	int i;
+
+	if (dev_priv->pm.suspended)
+		return false;
 
 	power_domains = &dev_priv->power_domains;
+	is_enabled = true;
+	for_each_power_well_rev(i, power_well, BIT(domain), power_domains) {
+		if (power_well->always_on)
+			continue;
 
-	return power_domains->domain_use_count[domain];
+		if (!power_well->count) {
+			is_enabled = false;
+			break;
+		}
+	}
+	return is_enabled;
 }
 
 bool intel_display_power_enabled(struct drm_device *dev,


