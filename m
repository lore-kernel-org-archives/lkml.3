Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3IKS0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:26:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11021 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3IKS0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:26:45 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=1-5Fvpkf_ggA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=p0fUubgcrXwA:10 a=v8_uC2TkAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=7V7tsg6NAf3Z5ji50uEA:9 a=dVFtqek8c9QA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042907.919175166@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [094/251] staging: comedi: COMEDI_CANCEL ioctl should wake up read/write
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0094-staging-comedi-COMEDI_CANCEL-ioctl-should-wake-up-re.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 69acbaac303e8cb948801a9ddd0ac24e86cc4a1b ]

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
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/staging/comedi/comedi_fops.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 41dea18..d29b050 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1470,6 +1470,7 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
 			   void *file)
 {
 	struct comedi_subdevice *s;
+	int ret;
 
 	if (arg >= dev->n_subdevices)
 		return -EINVAL;
@@ -1486,7 +1487,11 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
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
1.7.10.4


