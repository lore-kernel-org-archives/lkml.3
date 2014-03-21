Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966090AbaCUAJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:09:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965981AbaCUAJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.10 66/85] can: flexcan: flexcan_open(): fix error path if flexcan_chip_start() fails
Date: Thu, 20 Mar 2014 17:10:09 -0700
Message-Id: <20140321000608.096911608@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 7e9e148af01ef388efb6e2490805970be4622792 upstream.

If flexcan_chip_start() in flexcan_open() fails, the interrupt is not freed,
this patch adds the missing cleanup.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -862,7 +862,7 @@ static int flexcan_open(struct net_devic
 	/* start chip and queuing */
 	err = flexcan_chip_start(dev);
 	if (err)
-		goto out_close;
+		goto out_free_irq;
 
 	can_led_event(dev, CAN_LED_EVENT_OPEN);
 
@@ -871,6 +871,8 @@ static int flexcan_open(struct net_devic
 
 	return 0;
 
+ out_free_irq:
+	free_irq(dev->irq, dev);
  out_close:
 	close_candev(dev);
  out:


