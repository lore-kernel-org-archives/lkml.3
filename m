Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825Ab3HBKJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:09:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444Ab3HBKJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:09:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 34/99] staging: comedi: fix a race between do_cmd_ioctl() and read/write
Date: Fri,  2 Aug 2013 18:07:47 +0800
Message-Id: <20130802100230.824972799@linuxfoundation.org>
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

---
 drivers/staging/comedi/comedi_fops.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1401,22 +1401,19 @@ static int do_cmd_ioctl(struct comedi_de
 		DPRINTK("subdevice busy\n");
 		return -EBUSY;
 	}
-	s->busy = file;
 
 	/* make sure channel/gain list isn't too long */
 	if (cmd.chanlist_len > s->len_chanlist) {
 		DPRINTK("channel/gain list too long %u > %d\n",
 			cmd.chanlist_len, s->len_chanlist);
-		ret = -EINVAL;
-		goto cleanup;
+		return -EINVAL;
 	}
 
 	/* make sure channel/gain list isn't too short */
 	if (cmd.chanlist_len < 1) {
 		DPRINTK("channel/gain list too short %u < 1\n",
 			cmd.chanlist_len);
-		ret = -EINVAL;
-		goto cleanup;
+		return -EINVAL;
 	}
 
 	async->cmd = cmd;
@@ -1426,8 +1423,7 @@ static int do_cmd_ioctl(struct comedi_de
 	    kmalloc(async->cmd.chanlist_len * sizeof(int), GFP_KERNEL);
 	if (!async->cmd.chanlist) {
 		DPRINTK("allocation failed\n");
-		ret = -ENOMEM;
-		goto cleanup;
+		return -ENOMEM;
 	}
 
 	if (copy_from_user(async->cmd.chanlist, user_chanlist,
@@ -1479,6 +1475,9 @@ static int do_cmd_ioctl(struct comedi_de
 
 	comedi_set_subdevice_runflags(s, ~0, SRF_USER | SRF_RUNNING);
 
+	/* set s->busy _after_ setting SRF_RUNNING flag to avoid race with
+	 * comedi_read() or comedi_write() */
+	s->busy = file;
 	ret = s->do_cmd(dev, s);
 	if (ret == 0)
 		return 0;
@@ -2041,11 +2040,13 @@ static ssize_t comedi_write(struct file
 
 		if (!comedi_is_subdevice_running(s)) {
 			if (count == 0) {
+				mutex_lock(&dev->mutex);
 				if (comedi_is_subdevice_in_error(s))
 					retval = -EPIPE;
 				else
 					retval = 0;
 				do_become_nonbusy(dev, s);
+				mutex_unlock(&dev->mutex);
 			}
 			break;
 		}
@@ -2144,11 +2145,13 @@ static ssize_t comedi_read(struct file *
 
 		if (n == 0) {
 			if (!comedi_is_subdevice_running(s)) {
+				mutex_lock(&dev->mutex);
 				do_become_nonbusy(dev, s);
 				if (comedi_is_subdevice_in_error(s))
 					retval = -EPIPE;
 				else
 					retval = 0;
+				mutex_unlock(&dev->mutex);
 				break;
 			}
 			if (file->f_flags & O_NONBLOCK) {
@@ -2186,9 +2189,11 @@ static ssize_t comedi_read(struct file *
 		buf += n;
 		break;		/* makes device work like a pipe */
 	}
-	if (comedi_is_subdevice_idle(s) &&
-	    async->buf_read_count - async->buf_write_count == 0) {
-		do_become_nonbusy(dev, s);
+	if (comedi_is_subdevice_idle(s)) {
+		mutex_lock(&dev->mutex);
+		if (async->buf_read_count - async->buf_write_count == 0)
+			do_become_nonbusy(dev, s);
+		mutex_unlock(&dev->mutex);
 	}
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&async->wait_head, &wait);


