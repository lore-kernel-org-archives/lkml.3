Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab3AOWky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:40:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:43988 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900Ab3AOWgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Dan Mick <dan.mick@inktank.com>,
        Josh Durgin <josh.durgin@inktank.com>
Subject: [ 208/221] rbd: increase maximum snapshot name length
Date: Tue, 15 Jan 2013 10:52:15 -0800
Message-Id: <20130115185013.060640868@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

(cherry picked from commit d4b125e9eb43babd14538ba61718e3db71a98d29)

Change RBD_MAX_SNAP_NAME_LEN to be based on NAME_MAX.  That is a
practical limit for the length of a snapshot name (based on the
presence of a directory using the name under /sys/bus/rbd to
represent the snapshot).

The /sys entry is created by prefixing it with "snap_"; define that
prefix symbolically, and take its length into account in defining
the snapshot name length limit.

Enforce the limit in rbd_add_parse_args().  Also delete a dout()
call in that function that was not meant to be committed.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Dan Mick <dan.mick@inktank.com>
Reviewed-by: Josh Durgin <josh.durgin@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -61,7 +61,10 @@
 
 #define RBD_MINORS_PER_MAJOR	256		/* max minors per blkdev */
 
-#define RBD_MAX_SNAP_NAME_LEN	32
+#define RBD_SNAP_DEV_NAME_PREFIX	"snap_"
+#define RBD_MAX_SNAP_NAME_LEN	\
+			(NAME_MAX - (sizeof (RBD_SNAP_DEV_NAME_PREFIX) - 1))
+
 #define RBD_MAX_SNAP_COUNT	510	/* allows max snapc to fit in 4KB */
 #define RBD_MAX_OPT_LEN		1024
 
@@ -2073,7 +2076,7 @@ static int rbd_register_snap_dev(struct
 	dev->type = &rbd_snap_device_type;
 	dev->parent = parent;
 	dev->release = rbd_snap_dev_release;
-	dev_set_name(dev, "snap_%s", snap->name);
+	dev_set_name(dev, "%s%s", RBD_SNAP_DEV_NAME_PREFIX, snap->name);
 	dout("%s: registering device for snapshot %s\n", __func__, snap->name);
 
 	ret = device_register(dev);
@@ -2766,8 +2769,13 @@ static char *rbd_add_parse_args(struct r
 	if (!rbd_dev->image_name)
 		goto out_err;
 
-	/* Snapshot name is optional */
+	/* Snapshot name is optional; default is to use "head" */
+
 	len = next_token(&buf);
+	if (len > RBD_MAX_SNAP_NAME_LEN) {
+		err_ptr = ERR_PTR(-ENAMETOOLONG);
+		goto out_err;
+	}
 	if (!len) {
 		buf = RBD_SNAP_HEAD_NAME; /* No snapshot supplied */
 		len = sizeof (RBD_SNAP_HEAD_NAME) - 1;
@@ -2778,8 +2786,6 @@ static char *rbd_add_parse_args(struct r
 	memcpy(snap_name, buf, len);
 	*(snap_name + len) = '\0';
 
-dout("    SNAP_NAME is <%s>, len is %zd\n", snap_name, len);
-
 	return snap_name;
 
 out_err:


