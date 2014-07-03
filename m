Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbaGCKI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:08:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51715 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaGCJWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 056/198] USB: sierra: fix urb and memory leak in resume error path
Date: Thu,  3 Jul 2014 10:18:19 +0100
Message-Id: <1404379241-8590-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/sierra.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index efdb76a7b787..5f7f64f70044 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -1012,8 +1012,12 @@ static int sierra_resume(struct usb_serial *serial)
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
 
-- 
1.9.1

