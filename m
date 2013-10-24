Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3JXHIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:08:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:8385 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab3JXHIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:08:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="379204374"
Subject: drm/i915: Avoid accessing the stolen address when it is unavailable
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: daniel.vetter@ffwll.ch, airlied@linux.ie
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
        fei.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Oct 2013 00:33:47 +0800
Message-ID: <1382632427.26153.94.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In our platform, we hit the the stolen region initialization failure case,
such as below log:
[drm:i915_stolen_to_physical] *ERROR* conflict detected with stolen region: [0x7b000000]

And it causes the dev_priv->mm.stolen_base is NULL, in this case, we should
avoid accessing it any more.

Here is possible call trace:
intel_enable_gt_powersave -- >
valleyview_enable_rps -- >
valleyview_setup_pctx

Cc: Li Fei <fei.li@intel.com>
Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/gpu/drm/i915/intel_pm.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 26c2ea3..1069b24 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3735,6 +3735,9 @@ static void valleyview_setup_pctx(struct drm_device *dev)
 	u32 pcbr;
 	int pctx_size = 24*1024;
 
+	if (!dev_priv->mm.stolen_base)
+		return;
+
 	pcbr = I915_READ(VLV_PCBR);
 	if (pcbr) {
 		/* BIOS set it up already, grab the pre-alloc'd space */
-- 
1.7.9.5



