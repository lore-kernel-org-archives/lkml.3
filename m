Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934777AbaJ2Rft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:35:49 -0400
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:53406 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934130AbaJ2Rfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:35:34 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] staging: comedi: das16: use spin-lock when setting timer
Date: Wed, 29 Oct 2014 17:35:12 +0000
Message-Id: <1414604112-4362-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414604112-4362-1-git-send-email-abbotti@mev.co.uk>
References: <1414604112-4362-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"das16" sets a timer running in `das16_cmd_exec()` and sets
`devpriv->timer_running` to indicate that it is running.  The timer
expiration routine `das16_timer_interrupt()` checks
`devpriv->timer_running` to check whether it needs to reschedule the
timer, but this is not synchronized with `das16_cmd_exec()`.  Since
`das16_cancel()` acquires the `dev->spinlock` spin-lock when clearing
`devpriv->timer_running` and removing the timer from the queue, use the
same spin-lock in `das16_cmd_exec()` and `das16_timer_interrupt()`
around the setting and checking of `devpriv->timer_running`.

Since `das16_interrupt()` (called from `das16_timer_interrupt()`) checks
whether DMA is enabled in the device while holding `dev->spinlock`, and
DMA is enabled by `das16_cmd_exec()` around the time it schedules the
timer, enable the DMA in the device while holding the spin-lock.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/das16.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 51c4a58..3d38404 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -593,11 +593,14 @@ static void das16_timer_interrupt(unsigned long arg)
 {
 	struct comedi_device *dev = (struct comedi_device *)arg;
 	struct das16_private_struct *devpriv = dev->private;
+	unsigned long flags;
 
 	das16_interrupt(dev);
 
+	spin_lock_irqsave(&dev->spinlock, flags);
 	if (devpriv->timer_running)
 		mod_timer(&devpriv->timer, jiffies + timer_period());
+	spin_unlock_irqrestore(&dev->spinlock, flags);
 }
 
 static int das16_ai_check_chanlist(struct comedi_device *dev,
@@ -814,7 +817,8 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 	enable_dma(devpriv->dma_chan);
 	release_dma_lock(flags);
 
-	/*  set up interrupt */
+	/*  set up timer */
+	spin_lock_irqsave(&dev->spinlock, flags);
 	devpriv->timer_running = 1;
 	devpriv->timer.expires = jiffies + timer_period();
 	add_timer(&devpriv->timer);
@@ -823,6 +827,7 @@ static int das16_cmd_exec(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	if (devpriv->can_burst)
 		outb(0, dev->iobase + DAS1600_CONV_REG);
+	spin_unlock_irqrestore(&dev->spinlock, flags);
 
 	return 0;
 }
-- 
2.1.1

