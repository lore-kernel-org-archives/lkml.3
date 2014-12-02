Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaLBRPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:15:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41858 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbaLBRPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:15:46 -0500
Date: Tue, 2 Dec 2014 17:15:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: sunwxg <sun.wxg@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Amir Shehata <amir.shehata@intel.com>, Peng Tao <bergwolf@gmail.com>,
        Doug Oucharek <doug.s.oucharek@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:lustre:lnet: Incorrect type in assignment
Message-ID: <20141202171537.GH29748@ZenIV.linux.org.uk>
References: <1417416832-10352-1-git-send-email-sun.wxg@gmail.com>
 <1417416832-10352-2-git-send-email-sun.wxg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417416832-10352-2-git-send-email-sun.wxg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 02:53:52PM +0800, sunwxg wrote:
> From: Sun Wang <sun.wxg@gmail.com>
> 
> Incorrect type when assign value to varible iov_base.

Oh, for pity sake...  Folks, these struct iovec in there are bloody wrong.
It's not iovec at all.  There are exactly two declarations in the whole
drivers/staging/lustre where struct iovec should not be struct kvec.  As for
everything else, see below.

commit 82fa028f2b462743aeeb9b973d02733801b2f8e6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Nov 29 12:24:20 2014 -0500

    lustre: don't use iovec instead of kvec
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
index 7e89b3b..99fb52a 100644
--- a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
+++ b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
@@ -752,9 +752,9 @@ int lnet_fail_nid(lnet_nid_t nid, unsigned int threshold);
 void lnet_counters_get(lnet_counters_t *counters);
 void lnet_counters_reset(void);
 
-unsigned int lnet_iov_nob(unsigned int niov, struct iovec *iov);
-int lnet_extract_iov(int dst_niov, struct iovec *dst,
-		     int src_niov, struct iovec *src,
+unsigned int lnet_iov_nob(unsigned int niov, struct kvec *iov);
+int lnet_extract_iov(int dst_niov, struct kvec *dst,
+		     int src_niov, struct kvec *src,
 		      unsigned int offset, unsigned int len);
 
 unsigned int lnet_kiov_nob(unsigned int niov, lnet_kiov_t *iov);
@@ -762,17 +762,17 @@ int lnet_extract_kiov(int dst_niov, lnet_kiov_t *dst,
 		      int src_niov, lnet_kiov_t *src,
 		      unsigned int offset, unsigned int len);
 
-void lnet_copy_iov2iov(unsigned int ndiov, struct iovec *diov,
+void lnet_copy_iov2iov(unsigned int ndiov, struct kvec *diov,
 		       unsigned int doffset,
-			unsigned int nsiov, struct iovec *siov,
+			unsigned int nsiov, struct kvec *siov,
 			unsigned int soffset, unsigned int nob);
-void lnet_copy_kiov2iov(unsigned int niov, struct iovec *iov,
+void lnet_copy_kiov2iov(unsigned int niov, struct kvec *iov,
 			unsigned int iovoffset,
 			 unsigned int nkiov, lnet_kiov_t *kiov,
 			 unsigned int kiovoffset, unsigned int nob);
 void lnet_copy_iov2kiov(unsigned int nkiov, lnet_kiov_t *kiov,
 			unsigned int kiovoffset,
-			 unsigned int niov, struct iovec *iov,
+			 unsigned int niov, struct kvec *iov,
 			 unsigned int iovoffset, unsigned int nob);
 void lnet_copy_kiov2kiov(unsigned int ndkiov, lnet_kiov_t *dkiov,
 			 unsigned int doffset,
@@ -781,10 +781,10 @@ void lnet_copy_kiov2kiov(unsigned int ndkiov, lnet_kiov_t *dkiov,
 
 static inline void
 lnet_copy_iov2flat(int dlen, void *dest, unsigned int doffset,
-		   unsigned int nsiov, struct iovec *siov, unsigned int soffset,
+		   unsigned int nsiov, struct kvec *siov, unsigned int soffset,
 		   unsigned int nob)
 {
-	struct iovec diov = {/*.iov_base = */ dest, /*.iov_len = */ dlen};
+	struct kvec diov = {/*.iov_base = */ dest, /*.iov_len = */ dlen};
 
 	lnet_copy_iov2iov(1, &diov, doffset,
 			  nsiov, siov, soffset, nob);
@@ -795,17 +795,17 @@ lnet_copy_kiov2flat(int dlen, void *dest, unsigned int doffset,
 		    unsigned int nsiov, lnet_kiov_t *skiov,
 		    unsigned int soffset, unsigned int nob)
 {
-	struct iovec diov = {/* .iov_base = */ dest, /* .iov_len = */ dlen};
+	struct kvec diov = {/* .iov_base = */ dest, /* .iov_len = */ dlen};
 
 	lnet_copy_kiov2iov(1, &diov, doffset,
 			   nsiov, skiov, soffset, nob);
 }
 
 static inline void
-lnet_copy_flat2iov(unsigned int ndiov, struct iovec *diov, unsigned int doffset,
+lnet_copy_flat2iov(unsigned int ndiov, struct kvec *diov, unsigned int doffset,
 		   int slen, void *src, unsigned int soffset, unsigned int nob)
 {
-	struct iovec siov = {/*.iov_base = */ src, /*.iov_len = */slen};
+	struct kvec siov = {/*.iov_base = */ src, /*.iov_len = */slen};
 
 	lnet_copy_iov2iov(ndiov, diov, doffset,
 			  1, &siov, soffset, nob);
@@ -816,7 +816,7 @@ lnet_copy_flat2kiov(unsigned int ndiov, lnet_kiov_t *dkiov,
 		    unsigned int doffset, int slen, void *src,
 		    unsigned int soffset, unsigned int nob)
 {
-	struct iovec siov = {/* .iov_base = */ src, /* .iov_len = */ slen};
+	struct kvec siov = {/* .iov_base = */ src, /* .iov_len = */ slen};
 
 	lnet_copy_iov2kiov(ndiov, dkiov, doffset,
 			   1, &siov, soffset, nob);
diff --git a/drivers/staging/lustre/include/linux/lnet/lib-types.h b/drivers/staging/lustre/include/linux/lnet/lib-types.h
index f16213f..ba1876f 100644
--- a/drivers/staging/lustre/include/linux/lnet/lib-types.h
+++ b/drivers/staging/lustre/include/linux/lnet/lib-types.h
@@ -217,7 +217,7 @@ typedef struct lnet_msg {
 	unsigned int	  msg_wanted;
 	unsigned int	  msg_offset;
 	unsigned int	  msg_niov;
-	struct iovec	 *msg_iov;
+	struct kvec	 *msg_iov;
 	lnet_kiov_t	  *msg_kiov;
 
 	lnet_event_t	  msg_ev;
@@ -271,7 +271,7 @@ typedef struct lnet_libmd {
 	lnet_eq_t	    *md_eq;
 	unsigned int	  md_niov;		/* # frags */
 	union {
-		struct iovec  iov[LNET_MAX_IOV];
+		struct kvec   iov[LNET_MAX_IOV];
 		lnet_kiov_t   kiov[LNET_MAX_IOV];
 	} md_iov;
 } lnet_libmd_t;
@@ -346,7 +346,7 @@ typedef struct lnet_lnd {
 	 * credit if the LND does flow control. */
 	int (*lnd_recv)(struct lnet_ni *ni, void *private, lnet_msg_t *msg,
 			int delayed, unsigned int niov,
-			struct iovec *iov, lnet_kiov_t *kiov,
+			struct kvec *iov, lnet_kiov_t *kiov,
 			unsigned int offset, unsigned int mlen, unsigned int rlen);
 
 	/* lnet_parse() has had to delay processing of this message
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
index b02b4ec..ab128de 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
@@ -1026,5 +1026,5 @@ int  kiblnd_post_rx (kib_rx_t *rx, int credit);
 
 int  kiblnd_send(lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg);
 int  kiblnd_recv(lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg, int delayed,
-		 unsigned int niov, struct iovec *iov, lnet_kiov_t *kiov,
+		 unsigned int niov, struct kvec *iov, lnet_kiov_t *kiov,
 		 unsigned int offset, unsigned int mlen, unsigned int rlen);
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 14c9c8d..00eaab2 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -697,7 +697,7 @@ kiblnd_map_tx(lnet_ni_t *ni, kib_tx_t *tx,
 
 static int
 kiblnd_setup_rd_iov(lnet_ni_t *ni, kib_tx_t *tx, kib_rdma_desc_t *rd,
-		    unsigned int niov, struct iovec *iov, int offset, int nob)
+		    unsigned int niov, struct kvec *iov, int offset, int nob)
 {
 	kib_net_t	  *net = ni->ni_data;
 	struct page	*page;
@@ -1462,7 +1462,7 @@ kiblnd_send (lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg)
 	int	       target_is_router = lntmsg->msg_target_is_router;
 	int	       routing = lntmsg->msg_routing;
 	unsigned int      payload_niov = lntmsg->msg_niov;
-	struct iovec     *payload_iov = lntmsg->msg_iov;
+	struct kvec      *payload_iov = lntmsg->msg_iov;
 	lnet_kiov_t      *payload_kiov = lntmsg->msg_kiov;
 	unsigned int      payload_offset = lntmsg->msg_offset;
 	unsigned int      payload_nob = lntmsg->msg_len;
@@ -1629,7 +1629,7 @@ kiblnd_reply (lnet_ni_t *ni, kib_rx_t *rx, lnet_msg_t *lntmsg)
 {
 	lnet_process_id_t target = lntmsg->msg_target;
 	unsigned int      niov = lntmsg->msg_niov;
-	struct iovec     *iov = lntmsg->msg_iov;
+	struct kvec      *iov = lntmsg->msg_iov;
 	lnet_kiov_t      *kiov = lntmsg->msg_kiov;
 	unsigned int      offset = lntmsg->msg_offset;
 	unsigned int      nob = lntmsg->msg_len;
@@ -1688,7 +1688,7 @@ kiblnd_reply (lnet_ni_t *ni, kib_rx_t *rx, lnet_msg_t *lntmsg)
 
 int
 kiblnd_recv (lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg, int delayed,
-	     unsigned int niov, struct iovec *iov, lnet_kiov_t *kiov,
+	     unsigned int niov, struct kvec *iov, lnet_kiov_t *kiov,
 	     unsigned int offset, unsigned int mlen, unsigned int rlen)
 {
 	kib_rx_t    *rx = private;
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
index a29d4da..03488d2 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
@@ -69,7 +69,7 @@ typedef struct				  /* per scheduler state */
 	int			kss_nconns;
 	struct ksock_sched_info	*kss_info;	/* owner of it */
 	struct page		*kss_rx_scratch_pgs[LNET_MAX_IOV];
-	struct iovec		kss_scratch_iov[LNET_MAX_IOV];
+	struct kvec		kss_scratch_iov[LNET_MAX_IOV];
 } ksock_sched_t;
 
 struct ksock_sched_info {
@@ -213,7 +213,7 @@ typedef struct				  /* transmit packet */
 	int	    tx_nob;	 /* # packet bytes */
 	int	    tx_resid;       /* residual bytes */
 	int	    tx_niov;	/* # packet iovec frags */
-	struct iovec  *tx_iov;	 /* packet iovec frags */
+	struct kvec  *tx_iov;	 /* packet iovec frags */
 	int	    tx_nkiov;       /* # packet page frags */
 	unsigned short tx_zc_aborted;  /* aborted ZC request */
 	unsigned short tx_zc_capable:1; /* payload is large enough for ZC */
@@ -227,11 +227,11 @@ typedef struct				  /* transmit packet */
 	int	    tx_desc_size;   /* size of this descriptor */
 	union {
 		struct {
-			struct iovec iov;       /* virt hdr */
+			struct kvec iov;       /* virt hdr */
 			lnet_kiov_t  kiov[0];   /* paged payload */
 		}		  paged;
 		struct {
-			struct iovec iov[1];    /* virt hdr + payload */
+			struct kvec iov[1];    /* virt hdr + payload */
 		}		  virt;
 	}		       tx_frags;
 } ksock_tx_t;
@@ -243,7 +243,7 @@ typedef struct				  /* transmit packet */
 /* space for the rx frag descriptors; we either read a single contiguous
  * header, or up to LNET_MAX_IOV frags of payload of either type. */
 typedef union {
-	struct iovec     iov[LNET_MAX_IOV];
+	struct kvec      iov[LNET_MAX_IOV];
 	lnet_kiov_t      kiov[LNET_MAX_IOV];
 } ksock_rxiovspace_t;
 
@@ -284,7 +284,7 @@ typedef struct ksock_conn {
 	int		   ksnc_rx_nob_left; /* # bytes to next hdr/body */
 	int		   ksnc_rx_nob_wanted; /* bytes actually wanted */
 	int		   ksnc_rx_niov;     /* # iovec frags */
-	struct iovec	 *ksnc_rx_iov;      /* the iovec frags */
+	struct kvec 	 *ksnc_rx_iov;      /* the iovec frags */
 	int		   ksnc_rx_nkiov;    /* # page frags */
 	lnet_kiov_t	  *ksnc_rx_kiov;     /* the page frags */
 	ksock_rxiovspace_t    ksnc_rx_iov_space;/* space for frag descriptors */
@@ -517,7 +517,7 @@ int ksocknal_ctl(lnet_ni_t *ni, unsigned int cmd, void *arg);
 int ksocknal_send (lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg);
 int ksocknal_recv(lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg,
 		  int delayed, unsigned int niov,
-		  struct iovec *iov, lnet_kiov_t *kiov,
+		  struct kvec *iov, lnet_kiov_t *kiov,
 		  unsigned int offset, unsigned int mlen, unsigned int rlen);
 int ksocknal_accept(lnet_ni_t *ni, struct socket *sock);
 
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index d29f5f1..6070cba 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -110,7 +110,7 @@ ksocknal_free_tx (ksock_tx_t *tx)
 static int
 ksocknal_send_iov (ksock_conn_t *conn, ksock_tx_t *tx)
 {
-	struct iovec  *iov = tx->tx_iov;
+	struct kvec  *iov = tx->tx_iov;
 	int    nob;
 	int    rc;
 
@@ -251,7 +251,7 @@ ksocknal_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 static int
 ksocknal_recv_iov (ksock_conn_t *conn)
 {
-	struct iovec *iov = conn->ksnc_rx_iov;
+	struct kvec *iov = conn->ksnc_rx_iov;
 	int     nob;
 	int     rc;
 
@@ -930,7 +930,7 @@ ksocknal_send(lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg)
 	int	       type = lntmsg->msg_type;
 	lnet_process_id_t target = lntmsg->msg_target;
 	unsigned int      payload_niov = lntmsg->msg_niov;
-	struct iovec     *payload_iov = lntmsg->msg_iov;
+	struct kvec      *payload_iov = lntmsg->msg_iov;
 	lnet_kiov_t      *payload_kiov = lntmsg->msg_kiov;
 	unsigned int      payload_offset = lntmsg->msg_offset;
 	unsigned int      payload_nob = lntmsg->msg_len;
@@ -1051,8 +1051,8 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 		case  KSOCK_PROTO_V2:
 		case  KSOCK_PROTO_V3:
 			conn->ksnc_rx_state = SOCKNAL_RX_KSM_HEADER;
-			conn->ksnc_rx_iov = (struct iovec *)&conn->ksnc_rx_iov_space;
-			conn->ksnc_rx_iov[0].iov_base = (char *)&conn->ksnc_msg;
+			conn->ksnc_rx_iov = (struct kvec *)&conn->ksnc_rx_iov_space;
+			conn->ksnc_rx_iov[0].iov_base = &conn->ksnc_msg;
 
 			conn->ksnc_rx_nob_wanted = offsetof(ksock_msg_t, ksm_u);
 			conn->ksnc_rx_nob_left = offsetof(ksock_msg_t, ksm_u);
@@ -1065,8 +1065,8 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 			conn->ksnc_rx_nob_wanted = sizeof(lnet_hdr_t);
 			conn->ksnc_rx_nob_left = sizeof(lnet_hdr_t);
 
-			conn->ksnc_rx_iov = (struct iovec *)&conn->ksnc_rx_iov_space;
-			conn->ksnc_rx_iov[0].iov_base = (char *)&conn->ksnc_msg.ksm_u.lnetmsg;
+			conn->ksnc_rx_iov = (struct kvec *)&conn->ksnc_rx_iov_space;
+			conn->ksnc_rx_iov[0].iov_base = &conn->ksnc_msg.ksm_u.lnetmsg;
 			conn->ksnc_rx_iov[0].iov_len  = sizeof (lnet_hdr_t);
 			break;
 
@@ -1086,7 +1086,7 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 
 	conn->ksnc_rx_state = SOCKNAL_RX_SLOP;
 	conn->ksnc_rx_nob_left = nob_to_skip;
-	conn->ksnc_rx_iov = (struct iovec *)&conn->ksnc_rx_iov_space;
+	conn->ksnc_rx_iov = (struct kvec *)&conn->ksnc_rx_iov_space;
 	skipped = 0;
 	niov = 0;
 
@@ -1217,8 +1217,8 @@ ksocknal_process_receive (ksock_conn_t *conn)
 		conn->ksnc_rx_nob_wanted = sizeof(ksock_lnet_msg_t);
 		conn->ksnc_rx_nob_left = sizeof(ksock_lnet_msg_t);
 
-		conn->ksnc_rx_iov = (struct iovec *)&conn->ksnc_rx_iov_space;
-		conn->ksnc_rx_iov[0].iov_base = (char *)&conn->ksnc_msg.ksm_u.lnetmsg;
+		conn->ksnc_rx_iov = (struct kvec *)&conn->ksnc_rx_iov_space;
+		conn->ksnc_rx_iov[0].iov_base = &conn->ksnc_msg.ksm_u.lnetmsg;
 		conn->ksnc_rx_iov[0].iov_len  = sizeof(ksock_lnet_msg_t);
 
 		conn->ksnc_rx_niov = 1;
@@ -1316,7 +1316,7 @@ ksocknal_process_receive (ksock_conn_t *conn)
 
 int
 ksocknal_recv (lnet_ni_t *ni, void *private, lnet_msg_t *msg, int delayed,
-	       unsigned int niov, struct iovec *iov, lnet_kiov_t *kiov,
+	       unsigned int niov, struct kvec *iov, lnet_kiov_t *kiov,
 	       unsigned int offset, unsigned int mlen, unsigned int rlen)
 {
 	ksock_conn_t  *conn = (ksock_conn_t *)private;
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
index 245c9d7..66cc509 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
@@ -92,11 +92,11 @@ ksocknal_lib_send_iov (ksock_conn_t *conn, ksock_tx_t *tx)
 
 	{
 #if SOCKNAL_SINGLE_FRAG_TX
-		struct iovec    scratch;
-		struct iovec   *scratchiov = &scratch;
+		struct kvec    scratch;
+		struct kvec   *scratchiov = &scratch;
 		unsigned int    niov = 1;
 #else
-		struct iovec   *scratchiov = conn->ksnc_scheduler->kss_scratch_iov;
+		struct kvec   *scratchiov = conn->ksnc_scheduler->kss_scratch_iov;
 		unsigned int    niov = tx->tx_niov;
 #endif
 		struct msghdr msg = {.msg_flags = MSG_DONTWAIT};
@@ -111,7 +111,7 @@ ksocknal_lib_send_iov (ksock_conn_t *conn, ksock_tx_t *tx)
 		    nob < tx->tx_resid)
 			msg.msg_flags |= MSG_MORE;
 
-		rc = kernel_sendmsg(sock, &msg, (struct kvec *)scratchiov, niov, nob);
+		rc = kernel_sendmsg(sock, &msg, scratchiov, niov, nob);
 	}
 	return rc;
 }
@@ -153,14 +153,14 @@ ksocknal_lib_send_kiov (ksock_conn_t *conn, ksock_tx_t *tx)
 		}
 	} else {
 #if SOCKNAL_SINGLE_FRAG_TX || !SOCKNAL_RISK_KMAP_DEADLOCK
-		struct iovec  scratch;
-		struct iovec *scratchiov = &scratch;
+		struct kvec  scratch;
+		struct kvec *scratchiov = &scratch;
 		unsigned int  niov = 1;
 #else
 #ifdef CONFIG_HIGHMEM
 #warning "XXX risk of kmap deadlock on multiple frags..."
 #endif
-		struct iovec *scratchiov = conn->ksnc_scheduler->kss_scratch_iov;
+		struct kvec *scratchiov = conn->ksnc_scheduler->kss_scratch_iov;
 		unsigned int  niov = tx->tx_nkiov;
 #endif
 		struct msghdr msg = {.msg_flags = MSG_DONTWAIT};
@@ -203,14 +203,14 @@ int
 ksocknal_lib_recv_iov (ksock_conn_t *conn)
 {
 #if SOCKNAL_SINGLE_FRAG_RX
-	struct iovec  scratch;
-	struct iovec *scratchiov = &scratch;
+	struct kvec  scratch;
+	struct kvec *scratchiov = &scratch;
 	unsigned int  niov = 1;
 #else
-	struct iovec *scratchiov = conn->ksnc_scheduler->kss_scratch_iov;
+	struct kvec *scratchiov = conn->ksnc_scheduler->kss_scratch_iov;
 	unsigned int  niov = conn->ksnc_rx_niov;
 #endif
-	struct iovec *iov = conn->ksnc_rx_iov;
+	struct kvec *iov = conn->ksnc_rx_iov;
 	struct msghdr msg = {
 		.msg_flags      = 0
 	};
@@ -232,7 +232,7 @@ ksocknal_lib_recv_iov (ksock_conn_t *conn)
 	LASSERT (nob <= conn->ksnc_rx_nob_wanted);
 
 	rc = kernel_recvmsg(conn->ksnc_sock, &msg,
-		(struct kvec *)scratchiov, niov, nob, MSG_DONTWAIT);
+		scratchiov, niov, nob, MSG_DONTWAIT);
 
 	saved_csum = 0;
 	if (conn->ksnc_proto == &ksocknal_protocol_v2x) {
@@ -269,7 +269,7 @@ ksocknal_lib_kiov_vunmap(void *addr)
 
 static void *
 ksocknal_lib_kiov_vmap(lnet_kiov_t *kiov, int niov,
-		       struct iovec *iov, struct page **pages)
+		       struct kvec *iov, struct page **pages)
 {
 	void	     *addr;
 	int	       nob;
@@ -307,15 +307,15 @@ int
 ksocknal_lib_recv_kiov (ksock_conn_t *conn)
 {
 #if SOCKNAL_SINGLE_FRAG_RX || !SOCKNAL_RISK_KMAP_DEADLOCK
-	struct iovec   scratch;
-	struct iovec  *scratchiov = &scratch;
+	struct kvec   scratch;
+	struct kvec  *scratchiov = &scratch;
 	struct page  **pages      = NULL;
 	unsigned int   niov       = 1;
 #else
 #ifdef CONFIG_HIGHMEM
 #warning "XXX risk of kmap deadlock on multiple frags..."
 #endif
-	struct iovec  *scratchiov = conn->ksnc_scheduler->kss_scratch_iov;
+	struct kvec  *scratchiov = conn->ksnc_scheduler->kss_scratch_iov;
 	struct page  **pages      = conn->ksnc_scheduler->kss_rx_scratch_pgs;
 	unsigned int   niov       = conn->ksnc_rx_nkiov;
 #endif
@@ -390,13 +390,13 @@ ksocknal_lib_csum_tx(ksock_tx_t *tx)
 	__u32	csum;
 	void	*base;
 
-	LASSERT(tx->tx_iov[0].iov_base == (void *)&tx->tx_msg);
+	LASSERT(tx->tx_iov[0].iov_base == &tx->tx_msg);
 	LASSERT(tx->tx_conn != NULL);
 	LASSERT(tx->tx_conn->ksnc_proto == &ksocknal_protocol_v2x);
 
 	tx->tx_msg.ksm_csum = 0;
 
-	csum = ksocknal_csum(~0, (void *)tx->tx_iov[0].iov_base,
+	csum = ksocknal_csum(~0, tx->tx_iov[0].iov_base,
 			     tx->tx_iov[0].iov_len);
 
 	if (tx->tx_kiov != NULL) {
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
index 9dde548..46ee6a9 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
@@ -718,7 +718,7 @@ ksocknal_pack_msg_v1(ksock_tx_t *tx)
 	LASSERT(tx->tx_msg.ksm_type != KSOCK_MSG_NOOP);
 	LASSERT(tx->tx_lnetmsg != NULL);
 
-	tx->tx_iov[0].iov_base = (void *)&tx->tx_lnetmsg->msg_hdr;
+	tx->tx_iov[0].iov_base = &tx->tx_lnetmsg->msg_hdr;
 	tx->tx_iov[0].iov_len  = sizeof(lnet_hdr_t);
 
 	tx->tx_resid = tx->tx_nob = tx->tx_lnetmsg->msg_len + sizeof(lnet_hdr_t);
@@ -727,7 +727,7 @@ ksocknal_pack_msg_v1(ksock_tx_t *tx)
 static void
 ksocknal_pack_msg_v2(ksock_tx_t *tx)
 {
-	tx->tx_iov[0].iov_base = (void *)&tx->tx_msg;
+	tx->tx_iov[0].iov_base = &tx->tx_msg;
 
 	if (tx->tx_lnetmsg != NULL) {
 		LASSERT(tx->tx_msg.ksm_type != KSOCK_MSG_NOOP);
diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index 4b9567d..ccdcd39 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -158,7 +158,7 @@ fail_peer(lnet_nid_t nid, int outgoing)
 }
 
 unsigned int
-lnet_iov_nob(unsigned int niov, struct iovec *iov)
+lnet_iov_nob(unsigned int niov, struct kvec *iov)
 {
 	unsigned int nob = 0;
 
@@ -170,8 +170,8 @@ lnet_iov_nob(unsigned int niov, struct iovec *iov)
 EXPORT_SYMBOL(lnet_iov_nob);
 
 void
-lnet_copy_iov2iov(unsigned int ndiov, struct iovec *diov, unsigned int doffset,
-		   unsigned int nsiov, struct iovec *siov, unsigned int soffset,
+lnet_copy_iov2iov(unsigned int ndiov, struct kvec *diov, unsigned int doffset,
+		   unsigned int nsiov, struct kvec *siov, unsigned int soffset,
 		   unsigned int nob)
 {
 	/* NB diov, siov are READ-ONLY */
@@ -229,8 +229,8 @@ lnet_copy_iov2iov(unsigned int ndiov, struct iovec *diov, unsigned int doffset,
 EXPORT_SYMBOL(lnet_copy_iov2iov);
 
 int
-lnet_extract_iov(int dst_niov, struct iovec *dst,
-		  int src_niov, struct iovec *src,
+lnet_extract_iov(int dst_niov, struct kvec *dst,
+		  int src_niov, struct kvec *src,
 		  unsigned int offset, unsigned int len)
 {
 	/* Initialise 'dst' to the subset of 'src' starting at 'offset',
@@ -371,7 +371,7 @@ lnet_copy_kiov2kiov(unsigned int ndiov, lnet_kiov_t *diov, unsigned int doffset,
 EXPORT_SYMBOL(lnet_copy_kiov2kiov);
 
 void
-lnet_copy_kiov2iov(unsigned int niov, struct iovec *iov, unsigned int iovoffset,
+lnet_copy_kiov2iov(unsigned int niov, struct kvec *iov, unsigned int iovoffset,
 		   unsigned int nkiov, lnet_kiov_t *kiov,
 		   unsigned int kiovoffset, unsigned int nob)
 {
@@ -443,7 +443,7 @@ EXPORT_SYMBOL(lnet_copy_kiov2iov);
 void
 lnet_copy_iov2kiov(unsigned int nkiov, lnet_kiov_t *kiov,
 		   unsigned int kiovoffset, unsigned int niov,
-		   struct iovec *iov, unsigned int iovoffset,
+		   struct kvec *iov, unsigned int iovoffset,
 		   unsigned int nob)
 {
 	/* NB kiov, iov are READ-ONLY */
@@ -566,7 +566,7 @@ lnet_ni_recv(lnet_ni_t *ni, void *private, lnet_msg_t *msg, int delayed,
 	     unsigned int offset, unsigned int mlen, unsigned int rlen)
 {
 	unsigned int  niov = 0;
-	struct iovec *iov = NULL;
+	struct kvec *iov = NULL;
 	lnet_kiov_t  *kiov = NULL;
 	int	   rc;
 
diff --git a/drivers/staging/lustre/lnet/lnet/lo.c b/drivers/staging/lustre/lnet/lnet/lo.c
index be31dfc..c412ce3 100644
--- a/drivers/staging/lustre/lnet/lnet/lo.c
+++ b/drivers/staging/lustre/lnet/lnet/lo.c
@@ -47,7 +47,7 @@ lolnd_send(lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg)
 int
 lolnd_recv(lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg,
 	    int delayed, unsigned int niov,
-	    struct iovec *iov, lnet_kiov_t *kiov,
+	    struct kvec *iov, lnet_kiov_t *kiov,
 	    unsigned int offset, unsigned int mlen, unsigned int rlen)
 {
 	lnet_msg_t *sendmsg = private;
