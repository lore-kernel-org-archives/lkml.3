Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaF3JB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:01:59 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:56998 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077AbaF3JB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:01:56 -0400
Date: Mon, 30 Jun 2014 13:01:23 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: gregkh@linuxfoundation.org
cc: linux-kernel@vger.kernel.org, linux-parport@lists.infradead.org,
        hsommer@eso.org, matwey.kornilov@gmail.com
Subject: [PATCHv2 1/2] parport: parport_pc: Introduce intel_bug_present
 function.
Message-ID: <alpine.LRH.2.00.1406301300190.15772@lnfm1.sai.msu.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c89138e2c968c07dd11b3c6bfc05a803d0c5434d Mon Sep 17 00:00:00 2001
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Wed, 25 Jun 2014 00:53:54 +0400
Subject: [PATCHv2 1/2] parport: parport_pc: Introduce intel_bug_present function.

Put the code to check present of the Intel bug from parport_EPP_supported
into new intel_bug_present function. The later also return ECR register
to the state it has before function call.

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

