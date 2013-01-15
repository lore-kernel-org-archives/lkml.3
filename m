Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab3AOWgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:36:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:43968 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab3AOWgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Josh Durgin <josh.durgin@inktank.com>,
        Dan Mick <dan.mick@inktank.com>
Subject: [ 206/221] rbd: zero return code in rbd_dev_image_id()
Date: Tue, 15 Jan 2013 10:52:13 -0800
Message-Id: <20130115185012.901714274@linuxfoundation.org>
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

(cherry picked from commit a0ea3a40fd20b8c66381f747c454f89d6d1f50d4)

When rbd_dev_probe() calls rbd_dev_image_id() it expects to get
a 0 return code if successful, but it is getting a positive value.

The reason is that rbd_dev_image_id() returns the value it gets from
rbd_req_sync_exec(), which returns the number of bytes read in as a
result of the request.  (This ultimately comes from
ceph_copy_from_page_vector() in rbd_req_sync_op()).

Force the return value to 0 when successful in rbd_dev_image_id().
Do the same in rbd_dev_v2_object_prefix().

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Dan Mick <dan.mick@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2189,6 +2189,7 @@ static int rbd_dev_v2_object_prefix(stru
 	dout("%s: rbd_req_sync_exec returned %d\n", __func__, ret);
 	if (ret < 0)
 		goto out;
+	ret = 0;    /* rbd_req_sync_exec() can return positive */
 
 	p = reply_buf;
 	rbd_dev->header.object_prefix = ceph_extract_encoded_string(&p,
@@ -2841,6 +2842,7 @@ static int rbd_dev_image_id(struct rbd_d
 	dout("%s: rbd_req_sync_exec returned %d\n", __func__, ret);
 	if (ret < 0)
 		goto out;
+	ret = 0;    /* rbd_req_sync_exec() can return positive */
 
 	p = response;
 	rbd_dev->image_id = ceph_extract_encoded_string(&p,


