Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3FDXP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:15:59 -0400
Received: from 1wt.eu ([62.212.114.60]:35412 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab3FDWmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:15 -0400
Message-Id: <20130604172133.083450535@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 067/184] staging: comedi: ni_labpc: correct differential
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 channel sequence for AI commands

From: Ian Abbott <abbotti@mev.co.uk>

Commit 4c4bc25d0fa6beaf054c0b4c3b324487f266c820 upstream.

Tuomas <tvainikk _at_ gmail _dot_ com> reported problems getting
meaningful output from a Lab-PC+ in differential mode for AI cmds, but
AI insn reads gave correct readings.  He tracked it down to two
problems, one of which is addressed by this patch.

It seems the setting of the channel bits for particular scanning modes
was incorrect for differential mode.  (Only half the number of channels
are available in differential mode; comedi refers to them as channels 0,
1, 2 and 3, but the hardware documentation refers to them as channels 0,
2, 4 and 6.)  In differential mode, the setting of the channel enable
bits in the command1 register should depend on whether the scan enable
bit is set.  Effectively, we need to double the comedi channel number
when the scan enable bit is not set in differential mode.  The scan
enable bit gets set when the AI scan mode is `MODE_MULT_CHAN_UP` or
`MODE_MULT_CHAN_DOWN`, and gets cleared when the AI scan mode is
`MODE_SINGLE_CHAN` or `MODE_SINGLE_CHAN_INTERVAL`.  The existing test
for whether the comedi channel number needs to be doubled in
differential mode is incorrect in `labpc_ai_cmd()`.  This patch corrects
the test.

Thanks to Tuomas for suggesting the fix.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/comedi/drivers/ni_labpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 4ac745a..eada2ce 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1178,7 +1178,9 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	else
 		channel = CR_CHAN(cmd->chanlist[0]);
 	/*  munge channel bits for differential / scan disabled mode */
-	if (labpc_ai_scan_mode(cmd) != MODE_SINGLE_CHAN && aref == AREF_DIFF)
+	if ((labpc_ai_scan_mode(cmd) == MODE_SINGLE_CHAN ||
+	     labpc_ai_scan_mode(cmd) == MODE_SINGLE_CHAN_INTERVAL) &&
+	    aref == AREF_DIFF)
 		channel *= 2;
 	devpriv->command1_bits |= ADC_CHAN_BITS(channel);
 	devpriv->command1_bits |= thisboard->ai_range_code[range];
-- 
1.7.12.2.21.g234cd45.dirty



