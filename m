Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761218AbbA2JWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:22:08 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44875 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754776AbbA2JGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:06:45 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 114/176] USB: EHCI: fix initialization bug in iso_stream_schedule()
Date: Wed, 28 Jan 2015 15:29:04 +0100
Message-Id: <babccf99f56efe05fe2b47f3d8beacdf5f46fa70.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6d89252a998a695ecb0348fc2d717dc33d90cae9 upstream.

Commit c3ee9b76aa93 (EHCI: improved logic for isochronous scheduling)
introduced the idea of using ehci->last_iso_frame as the origin (or
base) for the circular calculations involved in modifying the
isochronous schedule.  However, the new code it added used
ehci->last_iso_frame before the value was properly initialized.  This
patch rectifies the mistake by moving the initialization lines earlier
in iso_stream_schedule().

This fixes Bugzilla #72891.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: c3ee9b76aa93
Reported-by: Joe Bryant <tenminjoe@yahoo.com>
Tested-by: Joe Bryant <tenminjoe@yahoo.com>
Tested-by: Martin Long <martin@longhome.co.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/ehci-sched.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 85dd24ed97a6..8ecf164f0318 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1384,6 +1384,10 @@ iso_stream_schedule (
 
 	now = ehci_read_frame_index(ehci) & (mod - 1);
 
+	/* If needed, initialize last_iso_frame so that this URB will be seen */
+	if (ehci->isoc_count == 0)
+		ehci->last_iso_frame = now >> 3;
+
 	/* Typical case: reuse current schedule, stream is still active.
 	 * Hopefully there are no gaps from the host falling behind
 	 * (irq delays etc).  If there are, the behavior depends on
@@ -1493,10 +1497,6 @@ iso_stream_schedule (
 	urb->start_frame = stream->next_uframe;
 	if (!stream->highspeed)
 		urb->start_frame >>= 3;
-
-	/* Make sure scan_isoc() sees these */
-	if (ehci->isoc_count == 0)
-		ehci->last_iso_frame = now >> 3;
 	return 0;
 
  fail:
-- 
2.2.2

