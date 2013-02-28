Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3B1Owi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:52:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933232Ab3B1Ove (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 138/139] staging: comedi: ni_labpc: set up command4 register *after* command3
Date: Thu, 28 Feb 2013 14:44:48 +0000
Message-Id: <1362062689-2567-139-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/ni_labpc.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 5334977..5b2b966 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1275,21 +1275,6 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
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
@@ -1369,6 +1354,22 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
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
-- 
1.8.1.2

