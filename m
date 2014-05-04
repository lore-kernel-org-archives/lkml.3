Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbaEDQrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:47:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaEDPlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>, Bernd Porr <mail@berndporr.me.uk>
Subject: [PATCH 3.14 054/158] staging: comedi: usbdux: bug fix for accessing ao_chanlist in private data
Date: Sun,  4 May 2014 11:39:23 -0400
Message-Id: <20140504154037.300985784@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H Hartley Sweeten <hsweeten@visionengravers.com>

commit 2704f807f9498054b8153002bafa3e818079e9a5 upstream.

In usbdux_ao_cmd(), the channels for the command are transfered from the
cmd->chanlist and stored in the private data 'ao_chanlist'. The channel
numbers are bit-shifted when stored so that they become the "command"
that is transfered to the device. The channel to command conversion
results in the 'ao_chanlist' having these values for the channels:

  channel 0 -> ao_chanlist = 0x00
  channel 1 -> ao_chanlist = 0x40
  channel 2 -> ao_chanlist = 0x80
  channel 3 -> ao_chanlist = 0xc0

The problem is, the usbduxsub_ao_isoc_irq() function uses the 'chan' value
from 'ao_chanlist' to access the 'ao_readback' array in the private data.
So instead of accessing the array as 0, 1, 2, 3, it accesses it as 0x00,
0x40, 0x80, 0xc0.

Fix this by storing the raw channel number in 'ao_chanlist' and doing the
bit-shift when creating the command.

Fixes: a998a3db530bff80 "staging: comedi: usbdux: cleanup the private data 'outBuffer'"
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: Bernd Porr <mail@berndporr.me.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/usbdux.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -493,7 +493,7 @@ static void usbduxsub_ao_isoc_irq(struct
 			/* pointer to the DA */
 			*datap++ = val & 0xff;
 			*datap++ = (val >> 8) & 0xff;
-			*datap++ = chan;
+			*datap++ = chan << 6;
 			devpriv->ao_readback[chan] = val;
 
 			s->async->events |= COMEDI_CB_BLOCK;
@@ -1040,11 +1040,8 @@ static int usbdux_ao_cmd(struct comedi_d
 	/* set current channel of the running acquisition to zero */
 	s->async->cur_chan = 0;
 
-	for (i = 0; i < cmd->chanlist_len; ++i) {
-		unsigned int chan = CR_CHAN(cmd->chanlist[i]);
-
-		devpriv->ao_chanlist[i] = chan << 6;
-	}
+	for (i = 0; i < cmd->chanlist_len; ++i)
+		devpriv->ao_chanlist[i] = CR_CHAN(cmd->chanlist[i]);
 
 	/* we count in steps of 1ms (125us) */
 	/* 125us mode not used yet */


