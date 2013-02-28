Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab3B1PSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:18:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41994 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab3B1OrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 031/139] staging: comedi: check s->async for poll(), read() and write()
Date: Thu, 28 Feb 2013 14:43:01 +0000
Message-Id: <1362062689-2567-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: adjust context, variables names ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/comedi_fops.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 2831080..b08cbbe 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1866,7 +1866,7 @@ static unsigned int comedi_poll(struct file *file, poll_table *wait)
 
 	mask = 0;
 	read_subdev = comedi_get_read_subdevice(dev_file_info);
-	if (read_subdev) {
+	if (read_subdev && read_subdev->async) {
 		poll_wait(file, &read_subdev->async->wait_head, wait);
 		if (!read_subdev->busy
 		    || comedi_buf_read_n_available(read_subdev->async) > 0
@@ -1876,7 +1876,7 @@ static unsigned int comedi_poll(struct file *file, poll_table *wait)
 		}
 	}
 	write_subdev = comedi_get_write_subdevice(dev_file_info);
-	if (write_subdev) {
+	if (write_subdev && write_subdev->async) {
 		poll_wait(file, &write_subdev->async->wait_head, wait);
 		comedi_buf_write_alloc(write_subdev->async,
 				       write_subdev->async->prealloc_bufsz);
@@ -1918,7 +1918,7 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 	}
 
 	s = comedi_get_write_subdevice(dev_file_info);
-	if (s == NULL) {
+	if (!s || !s->async) {
 		retval = -EIO;
 		goto done;
 	}
@@ -2029,7 +2029,7 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 	}
 
 	s = comedi_get_read_subdevice(dev_file_info);
-	if (s == NULL) {
+	if (!s || !s->async) {
 		retval = -EIO;
 		goto done;
 	}
-- 
1.8.1.2

