Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaJFTSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:18:41 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:35948 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbaJFTSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:18:39 -0400
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 1/4] ipmi: Clean up the error handling for channel config errors
Date: Mon,  6 Oct 2014 14:17:50 -0500
Message-Id: <1412623073-6166-2-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1412623073-6166-1-git-send-email-minyard@acm.org>
References: <1412623073-6166-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

The code to send the channel config errors was missing an error report
in one place and needed some more information in another, and had an
extraneous bit of code.  Clean all that up.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_msghandler.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index e6db938..f816211 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2796,7 +2796,6 @@ channel_handler(ipmi_smi_t intf, struct ipmi_recv_msg *msg)
 					= IPMI_CHANNEL_MEDIUM_IPMB;
 				intf->channels[0].protocol
 					= IPMI_CHANNEL_PROTOCOL_IPMB;
-				rv = -ENOSYS;
 
 				intf->curr_channel = IPMI_MAX_CHANNELS;
 				wake_up(&intf->waitq);
@@ -2821,12 +2820,12 @@ channel_handler(ipmi_smi_t intf, struct ipmi_recv_msg *msg)
 
 		if (rv) {
 			/* Got an error somehow, just give up. */
+			printk(KERN_WARNING PFX
+			       "Error sending channel information for channel"
+			       " %d: %d\n", intf->curr_channel, rv);
+
 			intf->curr_channel = IPMI_MAX_CHANNELS;
 			wake_up(&intf->waitq);
-
-			printk(KERN_WARNING PFX
-			       "Error sending channel information: %d\n",
-			       rv);
 		}
 	}
  out:
@@ -2964,8 +2963,12 @@ int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
 		intf->null_user_handler = channel_handler;
 		intf->curr_channel = 0;
 		rv = send_channel_info_cmd(intf, 0);
-		if (rv)
+		if (rv) {
+			printk(KERN_WARNING PFX
+			       "Error sending channel information for channel"
+			       " 0, %d\n", rv);
 			goto out;
+		}
 
 		/* Wait for the channel info to be read. */
 		wait_event(intf->waitq,
-- 
1.8.3.1

