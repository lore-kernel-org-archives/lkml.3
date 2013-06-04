Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab3FDXMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:12:42 -0400
Received: from 1wt.eu ([62.212.114.60]:35446 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab3FDWmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:20 -0400
Message-Id: <20130604172133.125203398@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 068/184] staging: comedi: ni_labpc: set up command4 register
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 *after* command3

From: Ian Abbott <abbotti@mev.co.uk>

Commit 22056e2b46246d97ff0f7c6e21a77b8daa07f02c upstream.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/comedi/drivers/ni_labpc.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index eada2ce..76ca73a 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1195,21 +1195,6 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
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
@@ -1287,6 +1272,22 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
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
 	/*  startup aquisition */
 
 	/*  command2 reg */
-- 
1.7.12.2.21.g234cd45.dirty



