Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab3BZX6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:58:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab3BZX6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 094/150] staging: comedi: ni_labpc: set up command4 register *after* command3
Date: Tue, 26 Feb 2013 15:55:51 -0800
Message-Id: <20130226235533.841414371@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/ni_labpc.c |   31 +++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1217,21 +1217,6 @@ static int labpc_ai_cmd(struct comedi_de
 		devpriv->write_byte(devpriv->command1_bits,
 				    dev->iobase + COMMAND1_REG);
 	}
-	/*  setup any external triggering/pacing (command4 register) */
-	devpriv->command4_bits = 0;
-	if (cmd->convert_src != TRIG_EXT)
-		devpriv->command4_bits |= EXT_CONVERT_DISABLE_BIT;
-	/* XXX should discard first scan when using interval scanning
-	 * since manual says it is not synced with scan clock */
-	if (labpc_use_continuous_mode(cmd, mode) == 0) {
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
@@ -1311,6 +1296,22 @@ static int labpc_ai_cmd(struct comedi_de
 		devpriv->command3_bits &= ~ADC_FNE_INTR_EN_BIT;
 	devpriv->write_byte(devpriv->command3_bits, dev->iobase + COMMAND3_REG);
 
+	/*  setup any external triggering/pacing (command4 register) */
+	devpriv->command4_bits = 0;
+	if (cmd->convert_src != TRIG_EXT)
+		devpriv->command4_bits |= EXT_CONVERT_DISABLE_BIT;
+	/* XXX should discard first scan when using interval scanning
+	 * since manual says it is not synced with scan clock */
+	if (labpc_use_continuous_mode(cmd, mode) == 0) {
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


