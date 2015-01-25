Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbbAYS3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:29:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbbAYSK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.18 154/183] usb: musb: stuff leak of struct usb_hcd
Date: Sun, 25 Jan 2015 10:07:56 -0800
Message-Id: <20150125180816.875349128@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 68693b8ea4e284c46bff919ac62bd9ccdfdbb6ba upstream.

since the split of host+gadget mode in commit 74c2e9360058 ("usb: musb:
factor out hcd initalization") we leak the usb_hcd struct. We call now
musb_host_cleanup() which does basically usb_remove_hcd() and also sets
the hcd variable to NULL. Doing so makes the finall call to
musb_host_free() basically a nop and the usb_hcd remains around for ever
without anowner.
This patch drops that NULL assignment for that reason.

Fixes: 74c2e9360058 ("usb: musb: factor out hcd initalization")
Cc: Daniel Mack <zonque@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_host.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -2663,7 +2663,6 @@ void musb_host_cleanup(struct musb *musb
 	if (musb->port_mode == MUSB_PORT_MODE_GADGET)
 		return;
 	usb_remove_hcd(musb->hcd);
-	musb->hcd = NULL;
 }
 
 void musb_host_free(struct musb *musb)


