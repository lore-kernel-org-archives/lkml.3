Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbaAFX7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:59:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbaAFWjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paulo Zanoni <paulo.r.zanoni@intel.com>, Dave Jones <davej@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.12 075/144] drm/i915: change CRTC assertion on LCPLL disable
Date: Mon,  6 Jan 2014 14:37:16 -0800
Message-Id: <20140106223747.502673660@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit 96b4026878d9dac71bd4c3d6e05c7fbb16a3e0aa upstream.

Currently, PC8 is enabled at modeset_global_resources, which is called
after intel_modeset_update_state. Due to this, there's a small race
condition on the case where we start enabling PC8, then do a modeset
while PC8 is still being enabled. The racing condition triggers a WARN
because intel_modeset_update_state will mark the CRTC as enabled, then
the thread that's still enabling PC8 might look at the data structure
and think that PC8 is being enabled while a pipe is enabled. Despite
the WARN, this is not really a bug since we'll wait for the
PC8-enabling thread to finish when we call modeset_global_resources.

The spec says the CRTC cannot be enabled when we disable LCPLL, so we
had a check for crtc->base.enabled. If we change to crtc->active we
will still prevent disabling LCPLL while the CRTC is enabled, and we
will also prevent the WARN above.

This is a replacement for the previous patch named
    "drm/i915: get/put PC8 when we get/put a CRTC"

Testcase: igt/pm_pc8/modeset-lpsp-stress-no-wait
Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
(cherry picked from commit 798183c54799fbe1e5a5bfabb3a8c0505ffd2149
from -next due to Dave's report.)
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6009,7 +6009,7 @@ static void assert_can_disable_lcpll(str
 	uint32_t val;
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, base.head)
-		WARN(crtc->base.enabled, "CRTC for pipe %c enabled\n",
+		WARN(crtc->active, "CRTC for pipe %c enabled\n",
 		     pipe_name(crtc->pipe));
 
 	WARN(I915_READ(HSW_PWR_WELL_DRIVER), "Power well on\n");


