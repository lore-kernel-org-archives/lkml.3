Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3CATsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:48:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3CATqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 28/30] staging: comedi: ni_labpc: correct differential channel sequence for AI commands
Date: Fri,  1 Mar 2013 11:45:49 -0800
Message-Id: <20130301194531.053015341@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194527.988540148@linuxfoundation.org>
References: <20130301194527.988540148@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/ni_labpc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1241,7 +1241,9 @@ static int labpc_ai_cmd(struct comedi_de
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


