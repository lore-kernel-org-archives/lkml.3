Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3FDXPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:15:00 -0400
Received: from 1wt.eu ([62.212.114.60]:35413 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab3FDWmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:16 -0400
Message-Id: <20130604172133.166370388@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 069/184] staging: comedi: comedi_test: fix race when
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 cancelling command

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/comedi/drivers/comedi_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index ef83a1a..7a1e2e8 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -450,7 +450,7 @@ static int waveform_ai_cancel(struct comedi_device *dev,
 			      struct comedi_subdevice *s)
 {
 	devpriv->timer_running = 0;
-	del_timer(&devpriv->timer);
+	del_timer_sync(&devpriv->timer);
 	return 0;
 }
 
-- 
1.7.12.2.21.g234cd45.dirty



