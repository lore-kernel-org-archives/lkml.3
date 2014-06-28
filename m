Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaF1Rtu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:49:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaF1Rtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.14 049/110] USB: sierra: fix urb and memory leak in resume error path
Date: Sat, 28 Jun 2014 10:46:46 -0700
Message-Id: <20140628174548.274757635@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/sierra.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -1004,8 +1004,12 @@ static int sierra_resume(struct usb_seri
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
 


