Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbbAYS6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:58:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbbAYSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        lu hua <huax.lu@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.18 040/183] drm/i915: Dont complain about stolen conflicts on gen3
Date: Sun, 25 Jan 2015 10:06:02 -0800
Message-Id: <20150125180811.919888352@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 0b6d24c01932db99fc95304235e751e7f7625c41 upstream.

Apparently stuff works that way on those machines.

I agree with Chris' concern that this is a bit risky but imo worth a
shot in -next just for fun. Afaics all these machines have the pci
resources allocated like that by the BIOS, so I suspect that it's all
ok.

This regression goes back to

commit eaba1b8f3379b5d100bd146b9a41d28348bdfd09
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Jul 4 12:28:35 2013 +0100

    drm/i915: Verify that our stolen memory doesn't conflict

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=76983
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=71031
Tested-by: lu hua <huax.lu@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: Paul Menzel <paulepanter@users.sourceforge.net>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_stolen.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -137,7 +137,11 @@ static unsigned long i915_stolen_to_phys
 		r = devm_request_mem_region(dev->dev, base + 1,
 					    dev_priv->gtt.stolen_size - 1,
 					    "Graphics Stolen Memory");
-		if (r == NULL) {
+		/*
+		 * GEN3 firmware likes to smash pci bridges into the stolen
+		 * range. Apparently this works.
+		 */
+		if (r == NULL && !IS_GEN3(dev)) {
 			DRM_ERROR("conflict detected with stolen region: [0x%08x - 0x%08x]\n",
 				  base, base + (uint32_t)dev_priv->gtt.stolen_size);
 			base = 0;


