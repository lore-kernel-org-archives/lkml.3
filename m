Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901Ab3AOXVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:21:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:47320 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933855Ab3AOWx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Yehuda Sadeh <yehuda@inktank.com>
Subject: [ 155/171] rbd: add read_only rbd map option
Date: Tue, 15 Jan 2013 14:45:20 -0800
Message-Id: <20130115224324.524913315@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

Add the ability to map an rbd image read-only, by specifying either
"read_only" or "ro" as an option on the rbd "command line."  Also
allow the inverse to be explicitly specified using "read_write" or
"rw".

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
(based on commit cc0538b62c839c2df7b9f8378bb37e3b35faa608)
---
 drivers/block/rbd.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -71,7 +71,8 @@
 #define DEV_NAME_LEN		32
 #define MAX_INT_FORMAT_WIDTH	((5 * sizeof (int)) / 2 + 1)
 
-#define RBD_NOTIFY_TIMEOUT_DEFAULT 10
+#define RBD_NOTIFY_TIMEOUT_DEFAULT	10
+#define RBD_READ_ONLY_DEFAULT		false
 
 /*
  * block device image metadata (in-memory version)
@@ -95,6 +96,7 @@ struct rbd_image_header {
 
 struct rbd_options {
 	int	notify_timeout;
+	bool	read_only;
 };
 
 /*
@@ -180,7 +182,7 @@ struct rbd_device {
 	u64                     snap_id;	/* current snapshot id */
 	/* whether the snap_id this device reads from still exists */
 	bool                    snap_exists;
-	int                     read_only;
+	bool			read_only;
 
 	struct list_head	node;
 
@@ -346,12 +348,21 @@ enum {
 	/* int args above */
 	Opt_last_string,
 	/* string args above */
+	Opt_read_only,
+	Opt_read_write,
+	/* Boolean args above */
+	Opt_last_bool,
 };
 
 static match_table_t rbdopt_tokens = {
 	{Opt_notify_timeout, "notify_timeout=%d"},
 	/* int args above */
 	/* string args above */
+	{Opt_read_only, "read_only"},
+	{Opt_read_only, "ro"},		/* Alternate spelling */
+	{Opt_read_write, "read_write"},
+	{Opt_read_write, "rw"},		/* Alternate spelling */
+	/* Boolean args above */
 	{-1, NULL}
 };
 
@@ -376,6 +387,8 @@ static int parse_rbd_opts_token(char *c,
 	} else if (token > Opt_last_int && token < Opt_last_string) {
 		dout("got string token %d val %s\n", token,
 		     argstr[0].from);
+	} else if (token > Opt_last_string && token < Opt_last_bool) {
+		dout("got Boolean token %d\n", token);
 	} else {
 		dout("got token %d\n", token);
 	}
@@ -384,6 +397,12 @@ static int parse_rbd_opts_token(char *c,
 	case Opt_notify_timeout:
 		rbdopt->notify_timeout = intval;
 		break;
+	case Opt_read_only:
+		rbdopt->read_only = true;
+		break;
+	case Opt_read_write:
+		rbdopt->read_only = false;
+		break;
 	default:
 		BUG_ON(token);
 	}
@@ -407,6 +426,7 @@ static struct rbd_client *rbd_get_client
 		return ERR_PTR(-ENOMEM);
 
 	rbd_opts->notify_timeout = RBD_NOTIFY_TIMEOUT_DEFAULT;
+	rbd_opts->read_only = RBD_READ_ONLY_DEFAULT;
 
 	opt = ceph_parse_options(options, mon_addr,
 				mon_addr + mon_addr_len,
@@ -590,7 +610,7 @@ static int rbd_header_set_snap(struct rb
 			snapc->seq = 0;
 		dev->snap_id = CEPH_NOSNAP;
 		dev->snap_exists = false;
-		dev->read_only = 0;
+		dev->read_only = dev->rbd_client->rbd_opts->read_only;
 		if (size)
 			*size = header->image_size;
 	} else {
@@ -599,7 +619,7 @@ static int rbd_header_set_snap(struct rb
 			goto done;
 		dev->snap_id = snapc->seq;
 		dev->snap_exists = true;
-		dev->read_only = 1;
+		dev->read_only = true;	/* No choice for snapshots */
 	}
 
 	ret = 0;


