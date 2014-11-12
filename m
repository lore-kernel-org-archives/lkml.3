Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaKLBeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:34:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbaKLBd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:33:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH 3.17 271/319] staging: comedi: fix memory leak / bad pointer freeing for chanlist
Date: Wed, 12 Nov 2014 10:16:49 +0900
Message-Id: <20141112011037.570794977@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/comedi/comedi_fops.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1462,6 +1462,7 @@ static int __comedi_get_user_chanlist(st
 	unsigned int *chanlist;
 	int ret;
 
+	cmd->chanlist = NULL;
 	chanlist = memdup_user(user_chanlist,
 			       cmd->chanlist_len * sizeof(unsigned int));
 	if (IS_ERR(chanlist))
@@ -1615,6 +1616,8 @@ static int do_cmdtest_ioctl(struct comed
 
 	ret = s->do_cmdtest(dev, s, &cmd);
 
+	kfree(cmd.chanlist);	/* free kernel copy of user chanlist */
+
 	/* restore chanlist pointer before copying back */
 	cmd.chanlist = (unsigned int __force *)user_chanlist;
 


