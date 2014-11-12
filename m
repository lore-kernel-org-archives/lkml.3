Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbaKLB2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:28:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbaKLB2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:28:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "U. Artie Eoff" <ullysses.a.eoff@intel.com>,
        Joe Konno <joe.konno@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.17 167/319] drm/i915: intel_backlight scale() math WA
Date: Wed, 12 Nov 2014 10:15:05 +0900
Message-Id: <20141112011020.323435473@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "U. Artie Eoff" <ullysses.a.eoff@intel.com>

commit 673e7bbdb3920b62cfc6c710bea626b0a9b0f43a upstream.

Improper truncated integer division in the scale() function causes
actual_brightness != brightness. This (partial) work-around should be
sufficient for a majority of use-cases, but it is by no means a complete
solution.

TODO: Determine how best to scale "user" values to "hw" values, and
vice-versa, when the ranges are of different sizes. That would be a
buggy scenario even with this work-around.

The issue was introduced in the following (v3.17-rc1) commit:

    6dda730 drm/i915: respect the VBT minimum backlight brightness

Note that for easier backporting this commit adds a duplicated macro.
A follow-up cleanup patch rectifies this for 3.18+

v2: (thanks to Chris Wilson) clarify commit message, use rounded division
macro

v3: -DIV_ROUND_CLOSEST() fails to build with CONFIG_X86_32=y. (Jani)
    -Use DIV_ROUND_CLOSEST_ULL() instead. (Damien)
    -v1 and v2 originally authored by Joe Konno.

Signed-off-by: U. Artie Eoff <ullysses.a.eoff@intel.com>
Reviewed-By: Joe Konno <joe.konno@intel.com>
[danvet: Add backporting note.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_panel.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -398,6 +398,9 @@ intel_panel_detect(struct drm_device *de
 	}
 }
 
+#define DIV_ROUND_CLOSEST_ULL(ll, d)	\
+({ unsigned long long _tmp = (ll)+(d)/2; do_div(_tmp, d); _tmp; })
+
 /**
  * scale - scale values from one range to another
  *
@@ -419,9 +422,8 @@ static uint32_t scale(uint32_t source_va
 	source_val = clamp(source_val, source_min, source_max);
 
 	/* avoid overflows */
-	target_val = (uint64_t)(source_val - source_min) *
-		(target_max - target_min);
-	do_div(target_val, source_max - source_min);
+	target_val = DIV_ROUND_CLOSEST_ULL((uint64_t)(source_val - source_min) *
+			(target_max - target_min), source_max - source_min);
 	target_val += target_min;
 
 	return target_val;


