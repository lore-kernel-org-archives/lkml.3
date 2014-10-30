Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbaJ3Msc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:48:32 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:51183 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759848AbaJ3MnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:05 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] staging: comedi: don't allow write() on async command set up for "read"
Date: Thu, 30 Oct 2014 12:42:30 +0000
Message-Id: <1414672952-1587-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a Comedi asynchronous command has been set up for data transfer in
the "read" direction on the current "write" subdevice (for those
subdevices that support both directions), don't allow the "write" file
operation as that would mess with the data in the comedi data buffer
that is written by the low-level comedi hardware driver.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 6805ec9..6328965 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2075,6 +2075,10 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 		retval = -EACCES;
 		goto out;
 	}
+	if (!(async->cmd.flags & CMDF_WRITE)) {
+		retval = -EINVAL;
+		goto out;
+	}
 
 	add_wait_queue(&async->wait_head, &wait);
 	on_wait_queue = true;
@@ -2146,6 +2150,10 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 				retval = -EACCES;
 				break;
 			}
+			if (!(async->cmd.flags & CMDF_WRITE)) {
+				retval = -EINVAL;
+				break;
+			}
 			continue;
 		}
 
-- 
2.1.1

