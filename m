Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaKNI1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:27:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35495 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbaKNI1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:27:02 -0500
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bigeasy@linutronix.de>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is fully handled
Date: Fri, 14 Nov 2014 13:54:46 +0530
Message-ID: <1415953486-6000-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable the MUSB interrupts till MUSB is recovered fully from BABBLE
condition. There are chances that we could get multiple interrupts
till the time the babble recover work gets scheduled. Sometimes
this could even end up in an endless loop making MUSB itself unusable.

Reported-by: Felipe Balbi <balbi@ti.com>	
Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 3345c94..992c768 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -423,6 +423,7 @@ void musb_hnp_stop(struct musb *musb)
 	musb->port1_status &= ~(USB_PORT_STAT_C_CONNECTION << 16);
 }
 
+static void musb_generic_disable(struct musb *musb);
 /*
  * Interrupt Service Routine to record USB "global" interrupts.
  * Since these do not happen often and signify things of
@@ -846,9 +847,11 @@ b_host:
 	}
 
 	/* handle babble condition */
-	if (int_usb & MUSB_INTR_BABBLE && is_host_active(musb))
+	if (int_usb & MUSB_INTR_BABBLE && is_host_active(musb)) {
+		musb_generic_disable(musb);
 		schedule_delayed_work(&musb->recover_work,
 				      msecs_to_jiffies(100));
+	}
 
 #if 0
 /* REVISIT ... this would be for multiplexing periodic endpoints, or
-- 
1.8.3.1

