Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636AbaAFWsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:48:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933432AbaAFWmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.4 35/43] GFS2: dont hold s_umount over blkdev_put
Date: Mon,  6 Jan 2014 14:39:52 -0800
Message-Id: <20140106223943.254898539@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223942.259651490@linuxfoundation.org>
References: <20140106223942.259651490@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit dfe5b9ad83a63180f358b27d1018649a27b394a9 upstream.

This is a GFS2 version of Tejun's patch:
4f331f01b9c43bf001d3ffee578a97a1e0633eac
vfs: don't hold s_umount over close_bdev_exclusive() call

In this case its blkdev_put itself that is the issue and this
patch uses the same solution of dropping and retaking s_umount.

Reported-by: Tejun Heo <tj@kernel.org>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/ops_fstype.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1298,8 +1298,18 @@ static struct dentry *gfs2_mount(struct
 	if (IS_ERR(s))
 		goto error_bdev;
 
-	if (s->s_root)
+	if (s->s_root) {
+		/*
+		 * s_umount nests inside bd_mutex during
+		 * __invalidate_device().  blkdev_put() acquires
+		 * bd_mutex and can't be called under s_umount.  Drop
+		 * s_umount temporarily.  This is safe as we're
+		 * holding an active reference.
+		 */
+		up_write(&s->s_umount);
 		blkdev_put(bdev, mode);
+		down_write(&s->s_umount);
+	}
 
 	memset(&args, 0, sizeof(args));
 	args.ar_quota = GFS2_QUOTA_DEFAULT;


