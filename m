Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbaICXBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:01:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940AbaICWZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:25:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.16 116/125] usbcore: Fix wrong device in an error message in hub_port_connect()
Date: Wed,  3 Sep 2014 15:07:53 -0700
Message-Id: <20140903220627.177279591@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit dd5f5006d1035547559c8a90781a7e249787a7a2 upstream.

The commit [5ee0f803cc3a: usbcore: don't log on consecutive debounce
failures of the same port] added the check of the reliable port, but
it also replaced the device argument to dev_err() wrongly, which leads
to a NULL dereference.

This patch restores the right device, port_dev->dev.  Also, since
dev_err() itself shows the port number, reduce the port number shown
in the error message, essentially reverting to the state before the
commit 5ee0f803cc3a.

[The fix suggested by Hannes, and the error message cleanup suggested
 by Alan Stern]

Fixes: 5ee0f803cc3a ('usbcore: don't log on consecutive debounce failures of the same port')
Reported-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4619,9 +4619,7 @@ static void hub_port_connect(struct usb_
 			if (status != -ENODEV &&
 				port1 != unreliable_port &&
 				printk_ratelimit())
-				dev_err(&udev->dev, "connect-debounce failed, port %d disabled\n",
-					port1);
-
+				dev_err(&port_dev->dev, "connect-debounce failed\n");
 			portstatus &= ~USB_PORT_STAT_CONNECTION;
 			unreliable_port = port1;
 		} else {


