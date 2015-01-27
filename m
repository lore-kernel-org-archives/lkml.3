Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbbA0M2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:28:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35358 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690AbbA0MTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 098/126] USB: EHCI: fix initialization bug in iso_stream_schedule()
Date: Tue, 27 Jan 2015 12:16:43 +0000
Message-Id: <1422361031-19364-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/ehci-sched.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index e113fd73aeae..c399606f154e 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1581,6 +1581,10 @@ iso_stream_schedule (
 	else
 		next = (now + 2 + 7) & ~0x07;	/* full frame cache */
 
+	/* If needed, initialize last_iso_frame so that this URB will be seen */
+	if (ehci->isoc_count == 0)
+		ehci->last_iso_frame = now >> 3;
+
 	/*
 	 * Use ehci->last_iso_frame as the base.  There can't be any
 	 * TDs scheduled for earlier than that.
@@ -1671,10 +1675,6 @@ iso_stream_schedule (
 	urb->start_frame = start & (mod - 1);
 	if (!stream->highspeed)
 		urb->start_frame >>= 3;
-
-	/* Make sure scan_isoc() sees these */
-	if (ehci->isoc_count == 0)
-		ehci->last_iso_frame = now >> 3;
 	return status;
 
  fail:
-- 
2.1.4

