Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab3L2Cd4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:33:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55449 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab3L2CKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:46 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.156873844@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 091/185] USB: serial: fix race in generic write
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 6f6485463aada1ec6a0f3db6a03eb8e393d6bb55 upstream.

Fix race in generic write implementation, which could lead to
temporarily degraded throughput.

The current generic write implementation introduced by commit
27c7acf22047 ("USB: serial: reimplement generic fifo-based writes") has
always had this bug, although it's fairly hard to trigger and the
consequences are not likely to be noticed.

Specifically, a write() on one CPU while the completion handler is
running on another could result in only one of the two write urbs being
utilised to empty the remainder of the write fifo (unless there is a
second write() that doesn't race during that time).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: deleted code is a bit different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/generic.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -228,14 +228,7 @@ retry:
 		return result;
 	}
 
-	/* Try sending off another urb, unless in irq context (in which case
-	 * there will be no free urb). */
-	if (!in_irq())
-		goto retry;
-
-	clear_bit_unlock(USB_SERIAL_WRITE_BUSY, &port->flags);
-
-	return 0;
+	goto retry;	/* try sending off another urb */
 }
 
 /**

