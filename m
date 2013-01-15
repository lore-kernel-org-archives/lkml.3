Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467Ab3AOW5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:57:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:48644 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934446Ab3AOW5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:57:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>,
        =?ISO-8859-15?q?=C3=89ric=20Piel?= <piel@delmic.com>
Subject: [ 50/71] staging: comedi: comedi_test: fix race when cancelling command
Date: Tue, 15 Jan 2013 14:54:47 -0800
Message-Id: <20130115225344.018333401@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
 


