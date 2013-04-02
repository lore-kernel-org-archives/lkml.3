Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797Ab3DBXFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:05:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab3DBWua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 07/56] staging: comedi: s626: fix continuous acquisition
Date: Tue,  2 Apr 2013 15:49:34 -0700
Message-Id: <20130402224712.723596018@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
 


