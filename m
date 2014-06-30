Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbaF3Miz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:38:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964805AbaF3Mbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 135/181] USB: sierra: fix urb and memory leak in resume error path
Date: Mon, 30 Jun 2014 13:52:36 +0200
Message-Id: <386d58e8c3934548b90e6bd69bf3b942f87f47d6.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

