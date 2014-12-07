Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaLGV0s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 16:26:48 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:49873 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaLGV0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 16:26:47 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i915: Fix comparison bug
Date: Sun,  7 Dec 2014 22:26:27 +0100
Message-Id: <1417987587-7240-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->stolen->start has type unsigned long; relying on the difference
(effectively cast to int) for sorting is wrong.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/gpu/drm/i915/i915_debugfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 063b44817e08..adfb863bb580 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -236,7 +236,11 @@ static int obj_rank_by_stolen(void *priv,
 	struct drm_i915_gem_object *b =
 		container_of(B, struct drm_i915_gem_object, obj_exec_link);
 
-	return a->stolen->start - b->stolen->start;
+	if (a->stolen->start < b->stolen->start)
+		return -1;
+	if (a->stolen->start > b->stolen->start)
+		return 1;
+	return 0;
 }
 
 static int i915_gem_stolen_list_info(struct seq_file *m, void *data)
-- 
2.1.3

