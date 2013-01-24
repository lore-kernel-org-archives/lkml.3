Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3AXDaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:30:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3AXD30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:26 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 29/74] staging: comedi: comedi_test: fix race when cancelling command
Date: Thu, 24 Jan 2013 01:26:41 -0200
Message-Id: <1358998046-613-30-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/comedi/drivers/comedi_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index 873e374..806c397 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -398,7 +398,7 @@ static int waveform_ai_cancel(struct comedi_device *dev,
 			      struct comedi_subdevice *s)
 {
 	devpriv->timer_running = 0;
-	del_timer(&devpriv->timer);
+	del_timer_sync(&devpriv->timer);
 	return 0;
 }
 
-- 
1.7.9.5

