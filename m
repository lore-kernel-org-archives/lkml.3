Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3CDDo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:44:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33187 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757343Ab3CDDox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:53 -0500
Message-Id: <20130304033710.422468600@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:36 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [ 029/153] staging: comedi: check s->async for poll(), read() and write()
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/comedi_fops.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1574,7 +1574,7 @@ static unsigned int comedi_poll(struct f
 
 	mask = 0;
 	read_subdev = comedi_get_read_subdevice(dev_file_info);
-	if (read_subdev) {
+	if (read_subdev && read_subdev->async) {
 		poll_wait(file, &read_subdev->async->wait_head, wait);
 		if (!read_subdev->busy
 		    || comedi_buf_read_n_available(read_subdev->async) > 0
@@ -1584,7 +1584,7 @@ static unsigned int comedi_poll(struct f
 		}
 	}
 	write_subdev = comedi_get_write_subdevice(dev_file_info);
-	if (write_subdev) {
+	if (write_subdev && write_subdev->async) {
 		poll_wait(file, &write_subdev->async->wait_head, wait);
 		comedi_buf_write_alloc(write_subdev->async,
 				       write_subdev->async->prealloc_bufsz);
@@ -1626,7 +1626,7 @@ static ssize_t comedi_write(struct file
 	}
 
 	s = comedi_get_write_subdevice(dev_file_info);
-	if (s == NULL) {
+	if (s == NULL || s->async == NULL) {
 		retval = -EIO;
 		goto done;
 	}
@@ -1737,7 +1737,7 @@ static ssize_t comedi_read(struct file *
 	}
 
 	s = comedi_get_read_subdevice(dev_file_info);
-	if (s == NULL) {
+	if (s == NULL || s->async == NULL) {
 		retval = -EIO;
 		goto done;
 	}


