Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3LQSPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:15:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32808 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3LQSPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 067/103] USB: serial: fix race in generic write
Date: Tue, 17 Dec 2013 18:12:56 +0000
Message-Id: <1387304012-23805-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/generic.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 9b026bf..ff91eca 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -191,14 +191,7 @@ retry:
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
-- 
1.8.3.2

