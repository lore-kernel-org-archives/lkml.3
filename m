Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbaJ3MnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:43:07 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:54300 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759871AbaJ3MnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:04 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] staging: comedi: don't allow read() on async command set up for "write"
Date: Thu, 30 Oct 2014 12:42:29 +0000
Message-Id: <1414672952-1587-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
References: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a Comedi asynchronous command has been set up for data transfer in
the "write" direction on the current "read" subdevice (for those
subdevices that support both directions), don't allow the "read" file
operation as that would mess with the data in the comedi data buffer
that is read by the low-level comedi hardware driver.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index fef68da..6805ec9 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2210,6 +2210,10 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 		retval = -EACCES;
 		goto out;
 	}
+	if (async->cmd.flags & CMDF_WRITE) {
+		retval = -EINVAL;
+		goto out;
+	}
 
 	add_wait_queue(&async->wait_head, &wait);
 	while (nbytes > 0 && !retval) {
@@ -2249,6 +2253,10 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 				retval = -EACCES;
 				break;
 			}
+			if (async->cmd.flags & CMDF_WRITE) {
+				retval = -EINVAL;
+				break;
+			}
 			continue;
 		}
 		m = copy_to_user(buf, async->prealloc_buf +
-- 
2.1.1

