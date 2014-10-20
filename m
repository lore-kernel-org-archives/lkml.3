Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaJTOLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:11:04 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:40691 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbaJTOK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:10:58 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] staging: comedi: fix memory leak / bad pointer freeing for chanlist
Date: Mon, 20 Oct 2014 15:10:40 +0100
Message-Id: <1413814240-3094-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a follow-up to commit 6cab7a37f5c04 ("staging: comedi: (regression)
channel list must be set for COMEDI_CMD ioctl"), Hartley Sweeten pointed
out another couple of bugs stemming from commit 6cab7a37f5c04 ("staging:
comedi: comedi_fops: introduce __comedi_get_user_chanlist()").

Firstly, `do_cmdtest_ioctl()` never frees the kernel copy of the user
chanlist allocated by `__comedi_get_user_chanlist()`, so that memory is
leaked.  Fix it by freeing the allocated kernel memory pointed to by
`cmd.chanlist` before that pointer is overwritten with its original
pointer to user memory before `cmd` is copied back to user-space.

Secondly, if `__comedi_get_user_chanlist()` returns an error,
`cmd->chanlist` is left unchanged and in fact will be a pointer to user
memory.  This causes `do_cmd_ioctl()` to `goto cleanup` and call
`do_become_nonbusy()` which would attempt to free the memory pointed to
by the user-space pointer.  Fix it by setting `cmd->chanlist` to NULL at
the start of `__comedi_get_user_chanlist()`.

Fixes: c6cd0eefb27b ("staging: comedi: comedi_fops: introduce __comedi_get_user_chanlist()")
Reported-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: <stable@vger.kernel.org> # 3.15.y 3.16.y 3.17.y: 6cab7a37f5c04
Cc: <stable@vger.kernel.org> # 3.15.y 3.16.y 3.17.y
---
Greg, this patch applies to your "staging-linus" branch.
---
 drivers/staging/comedi/comedi_fops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index a9b7fe5..a1788e8 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1462,6 +1462,7 @@ static int __comedi_get_user_chanlist(struct comedi_device *dev,
 	unsigned int *chanlist;
 	int ret;
 
+	cmd->chanlist = NULL;
 	chanlist = memdup_user(user_chanlist,
 			       cmd->chanlist_len * sizeof(unsigned int));
 	if (IS_ERR(chanlist))
@@ -1615,6 +1616,8 @@ static int do_cmdtest_ioctl(struct comedi_device *dev,
 
 	ret = s->do_cmdtest(dev, s, &cmd);
 
+	kfree(cmd.chanlist);	/* free kernel copy of user chanlist */
+
 	/* restore chanlist pointer before copying back */
 	cmd.chanlist = (unsigned int __force *)user_chanlist;
 
-- 
2.1.1

