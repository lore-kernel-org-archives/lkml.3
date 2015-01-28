Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbbA2JUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:20:06 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44892 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760511AbbA2JH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:07:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Daniel Mack <zonque@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 115/176] usb: musb: stuff leak of struct usb_hcd
Date: Wed, 28 Jan 2015 15:29:05 +0100
Message-Id: <156bcb16168cac3018b457f907c4e163ed0b756a.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/musb/musb_host.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 9a2b8c85f19a..d73cda3591aa 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -2631,7 +2631,6 @@ void musb_host_cleanup(struct musb *musb)
 	if (musb->port_mode == MUSB_PORT_MODE_GADGET)
 		return;
 	usb_remove_hcd(musb->hcd);
-	musb->hcd = NULL;
 }
 
 void musb_host_free(struct musb *musb)
-- 
2.2.2

