Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbaAFXK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:10:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbaAFWlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 3.10 102/129] libceph: call r_unsafe_callback when unsafe reply is received
Date: Mon,  6 Jan 2014 14:38:51 -0800
Message-Id: <20140106223902.521897294@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit 61c5d6bf7074ee32d014dcdf7698dc8c59eb712d upstream.

We can't use !req->r_sent to check if OSD request is sent for the
first time, this is because __cancel_request() zeros req->r_sent
when OSD map changes. Rather than adding a new variable to struct
ceph_osd_request to indicate if it's sent for the first time, We
can call the unsafe callback only when unsafe OSD reply is received.
If OSD's first reply is safe, just skip calling the unsafe callback.

The purpose of unsafe callback is adding unsafe request to a list,
so that fsync(2) can wait for the safe reply. fsync(2) doesn't need
to wait for a write(2) that hasn't returned yet. So it's OK to add
request to the unsafe list when the first OSD reply is received.
(ceph_sync_write() returns after receiving the first OSD reply)

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/osd_client.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1337,10 +1337,6 @@ static void __send_request(struct ceph_o
 
 	ceph_msg_get(req->r_request); /* send consumes a ref */
 
-	/* Mark the request unsafe if this is the first timet's being sent. */
-
-	if (!req->r_sent && req->r_unsafe_callback)
-		req->r_unsafe_callback(req, true);
 	req->r_sent = req->r_osd->o_incarnation;
 
 	ceph_con_send(&req->r_osd->o_con, req->r_request);
@@ -1431,8 +1427,6 @@ static void handle_osds_timeout(struct w
 
 static void complete_request(struct ceph_osd_request *req)
 {
-	if (req->r_unsafe_callback)
-		req->r_unsafe_callback(req, false);
 	complete_all(&req->r_safe_completion);  /* fsync waiter */
 }
 
@@ -1559,14 +1553,20 @@ static void handle_reply(struct ceph_osd
 	mutex_unlock(&osdc->request_mutex);
 
 	if (!already_completed) {
+		if (req->r_unsafe_callback &&
+		    result >= 0 && !(flags & CEPH_OSD_FLAG_ONDISK))
+			req->r_unsafe_callback(req, true);
 		if (req->r_callback)
 			req->r_callback(req, msg);
 		else
 			complete_all(&req->r_completion);
 	}
 
-	if (flags & CEPH_OSD_FLAG_ONDISK)
+	if (flags & CEPH_OSD_FLAG_ONDISK) {
+		if (req->r_unsafe_callback && already_completed)
+			req->r_unsafe_callback(req, false);
 		complete_request(req);
+	}
 
 done:
 	dout("req=%p req->r_linger=%d\n", req, req->r_linger);


