Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3CAT4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:56:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3CATqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 42/46] staging: comedi: check s->async for poll(), read() and write()
Date: Fri,  1 Mar 2013 11:45:30 -0800
Message-Id: <20130301194436.678964336@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit cc400e185c07c15a42d2635995f422de5b94b696 upstream.

Some low-level comedi drivers (incorrectly) point `dev->read_subdev` or
`dev->write_subdev` to a subdevice that does not support asynchronous
commands.  Comedi's poll(), read() and write() file operation handlers
assume these subdevices do support asynchronous commands.  In
particular, they assume `s->async` is valid (where `s` points to the
read or write subdevice), which it won't be if it has been set
incorrectly.  This can lead to a NULL pointer dereference.

Check `s->async` is non-NULL in `comedi_poll()`, `comedi_read()` and
`comedi_write()` to avoid the bug.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/comedi_fops.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1577,7 +1577,7 @@ static unsigned int comedi_poll(struct f
 
 	mask = 0;
 	read_subdev = comedi_get_read_subdevice(dev_file_info);
-	if (read_subdev) {
+	if (read_subdev && read_subdev->async) {
 		poll_wait(file, &read_subdev->async->wait_head, wait);
 		if (!read_subdev->busy
 		    || comedi_buf_read_n_available(read_subdev->async) > 0
@@ -1587,7 +1587,7 @@ static unsigned int comedi_poll(struct f
 		}
 	}
 	write_subdev = comedi_get_write_subdevice(dev_file_info);
-	if (write_subdev) {
+	if (write_subdev && write_subdev->async) {
 		poll_wait(file, &write_subdev->async->wait_head, wait);
 		comedi_buf_write_alloc(write_subdev->async,
 				       write_subdev->async->prealloc_bufsz);
@@ -1629,7 +1629,7 @@ static ssize_t comedi_write(struct file
 	}
 
 	s = comedi_get_write_subdevice(dev_file_info);
-	if (s == NULL) {
+	if (s == NULL || s->async == NULL) {
 		retval = -EIO;
 		goto done;
 	}
@@ -1740,7 +1740,7 @@ static ssize_t comedi_read(struct file *
 	}
 
 	s = comedi_get_read_subdevice(dev_file_info);
-	if (s == NULL) {
+	if (s == NULL || s->async == NULL) {
 		retval = -EIO;
 		goto done;
 	}


