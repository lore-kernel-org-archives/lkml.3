Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716Ab3LIPAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:00:00 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:42667 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab3LIO7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:59:53 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 01/13] staging/lustre: remove server macros from lustre_net.h
Date: Mon,  9 Dec 2013 22:56:53 +0800
Message-Id: <1386601025-422-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
References: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros are only used on server side.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 drivers/staging/lustre/lustre/include/lustre_net.h |  234 --------------------
 1 file changed, 234 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index 6c5479b..d8d0880 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -264,241 +264,7 @@
 #define LDLM_MAXREQSIZE   (5 * 1024)
 #define LDLM_MAXREPSIZE   (1024)
 
- /*
-  * MDS threads constants:
-  *
-  * Please see examples in "Thread Constants", MDS threads number will be at
-  * the comparable level of old versions, unless the server has many cores.
-  */
-#ifndef MDS_MAX_THREADS
-#define MDS_MAX_THREADS		1024
-#define MDS_MAX_OTHR_THREADS	256
-
-#else /* MDS_MAX_THREADS */
-#if MDS_MAX_THREADS < PTLRPC_NTHRS_INIT
-#undef MDS_MAX_THREADS
-#define MDS_MAX_THREADS	PTLRPC_NTHRS_INIT
-#endif
-#define MDS_MAX_OTHR_THREADS	max(PTLRPC_NTHRS_INIT, MDS_MAX_THREADS / 2)
-#endif
-
-/* default service */
-#define MDS_THR_FACTOR		8
-#define MDS_NTHRS_INIT		PTLRPC_NTHRS_INIT
-#define MDS_NTHRS_MAX		MDS_MAX_THREADS
-#define MDS_NTHRS_BASE		min(64, MDS_NTHRS_MAX)
-
-/* read-page service */
-#define MDS_RDPG_THR_FACTOR	4
-#define MDS_RDPG_NTHRS_INIT	PTLRPC_NTHRS_INIT
-#define MDS_RDPG_NTHRS_MAX	MDS_MAX_OTHR_THREADS
-#define MDS_RDPG_NTHRS_BASE	min(48, MDS_RDPG_NTHRS_MAX)
-
-/* these should be removed when we remove setattr service in the future */
-#define MDS_SETA_THR_FACTOR	4
-#define MDS_SETA_NTHRS_INIT	PTLRPC_NTHRS_INIT
-#define MDS_SETA_NTHRS_MAX	MDS_MAX_OTHR_THREADS
-#define MDS_SETA_NTHRS_BASE	min(48, MDS_SETA_NTHRS_MAX)
-
-/* non-affinity threads */
-#define MDS_OTHR_NTHRS_INIT	PTLRPC_NTHRS_INIT
-#define MDS_OTHR_NTHRS_MAX	MDS_MAX_OTHR_THREADS
-
-#define MDS_NBUFS		64
-
-/**
- * Assume file name length = FNAME_MAX = 256 (true for ext3).
- *	  path name length = PATH_MAX = 4096
- *	  LOV MD size max  = EA_MAX = 24 * 2000
- *		(NB: 24 is size of lov_ost_data)
- *	  LOV LOGCOOKIE size max = 32 * 2000
- *		(NB: 32 is size of llog_cookie)
- * symlink:  FNAME_MAX + PATH_MAX  <- largest
- * link:     FNAME_MAX + PATH_MAX  (mds_rec_link < mds_rec_create)
- * rename:   FNAME_MAX + FNAME_MAX
- * open:     FNAME_MAX + EA_MAX
- *
- * MDS_MAXREQSIZE ~= 4736 bytes =
- * lustre_msg + ldlm_request + mdt_body + mds_rec_create + FNAME_MAX + PATH_MAX
- * MDS_MAXREPSIZE ~= 8300 bytes = lustre_msg + llog_header
- *
- * Realistic size is about 512 bytes (20 character name + 128 char symlink),
- * except in the open case where there are a large number of OSTs in a LOV.
- */
-#define MDS_MAXREQSIZE		(5 * 1024)	/* >= 4736 */
-#define MDS_MAXREPSIZE		(9 * 1024)	/* >= 8300 */
-
-/**
- * MDS incoming request with LOV EA
- * 24 = sizeof(struct lov_ost_data), i.e: replay of opencreate
- */
-#define MDS_LOV_MAXREQSIZE	max(MDS_MAXREQSIZE, \
-				    362 + LOV_MAX_STRIPE_COUNT * 24)
-/**
- * MDS outgoing reply with LOV EA
- *
- * NB: max reply size Lustre 2.4+ client can get from old MDS is:
- * LOV_MAX_STRIPE_COUNT * (llog_cookie + lov_ost_data) + extra bytes
- *
- * but 2.4 or later MDS will never send reply with llog_cookie to any
- * version client. This macro is defined for server side reply buffer size.
- */
-#define MDS_LOV_MAXREPSIZE	MDS_LOV_MAXREQSIZE
-
-/**
- * This is the size of a maximum REINT_SETXATTR request:
- *
- *   lustre_msg		 56 (32 + 4 x 5 + 4)
- *   ptlrpc_body	184
- *   mdt_rec_setxattr	136
- *   lustre_capa	120
- *   name		256 (XATTR_NAME_MAX)
- *   value	      65536 (XATTR_SIZE_MAX)
- */
-#define MDS_EA_MAXREQSIZE	66288
-
-/**
- * These are the maximum request and reply sizes (rounded up to 1 KB
- * boundaries) for the "regular" MDS_REQUEST_PORTAL and MDS_REPLY_PORTAL.
- */
-#define MDS_REG_MAXREQSIZE	(((max(MDS_EA_MAXREQSIZE, \
-				       MDS_LOV_MAXREQSIZE) + 1023) >> 10) << 10)
-#define MDS_REG_MAXREPSIZE	MDS_REG_MAXREQSIZE
-
-/**
- * The update request includes all of updates from the create, which might
- * include linkea (4K maxim), together with other updates, we set it to 9K:
- * lustre_msg + ptlrpc_body + UPDATE_BUF_SIZE (8K)
- */
-#define MDS_OUT_MAXREQSIZE	(9 * 1024)
-#define MDS_OUT_MAXREPSIZE	MDS_MAXREPSIZE
-
-/** MDS_BUFSIZE = max_reqsize (w/o LOV EA) + max sptlrpc payload size */
-#define MDS_BUFSIZE		max(MDS_MAXREQSIZE + SPTLRPC_MAX_PAYLOAD, \
-				    8 * 1024)
-
-/**
- * MDS_REG_BUFSIZE should at least be MDS_REG_MAXREQSIZE + SPTLRPC_MAX_PAYLOAD.
- * However, we need to allocate a much larger buffer for it because LNet
- * requires each MD(rqbd) has at least MDS_REQ_MAXREQSIZE bytes left to avoid
- * dropping of maximum-sized incoming request.  So if MDS_REG_BUFSIZE is only a
- * little larger than MDS_REG_MAXREQSIZE, then it can only fit in one request
- * even there are about MDS_REG_MAX_REQSIZE bytes left in a rqbd, and memory
- * utilization is very low.
- *
- * In the meanwhile, size of rqbd can't be too large, because rqbd can't be
- * reused until all requests fit in it have been processed and released,
- * which means one long blocked request can prevent the rqbd be reused.
- * Now we set request buffer size to 160 KB, so even each rqbd is unlinked
- * from LNet with unused 65 KB, buffer utilization will be about 59%.
- * Please check LU-2432 for details.
- */
-#define MDS_REG_BUFSIZE		max(MDS_REG_MAXREQSIZE + SPTLRPC_MAX_PAYLOAD, \
-				    160 * 1024)
-
-/**
- * MDS_OUT_BUFSIZE = max_out_reqsize + max sptlrpc payload (~1K) which is
- * about 10K, for the same reason as MDS_REG_BUFSIZE, we also give some
- * extra bytes to each request buffer to improve buffer utilization rate.
-  */
-#define MDS_OUT_BUFSIZE		max(MDS_OUT_MAXREQSIZE + SPTLRPC_MAX_PAYLOAD, \
-				    24 * 1024)
-
-/** FLD_MAXREQSIZE == lustre_msg + __u32 padding + ptlrpc_body + opc */
-#define FLD_MAXREQSIZE  (160)
-
-/** FLD_MAXREPSIZE == lustre_msg + ptlrpc_body */
-#define FLD_MAXREPSIZE  (152)
-#define FLD_BUFSIZE	(1 << 12)
-
-/**
- * SEQ_MAXREQSIZE == lustre_msg + __u32 padding + ptlrpc_body + opc + lu_range +
- * __u32 padding */
-#define SEQ_MAXREQSIZE  (160)
-
-/** SEQ_MAXREPSIZE == lustre_msg + ptlrpc_body + lu_range */
-#define SEQ_MAXREPSIZE  (152)
-#define SEQ_BUFSIZE	(1 << 12)
-
-/** MGS threads must be >= 3, see bug 22458 comment #28 */
-#define MGS_NTHRS_INIT	(PTLRPC_NTHRS_INIT + 1)
-#define MGS_NTHRS_MAX	32
-
-#define MGS_NBUFS       64
-#define MGS_BUFSIZE     (8 * 1024)
-#define MGS_MAXREQSIZE  (7 * 1024)
-#define MGS_MAXREPSIZE  (9 * 1024)
-
- /*
-  * OSS threads constants:
-  *
-  * Given 8 as factor and 64 as base threads number
-  *
-  * example 1):
-  * On 8-core server configured to 2 partitions, we will have
-  * 64 + 8 * 4 = 96 threads for each partition, 192 total threads.
-  *
-  * example 2):
-  * On 32-core machine configured to 4 partitions, we will have
-  * 64 + 8 * 8 = 112 threads for each partition, so total threads number
-  * will be 112 * 4 = 448.
-  *
-  * example 3):
-  * On 64-core machine configured to 4 partitions, we will have
-  * 64 + 16 * 8 = 192 threads for each partition, so total threads number
-  * will be 192 * 4 = 768 which is above limit OSS_NTHRS_MAX(512), so we
-  * cut off the value to OSS_NTHRS_MAX(512) / 4 which is 128 threads
-  * for each partition.
-  *
-  * So we can see that with these constants, threads number wil be at the
-  * similar level of old versions, unless the server has many cores.
-  */
- /* depress threads factor for VM with small memory size */
-#define OSS_THR_FACTOR		min_t(int, 8, \
-				NUM_CACHEPAGES >> (28 - PAGE_CACHE_SHIFT))
-#define OSS_NTHRS_INIT		(PTLRPC_NTHRS_INIT + 1)
-#define OSS_NTHRS_BASE		64
-#define OSS_NTHRS_MAX		512
-
-/* threads for handling "create" request */
-#define OSS_CR_THR_FACTOR	1
-#define OSS_CR_NTHRS_INIT	PTLRPC_NTHRS_INIT
-#define OSS_CR_NTHRS_BASE	8
-#define OSS_CR_NTHRS_MAX	64
-
-/**
- * OST_IO_MAXREQSIZE ~=
- *	lustre_msg + ptlrpc_body + obdo + obd_ioobj +
- *	DT_MAX_BRW_PAGES * niobuf_remote
- *
- * - single object with 16 pages is 512 bytes
- * - OST_IO_MAXREQSIZE must be at least 1 page of cookies plus some spillover
- * - Must be a multiple of 1024
- * - actual size is about 18K
- */
-#define _OST_MAXREQSIZE_SUM (sizeof(struct lustre_msg) + \
-			     sizeof(struct ptlrpc_body) + \
-			     sizeof(struct obdo) + \
-			     sizeof(struct obd_ioobj) + \
-			     sizeof(struct niobuf_remote) * DT_MAX_BRW_PAGES)
-/**
- * FIEMAP request can be 4K+ for now
- */
 #define OST_MAXREQSIZE		(5 * 1024)
-#define OST_IO_MAXREQSIZE	max_t(int, OST_MAXREQSIZE, \
-				(((_OST_MAXREQSIZE_SUM - 1) | (1024 - 1)) + 1))
-
-#define OST_MAXREPSIZE		(9 * 1024)
-#define OST_IO_MAXREPSIZE	OST_MAXREPSIZE
-
-#define OST_NBUFS		64
-/** OST_BUFSIZE = max_reqsize + max sptlrpc payload size */
-#define OST_BUFSIZE		max_t(int, OST_MAXREQSIZE + 1024, 16 * 1024)
-/**
- * OST_IO_MAXREQSIZE is 18K, giving extra 46K can increase buffer utilization
- * rate of request buffer, please check comment of MDS_LOV_BUFSIZE for details.
- */
-#define OST_IO_BUFSIZE		max_t(int, OST_IO_MAXREQSIZE + 1024, 64 * 1024)
 
 /* Macro to hide a typecast. */
 #define ptlrpc_req_async_args(req) ((void *)&req->rq_async_args)
-- 
1.7.9.5

