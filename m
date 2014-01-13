Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbaAMQEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:04:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53380 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbaAMQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 118/208] libceph: fix error handling in handle_reply()
Date: Mon, 13 Jan 2014 15:59:19 +0000
Message-Id: <1389628849-1614-119-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 1874119664dafda3ef2ed9b51b4759a9540d4a1a upstream.

We've tried to fix the error paths in this function before, but there
is still a hidden goto in the ceph_decode_need() macro which goes to the
wrong place.  We need to release the "req" and unlock a mutex before
returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/osd_client.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index dbc0a73..559a832 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1488,14 +1488,14 @@ static void handle_reply(struct ceph_osd_client *osdc, struct ceph_msg *msg,
 	dout("handle_reply %p tid %llu req %p result %d\n", msg, tid,
 	     req, result);
 
-	ceph_decode_need(&p, end, 4, bad);
+	ceph_decode_need(&p, end, 4, bad_put);
 	numops = ceph_decode_32(&p);
 	if (numops > CEPH_OSD_MAX_OP)
 		goto bad_put;
 	if (numops != req->r_num_ops)
 		goto bad_put;
 	payload_len = 0;
-	ceph_decode_need(&p, end, numops * sizeof(struct ceph_osd_op), bad);
+	ceph_decode_need(&p, end, numops * sizeof(struct ceph_osd_op), bad_put);
 	for (i = 0; i < numops; i++) {
 		struct ceph_osd_op *op = p;
 		int len;
@@ -1513,7 +1513,7 @@ static void handle_reply(struct ceph_osd_client *osdc, struct ceph_msg *msg,
 		goto bad_put;
 	}
 
-	ceph_decode_need(&p, end, 4 + numops * 4, bad);
+	ceph_decode_need(&p, end, 4 + numops * 4, bad_put);
 	retry_attempt = ceph_decode_32(&p);
 	for (i = 0; i < numops; i++)
 		req->r_reply_op_result[i] = ceph_decode_32(&p);
-- 
1.8.3.2

