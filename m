Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaFWBct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:32:49 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39736 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaFWBcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:45 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 02/18] staging/lustre/ptlrpc: Protect request buffer changing
Date: Sun, 22 Jun 2014 21:32:06 -0400
Message-Id: <1403487142-4880-3-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*_enlarge_reqbuf class of functions can change request body location
for a request that's already in replay list, as such a parallel
traverser of the list (after_reply -> ptlrpc_free_committed) might
access freed and scrambled memory causing assertion.

Since all such users only can get to this request under imp_lock, take
imp_lock to protect against them in *_enlarge_reqbuf

Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-on: http://review.whamcloud.com/10074
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3333
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c | 29 ++++++++++++++++++++++
 drivers/staging/lustre/lustre/ptlrpc/sec_null.c    | 11 ++++++++
 drivers/staging/lustre/lustre/ptlrpc/sec_plain.c   | 12 +++++++++
 3 files changed, 52 insertions(+)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c b/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c
index 383601c..ef44e09 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/sec_gss.c
@@ -1687,12 +1687,24 @@ int gss_enlarge_reqbuf_intg(struct ptlrpc_sec *sec,
 		if (newbuf == NULL)
 			return -ENOMEM;
 
+		/* Must lock this, so that otherwise unprotected change of
+		 * rq_reqmsg is not racing with parallel processing of
+		 * imp_replay_list traversing threads. See LU-3333
+		 * This is a bandaid at best, we really need to deal with this
+		 * in request enlarging code before unpacking that's already
+		 * there */
+		if (req->rq_import)
+			spin_lock(&req->rq_import->imp_lock);
+
 		memcpy(newbuf, req->rq_reqbuf, req->rq_reqbuf_len);
 
 		OBD_FREE_LARGE(req->rq_reqbuf, req->rq_reqbuf_len);
 		req->rq_reqbuf = newbuf;
 		req->rq_reqbuf_len = newbuf_size;
 		req->rq_reqmsg = lustre_msg_buf(req->rq_reqbuf, 1, 0);
+
+		if (req->rq_import)
+			spin_unlock(&req->rq_import->imp_lock);
 	}
 
 	/* do enlargement, from wrapper to embedded, from end to begin */
@@ -1753,6 +1765,8 @@ int gss_enlarge_reqbuf_priv(struct ptlrpc_sec *sec,
 		if (newclrbuf_size + newcipbuf_size <= req->rq_reqbuf_len) {
 			void *src, *dst;
 
+			if (req->rq_import)
+				spin_lock(&req->rq_import->imp_lock);
 			/* move clear text backward. */
 			src = req->rq_clrbuf;
 			dst = (char *) req->rq_reqbuf + newcipbuf_size;
@@ -1762,6 +1776,9 @@ int gss_enlarge_reqbuf_priv(struct ptlrpc_sec *sec,
 			req->rq_clrbuf = (struct lustre_msg *) dst;
 			req->rq_clrbuf_len = newclrbuf_size;
 			req->rq_reqmsg = lustre_msg_buf(req->rq_clrbuf, 0, 0);
+
+			if (req->rq_import)
+				spin_unlock(&req->rq_import->imp_lock);
 		} else {
 			/* sadly we have to split out the clear buffer */
 			LASSERT(req->rq_reqbuf_len >= newcipbuf_size);
@@ -1776,6 +1793,15 @@ int gss_enlarge_reqbuf_priv(struct ptlrpc_sec *sec,
 		if (newclrbuf == NULL)
 			return -ENOMEM;
 
+		/* Must lock this, so that otherwise unprotected change of
+		 * rq_reqmsg is not racing with parallel processing of
+		 * imp_replay_list traversing threads. See LU-3333
+		 * This is a bandaid at best, we really need to deal with this
+		 * in request enlarging code before unpacking that's already
+		 * there */
+		if (req->rq_import)
+			spin_lock(&req->rq_import->imp_lock);
+
 		memcpy(newclrbuf, req->rq_clrbuf, req->rq_clrbuf_len);
 
 		if (req->rq_reqbuf == NULL ||
@@ -1788,6 +1814,9 @@ int gss_enlarge_reqbuf_priv(struct ptlrpc_sec *sec,
 		req->rq_clrbuf = newclrbuf;
 		req->rq_clrbuf_len = newclrbuf_size;
 		req->rq_reqmsg = lustre_msg_buf(req->rq_clrbuf, 0, 0);
+
+		if (req->rq_import)
+			spin_unlock(&req->rq_import->imp_lock);
 	}
 
 	_sptlrpc_enlarge_msg_inplace(req->rq_clrbuf, 0, newmsg_size);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_null.c b/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
index ff1137f..ac967cb 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
@@ -260,11 +260,22 @@ int null_enlarge_reqbuf(struct ptlrpc_sec *sec,
 		if (newbuf == NULL)
 			return -ENOMEM;
 
+		/* Must lock this, so that otherwise unprotected change of
+		 * rq_reqmsg is not racing with parallel processing of
+		 * imp_replay_list traversing threads. See LU-3333
+		 * This is a bandaid at best, we really need to deal with this
+		 * in request enlarging code before unpacking that's already
+		 * there */
+		if (req->rq_import)
+			spin_lock(&req->rq_import->imp_lock);
 		memcpy(newbuf, req->rq_reqbuf, req->rq_reqlen);
 
 		OBD_FREE_LARGE(req->rq_reqbuf, req->rq_reqbuf_len);
 		req->rq_reqbuf = req->rq_reqmsg = newbuf;
 		req->rq_reqbuf_len = alloc_size;
+
+		if (req->rq_import)
+			spin_unlock(&req->rq_import->imp_lock);
 	}
 
 	_sptlrpc_enlarge_msg_inplace(req->rq_reqmsg, segment, newsize);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c b/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c
index 416401b..12c6cef 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_plain.c
@@ -669,6 +669,15 @@ int plain_enlarge_reqbuf(struct ptlrpc_sec *sec,
 		if (newbuf == NULL)
 			return -ENOMEM;
 
+		/* Must lock this, so that otherwise unprotected change of
+		 * rq_reqmsg is not racing with parallel processing of
+		 * imp_replay_list traversing threads. See LU-3333
+		 * This is a bandaid at best, we really need to deal with this
+		 * in request enlarging code before unpacking that's already
+		 * there */
+		if (req->rq_import)
+			spin_lock(&req->rq_import->imp_lock);
+
 		memcpy(newbuf, req->rq_reqbuf, req->rq_reqbuf_len);
 
 		OBD_FREE_LARGE(req->rq_reqbuf, req->rq_reqbuf_len);
@@ -676,6 +685,9 @@ int plain_enlarge_reqbuf(struct ptlrpc_sec *sec,
 		req->rq_reqbuf_len = newbuf_size;
 		req->rq_reqmsg = lustre_msg_buf(req->rq_reqbuf,
 						PLAIN_PACK_MSG_OFF, 0);
+
+		if (req->rq_import)
+			spin_unlock(&req->rq_import->imp_lock);
 	}
 
 	_sptlrpc_enlarge_msg_inplace(req->rq_reqbuf, PLAIN_PACK_MSG_OFF,
-- 
1.9.0

