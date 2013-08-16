Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab3HPWol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:44:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51941 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab3HPWlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 025/133] staging: comedi: COMEDI_CANCEL ioctl should wake up read/write
Date: Fri, 16 Aug 2013 15:32:47 -0700
Message-Id: <1376692475-28413-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/comedi/comedi_fops.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 6894b3e..929452e 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1472,6 +1472,7 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
 			   void *file)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	if (arg >= dev->n_subdevices)
 		return -EINVAL;
@@ -1488,7 +1489,11 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
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
1.8.1.2

