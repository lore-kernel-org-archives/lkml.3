Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3CDEO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:14:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60884 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755665Ab3CDDmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:54 -0500
Message-Id: <20130304033720.067175720@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:14 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [ 127/153] staging: comedi: ni_labpc: correct  differential channel sequence for AI commands
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

commit 4c4bc25d0fa6beaf054c0b4c3b324487f266c820 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/ni_labpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1264,7 +1264,9 @@ static int labpc_ai_cmd(struct comedi_de
 	else
 		channel = CR_CHAN(cmd->chanlist[0]);
 	/* munge channel bits for differential / scan disabled mode */
-	if (labpc_ai_scan_mode(cmd) != MODE_SINGLE_CHAN && aref == AREF_DIFF)
+	if ((labpc_ai_scan_mode(cmd) == MODE_SINGLE_CHAN ||
+	     labpc_ai_scan_mode(cmd) == MODE_SINGLE_CHAN_INTERVAL) &&
+	    aref == AREF_DIFF)
 		channel *= 2;
 	devpriv->command1_bits |= ADC_CHAN_BITS(channel);
 	devpriv->command1_bits |= thisboard->ai_range_code[range];


