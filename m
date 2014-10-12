Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaJLCr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 22:47:56 -0400
Received: from linuxhacker.ru ([217.76.32.60]:38366 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbaJLCr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 22:47:26 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 1/3] staging/lustre/ptlrpc: get rid of lustre 1.8 compatible checksums
Date: Sat, 11 Oct 2014 22:46:52 -0400
Message-Id: <1413082014-10510-2-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413082014-10510-1-git-send-email-green@linuxhacker.ru>
References: <1413082014-10510-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old version of lustre (1.8) calculated RPC checksums differently,
but the compat code is no longer important since in-kernel
version of lustre is nto compatible with 1.8 lustre servers
(that are long deprecated too).

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/staging/lustre/lustre/include/lustre_net.h |  5 -----
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    | 26 ----------------------
 drivers/staging/lustre/lustre/ptlrpc/sec_null.c    | 18 ---------------
 3 files changed, 49 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index 0a024d3..0235d7a 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -2627,12 +2627,7 @@ __u32 lustre_msg_get_timeout(struct lustre_msg *msg);
 __u32 lustre_msg_get_service_time(struct lustre_msg *msg);
 char *lustre_msg_get_jobid(struct lustre_msg *msg);
 __u32 lustre_msg_get_cksum(struct lustre_msg *msg);
-#if LUSTRE_VERSION_CODE < OBD_OCD_VERSION(2, 7, 50, 0)
-__u32 lustre_msg_calc_cksum(struct lustre_msg *msg, int compat18);
-#else
-# warning "remove checksum compatibility support for b1_8"
 __u32 lustre_msg_calc_cksum(struct lustre_msg *msg);
-#endif
 void lustre_msg_set_handle(struct lustre_msg *msg,
 			   struct lustre_handle *handle);
 void lustre_msg_set_type(struct lustre_msg *msg, __u32 type);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
index 50556db..60552f4 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
@@ -1313,43 +1313,17 @@ __u32 lustre_msg_get_cksum(struct lustre_msg *msg)
 	}
 }
 
-#if LUSTRE_VERSION_CODE < OBD_OCD_VERSION(2, 7, 50, 0)
-/*
- * In 1.6 and 1.8 the checksum was computed only on struct ptlrpc_body as
- * it was in 1.6 (88 bytes, smaller than the full size in 1.8).  It makes
- * more sense to compute the checksum on the full ptlrpc_body, regardless
- * of what size it is, but in order to keep interoperability with 1.8 we
- * can optionally also checksum only the first 88 bytes (caller decides). */
-# define ptlrpc_body_cksum_size_compat18	 88
-
-__u32 lustre_msg_calc_cksum(struct lustre_msg *msg, int compat18)
-#else
-# warning "remove checksum compatibility support for b1_8"
 __u32 lustre_msg_calc_cksum(struct lustre_msg *msg)
-#endif
 {
 	switch (msg->lm_magic) {
 	case LUSTRE_MSG_MAGIC_V2: {
 		struct ptlrpc_body *pb = lustre_msg_ptlrpc_body(msg);
-#if LUSTRE_VERSION_CODE < OBD_OCD_VERSION(2, 7, 50, 0)
-		__u32 crc;
-		unsigned int hsize = 4;
-		__u32 len = compat18 ? ptlrpc_body_cksum_size_compat18 :
-			    lustre_msg_buflen(msg, MSG_PTLRPC_BODY_OFF);
-		LASSERTF(pb, "invalid msg %p: no ptlrpc body!\n", msg);
-		cfs_crypto_hash_digest(CFS_HASH_ALG_CRC32, (unsigned char *)pb,
-				       len, NULL, 0, (unsigned char *)&crc,
-				       &hsize);
-		return crc;
-#else
-# warning "remove checksum compatibility support for b1_8"
 		__u32 crc;
 		unsigned int hsize = 4;
 		cfs_crypto_hash_digest(CFS_HASH_ALG_CRC32, (unsigned char *)pb,
 				   lustre_msg_buflen(msg, MSG_PTLRPC_BODY_OFF),
 				   NULL, 0, (unsigned char *)&crc, &hsize);
 		return crc;
-#endif
 	}
 	default:
 		CERROR("incorrect message magic: %08x\n", msg->lm_magic);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_null.c b/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
index 099cec3..4e13243 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_null.c
@@ -101,16 +101,7 @@ int null_ctx_verify(struct ptlrpc_cli_ctx *ctx, struct ptlrpc_request *req)
 
 	if (req->rq_early) {
 		cksums = lustre_msg_get_cksum(req->rq_repdata);
-#if LUSTRE_VERSION_CODE < OBD_OCD_VERSION(2, 7, 50, 0)
-		if (lustre_msghdr_get_flags(req->rq_reqmsg) &
-		    MSGHDR_CKSUM_INCOMPAT18)
-			cksumc = lustre_msg_calc_cksum(req->rq_repmsg, 0);
-		else
-			cksumc = lustre_msg_calc_cksum(req->rq_repmsg, 1);
-#else
-# warning "remove checksum compatibility support for b1_8"
 		cksumc = lustre_msg_calc_cksum(req->rq_repmsg);
-#endif
 		if (cksumc != cksums) {
 			CDEBUG(D_SEC,
 			       "early reply checksum mismatch: %08x != %08x\n",
@@ -371,16 +362,7 @@ int null_authorize(struct ptlrpc_request *req)
 	} else {
 		__u32 cksum;
 
-#if LUSTRE_VERSION_CODE < OBD_OCD_VERSION(2, 7, 50, 0)
-		if (lustre_msghdr_get_flags(req->rq_reqmsg) &
-		    MSGHDR_CKSUM_INCOMPAT18)
-			cksum = lustre_msg_calc_cksum(rs->rs_repbuf, 0);
-		else
-			cksum = lustre_msg_calc_cksum(rs->rs_repbuf, 1);
-#else
-# warning "remove checksum compatibility support for b1_8"
 		cksum = lustre_msg_calc_cksum(rs->rs_repbuf);
-#endif
 		lustre_msg_set_cksum(rs->rs_repbuf, cksum);
 		req->rq_reply_off = 0;
 	}
-- 
1.9.3

