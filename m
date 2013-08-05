Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3HERls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:41:48 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:31959 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3HERkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:40:25 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 1/4] staging: ozwpan: Fixes crash due to invalid port aceess.
Date: Mon, 5 Aug 2013 18:40:12 +0100
Message-ID: <1375724415-10801-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes kernel crash issue, when we receive URB request
after de-enumerating device.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index ed63868..d313a63 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -480,10 +480,14 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 		oz_free_urb_link(urbl);
 		return 0;
 	}
-	if (in_dir)
+	if (in_dir && port->in_ep[ep_addr])
 		ep = port->in_ep[ep_addr];
-	else
+	else if (!in_dir && port->out_ep[ep_addr])
 		ep = port->out_ep[ep_addr];
+	else {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	/*For interrupt endpoint check for buffered data
 	* & complete urb
@@ -505,6 +509,7 @@ static int oz_enqueue_ep_urb(struct oz_port *port, u8 ep_addr, int in_dir,
 	} else {
 		err = -EPIPE;
 	}
+out:
 	spin_unlock_bh(&port->ozhcd->hcd_lock);
 	if (err)
 		oz_free_urb_link(urbl);
-- 
1.7.9.5

