Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbaGHTOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:14:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54365 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.769850628@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 025/125] USB: sierra: fix urb and memory leak in
 resume error path
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 7fdd26a01eb7b6cb6855ff8f69ef4a720720dfcb upstream.

Neither the transfer buffer or the urb itself were released in the
resume error path for delayed writes. Also on errors, the remainder of
the queue was not even processed, which leads to further urb and buffer
leaks.

The same error path also failed to balance the outstanding-urb counter,
something which results in degraded throughput or completely blocked
writes.

Fix this by releasing urb and buffer and balancing counters on errors,
and by always processing the whole queue even when submission of one urb
fails.

Fixes: e6929a9020ac ("USB: support for autosuspend in sierra while
online")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/sierra.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -1065,8 +1065,12 @@ static int sierra_resume(struct usb_seri
 			if (err < 0) {
 				intfdata->in_flight--;
 				usb_unanchor_urb(urb);
-				usb_scuttle_anchored_urbs(&portdata->delayed);
-				break;
+				kfree(urb->transfer_buffer);
+				usb_free_urb(urb);
+				spin_lock(&portdata->lock);
+				portdata->outstanding_urbs--;
+				spin_unlock(&portdata->lock);
+				continue;
 			}
 		}
 

