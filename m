Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbbA0Pw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:52:57 -0500
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:49172 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932221AbbA0Puj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:50:39 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH 1/7] staging: comedi: comedi_compat32.c: fix COMEDI_CMD copy back
Date: Tue, 27 Jan 2015 15:50:18 +0000
Message-Id: <1422373824-12793-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
References: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`do_cmd_ioctl()` in "comedi_fops.c" handles the `COMEDI_CMD` ioctl.
This returns `-EAGAIN` if it has copied a modified `struct comedi_cmd`
back to user-space.  (This occurs when the low-level Comedi driver's
`do_cmdtest()` handler returns non-zero to indicate a problem with the
contents of the `struct comedi_cmd`, or when the `struct comedi_cmd` has
the `CMDF_BOGUS` flag set.)

`compat_cmd()` in "comedi_compat32.c" handles the 32-bit compatible
version of the `COMEDI_CMD` ioctl.  Currently, it never copies a 32-bit
compatible version of `struct comedi_cmd` back to user-space, which is
at odds with the way the regular `COMEDI_CMD` ioctl is handled.  To fix
it, change `compat_cmd()` to copy a 32-bit compatible version of the
`struct comedi_cmd` back to user-space when the main ioctl handler
returns `-EAGAIN`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Cc: <stable@vger.kernel.org>
---
 drivers/staging/comedi/comedi_compat32.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_compat32.c b/drivers/staging/comedi/comedi_compat32.c
index 5a4c74f..2440c60 100644
--- a/drivers/staging/comedi/comedi_compat32.c
+++ b/drivers/staging/comedi/comedi_compat32.c
@@ -262,7 +262,8 @@ static int compat_cmd(struct file *file, unsigned long arg)
 {
 	struct comedi_cmd __user *cmd;
 	struct comedi32_cmd_struct __user *cmd32;
-	int rc;
+	long rc;
+	int err;
 
 	cmd32 = compat_ptr(arg);
 	cmd = compat_alloc_user_space(sizeof(*cmd));
@@ -271,7 +272,15 @@ static int compat_cmd(struct file *file, unsigned long arg)
 	if (rc)
 		return rc;
 
-	return translated_ioctl(file, COMEDI_CMD, (unsigned long)cmd);
+	rc = translated_ioctl(file, COMEDI_CMD, (unsigned long)cmd);
+	if (rc == -EAGAIN) {
+		/* Special case: copy cmd back to user. */
+		err = put_compat_cmd(cmd32, cmd);
+		if (err)
+			rc = err;
+	}
+
+	return rc;
 }
 
 /* Handle 32-bit COMEDI_CMDTEST ioctl. */
-- 
2.1.4

