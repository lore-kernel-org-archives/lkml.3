Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab3APP6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:58:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35727 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab3APP6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:58:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julius Werner <jwerner@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 023/222] xhci: fix null-pointer dereference when destroying half-built segment rings
Date: Wed, 16 Jan 2013 13:53:43 -0200
Message-Id: <1358351822-7675-24-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Werner <jwerner@chromium.org>

commit 68e5254adb88bede68285f11fb442a4d34fb550c upstream.

xhci_alloc_segments_for_ring() builds a list of xhci_segments and links
the tail to head at the end (forming a ring). When it bails out for OOM
reasons half-way through, it tries to destroy its half-built list with
xhci_free_segments_for_ring(), even though it is not a ring yet. This
causes a null-pointer dereference upon hitting the last element.

Furthermore, one of its callers (xhci_ring_alloc()) mistakenly believes
the output parameters to be valid upon this kind of OOM failure, and
calls xhci_ring_free() on them. Since the (incomplete) list/ring should
already be destroyed in that case, this would lead to a use after free.

This patch fixes those issues by having xhci_alloc_segments_for_ring()
destroy its half-built, non-circular list manually and destroying the
invalid struct xhci_ring in xhci_ring_alloc() with a plain kfree().

This patch should be backported to kernels as old as 2.6.31, that
contains the commit 0ebbab37422315a5d0cb29792271085bafdf38c0 "USB: xhci:
Ring allocation and initialization."

A separate patch will need to be developed for kernels older than 3.4,
since the ring allocation code was refactored in that kernel.

Signed-off-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/xhci-mem.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 487bc08..fb51c70 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -205,7 +205,12 @@ static int xhci_alloc_segments_for_ring(struct xhci_hcd *xhci,
 
 		next = xhci_segment_alloc(xhci, cycle_state, flags);
 		if (!next) {
-			xhci_free_segments_for_ring(xhci, *first);
+			prev = *first;
+			while (prev) {
+				next = prev->next;
+				xhci_segment_free(xhci, prev);
+				prev = next;
+			}
 			return -ENOMEM;
 		}
 		xhci_link_segments(xhci, prev, next, type);
@@ -258,7 +263,7 @@ static struct xhci_ring *xhci_ring_alloc(struct xhci_hcd *xhci,
 	return ring;
 
 fail:
-	xhci_ring_free(xhci, ring);
+	kfree(ring);
 	return NULL;
 }
 
-- 
1.7.9.5

