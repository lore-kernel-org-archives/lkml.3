Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbaEMKFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:05:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60805 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760064AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 048/182] staging: comedi: usbdux: bug fix for accessing 'ao_chanlist' in private data
Date: Tue, 13 May 2014 11:26:40 +0200
Message-Id: <c4ec377c9b6d02448a771ba9b22b04a51413d03b.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hsweeten@visionengravers.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/comedi/drivers/usbdux.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 701ad1a69394..4fbe303e8186 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -494,7 +494,7 @@ static void usbduxsub_ao_isoc_irq(struct urb *urb)
 			/* pointer to the DA */
 			*datap++ = val & 0xff;
 			*datap++ = (val >> 8) & 0xff;
-			*datap++ = chan;
+			*datap++ = chan << 6;
 			devpriv->ao_readback[chan] = val;
 
 			s->async->events |= COMEDI_CB_BLOCK;
@@ -1040,11 +1040,8 @@ static int usbdux_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
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
-- 
1.9.3

