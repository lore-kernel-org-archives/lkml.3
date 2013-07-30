Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab3G3Jdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:33:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53362 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab3G3Jdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 090/106] staging: comedi: COMEDI_CANCEL ioctl should wake up read/write
Date: Tue, 30 Jul 2013 10:31:49 +0100
Message-Id: <1375176725-5825-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 69acbaac303e8cb948801a9ddd0ac24e86cc4a1b upstream.

Comedi devices can do blocking read() or write() (or poll()) if an
asynchronous command has been set up, blocking for data (for read()) or
buffer space (for write()).  Various events associated with the
asynchronous command will wake up the blocked reader or writer (or
poller).  It is also possible to force the asynchronous command to
terminate by issuing a `COMEDI_CANCEL` ioctl.  That shuts down the
asynchronous command, but does not currently wake up the blocked reader
or writer (or poller).  If the blocked task could be woken up, it would
see that the command is no longer active and return.  The caller of the
`COMEDI_CANCEL` ioctl could attempt to wake up the blocked task by
sending a signal, but that's a nasty workaround.

Change `do_cancel_ioctl()` to wake up the wait queue after it returns
from `do_cancel()`.  `do_cancel()` can propagate an error return value
from the low-level comedi driver's cancel routine, but it always shuts
the command down regardless, so `do_cancel_ioctl()` can wake up he wait
queue regardless of the return value from `do_cancel()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/comedi_fops.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index b08cbbe..d028e8c 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1659,6 +1659,7 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
 			   void *file)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	if (arg >= dev->n_subdevices)
 		return -EINVAL;
@@ -1675,7 +1676,11 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
 	if (s->busy != file)
 		return -EBUSY;
 
-	return do_cancel(dev, s);
+	ret = do_cancel(dev, s);
+	if (comedi_get_subdevice_runflags(s) & SRF_USER)
+		wake_up_interruptible(&s->async->wait_head);
+
+	return ret;
 }
 
 /*
-- 
1.8.3.2

