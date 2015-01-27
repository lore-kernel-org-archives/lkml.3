Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbbA0STK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:19:10 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:43507 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759001AbbA0SRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:17:10 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v2 1/6] staging: comedi: comedi_compat32.c: fix COMEDI_CMD copy back
Date: Tue, 27 Jan 2015 18:16:51 +0000
Message-Id: <1422382616-6884-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422382616-6884-1-git-send-email-abbotti@mev.co.uk>
References: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
 <1422382616-6884-1-git-send-email-abbotti@mev.co.uk>
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
v2: keep existing type of `rc` variable - don't change it to `long`.
---
 drivers/staging/comedi/comedi_compat32.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_compat32.c b/drivers/staging/comedi/comedi_compat32.c
index 5a4c74f..03a2d07 100644
--- a/drivers/staging/comedi/comedi_compat32.c
+++ b/drivers/staging/comedi/comedi_compat32.c
@@ -262,7 +262,7 @@ static int compat_cmd(struct file *file, unsigned long arg)
 {
 	struct comedi_cmd __user *cmd;
 	struct comedi32_cmd_struct __user *cmd32;
-	int rc;
+	int rc, err;
 
 	cmd32 = compat_ptr(arg);
 	cmd = compat_alloc_user_space(sizeof(*cmd));
@@ -271,7 +271,15 @@ static int compat_cmd(struct file *file, unsigned long arg)
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

