Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbaJ3Mr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:47:59 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:55882 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759884AbaJ3MnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:07 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] staging: comedi: check command direction in poll() file operation
Date: Thu, 30 Oct 2014 12:42:31 +0000
Message-Id: <1414672952-1587-7-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`comedi_poll()` handles the poll() file operation for comedi devices.

If no asynchronous command has been set up on the current "read"
subdevice, it sets the `POLLIN` and `POLLRDNORM` bits in the return
value to indicate that the read() file operation would not block as it
would return an error.  Add a check so it also does that if the
asynchronous command has been set up in the "write" direction as that
also causes the read() file operation to return an error.

Similarly, if no asynchronous command has need set up on the current
"write" subdevice, it sets the `POLLOUT` and `POLLWRNORM` bits in the
return value to indicate that the write() file operation would not block
as it would return an error.  Add a check so it also does that if the
asynchronous command has been set up in the "read" direction as that
also causes the write() file operation to return an error.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 6328965..d55f709 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2017,6 +2017,7 @@ static unsigned int comedi_poll(struct file *file, poll_table *wait)
 	if (s && s->async) {
 		poll_wait(file, &s->async->wait_head, wait);
 		if (!s->busy || !comedi_is_subdevice_running(s) ||
+		    (s->async->cmd.flags & CMDF_WRITE) ||
 		    comedi_buf_read_n_available(s) > 0)
 			mask |= POLLIN | POLLRDNORM;
 	}
@@ -2028,6 +2029,7 @@ static unsigned int comedi_poll(struct file *file, poll_table *wait)
 		poll_wait(file, &s->async->wait_head, wait);
 		comedi_buf_write_alloc(s, s->async->prealloc_bufsz);
 		if (!s->busy || !comedi_is_subdevice_running(s) ||
+		    !(s->async->cmd.flags & CMDF_WRITE) ||
 		    comedi_buf_write_n_allocated(s) >= bps)
 			mask |= POLLOUT | POLLWRNORM;
 	}
-- 
2.1.1

