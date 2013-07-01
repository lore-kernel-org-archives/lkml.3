Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3GAUSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:18:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab3GAUKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        Bernd Krumboeck <krumboeck@universalnet.at>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [ 24/26] can: usb_8dev: unregister netdev before free()ing
Date: Mon,  1 Jul 2013 13:10:19 -0700
Message-Id: <20130701200732.588148188@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200729.872850414@linuxfoundation.org>
References: <20130701200729.872850414@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 4afe2156eb639e563d6ef0c2706b66ea400348b2 upstream.

The usb_8dev hardware has problems on some xhci USB hosts. The driver fails to
read the firmware revision in the probe function. This leads to the following
Oops:

    [ 3356.635912] kernel BUG at net/core/dev.c:5701!

The driver tries to free the netdev, which has already been registered, without
unregistering it.

This patch fixes the problem by unregistering the netdev in the error path.

Reported-by: Michael Olbrich <m.olbrich@pengutronix.de>
Reviewed-by: Bernd Krumboeck <krumboeck@universalnet.at>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/usb_8dev.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -977,7 +977,7 @@ static int usb_8dev_probe(struct usb_int
 	err = usb_8dev_cmd_version(priv, &version);
 	if (err) {
 		netdev_err(netdev, "can't get firmware version\n");
-		goto cleanup_cmd_msg_buffer;
+		goto cleanup_unregister_candev;
 	} else {
 		netdev_info(netdev,
 			 "firmware: %d.%d, hardware: %d.%d\n",
@@ -989,6 +989,9 @@ static int usb_8dev_probe(struct usb_int
 
 	return 0;
 
+cleanup_unregister_candev:
+	unregister_netdev(priv->netdev);
+
 cleanup_cmd_msg_buffer:
 	kfree(priv->cmd_msg_buffer);
 


