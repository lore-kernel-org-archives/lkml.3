Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbaJCWUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:20:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbaJCWTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:19:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.10 011/143] drm/i915: read HEAD register back in init_ring_common() to enforce ordering
Date: Fri,  3 Oct 2014 14:33:26 -0700
Message-Id: <20141003213314.822947923@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -396,6 +396,9 @@ static int init_ring_common(struct intel
 		}
 	}
 
+	/* Enforce ordering by reading HEAD register back */
+	I915_READ_HEAD(ring);
+
 	/* Initialize the ring. This must happen _after_ we've cleared the ring
 	 * registers with the above sequence (the readback of the HEAD registers
 	 * also enforces ordering), otherwise the hw might lose the new ring


