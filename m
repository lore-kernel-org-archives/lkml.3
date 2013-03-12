Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab3CLPch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:32:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab3CLPce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:32:34 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Revert "drm/i915: try to train DP even harder"
Date: Tue, 12 Mar 2013 16:32:27 +0100
Message-Id: <1363102348-16337-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363102348-16337-1-git-send-email-tiwai@suse.de>
References: <1363102348-16337-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 0d71068835e2610576d369d6d4cbf90e0f802a71.

Not only that the commit introduces a bogus check (voltage_tries == 5
will never meet at the inserted code path), it may bring the driver into
an endless DP-link-train loop (and actually it does on HP Z1 with eDP).

We can add a better check for the intended purpose of that commit, but
let's revert the wrong "fix" at first.

Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/gpu/drm/i915/intel_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index f61cb79..7d250aa 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1929,7 +1929,7 @@ intel_dp_start_link_train(struct intel_dp *intel_dp)
 		for (i = 0; i < intel_dp->lane_count; i++)
 			if ((intel_dp->train_set[i] & DP_TRAIN_MAX_SWING_REACHED) == 0)
 				break;
-		if (i == intel_dp->lane_count && voltage_tries == 5) {
+		if (i == intel_dp->lane_count) {
 			++loop_tries;
 			if (loop_tries == 5) {
 				DRM_DEBUG_KMS("too many full retries, give up\n");
-- 
1.8.1.4

