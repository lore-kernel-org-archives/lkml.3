Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbaAFWlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:41:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024AbaAFWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 3.10 106/129] libceph: fix error handling in handle_reply()
Date: Mon,  6 Jan 2014 14:38:55 -0800
Message-Id: <20140106223902.632665179@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 1874119664dafda3ef2ed9b51b4759a9540d4a1a upstream.

We've tried to fix the error paths in this function before, but there
is still a hidden goto in the ceph_decode_need() macro which goes to the
wrong place.  We need to release the "req" and unlock a mutex before
returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/osd_client.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1488,14 +1488,14 @@ static void handle_reply(struct ceph_osd
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
@@ -1513,7 +1513,7 @@ static void handle_reply(struct ceph_osd
 		goto bad_put;
 	}
 
-	ceph_decode_need(&p, end, 4 + numops * 4, bad);
+	ceph_decode_need(&p, end, 4 + numops * 4, bad_put);
 	retry_attempt = ceph_decode_32(&p);
 	for (i = 0; i < numops; i++)
 		req->r_reply_op_result[i] = ceph_decode_32(&p);


