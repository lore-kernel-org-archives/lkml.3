Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaF3MWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:22:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51929 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 064/181] USB: cdc-acm: fix I/O after failed open
Date: Mon, 30 Jun 2014 13:51:25 +0200
Message-Id: <f524bcefecdd95da34a614e42e674c9cc501abfc.1404128998.git.jslaby@suse.cz>
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

commit e4c36076c2a6195ec62c35b03c3fde84d0087dc8 upstream.

Make sure to kill any already submitted read urbs on read-urb submission
failures in open in order to prevent doing I/O for a closed port.

Fixes: 088c64f81284 ("USB: cdc-acm: re-write read processing")
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/class/cdc-acm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 6774bf165083..ebbe89f60f7b 100644
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
2.0.0

