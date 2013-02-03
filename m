Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab3BCPVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:21:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34147 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500Ab3BCOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:11 -0500
Message-Id: <20130203144646.179760100@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ian Abbott <abbotti@mev.co.uk>,
        =?ISO-8859-15?q?=C3=89ric=20Piel?= <piel@delmic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 024/128] staging: comedi: comedi_test: fix race when cancelling command
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit c0729eeefdcd76db338f635162bf0739fd2c5f6f upstream.

Éric Piel reported a kernel oops in the "comedi_test" module.  It was a
NULL pointer dereference within `waveform_ai_interrupt()` (actually a
timer function) that sometimes occurred when a running asynchronous
command is cancelled (either by the `COMEDI_CANCEL` ioctl or by closing
the device file).

This seems to be a race between the caller of `waveform_ai_cancel()`
which on return from that function goes and tears down the running
command, and the timer function which uses the command.  In particular,
`async->cmd.chanlist` gets freed (and the pointer set to NULL) by
`do_become_nonbusy()` in "comedi_fops.c" but a previously scheduled
`waveform_ai_interrupt()` timer function will dereference that pointer
regardless, leading to the oops.

Fix it by replacing the `del_timer()` call in `waveform_ai_cancel()`
with `del_timer_sync()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Reported-by: Éric Piel <piel@delmic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/comedi_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -461,7 +461,7 @@ static int waveform_ai_cancel(struct com
 			      struct comedi_subdevice *s)
 {
 	devpriv->timer_running = 0;
-	del_timer(&devpriv->timer);
+	del_timer_sync(&devpriv->timer);
 	return 0;
 }
 


