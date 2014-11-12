Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaKLBdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:33:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264AbaKLBdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:33:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bernd Porr <mail@berndporr.me.uk>, Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH 3.17 270/319] staging: comedi: (regression) channel list must be set for COMEDI_CMD ioctl
Date: Wed, 12 Nov 2014 10:16:48 +0900
Message-Id: <20141112011037.440177632@linuxfoundation.org>
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

commit 6cab7a37f5c048bb2a768f24b0ec748b052fda09 upstream.

`do_cmd_ioctl()`, the handler for the `COMEDI_CMD` ioctl can incorrectly
call the Comedi subdevice's `do_cmd()` handler with a NULL channel list
pointer.  This is a regression as the `do_cmd()` handler has never been
expected to deal with that, leading to a kernel OOPS when it tries to
dereference it.

A NULL channel list pointer is allowed for the `COMEDI_CMDTEST` ioctl,
handled by `do_cmdtest_ioctl()` and the subdevice's `do_cmdtest()`
handler, but not for the `COMEDI_CMD` ioctl and its handlers.

Both `do_cmd_ioctl()` and `do_cmdtest_ioctl()` call
`__comedi_get_user_chanlist()` to copy the channel list from user memory
into dynamically allocated kernel memory and check it for consistency.
That function currently returns 0 if the `user_chanlist` parameter
(pointing to the channel list in user memory) is NULL.  That's fine for
`do_cmdtest_ioctl()`, but `do_cmd_ioctl()` incorrectly assumes the
kernel copy of the channel list has been set-up correctly.

Fix it by not allowing the `user_chanlist` parameter to be NULL in
`__comedi_get_user_chanlist()`, and only calling it from
`do_cmdtest_ioctl()` if the parameter is non-NULL.

Thanks to Bernd Porr for reporting the bug via an initial patch sent
privately.

Fixes: c6cd0eefb27b ("staging: comedi: comedi_fops: introduce __comedi_get_user_chanlist()")
Reported-by: Bernd Porr <mail@berndporr.me.uk>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Bernd Porr <mail@berndporr.me.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/comedi_fops.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1462,10 +1462,6 @@ static int __comedi_get_user_chanlist(st
 	unsigned int *chanlist;
 	int ret;
 
-	/* user_chanlist could be NULL for do_cmdtest ioctls */
-	if (!user_chanlist)
-		return 0;
-
 	chanlist = memdup_user(user_chanlist,
 			       cmd->chanlist_len * sizeof(unsigned int));
 	if (IS_ERR(chanlist))
@@ -1609,10 +1605,13 @@ static int do_cmdtest_ioctl(struct comed
 
 	s = &dev->subdevices[cmd.subdev];
 
-	/* load channel/gain list */
-	ret = __comedi_get_user_chanlist(dev, s, user_chanlist, &cmd);
-	if (ret)
-		return ret;
+	/* user_chanlist can be NULL for COMEDI_CMDTEST ioctl */
+	if (user_chanlist) {
+		/* load channel/gain list */
+		ret = __comedi_get_user_chanlist(dev, s, user_chanlist, &cmd);
+		if (ret)
+			return ret;
+	}
 
 	ret = s->do_cmdtest(dev, s, &cmd);
 


