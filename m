Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615Ab3DGX27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:28:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46663 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934488Ab3DGX26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:28:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ian Abbott" <abbotti@mev.co.uk>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.27182830@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [29/74] staging: comedi: s626: fix continuous acquisition
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit e4317ce877a31dbb9d96375391c1c4ad2210d637 upstream.

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

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/s626.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1882,7 +1882,7 @@ static int s626_ai_cmd(struct comedi_dev
 	case TRIG_NONE:
 		/*  continous acquisition */
 		devpriv->ai_continous = 1;
-		devpriv->ai_sample_count = 0;
+		devpriv->ai_sample_count = 1;
 		break;
 	}
 

