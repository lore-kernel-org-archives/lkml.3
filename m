Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaKKLSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:18:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57834 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbaKKLLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 147/170] staging: comedi: fix memory leak / bad pointer freeing for chanlist
Date: Tue, 11 Nov 2014 11:08:26 +0000
Message-Id: <1415704129-12709-148-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 238b5ad855924919e5b98d0c772d9dc78795639b upstream.

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

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/comedi_fops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 2126d49a0049..47a9a5cf3447 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1466,6 +1466,7 @@ static int __comedi_get_user_chanlist(struct comedi_device *dev,
 	unsigned int *chanlist;
 	int ret;
 
+	cmd->chanlist = NULL;
 	chanlist = memdup_user(user_chanlist,
 			       cmd->chanlist_len * sizeof(unsigned int));
 	if (IS_ERR(chanlist))
@@ -1619,6 +1620,8 @@ static int do_cmdtest_ioctl(struct comedi_device *dev,
 
 	ret = s->do_cmdtest(dev, s, &cmd);
 
+	kfree(cmd.chanlist);	/* free kernel copy of user chanlist */
+
 	/* restore chanlist pointer before copying back */
 	cmd.chanlist = (unsigned int __force *)user_chanlist;
 
-- 
2.1.0

