Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3ASBWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:22:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:57277 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab3ASBWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:22:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Julius Werner <jwerner@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, CAI Qian <caiqian@redhat.com>
Subject: [ 11/16] xhci: fix null-pointer dereference when destroying half-built segment rings
Date: Fri, 18 Jan 2013 17:21:49 -0800
Message-Id: <20130119012140.003598658@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119012138.680057206@linuxfoundation.org>
References: <20130119012138.680057206@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Since segment allocation is done directly in xhci_ring_alloc(), walk
   the list starting from ring->first_seg when freeing]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/usb/host/xhci-mem.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -180,8 +180,15 @@ static struct xhci_ring *xhci_ring_alloc
 		struct xhci_segment	*next;
 
 		next = xhci_segment_alloc(xhci, flags);
-		if (!next)
+		if (!next) {
+			prev = ring->first_seg;
+			while (prev) {
+				next = prev->next;
+				xhci_segment_free(xhci, prev);
+				prev = next;
+			}
 			goto fail;
+		}
 		xhci_link_segments(xhci, prev, next, link_trbs, isoc);
 
 		prev = next;
@@ -201,7 +208,7 @@ static struct xhci_ring *xhci_ring_alloc
 	return ring;
 
 fail:
-	xhci_ring_free(xhci, ring);
+	kfree(ring);
 	return NULL;
 }
 


