Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbaGRHOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:14:48 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:37100 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaGRHOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:14:47 -0400
From: matwey@sai.msu.ru
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        hsommer@eso.org, gnomes@lxorguk.ukuu.org.uk, matwey.kornilov@gmail.com,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: [PATCHv4 1/2] parport: parport_pc: Introduce intel_bug_present function.
Date: Fri, 18 Jul 2014 11:12:54 +0400
Message-Id: <1405667575-3291-2-git-send-email-matwey@sai.msu.ru>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1405667575-3291-1-git-send-email-matwey@sai.msu.ru>
References: <1405667575-3291-1-git-send-email-matwey@sai.msu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matwey V. Kornilov" <matwey@sai.msu.ru>

Put the code to check present of the Intel bug from parport_EPP_supported
into new intel_bug_present function. The later also return ECR register
to the state it has before function call.

Suggested-by: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Tested-by: Heiko Andreas Sommer <hsommer@eso.org>
Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
---
 drivers/parport/parport_pc.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 76ee775..a6eaafb 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -1702,6 +1702,30 @@ static int parport_ECP_supported(struct parport *pb)
 }
 #endif
 
+static int intel_bug_present(struct parport *pb)
+{
+	const struct parport_pc_private *priv = pb->private_data;
+	int bug_present = 0;
+
+	if (priv->ecr) {
+		/* store value of ECR */
+		unsigned char ecr = inb(ECONTROL(pb));
+		unsigned char i;
+		for (i = 0x00; i < 0x80; i += 0x20) {
+			ECR_WRITE(pb, i);
+			if (clear_epp_timeout(pb)) {
+				/* Phony EPP in ECP. */
+				bug_present = 1;
+				break;
+			}
+		}
+		/* return ECR into the inital state */
+		ECR_WRITE(pb, ecr);
+	}
+
+	return bug_present;
+}
+
 static int parport_ECPPS2_supported(struct parport *pb)
 {
 	const struct parport_pc_private *priv = pb->private_data;
@@ -1722,8 +1746,6 @@ static int parport_ECPPS2_supported(struct parport *pb)
 
 static int parport_EPP_supported(struct parport *pb)
 {
-	const struct parport_pc_private *priv = pb->private_data;
-
 	/*
 	 * Theory:
 	 *	Bit 0 of STR is the EPP timeout bit, this bit is 0
@@ -1742,16 +1764,8 @@ static int parport_EPP_supported(struct parport *pb)
 		return 0;  /* No way to clear timeout */
 
 	/* Check for Intel bug. */
-	if (priv->ecr) {
-		unsigned char i;
-		for (i = 0x00; i < 0x80; i += 0x20) {
-			ECR_WRITE(pb, i);
-			if (clear_epp_timeout(pb)) {
-				/* Phony EPP in ECP. */
-				return 0;
-			}
-		}
-	}
+	if (intel_bug_present(pb))
+		return 0;
 
 	pb->modes |= PARPORT_MODE_EPP;
 
-- 
1.8.1.4

