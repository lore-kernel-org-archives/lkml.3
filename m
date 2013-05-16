Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3EPUFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:05:10 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:14760 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3EPUFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:05:07 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 May 2013 16:05:07 EDT
From: Corey Minyard <cminyard@mvista.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/4] ipmi: Improve error messages on failed irq enable
Date: Thu, 16 May 2013 14:04:26 -0500
Message-id: <1368731067-31404-4-git-send-email-cminyard@mvista.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1368731067-31404-1-git-send-email-cminyard@mvista.com>
References: <1368731067-31404-1-git-send-email-cminyard@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the interrupt enable message returns an error, the messages are
not entirely accurate nor helpful.  So improve them.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Andy Lutomirski <luto@amacapital.net>
---
 drivers/char/ipmi/ipmi_si_intf.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 313538a..af4b23f 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -663,8 +663,10 @@ static void handle_transaction_done(struct smi_info *smi_info)
 		/* We got the flags from the SMI, now handle them. */
 		smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
 		if (msg[2] != 0) {
-			dev_warn(smi_info->dev, "Could not enable interrupts"
-				 ", failed get, using polled mode.\n");
+			dev_warn(smi_info->dev,
+				 "Couldn't get irq info: %x.\n", msg[2]);
+			dev_warn(smi_info->dev,
+				 "Maybe ok, but ipmi might run very slowly.\n");
 			smi_info->si_state = SI_NORMAL;
 		} else {
 			msg[0] = (IPMI_NETFN_APP_REQUEST << 2);
@@ -685,10 +687,12 @@ static void handle_transaction_done(struct smi_info *smi_info)
 
 		/* We got the flags from the SMI, now handle them. */
 		smi_info->handlers->get_result(smi_info->si_sm, msg, 4);
-		if (msg[2] != 0)
-			dev_warn(smi_info->dev, "Could not enable interrupts"
-				 ", failed set, using polled mode.\n");
-		else
+		if (msg[2] != 0) {
+			dev_warn(smi_info->dev,
+				 "Couldn't set irq info: %x.\n", msg[2]);
+			dev_warn(smi_info->dev,
+				 "Maybe ok, but ipmi might run very slowly.\n");
+		} else
 			smi_info->interrupt_disabled = 0;
 		smi_info->si_state = SI_NORMAL;
 		break;
-- 
1.7.9.5

