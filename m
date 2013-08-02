Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502Ab3HBKLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:11:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030482Ab3HBKLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 74/99] drm/i915: Fix write-read race with multiple rings
Date: Fri,  2 Aug 2013 18:08:27 +0800
Message-Id: <20130802100236.305753308@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 02978ff57a5bdfbf703d2bc5a4d933a53ede3144 upstream.

Daniel noticed a problem where is we wrote to an object with ring A in
the middle of a very long running batch, then executed a quick batch on
ring B before a batch that reads from the same object, its obj->ring would
now point to ring B, but its last_write_seqno would be still relative to
ring A. This would allow for the user to read from the object before the
GPU had completed the write, as set_domain would only check that ring B
had passed the last_write_seqno.

To fix this simply (and inelegantly), we bump the last_write_seqno when
switching rings so that the last_write_seqno is always relative to the
current obj->ring.

This fixes igt/tests/gem_write_read_ring_switch.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
[danvet: Add note about the newly created igt which exercises this bug.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1881,6 +1881,10 @@ i915_gem_object_move_to_active(struct dr
 	u32 seqno = intel_ring_get_seqno(ring);
 
 	BUG_ON(ring == NULL);
+	if (obj->ring != ring && obj->last_write_seqno) {
+		/* Keep the seqno relative to the current ring */
+		obj->last_write_seqno = seqno;
+	}
 	obj->ring = ring;
 
 	/* Add a reference if we're newly entering the active list. */


