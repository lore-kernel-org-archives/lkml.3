Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab3G3Jej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:34:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53440 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab3G3JeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:34:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 105/106] staging: comedi: fix a race between do_cmd_ioctl() and read/write
Date: Tue, 30 Jul 2013 10:32:04 +0100
Message-Id: <1375176725-5825-106-git-send-email-luis.henriques@canonical.com>
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

commit 4b18f08be01a7b3c7b6df497137b6e3cb28adaa3 upstream.

`do_cmd_ioctl()` is called with the comedi device's mutex locked to
process the `COMEDI_CMD` ioctl to set up comedi's asynchronous command
handling on a comedi subdevice.  `comedi_read()` and `comedi_write()`
are the `read` and `write` handlers for the comedi device, but do not
lock the mutex (for performance reasons, as some things can hold the
mutex for quite a long time).

There is a race condition if `comedi_read()` or `comedi_write()` is
running at the same time and for the same file object and comedi
subdevice as `do_cmd_ioctl()`.  `do_cmd_ioctl()` sets the subdevice's
`busy` pointer to the file object way before it sets the `SRF_RUNNING` flag
in the subdevice's `runflags` member.  `comedi_read() and
`comedi_write()` check the subdevice's `busy` pointer is pointing to the
current file object, then if the `SRF_RUNNING` flag is not set, will call
`do_become_nonbusy()` to shut down the asyncronous command.  Bad things
can happen if the asynchronous command is being shutdown and set up at
the same time.

To prevent the race, don't set the `busy` pointer until
after the `SRF_RUNNING` flag has been set.  Also, make sure the mutex is
held in `comedi_read()` and `comedi_write()` while calling
`do_become_nonbusy()` in order to avoid moving the race condition to a
point within that function.

Change some error handling `goto cleanup` statements in `do_cmd_ioctl()`
to simple `return -ERRFOO` statements as a result of changing when the
`busy` pointer is set.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/comedi_fops.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index d028e8c..8c38317 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1367,22 +1367,19 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 		DPRINTK("subdevice busy\n");
 		return -EBUSY;
 	}
-	s->busy = file;
 
 	/* make sure channel/gain list isn't too long */
 	if (user_cmd.chanlist_len > s->len_chanlist) {
 		DPRINTK("channel/gain list too long %u > %d\n",
 			user_cmd.chanlist_len, s->len_chanlist);
-		ret = -EINVAL;
-		goto cleanup;
+		return -EINVAL;
 	}
 
 	/* make sure channel/gain list isn't too short */
 	if (user_cmd.chanlist_len < 1) {
 		DPRINTK("channel/gain list too short %u < 1\n",
 			user_cmd.chanlist_len);
-		ret = -EINVAL;
-		goto cleanup;
+		return -EINVAL;
 	}
 
 	async->cmd = user_cmd;
@@ -1392,8 +1389,7 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 	    kmalloc(async->cmd.chanlist_len * sizeof(int), GFP_KERNEL);
 	if (!async->cmd.chanlist) {
 		DPRINTK("allocation failed\n");
-		ret = -ENOMEM;
-		goto cleanup;
+		return -ENOMEM;
 	}
 
 	if (copy_from_user(async->cmd.chanlist, user_cmd.chanlist,
@@ -1445,6 +1441,9 @@ static int do_cmd_ioctl(struct comedi_device *dev,
 
 	comedi_set_subdevice_runflags(s, ~0, SRF_USER | SRF_RUNNING);
 
+	/* set s->busy _after_ setting SRF_RUNNING flag to avoid race with
+	 * comedi_read() or comedi_write() */
+	s->busy = file;
 	ret = s->do_cmd(dev, s);
 	if (ret == 0)
 		return 0;
@@ -1947,6 +1946,7 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 
 		if (!(comedi_get_subdevice_runflags(s) & SRF_RUNNING)) {
 			if (count == 0) {
+				mutex_lock(&dev->mutex);
 				if (comedi_get_subdevice_runflags(s) &
 					SRF_ERROR) {
 					retval = -EPIPE;
@@ -1954,6 +1954,7 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 					retval = 0;
 				}
 				do_become_nonbusy(dev, s);
+				mutex_unlock(&dev->mutex);
 			}
 			break;
 		}
@@ -2068,6 +2069,7 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 
 		if (n == 0) {
 			if (!(comedi_get_subdevice_runflags(s) & SRF_RUNNING)) {
+				mutex_lock(&dev->mutex);
 				do_become_nonbusy(dev, s);
 				if (comedi_get_subdevice_runflags(s) &
 				    SRF_ERROR) {
@@ -2075,6 +2077,7 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 				} else {
 					retval = 0;
 				}
+				mutex_unlock(&dev->mutex);
 				break;
 			}
 			if (file->f_flags & O_NONBLOCK) {
@@ -2112,9 +2115,11 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 		buf += n;
 		break;		/* makes device work like a pipe */
 	}
-	if (!(comedi_get_subdevice_runflags(s) & (SRF_ERROR | SRF_RUNNING)) &&
-	    async->buf_read_count - async->buf_write_count == 0) {
-		do_become_nonbusy(dev, s);
+	if (!(comedi_get_subdevice_runflags(s) & (SRF_ERROR | SRF_RUNNING))) {
+		mutex_lock(&dev->mutex);
+		if (async->buf_read_count - async->buf_write_count == 0)
+			do_become_nonbusy(dev, s);
+		mutex_unlock(&dev->mutex);
 	}
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&async->wait_head, &wait);
-- 
1.8.3.2

