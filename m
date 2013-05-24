Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab3EXIq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:46:58 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:37025 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab3EXIq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:46:56 -0400
From: Federico Manzan <f.manzan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sarah.a.sharp@linux.intel.com, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Federico Manzan <f.manzan@gmail.com>
Subject: [PATCH] usbfs: Increase arbitrary limit for USB 3 isopkt length
Date: Fri, 24 May 2013 10:47:29 +0200
Message-Id: <1369385249-15624-1-git-send-email-f.manzan@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the current arbitrary limit for isocronous packet size to a
value large enough to account for USB 3.0 super bandwidth streams,
bMaxBurst (0~15 allowed, 1~16 packets)
bmAttributes (bit 1:0, mult 0~2, 1~3 packets)
so the size max for one USB 3 isocronous transfer is
1024 byte * 16 * 3 = 49152 byte

Signed-off-by: Federico Manzan <f.manzan@gmail.com>
---
 drivers/usb/core/devio.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index caefc80..7ac137e 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1287,9 +1287,11 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 			goto error;
 		}
 		for (totlen = u = 0; u < uurb->number_of_packets; u++) {
-			/* arbitrary limit,
-			 * sufficient for USB 2.0 high-bandwidth iso */
-			if (isopkt[u].length > 8192) {
+			/* arbitrary limit need for USB 3.0
+			 * bMaxBurst (0~15 allowed, 1~16 packets)
+			 * bmAttributes (bit 1:0, mult 0~2, 1~3 packets)
+			 * sizemax: 1024 * 16 * 3 = 49152*/
+			if (isopkt[u].length > 65536) {
 				ret = -EINVAL;
 				goto error;
 			}
-- 
1.7.10.4

