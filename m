Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbaLEA4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 19:56:23 -0500
Received: from m12-13.163.com ([220.181.12.13]:58905 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbaLEA4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 19:56:22 -0500
X-Coremail-DSSMTP: 49.77.206.164
From: weiyj_lk@163.com
To: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] drm/i915: Fix missing unlock on error in i915_gem_init_hw()
Date: Fri,  5 Dec 2014 08:55:59 +0800
Message-Id: <1417740959-342-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DcCowACHOGSiAoFU82fFAA--.958S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4DKF1kZryUJw4DCrW7Arb_yoW3KFg_K3
	yjvrnrWr9rCF4q9Fy3uFs0vFyavF98ZF4rXr10qa4fJrnFyryDW3s3ur1UXr4xCFWkWF4k
	X3Z5ZFn0vrn7CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnov3UUUUUU==
X-Originating-IP: [49.77.206.164]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiJRZZ1k9pIRiCRgAAsn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function i915_gem_init_hw()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/i915/i915_gem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index d2ba315..3eeb2d0 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4879,8 +4879,10 @@ i915_gem_init_hw(struct drm_device *dev)
 	i915_gem_init_swizzling(dev);
 
 	ret = dev_priv->gt.init_rings(dev);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&dev->struct_mutex);
 		return ret;
+	}
 
 	for (i = 0; i < NUM_L3_SLICES(dev); i++)
 		i915_gem_l3_remap(&dev_priv->ring[RCS], i);

