Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505Ab3HBKJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:09:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758929Ab3HBKJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 35/99] staging: comedi: COMEDI_CANCEL ioctl should wake up read/write
Date: Fri,  2 Aug 2013 18:07:48 +0800
Message-Id: <20130802100230.968674712@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/comedi/comedi_fops.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1692,6 +1692,7 @@ static int do_cancel_ioctl(struct comedi
 			   void *file)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	if (arg >= dev->n_subdevices)
 		return -EINVAL;
@@ -1708,7 +1709,11 @@ static int do_cancel_ioctl(struct comedi
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


