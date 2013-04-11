Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936200Ab3DKU4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:56:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11236 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935855Ab3DKUt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:27 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Ixi7kM76hDYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=18Pwlee28WUA:10 a=v8_uC2TkAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=dVFtqek8c9QA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=WlfalsAKN0eYxt_Y:21 a=R_l5gDAl_ejiXsgC:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202559.008301449@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 078/171 ] staging: comedi: s626: fix continuous acquisition
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0078-staging-comedi-s626-fix-continuous-acquisition.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit e4317ce877a31dbb9d96375391c1c4ad2210d637 ]

For the s626 driver, there is a bug in the handling of asynchronous
commands on the AI subdevice when the stop source is `TRIG_NONE`.  The
command should run continuously until cancelled, but the interrupt
handler stops the command running after the first scan.

The command set-up function `s626_ai_cmd()` contains this code:

	switch (cmd->stop_src) {
	case TRIG_COUNT:
		/*  data arrives as one packet */
		devpriv->ai_sample_count = cmd->stop_arg;
		devpriv->ai_continous = 0;
		break;
	case TRIG_NONE:
		/*  continous acquisition */
		devpriv->ai_continous = 1;
		devpriv->ai_sample_count = 0;
		break;
	}

The interrupt handler `s626_irq_handler()` contains this code:

		if (!(devpriv->ai_continous))
			devpriv->ai_sample_count--;
		if (devpriv->ai_sample_count <= 0) {
			devpriv->ai_cmd_running = 0;
			/* ... */
		}

So `devpriv->ai_sample_count` is only decremented for the `TRIG_COUNT`
case, but `devpriv->ai_cmd_running` is set to 0 (and the command
stopped) regardless.

Fix this in `s626_ai_cmd()` by setting `devpriv->ai_sample_count = 1`
for the `TRIG_NONE` case.  The interrupt handler will not decrement it
so it will remain greater than 0 and the check for stopping the
acquisition will fail.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/staging/comedi/drivers/s626.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 2b03b68..f809ef3 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1509,7 +1509,7 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	case TRIG_NONE:
 		/*  continous acquisition */
 		devpriv->ai_continous = 1;
-		devpriv->ai_sample_count = 0;
+		devpriv->ai_sample_count = 1;
 		break;
 	}
 
-- 
1.7.10.4


