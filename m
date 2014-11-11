Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaKKLKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57597 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbaKKLKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>, Bernd Porr <mail@berndporr.me.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 096/170] staging: comedi: (regression) channel list must be set for COMEDI_CMD ioctl
Date: Tue, 11 Nov 2014 11:07:35 +0000
Message-Id: <1415704129-12709-97-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/comedi_fops.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 9d99fb3c18a6..2126d49a0049 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1466,10 +1466,6 @@ static int __comedi_get_user_chanlist(struct comedi_device *dev,
 	unsigned int *chanlist;
 	int ret;
 
-	/* user_chanlist could be NULL for do_cmdtest ioctls */
-	if (!user_chanlist)
-		return 0;
-
 	chanlist = memdup_user(user_chanlist,
 			       cmd->chanlist_len * sizeof(unsigned int));
 	if (IS_ERR(chanlist))
@@ -1613,10 +1609,13 @@ static int do_cmdtest_ioctl(struct comedi_device *dev,
 
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
 
-- 
2.1.0

