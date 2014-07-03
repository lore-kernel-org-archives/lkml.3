Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030516AbaGCJYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:24:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52496 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030464AbaGCJYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 165/198] USB: cdc-acm: fix I/O after failed open
Date: Thu,  3 Jul 2014 10:20:08 +0100
Message-Id: <1404379241-8590-166-git-send-email-luis.henriques@canonical.com>
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

commit e4c36076c2a6195ec62c35b03c3fde84d0087dc8 upstream.

Make sure to kill any already submitted read urbs on read-urb submission
failures in open in order to prevent doing I/O for a closed port.

Fixes: 088c64f81284 ("USB: cdc-acm: re-write read processing")
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index dc5cfa5a1118..83a19ae3c31c 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -494,6 +494,7 @@ static int acm_port_activate(struct tty_port *port, struct tty_struct *tty)
 {
 	struct acm *acm = container_of(port, struct acm, port);
 	int retval = -ENODEV;
+	int i;
 
 	dev_dbg(&acm->control->dev, "%s\n", __func__);
 
@@ -542,6 +543,8 @@ static int acm_port_activate(struct tty_port *port, struct tty_struct *tty)
 	return 0;
 
 error_submit_read_urbs:
+	for (i = 0; i < acm->rx_buflimit; i++)
+		usb_kill_urb(acm->read_urbs[i]);
 	acm->ctrlout = 0;
 	acm_set_control(acm, acm->ctrlout);
 error_set_control:
-- 
1.9.1

