Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbaJ3MnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:43:11 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:35965 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759800AbaJ3MnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:08 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] staging: comedi: check actual data direction for COMEDI_BUFINFO ioctl
Date: Thu, 30 Oct 2014 12:42:32 +0000
Message-Id: <1414672952-1587-8-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`do_bufinfo_ioctl()` handled the `COMEDI_BUFINFO` ioctl.  It is supposed
to update the read or write positions in the buffer depending on the
direction of data transfer set up by the asynchronous command.
Currently it checks the `SDF_CMD_READ` and `SDF_CMD_WRITE` subdevice
flags.  That's fine for most subdevices - the ones that only support one
direction, but is incorrect for those subdevices that allow the command
to be set up in either direction.  Since we now set the `CMDF_WRITE`
flag according to the data transfer direction of the current command
running on the subdevice, check that flag instead.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index d55f709..57ad6cd 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -991,7 +991,7 @@ static int do_bufinfo_ioctl(struct comedi_device *dev,
 	if (s->busy != file)
 		return -EACCES;
 
-	if (bi.bytes_read && (s->subdev_flags & SDF_CMD_READ)) {
+	if (bi.bytes_read && !(async->cmd.flags & CMDF_WRITE)) {
 		bi.bytes_read = comedi_buf_read_alloc(s, bi.bytes_read);
 		comedi_buf_read_free(s, bi.bytes_read);
 
@@ -1001,7 +1001,7 @@ static int do_bufinfo_ioctl(struct comedi_device *dev,
 		}
 	}
 
-	if (bi.bytes_written && (s->subdev_flags & SDF_CMD_WRITE)) {
+	if (bi.bytes_written && (async->cmd.flags & CMDF_WRITE)) {
 		bi.bytes_written =
 		    comedi_buf_write_alloc(s, bi.bytes_written);
 		comedi_buf_write_free(s, bi.bytes_written);
-- 
2.1.1

