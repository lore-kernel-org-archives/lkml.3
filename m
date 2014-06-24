Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbaFXQEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:04:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbaFXP4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.15 34/61] USB: cdc-acm: fix I/O after failed open
Date: Tue, 24 Jun 2014 11:51:17 -0400
Message-Id: <20140624154954.337788097@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e4c36076c2a6195ec62c35b03c3fde84d0087dc8 upstream.

Make sure to kill any already submitted read urbs on read-urb submission
failures in open in order to prevent doing I/O for a closed port.

Fixes: 088c64f81284 ("USB: cdc-acm: re-write read processing")
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -506,6 +506,7 @@ static int acm_port_activate(struct tty_
 {
 	struct acm *acm = container_of(port, struct acm, port);
 	int retval = -ENODEV;
+	int i;
 
 	dev_dbg(&acm->control->dev, "%s\n", __func__);
 
@@ -556,6 +557,8 @@ static int acm_port_activate(struct tty_
 	return 0;
 
 error_submit_read_urbs:
+	for (i = 0; i < acm->rx_buflimit; i++)
+		usb_kill_urb(acm->read_urbs[i]);
 	acm->ctrlout = 0;
 	acm_set_control(acm, acm->ctrlout);
 error_set_control:


