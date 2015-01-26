Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbbAZARr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 19:17:47 -0500
Received: from 64-251-151-187.fidnet.com ([64.251.151.187]:48209 "EHLO
	mail.icequake.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbAZARp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 19:17:45 -0500
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jan 2015 19:17:44 EST
From: "Ryan C. Underwood" <nemesis@icequake.net>
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Ryan Underwood <nemesis@icequake.net>
Subject: [PATCH] Disable write buffering on Toshiba ToPIC95
Date: Sun, 25 Jan 2015 16:07:09 -0800
Message-Id: <1422230829-14823-1-git-send-email-nemesis@icequake.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Underwood <nemesis@icequake.net>

Disable write buffering on the Toshiba ToPIC95 if it is enabled by somebody (it
is not supposed to be a power-on default according to the datasheet).  On the
ToPIC95, practically no 32-bit Cardbus card will work under heavy load without
locking up the whole system if this is left enabled.  I tried about a dozen.
It does not affect 16-bit cards.  This is similar to the O2 bugs in early
controller revisions it seems.  Originally posted to
https://bugzilla.kernel.org/show_bug.cgi?id=55961
---
 drivers/pcmcia/topic.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/pcmcia/topic.h b/drivers/pcmcia/topic.h
index 615a45a..582688fe 100644
--- a/drivers/pcmcia/topic.h
+++ b/drivers/pcmcia/topic.h
@@ -104,6 +104,9 @@
 #define TOPIC_EXCA_IF_CONTROL		0x3e	/* 8 bit */
 #define TOPIC_EXCA_IFC_33V_ENA		0x01
 
+#define TOPIC_PCI_CFG_PPBCN		0x3e	/* 16-bit */
+#define TOPIC_PCI_CFG_PPBCN_WBEN	0x0400
+
 static void topic97_zoom_video(struct pcmcia_socket *sock, int onoff)
 {
 	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
@@ -138,6 +141,7 @@ static int topic97_override(struct yenta_socket *socket)
 static int topic95_override(struct yenta_socket *socket)
 {
 	u8 fctrl;
+	u16 ppbcn;
 
 	/* enable 3.3V support for 16bit cards */
 	fctrl = exca_readb(socket, TOPIC_EXCA_IF_CONTROL);
@@ -146,6 +150,18 @@ static int topic95_override(struct yenta_socket *socket)
 	/* tell yenta to use exca registers to power 16bit cards */
 	socket->flags |= YENTA_16BIT_POWER_EXCA | YENTA_16BIT_POWER_DF;
 
+	/* Disable write buffers to prevent lockups under load with numerous
+	   Cardbus cards, observed on Tecra 500CDT and reported elsewhere on the
+	   net.  This is not a power-on default according to the datasheet
+	   but some BIOSes seem to set it. */
+	if (pci_read_config_word(socket->dev, TOPIC_PCI_CFG_PPBCN, &ppbcn) == 0
+	    && socket->dev->revision <= 7
+	    && (ppbcn & TOPIC_PCI_CFG_PPBCN_WBEN)) {
+		ppbcn &= ~TOPIC_PCI_CFG_PPBCN_WBEN;
+		pci_write_config_word(socket->dev, TOPIC_PCI_CFG_PPBCN, ppbcn);
+		dev_info(&socket->dev->dev, "Disabled ToPIC95 Cardbus write buffers.\n");
+	}
+
 	return 0;
 }
 
-- 
1.9.1

