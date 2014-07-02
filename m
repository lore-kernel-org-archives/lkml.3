Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaGBLCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:02:36 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36305 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaGBLCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:02:35 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: allow COMEDI_BUFINFO, COMEDI_CANCEL and COMEDI_POLL on locked subdevice
Date: Wed,  2 Jul 2014 12:02:16 +0100
Message-Id: <1404298936-5594-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comedi subdevices can be locked for mostly exclusive access by a
particular file object by means of the COMEDI_LOCK ioctl.  Some
operations disregard the lock.  For example, the read() and write() file
operations are allowed for the file object that set up an asynchronous
command on the subdevice (making it "busy") regardless of whether it is
locked.

The COMEDI_BUFINFO, COMEDI_CANCEL and COMEDI_POLL ioctls are also
associated with the file object that made the subdevice "busy" with a
command.  They currently obey the exclusive access lock on the subdevice
as well, but it makes more sense for them to ignore it like the read()
and write() file operations.  Remove the exclusive subdevice access
checks for these ioctls.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index d4904cc..e8e3809 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -968,9 +968,6 @@ static int do_bufinfo_ioctl(struct comedi_device *dev,
 
 	s = &dev->subdevices[bi.subdevice];
 
-	if (s->lock && s->lock != file)
-		return -EACCES;
-
 	async = s->async;
 
 	if (!async) {
@@ -1744,9 +1741,6 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
 	if (s->async == NULL)
 		return -EINVAL;
 
-	if (s->lock && s->lock != file)
-		return -EACCES;
-
 	if (!s->busy)
 		return 0;
 
@@ -1781,9 +1775,6 @@ static int do_poll_ioctl(struct comedi_device *dev, unsigned int arg,
 		return -EINVAL;
 	s = &dev->subdevices[arg];
 
-	if (s->lock && s->lock != file)
-		return -EACCES;
-
 	if (!s->busy)
 		return 0;
 
-- 
2.0.0

