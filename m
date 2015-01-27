Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbbA0MTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:19:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35240 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604AbbA0MS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Mack <zonque@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 075/126] usb: musb: stuff leak of struct usb_hcd
Date: Tue, 27 Jan 2015 12:16:20 +0000
Message-Id: <1422361031-19364-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/musb/musb_host.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index eb06291a40c8..0ae35ab5c392 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -2662,7 +2662,6 @@ void musb_host_cleanup(struct musb *musb)
 	if (musb->port_mode == MUSB_PORT_MODE_GADGET)
 		return;
 	usb_remove_hcd(musb->hcd);
-	musb->hcd = NULL;
 }
 
 void musb_host_free(struct musb *musb)
-- 
2.1.4

