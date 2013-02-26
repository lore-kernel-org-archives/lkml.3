Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab3B0A5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:57:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760283Ab3BZX6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 095/150] staging: comedi: ni_labpc: correct differential channel sequence for AI commands
Date: Tue, 26 Feb 2013 15:55:52 -0800
Message-Id: <20130226235533.937535450@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/ni_labpc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -1202,7 +1202,8 @@ static int labpc_ai_cmd(struct comedi_de
 	else
 		channel = CR_CHAN(cmd->chanlist[0]);
 	/* munge channel bits for differential / scan disabled mode */
-	if (mode != MODE_SINGLE_CHAN && aref == AREF_DIFF)
+	if ((mode == MODE_SINGLE_CHAN || mode == MODE_SINGLE_CHAN_INTERVAL) &&
+	    aref == AREF_DIFF)
 		channel *= 2;
 	devpriv->command1_bits |= ADC_CHAN_BITS(channel);
 	devpriv->command1_bits |= thisboard->ai_range_code[range];


