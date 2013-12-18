Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab3LRVVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:21:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3LRVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 3.12 101/118] staging: comedi: ssv_dnp: use comedi_dio_update_state()
Date: Wed, 18 Dec 2013 13:12:18 -0800
Message-Id: <20131218211222.307425069@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H Hartley Sweeten <hsweeten@visionengravers.com>

commit f6b316bcd8c421acd6fa5a6e18b4c846ecb9d965 upstream.

Use comedi_dio_update_state() to handle the boilerplate code to update
the subdevice s->state.

Also, fix a bug where the state of the channels is returned in data[0].
The comedi core expects it to be returned in data[1].

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/ssv_dnp.c |   48 ++++++++++++-------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -46,51 +46,43 @@ Status: unknown
 #define PCMR  0xa3		/* Port C Mode Register                      */
 #define PCDR  0xa7		/* Port C Data Register                      */
 
-/* ------------------------------------------------------------------------- */
-/* The insn_bits interface allows packed reading/writing of DIO channels.    */
-/* The comedi core can convert between insn_bits and insn_read/write, so you */
-/* are able to use these instructions as well.                               */
-/* ------------------------------------------------------------------------- */
-
 static int dnp_dio_insn_bits(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
-			     struct comedi_insn *insn, unsigned int *data)
+			     struct comedi_insn *insn,
+			     unsigned int *data)
 {
-	/* The insn data is a mask in data[0] and the new data in data[1],   */
-	/* each channel cooresponding to a bit.                              */
-
-	/* Ports A and B are straight forward: each bit corresponds to an    */
-	/* output pin with the same order. Port C is different: bits 0...3   */
-	/* correspond to bits 4...7 of the output register (PCDR).           */
+	unsigned int mask;
+	unsigned int val;
 
-	if (data[0]) {
+	/*
+	 * Ports A and B are straight forward: each bit corresponds to an
+	 * output pin with the same order. Port C is different: bits 0...3
+	 * correspond to bits 4...7 of the output register (PCDR).
+	 */
 
+	mask = comedi_dio_update_state(s, data);
+	if (mask) {
 		outb(PADR, CSCIR);
-		outb((inb(CSCDR)
-		      & ~(u8) (data[0] & 0x0000FF))
-		     | (u8) (data[1] & 0x0000FF), CSCDR);
+		outb(s->state & 0xff, CSCDR);
 
 		outb(PBDR, CSCIR);
-		outb((inb(CSCDR)
-		      & ~(u8) ((data[0] & 0x00FF00) >> 8))
-		     | (u8) ((data[1] & 0x00FF00) >> 8), CSCDR);
+		outb((s->state >> 8) & 0xff, CSCDR);
 
 		outb(PCDR, CSCIR);
-		outb((inb(CSCDR)
-		      & ~(u8) ((data[0] & 0x0F0000) >> 12))
-		     | (u8) ((data[1] & 0x0F0000) >> 12), CSCDR);
+		val = inb(CSCDR) & 0x0f;
+		outb(((s->state >> 12) & 0xf0) | val, CSCDR);
 	}
 
-	/* on return, data[1] contains the value of the digital input lines. */
 	outb(PADR, CSCIR);
-	data[0] = inb(CSCDR);
+	val = inb(CSCDR);
 	outb(PBDR, CSCIR);
-	data[0] += inb(CSCDR) << 8;
+	val |= (inb(CSCDR) << 8);
 	outb(PCDR, CSCIR);
-	data[0] += ((inb(CSCDR) & 0xF0) << 12);
+	val |= ((inb(CSCDR) & 0xf0) << 12);
 
-	return insn->n;
+	data[1] = val;
 
+	return insn->n;
 }
 
 static int dnp_dio_insn_config(struct comedi_device *dev,


