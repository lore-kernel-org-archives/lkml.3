Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab3EIXGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:06:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab3EIW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xiong Zhang <xiong.y.zhang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 43/73] drm/i915: correct the calculation of first_pd_entry_in_global_pt
Date: Thu,  9 May 2013 15:25:33 -0700
Message-Id: <20130509222530.812551775@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Zhang, Xiong Y" <xiong.y.zhang@intel.com>

commit 43b27290dd42b40f3f23f49677a7faa5a4eb1eff upstream.

When ppgtt is enabled, dev_priv->gtt.total has excluded the gtt space
occupied by ppgtt table in i915_gem_init_global_gtt() function. So the
calculation of first_pd_entry_in_global_pt doesn't need to subtract
I915_PPGTT_PD_ENTRIES again. Or else PPGTT directory table will be
destroyed by global gtt allocation.

This regression has been introduced in

commit a54c0c279f3864171fe53c66e769d5a137c5c651
Author: Ben Widawsky <ben@bwidawsk.net>
Date:   Thu Jan 24 14:45:00 2013 -0800

    drm/i915: remove intel_gtt structure

The breakage is pretty subtile since the old gtt_total_entries
included the pde range, whereas the new on did not.

Signed-off-by: Xiong Zhang<xiong.y.zhang@intel.com>
[danvet: Add regression citation and cc: stable. Thanks to Chris for
correcting my wrong guess about which commit broke things.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_gtt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -182,8 +182,7 @@ static int gen6_ppgtt_init(struct i915_h
 	/* ppgtt PDEs reside in the global gtt pagetable, which has 512*1024
 	 * entries. For aliasing ppgtt support we just steal them at the end for
 	 * now. */
-	first_pd_entry_in_global_pt =
-		gtt_total_entries(dev_priv->gtt) - I915_PPGTT_PD_ENTRIES;
+       first_pd_entry_in_global_pt = gtt_total_entries(dev_priv->gtt);
 
 	ppgtt->num_pd_entries = I915_PPGTT_PD_ENTRIES;
 	ppgtt->clear_range = gen6_ppgtt_clear_range;


