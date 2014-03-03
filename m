Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaCCCw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 21:52:27 -0500
Received: from nm8-vm1.bullet.mail.gq1.yahoo.com ([98.136.218.224]:32043 "EHLO
	nm8-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759AbaCCCwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 21:52:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=GfHGAbpSv3Jutj2JHrmXtducB8LEpbe9b4vnBxD4TTVtUVOCgMdKoGLSMhrbVx9i5ljRqPGM7EuQqvS6tZUtXrSKRtukLKIq79yVHepfGETxnouEMBfuLw1VcY0Bg0ql5xKUxLmCTO35sX99lm/qxoG2pEC0+bjCiuuK7LqTTBQ=;
X-Yahoo-Newman-Id: 895437.31670.bm@smtp209.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 2K80yBMVM1nrTcwRcb1SdebMQYLJbbnE2.tznlYXYMmKlBA
 GsXcDMXv64C2vmXq9pYL2R8W0G.JaWDyLrEDXj_fkklCH4KLQiNnsqXSVru5
 40miigTjvDyaLsS1slGl_fHzNEdhCBTkC3v2n3pumTczsz_VN0v5T3PFxD9A
 bIPcAi.YcgS5CisIU5m.2O6JhoPM6Ainb90gGPJNiwmaeE3UZ2iJIa6kHgd1
 511cFtsGmelS5x0G4oLkM1C30Jsj_XwoPHcs73Oq4Np.sBZr9AatvPauFDf2
 nd2r.yusznUFGf0R_CnQvaPF02QHh8h.LsgUs0ID.AoHsaZ6cXjPZgDfbRtN
 1opMK_DvtelqqnZGz8FHRXTjrlTorET0vSxMTaPBiw4OtiXBVs7VoO_1sN62
 QUtSnVoxrcxZuMoxHH45qak78vqSyc9I3N0eAWgjvL1zxQ2Qp5dCnOkULlVE
 pyQE8t2cjtWzcJsUT2yFNzNfDVYbnn_rR4hwXk2mZrxt3rFsOQ5T1GnLSVAl
 3Ppu8F2yddtXDvKwO9UbIt_yukEdc_7w_Nccx
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp209.mail.gq1.yahoo.com with SMTP; 02 Mar 2014 18:52:24 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v2 1/2] Staging: comedi: introduce {outl,inl}_amcc() and {outl,inl}_iobase() helper functions in hwdrv_apci1564.c
Date: Sun,  2 Mar 2014 20:52:19 -0600
Message-Id: <1393815139-10663-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com>
References: <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a few simple outl and inl helper functions to allow
several lines which violate the character limit to be shortened
appropriately.  It also changes a few macro values which represented
offset values from a single unique base value to instead represent the value
of that base plus the offset.  This is to simplify the use of these macros
in the new helper functions.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

All right, here's another shot at this.  Dan, I took your outl_amcc idea
and did a version for the outl/inl calls based from devpriv->iobase as well.
I changed all of the macros which only offset from one base value as you
had mentioned as well, and the result is starting to look very good.
The only outl/inl calls which still look a little gross (see PATCH v2 2/2) are
the ones involving DIGITAL_OP_WATCHDOG, TIMER, or any of the COUNTER macros,
just because they use a common set of offset macros so simplifying
those calls in the same way as the rest isn't possible.  What are your
thoughts on this version of the patchset?

This is version 2 of [PATCH 1/2] Staging: comedi: introduce outl_1564_* and
inl_1564_* helper functions in hwdrv_apci1564.c

2: Changed helper functions from {outl,inl}_1564_*() to
{outl,inl}_{amcc,iobase}()

Comments welcome!

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 38 +++++++++++++++++-----
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 2b47fa1..58e301d 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -49,25 +49,25 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 /* DIGITAL INPUT-OUTPUT DEFINE */
 /* Input defines */
 #define APCI1564_DIGITAL_IP				0x04
-#define APCI1564_DIGITAL_IP_INTERRUPT_MODE1		4
-#define APCI1564_DIGITAL_IP_INTERRUPT_MODE2		8
-#define APCI1564_DIGITAL_IP_IRQ				16
+#define APCI1564_DIGITAL_IP_INTERRUPT_MODE1		(0x04 + 0x04)
+#define APCI1564_DIGITAL_IP_INTERRUPT_MODE2		(0x04 + 0x08)
+#define APCI1564_DIGITAL_IP_IRQ				(0x04 + 0x10)
 
 /* Output defines */
 #define APCI1564_DIGITAL_OP				0x18
-#define APCI1564_DIGITAL_OP_RW				0
-#define APCI1564_DIGITAL_OP_INTERRUPT			4
-#define APCI1564_DIGITAL_OP_IRQ				12
+#define APCI1564_DIGITAL_OP_RW				0x18
+#define APCI1564_DIGITAL_OP_INTERRUPT			(0x18 + 0x04)
+#define APCI1564_DIGITAL_OP_IRQ				(0x18 + 0x0C)
 
 /* Digital Input IRQ Function Selection */
 #define ADDIDATA_OR					0
 #define ADDIDATA_AND					1
 
 /* Digital Input Interrupt Status */
-#define APCI1564_DIGITAL_IP_INTERRUPT_STATUS		12
+#define APCI1564_DIGITAL_IP_INTERRUPT_STATUS		(0x04 + 0x0C)
 
 /* Digital Output Interrupt Status */
-#define APCI1564_DIGITAL_OP_INTERRUPT_STATUS		8
+#define APCI1564_DIGITAL_OP_INTERRUPT_STATUS		(0x18 + 0x08)
 
 /* Digital Input Interrupt Enable Disable. */
 #define APCI1564_DIGITAL_IP_INTERRUPT_ENABLE		0x4
@@ -99,6 +99,28 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 #define APCI1564_TCW_WARN_TIMEVAL			24
 #define APCI1564_TCW_WARN_TIMEBASE			28
 
+static void outl_amcc(struct addi_private *devpriv, unsigned int cmd,
+				unsigned int reg)
+{
+	outl(cmd, devpriv->i_IobaseAmcc + reg);
+}
+
+static unsigned int inl_amcc(struct addi_private *devpriv, unsigned int reg)
+{
+	return inl(devpriv->i_IobaseAmcc + reg);
+}
+
+static void outl_iobase(struct addi_private *devpriv, unsigned int cmd,
+				unsigned int reg)
+{
+	outl(cmd, devpriv->iobase + reg);
+}
+
+static void inl_iobase(struct addi_private *devpriv, unsigned int reg)
+{
+	return inl(devpriv->iobase + reg);
+}
+
 /* Global variables */
 static unsigned int ui_InterruptStatus_1564;
 static unsigned int ui_InterruptData, ui_Type;
-- 
1.8.5.3

