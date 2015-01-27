Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbbA0PvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:51:10 -0500
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:59667 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932394AbbA0Puq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:50:46 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] staging: comedi: comedi_compat.c: use long unlocked_ioctl return value
Date: Tue, 27 Jan 2015 15:50:24 +0000
Message-Id: <1422373824-12793-8-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
References: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `unlocked_ioctl` and `compat_ioctl` file operations are both defined
to return a `long` (I don't know why).  Comedi's `compat_ioctl` handler
`comedi_compat_ioctl()` and its helper functions currently assume the
`unlocked_ioctl` handler return value will fit in an `int` (which it
does, in fact).  Change it to pass through the full `long` return value.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_compat32.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/comedi_compat32.c b/drivers/staging/comedi/comedi_compat32.c
index 24078b9..06ccf3c 100644
--- a/drivers/staging/comedi/comedi_compat32.c
+++ b/drivers/staging/comedi/comedi_compat32.c
@@ -87,8 +87,8 @@ struct comedi32_insnlist_struct {
 };
 
 /* Handle translated ioctl. */
-static int translated_ioctl(struct file *file, unsigned int cmd,
-			    unsigned long arg)
+static long translated_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
 {
 	if (file->f_op->unlocked_ioctl)
 		return file->f_op->unlocked_ioctl(file, cmd, arg);
@@ -97,7 +97,7 @@ static int translated_ioctl(struct file *file, unsigned int cmd,
 }
 
 /* Handle 32-bit COMEDI_CHANINFO ioctl. */
-static int compat_chaninfo(struct file *file, unsigned long arg)
+static long compat_chaninfo(struct file *file, unsigned long arg)
 {
 	struct comedi_chaninfo __user *chaninfo;
 	struct comedi32_chaninfo_struct __user *chaninfo32;
@@ -131,7 +131,7 @@ static int compat_chaninfo(struct file *file, unsigned long arg)
 }
 
 /* Handle 32-bit COMEDI_RANGEINFO ioctl. */
-static int compat_rangeinfo(struct file *file, unsigned long arg)
+static long compat_rangeinfo(struct file *file, unsigned long arg)
 {
 	struct comedi_rangeinfo __user *rangeinfo;
 	struct comedi32_rangeinfo_struct __user *rangeinfo32;
@@ -264,7 +264,7 @@ static int put_compat_cmd(struct comedi32_cmd_struct __user *cmd32,
 }
 
 /* Handle 32-bit COMEDI_CMD ioctl. */
-static int compat_cmd(struct file *file, unsigned long arg)
+static long compat_cmd(struct file *file, unsigned long arg)
 {
 	struct comedi_cmd __user *cmd;
 	struct comedi32_cmd_struct __user *cmd32;
@@ -290,11 +290,12 @@ static int compat_cmd(struct file *file, unsigned long arg)
 }
 
 /* Handle 32-bit COMEDI_CMDTEST ioctl. */
-static int compat_cmdtest(struct file *file, unsigned long arg)
+static long compat_cmdtest(struct file *file, unsigned long arg)
 {
 	struct comedi_cmd __user *cmd;
 	struct comedi32_cmd_struct __user *cmd32;
-	int rc, err;
+	long rc;
+	int err;
 
 	cmd32 = compat_ptr(arg);
 	cmd = compat_alloc_user_space(sizeof(*cmd));
@@ -344,7 +345,7 @@ static int get_compat_insn(struct comedi_insn __user *insn,
 }
 
 /* Handle 32-bit COMEDI_INSNLIST ioctl. */
-static int compat_insnlist(struct file *file, unsigned long arg)
+static long compat_insnlist(struct file *file, unsigned long arg)
 {
 	struct combined_insnlist {
 		struct comedi_insnlist insnlist;
@@ -394,7 +395,7 @@ static int compat_insnlist(struct file *file, unsigned long arg)
 }
 
 /* Handle 32-bit COMEDI_INSN ioctl. */
-static int compat_insn(struct file *file, unsigned long arg)
+static long compat_insn(struct file *file, unsigned long arg)
 {
 	struct comedi_insn __user *insn;
 	struct comedi32_insn_struct __user *insn32;
@@ -417,7 +418,7 @@ static int compat_insn(struct file *file, unsigned long arg)
  */
 long comedi_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	int rc;
+	long rc;
 
 	switch (cmd) {
 	case COMEDI_DEVCONFIG:
-- 
2.1.4

