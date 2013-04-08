Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935563Ab3DHJvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:51:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42715 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935540Ab3DHJvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:36 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 028/102] staging: comedi: s626: fix continuous acquisition
Date: Mon,  8 Apr 2013 10:49:43 +0100
Message-Id: <1365414657-29191-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/s626.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index e68e474..9c6b758 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1823,7 +1823,7 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	case TRIG_NONE:
 		/*  continous acquisition */
 		devpriv->ai_continous = 1;
-		devpriv->ai_sample_count = 0;
+		devpriv->ai_sample_count = 1;
 		break;
 	}
 
-- 
1.8.1.2

