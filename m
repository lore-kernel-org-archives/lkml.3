Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3ETRfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:35:33 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54477 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab3ETRfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:35:32 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] net/9p: Handle error in zero copy request correctly for 9p2000.u
Date: Mon, 20 May 2013 23:05:15 +0530
Message-Id: <1369071315-26047-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.2
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052017-9264-0000-0000-000003C7E761
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

For zero copy request, error will be encoded in the user space buffer.
So copy the error code correctly using copy_from_user. Here we use the
extra bytes we allocate for zero copy request. If total error details
are more than P9_ZC_HDR_SZ - 7 bytes, we return -EFAULT. The patch also
avoid a memory allocation in the error path.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 net/9p/client.c | 55 ++++++++++++++++++-------------------------------------
 1 file changed, 18 insertions(+), 37 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 5e94dab..01f1779 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -562,36 +562,19 @@ static int p9_check_zc_errors(struct p9_client *c, struct p9_req_t *req,
 
 	if (!p9_is_proto_dotl(c)) {
 		/* Error is reported in string format */
-		uint16_t len;
-		/* 7 = header size for RERROR, 2 is the size of string len; */
-		int inline_len = in_hdrlen - (7 + 2);
+		int len;
+		/* 7 = header size for RERROR; */
+		int inline_len = in_hdrlen - 7;
 
-		/* Read the size of error string */
-		err = p9pdu_readf(req->rc, c->proto_version, "w", &len);
-		if (err)
-			goto out_err;
-
-		ename = kmalloc(len + 1, GFP_NOFS);
-		if (!ename) {
-			err = -ENOMEM;
+		len =  req->rc->size - req->rc->offset;
+		if (len > (P9_ZC_HDR_SZ - 7)) {
+			err = -EFAULT;
 			goto out_err;
 		}
-		if (len <= inline_len) {
-			/* We have error in protocol buffer itself */
-			if (pdu_read(req->rc, ename, len)) {
-				err = -EFAULT;
-				goto out_free;
 
-			}
-		} else {
-			/*
-			 *  Part of the data is in user space buffer.
-			 */
-			if (pdu_read(req->rc, ename, inline_len)) {
-				err = -EFAULT;
-				goto out_free;
-
-			}
+		ename = &req->rc->sdata[req->rc->offset];
+		if (len > inline_len) {
+			/* We have error in external buffer */
 			if (kern_buf) {
 				memcpy(ename + inline_len, uidata,
 				       len - inline_len);
@@ -600,19 +583,19 @@ static int p9_check_zc_errors(struct p9_client *c, struct p9_req_t *req,
 						     uidata, len - inline_len);
 				if (err) {
 					err = -EFAULT;
-					goto out_free;
+					goto out_err;
 				}
 			}
 		}
-		ename[len] = 0;
-		if (p9_is_proto_dotu(c)) {
-			/* For dotu we also have error code */
-			err = p9pdu_readf(req->rc,
-					  c->proto_version, "d", &ecode);
-			if (err)
-				goto out_free;
+		ename = NULL;
+		err = p9pdu_readf(req->rc, c->proto_version, "s?d",
+				  &ename, &ecode);
+		if (err)
+			goto out_err;
+
+		if (p9_is_proto_dotu(c))
 			err = -ecode;
-		}
+
 		if (!err || !IS_ERR_VALUE(err)) {
 			err = p9_errstr2errno(ename, strlen(ename));
 
@@ -628,8 +611,6 @@ static int p9_check_zc_errors(struct p9_client *c, struct p9_req_t *req,
 	}
 	return err;
 
-out_free:
-	kfree(ename);
 out_err:
 	p9_debug(P9_DEBUG_ERROR, "couldn't parse error%d\n", err);
 	return err;
-- 
1.8.1.2

