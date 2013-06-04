Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3FDWrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:47:11 -0400
Received: from 1wt.eu ([62.212.114.60]:35923 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab3FDWom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:42 -0400
Message-Id: <20130604172133.372622019@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 074/184] staging: comedi: check s->async for poll(), read()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 and write()

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/comedi/comedi_fops.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 193b836..90810e8 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1498,7 +1498,7 @@ static unsigned int comedi_poll(struct file *file, poll_table * wait)
 
 	mask = 0;
 	read_subdev = comedi_get_read_subdevice(dev_file_info);
-	if (read_subdev) {
+	if (read_subdev && read_subdev->async) {
 		poll_wait(file, &read_subdev->async->wait_head, wait);
 		if (!read_subdev->busy
 		    || comedi_buf_read_n_available(read_subdev->async) > 0
@@ -1508,7 +1508,7 @@ static unsigned int comedi_poll(struct file *file, poll_table * wait)
 		}
 	}
 	write_subdev = comedi_get_write_subdevice(dev_file_info);
-	if (write_subdev) {
+	if (write_subdev && write_subdev->async) {
 		poll_wait(file, &write_subdev->async->wait_head, wait);
 		comedi_buf_write_alloc(write_subdev->async,
 				       write_subdev->async->prealloc_bufsz);
@@ -1550,7 +1550,7 @@ static ssize_t comedi_write(struct file *file, const char *buf, size_t nbytes,
 	}
 
 	s = comedi_get_write_subdevice(dev_file_info);
-	if (s == NULL) {
+	if (s == NULL || s->async == NULL) {
 		retval = -EIO;
 		goto done;
 	}
@@ -1658,7 +1658,7 @@ static ssize_t comedi_read(struct file *file, char *buf, size_t nbytes,
 	}
 
 	s = comedi_get_read_subdevice(dev_file_info);
-	if (s == NULL) {
+	if (s == NULL || s->async == NULL) {
 		retval = -EIO;
 		goto done;
 	}
-- 
1.7.12.2.21.g234cd45.dirty



