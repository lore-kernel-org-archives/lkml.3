Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbaGHA67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:58:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbaGGXyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>, Ben Widawsky <ben@bwidawsk.net>,
        "Yang, Guang A" <guang.a.yang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.15 039/122] drm/i915/bdw: Only use 2g GGTT for 32b platforms
Date: Mon,  7 Jul 2014 16:56:41 -0700
Message-Id: <20140707235735.419859534@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <benjamin.widawsky@intel.com>

commit 562d55d991b39ce376c492df2f7890fd6a541ffc upstream.

Daniel requested in the bug that I use a 3GB fallback size. Since this
is not in the spec as a valid size, I decided against it. We could
potentially add a patch to bump it to 3GB on top of this one.

This probably should be CC: stable - but I'll let the powers that be
decide that one.

Regression from a revert of the revert:
commit 7907f45bf9f67a1c5e5d4ae05bab428d7c2f43b2
Author: Ben Widawsky <benjamin.widawsky@intel.com>
Date:   Wed Feb 19 22:05:46 2014 -0800

    Revert "drm/i915/bdw: Limit GTT to 2GB"

v2: Change ifdef to 32b, instead of ifndef
update comment

v3. Update comment to not wrap (Daniel).
Update commit message

v4: s/CONFIG_32/CONFIG_X86_32 (Jani).

v5: s/CONFIG_x86_32BIT/CONFIG_x86_32, as meant in v4
s/32B/32b (chris)

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=76619
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Tested-by: "Yang, Guang A" <guang.a.yang@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_gtt.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -1811,6 +1811,13 @@ static inline unsigned int gen8_get_tota
 	bdw_gmch_ctl &= BDW_GMCH_GGMS_MASK;
 	if (bdw_gmch_ctl)
 		bdw_gmch_ctl = 1 << bdw_gmch_ctl;
+
+#ifdef CONFIG_X86_32
+	/* Limit 32b platforms to a 2GB GGTT: 4 << 20 / pte size * PAGE_SIZE */
+	if (bdw_gmch_ctl > 4)
+		bdw_gmch_ctl = 4;
+#endif
+
 	return bdw_gmch_ctl << 20;
 }
 


