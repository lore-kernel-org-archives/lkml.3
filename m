Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab3GaNZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:25:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46895 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759644Ab3GaNZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ian Abbott" <abbotti@mev.co.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.131639081@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [71/84] staging: comedi: COMEDI_CANCEL ioctl should wake up
 read/write
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/comedi_fops.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1370,6 +1370,7 @@ static int do_cancel_ioctl(struct comedi
 			   void *file)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	if (arg >= dev->n_subdevices)
 		return -EINVAL;
@@ -1386,7 +1387,11 @@ static int do_cancel_ioctl(struct comedi
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

