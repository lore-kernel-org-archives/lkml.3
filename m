Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbaIZJuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:50:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbaIZJqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 133/142] drm/i915: read HEAD register back in init_ring_common() to enforce ordering
Date: Fri, 26 Sep 2014 11:45:44 +0200
Message-Id: <7b5e127b34724f698d7567b7222f0cbf3624098b.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ece4a17d237a79f63fbfaf3f724a12b6d500555c upstream.

Withtout this, ring initialization fails reliabily during resume with

	[drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f001 head ffffff8804 tail 00000000 start 000e4000

This is not a complete fix, but it is verified to make the ring
initialization failures during resume much less likely.

We were not able to root-cause this bug (likely HW-specific to Gen4 chips)
yet. This is therefore used as a ducttape before problem is fully
understood and proper fix created, so that people don't suffer from
completely unusable systems in the meantime.

The discussion and debugging is happening at

	https://bugs.freedesktop.org/show_bug.cgi?id=76554

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 7507fe036b6e..1ceb95a3bbe0 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -423,6 +423,9 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 		}
 	}
 
+	/* Enforce ordering by reading HEAD register back */
+	I915_READ_HEAD(ring);
+
 	/* Initialize the ring. This must happen _after_ we've cleared the ring
 	 * registers with the above sequence (the readback of the HEAD registers
 	 * also enforces ordering), otherwise the hw might lose the new ring
-- 
2.1.0

