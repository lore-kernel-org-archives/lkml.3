Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbaJ3Mm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:42:57 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:53015 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759792AbaJ3Mmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:42:54 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] staging: comedi: maybe force CMDF_WRITE command flag
Date: Thu, 30 Oct 2014 12:42:26 +0000
Message-Id: <1414672952-1587-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most comedi subdevices that support asynchronous commands only support
data transfer in either the "read" or "write" direction, as indicated by
the `SDF_CMD_READ` and `SDF_CMD_WRITE` subdevice flags, although a few
support both directions on the same subdevice (though not
simultaneously).  The `struct comedi_cmd` structure passed via ioctl
call to set up the command contains a `CMDF_WRITE` flag that can be used
to choose the direction if the subdevice supports both directions, but
the flag is optional if the subdevice only supports data transfer in one
direction.

If the subdevice only supports asynchronous data transfer in a sing
direction, set the `CMDF_WRITE` flag to the correct state so that Comedi
can make use of it later.  In the case of the `COMEDI_CMDTEST` ioctl,
the updated flag will be written back to the `struct comedi_cmd` in
user-space.  In the case of the `COMEDI_CMD` ioctl, the flag only gets
written back if an error is detected while testing the command, or if
the `CMDF_BOGUS` command flag is set.  Since `__comedi_get_user_cmd()`
is called for both ioctls, that's a good place to set the flag.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 224af2b..fef68da 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1451,6 +1451,21 @@ static int __comedi_get_user_cmd(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
+	/*
+	 * Set the CMDF_WRITE flag to the correct state if the subdevice
+	 * supports only "read" commands or only "write" commands.
+	 */
+	switch (s->subdev_flags & (SDF_CMD_READ | SDF_CMD_WRITE)) {
+	case SDF_CMD_READ:
+		cmd->flags &= ~CMDF_WRITE;
+		break;
+	case SDF_CMD_WRITE:
+		cmd->flags |= CMDF_WRITE;
+		break;
+	default:
+		break;
+	}
+
 	return 0;
 }
 
-- 
2.1.1

