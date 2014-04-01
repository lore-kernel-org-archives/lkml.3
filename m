Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaDAL1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:27:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42742 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaDALS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 130/144] libceph: fix preallocation check in get_reply()
Date: Tue,  1 Apr 2014 12:15:34 +0100
Message-Id: <1396350948-29910-131-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <ilya.dryomov@inktank.com>

commit f2be82b0058e90b5d9ac2cb896b4914276fb50ef upstream.

The check that makes sure that we have enough memory allocated to read
in the entire header of the message in question is currently busted.
It compares front_len of the incoming message with iov_len field of
ceph_msg::front structure, which is used primarily to indicate the
amount of data already read in, and not the size of the allocated
buffer.  Under certain conditions (e.g. a short read from a socket
followed by that socket's shutdown and owning ceph_connection reset)
this results in a warning similar to

[85688.975866] libceph: get_reply front 198 > preallocated 122 (4#0)

and, through another bug, leads to forever hung tasks and forced
reboots.  Fix this by comparing front_len with front_alloc_len field of
struct ceph_msg, which stores the actual size of the buffer.

Fixes: http://tracker.ceph.com/issues/5425

Signed-off-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/messenger.c  | 3 +--
 net/ceph/osd_client.c | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index a9226b7..f857968 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3126,7 +3126,6 @@ struct ceph_msg *ceph_msg_new(int type, int front_len, gfp_t flags,
 	INIT_LIST_HEAD(&m->data);
 
 	/* front */
-	m->front_alloc_len = front_len;
 	if (front_len) {
 		if (front_len > PAGE_CACHE_SIZE) {
 			m->front.iov_base = __vmalloc(front_len, flags,
@@ -3143,7 +3142,7 @@ struct ceph_msg *ceph_msg_new(int type, int front_len, gfp_t flags,
 	} else {
 		m->front.iov_base = NULL;
 	}
-	m->front.iov_len = front_len;
+	m->front_alloc_len = m->front.iov_len = front_len;
 
 	dout("ceph_msg_new %p front %d\n", m, front_len);
 	return m;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 47eaf53..0da1b0f 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2467,9 +2467,9 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 		     req->r_reply, req->r_reply->con);
 	ceph_msg_revoke_incoming(req->r_reply);
 
-	if (front_len > req->r_reply->front.iov_len) {
+	if (front_len > req->r_reply->front_alloc_len) {
 		pr_warning("get_reply front %d > preallocated %d (%u#%llu)\n",
-			   front_len, (int)req->r_reply->front.iov_len,
+			   front_len, req->r_reply->front_alloc_len,
 			   (unsigned int)con->peer_name.type,
 			   le64_to_cpu(con->peer_name.num));
 		m = ceph_msg_new(CEPH_MSG_OSD_OPREPLY, front_len, GFP_NOFS,
-- 
1.9.1

