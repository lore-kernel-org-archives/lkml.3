Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbaJ3KEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:04:43 -0400
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:52889 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754839AbaJ3KEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:04:42 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] staging: comedi: comedi_test: fix timer lock-up
Date: Thu, 30 Oct 2014 10:03:53 +0000
Message-Id: <1414663433-11137-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414501642-14261-1-git-send-email-abbotti@mev.co.uk>
References: <1414501642-14261-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 240512474424 ("staging: comedi: comedi_test: use
comedi_handle_events()") resulted in the timer routine
`waveform_ai_interrupt()` calling `comedi_handle_events()` instead of
`comedi_events()`.  That had the advantage of automatically stopping the
acquisition on overflow/error/end-of-acquisition conditions (by calling
the comedi subdevice's "cancel" handler), but currently results in the
timer routine locking when one of those conditions occur.  This is
because the "cancel" handler `waveform_ai_cancel()` calls
`del_timer_sync()`.

Fix it by adding a bit to the device private data that indicates whether
the acquisition is active or not, and changing the "cancel" handler to
use `del_timer()` instead of `del_timer_sync()`.  The bit is set when
starting the acquisition, cleared when ending the acquisition (in the
"cancel" handler), and tested in the timer routine, which will do
nothing if the acquisition is inactive.  Also, make sure any scheduled
timeout event gets cancelled when the low-level device gets "detached"
from the comedi core by calling `del_timer_sync()` in the "detach"
handler `waveform_detach()`.

Fixes: 240512474424 ("staging: comedi: comedi_test: use comedi_handle_events()")
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
v2: rebased after commit dd28153b2a8ca
Greg, this fix is for "linux-next" and "staging-next".
---
 drivers/staging/comedi/drivers/comedi_test.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 4d4358c..e1a11c4 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -56,6 +56,10 @@ zero volts).
 
 #define N_CHANS 8
 
+enum waveform_state_bits {
+	WAVEFORM_AI_RUNNING = 0
+};
+
 /* Data unique to this driver */
 struct waveform_private {
 	struct timer_list timer;
@@ -65,6 +69,7 @@ struct waveform_private {
 	unsigned long usec_current;	/* current time (mod waveform period) */
 	unsigned long usec_remainder;	/* usec since last scan */
 	unsigned long ai_count;		/* number of conversions remaining */
+	unsigned long state_bits;
 	unsigned int scan_period;	/* scan period in usec */
 	unsigned int convert_period;	/* conversion period in usec */
 	unsigned int ao_loopbacks[N_CHANS];
@@ -175,6 +180,10 @@ static void waveform_ai_interrupt(unsigned long arg)
 	ktime_t now;
 	bool stopping = false;
 
+	/* check command is still active */
+	if (!test_bit(WAVEFORM_AI_RUNNING, &devpriv->state_bits))
+		return;
+
 	now = ktime_get();
 
 	elapsed_time = ktime_to_us(ktime_sub(now, devpriv->last));
@@ -322,6 +331,10 @@ static int waveform_ai_cmd(struct comedi_device *dev,
 	devpriv->usec_remainder = 0;
 
 	devpriv->timer.expires = jiffies + 1;
+	/* mark command as active */
+	smp_mb__before_atomic();
+	set_bit(WAVEFORM_AI_RUNNING, &devpriv->state_bits);
+	smp_mb__after_atomic();
 	add_timer(&devpriv->timer);
 	return 0;
 }
@@ -331,7 +344,11 @@ static int waveform_ai_cancel(struct comedi_device *dev,
 {
 	struct waveform_private *devpriv = dev->private;
 
-	del_timer_sync(&devpriv->timer);
+	/* mark command as no longer active */
+	clear_bit(WAVEFORM_AI_RUNNING, &devpriv->state_bits);
+	smp_mb__after_atomic();
+	/* cannot call del_timer_sync() as may be called from timer routine */
+	del_timer(&devpriv->timer);
 	return 0;
 }
 
@@ -433,7 +450,7 @@ static void waveform_detach(struct comedi_device *dev)
 	struct waveform_private *devpriv = dev->private;
 
 	if (devpriv)
-		waveform_ai_cancel(dev, dev->read_subdev);
+		del_timer_sync(&devpriv->timer);
 }
 
 static struct comedi_driver waveform_driver = {
-- 
2.1.1

