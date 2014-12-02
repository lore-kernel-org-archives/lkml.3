Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaLBQN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:13:28 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35834 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbaLBQN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:13:27 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 11:13:26 EST
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Gordon <david.s.gordon@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH] drm/i915: compute wait_ioctl timeout correctly
Date: Tue,  2 Dec 2014 16:36:22 +0100
Message-Id: <1417534582-2977-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417533733-2289-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1417533733-2289-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've lost the +1 required for correct timeouts in

commit 5ed0bdf21a85d78e04f89f15ccf227562177cbd9
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Jul 16 21:05:06 2014 +0000

    drm: i915: Use nsec based interfaces

    Use ktime_get_raw_ns() and get rid of the back and forth timespec
    conversions.

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: John Stultz <john.stultz@linaro.org>

So fix this up by reinstating our handrolled _timeout function. While
at it bother with handling MAX_JIFFIES.

v2: Convert to usecs (we don't care about the accuracy anyway) first
to avoid overflow issues Dave Gordon spotted.

v3: Drop the explicit MAX_JIFFY_OFFSET check, usecs_to_jiffies should
take care of that already. It might be a bit too enthusiastic about it
though.

Cc: Dave Gordon <david.s.gordon@intel.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=82749
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
---
 drivers/gpu/drm/i915/i915_drv.h | 8 ++++++++
 drivers/gpu/drm/i915/i915_gem.c | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 049482f5d9ac..4ea14a8c31f7 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -3097,6 +3097,14 @@ static inline unsigned long msecs_to_jiffies_timeout(const unsigned int m)
 	return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);
 }
 
+static inline unsigned long nsecs_to_jiffies_timeout(const u64 m)
+{
+	u64 usecs = div_u64(m + 999, 1000);
+	unsigned long j = usecs_to_jiffies(usecs);
+
+	return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);
+}
+
 static inline unsigned long
 timespec_to_jiffies_timeout(const struct timespec *value)
 {
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 9d362d320d82..04a9f26407ae 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1226,7 +1226,8 @@ int __i915_wait_request(struct drm_i915_gem_request *req,
 	if (i915_gem_request_completed(req, true))
 		return 0;
 
-	timeout_expire = timeout ? jiffies + nsecs_to_jiffies((u64)*timeout) : 0;
+	timeout_expire = timeout ?
+		jiffies + nsecs_to_jiffies_timeout((u64)*timeout) : 0;
 
 	if (INTEL_INFO(dev)->gen >= 6 && ring->id == RCS && can_wait_boost(file_priv)) {
 		gen6_rps_boost(dev_priv);
-- 
1.9.3

