Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3CDEN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:13:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60887 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755657Ab3CDDmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:55 -0500
Message-Id: <20130304033720.172220784@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:15 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [ 128/153] staging: comedi: ni_labpc: set up  command4 register *after* command3
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 22056e2b46246d97ff0f7c6e21a77b8daa07f02c upstream.

Tuomas <tvainikk _at_ gmail _dot_ com> reported problems getting
meaningful output from a Lab-PC+ in differential mode for AI cmds, but
AI insn reads gave correct readings.  He tracked it down to two
problems, one of which is addressed by this patch.

It seems that writing to the command3 register after writing to the
command4 register in `labpc_ai_cmd()` messes up the differential
reference bit setting in the command4 register.  Set up the command4
register after the command3 register (as in `labpc_ai_rinsn()`) to avoid
the problem.

Thanks to Tuomas for suggesting the fix.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/ni_labpc.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1282,21 +1282,6 @@ static int labpc_ai_cmd(struct comedi_de
 		devpriv->write_byte(devpriv->command1_bits,
 				    dev->iobase + COMMAND1_REG);
 	}
-	/*  setup any external triggering/pacing (command4 register) */
-	devpriv->command4_bits = 0;
-	if (cmd->convert_src != TRIG_EXT)
-		devpriv->command4_bits |= EXT_CONVERT_DISABLE_BIT;
-	/* XXX should discard first scan when using interval scanning
-	 * since manual says it is not synced with scan clock */
-	if (labpc_use_continuous_mode(cmd) == 0) {
-		devpriv->command4_bits |= INTERVAL_SCAN_EN_BIT;
-		if (cmd->scan_begin_src == TRIG_EXT)
-			devpriv->command4_bits |= EXT_SCAN_EN_BIT;
-	}
-	/*  single-ended/differential */
-	if (aref == AREF_DIFF)
-		devpriv->command4_bits |= ADC_DIFF_BIT;
-	devpriv->write_byte(devpriv->command4_bits, dev->iobase + COMMAND4_REG);
 
 	devpriv->write_byte(cmd->chanlist_len,
 			    dev->iobase + INTERVAL_COUNT_REG);
@@ -1376,6 +1361,22 @@ static int labpc_ai_cmd(struct comedi_de
 		devpriv->command3_bits &= ~ADC_FNE_INTR_EN_BIT;
 	devpriv->write_byte(devpriv->command3_bits, dev->iobase + COMMAND3_REG);
 
+	/*  setup any external triggering/pacing (command4 register) */
+	devpriv->command4_bits = 0;
+	if (cmd->convert_src != TRIG_EXT)
+		devpriv->command4_bits |= EXT_CONVERT_DISABLE_BIT;
+	/* XXX should discard first scan when using interval scanning
+	 * since manual says it is not synced with scan clock */
+	if (labpc_use_continuous_mode(cmd) == 0) {
+		devpriv->command4_bits |= INTERVAL_SCAN_EN_BIT;
+		if (cmd->scan_begin_src == TRIG_EXT)
+			devpriv->command4_bits |= EXT_SCAN_EN_BIT;
+	}
+	/*  single-ended/differential */
+	if (aref == AREF_DIFF)
+		devpriv->command4_bits |= ADC_DIFF_BIT;
+	devpriv->write_byte(devpriv->command4_bits, dev->iobase + COMMAND4_REG);
+
 	/*  startup acquisition */
 
 	/*  command2 reg */


