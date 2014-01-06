Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbaAFXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:25:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbaAFWkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.10 001/129] USB: serial: fix race in generic write
Date: Mon,  6 Jan 2014 14:37:10 -0800
Message-Id: <20140106223859.633364054@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/serial/generic.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -176,14 +176,7 @@ retry:
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


