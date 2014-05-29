Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934745AbaE2OBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:01:14 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59416 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933288AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevic@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 072/103] net: sctp: cache auth_enable per endpoint
Date: Thu, 29 May 2014 15:48:57 +0200
Message-Id: <88830f227a1f96e44d82ddfcb0cc81d517ec6dd8.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevic@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit b14878ccb7fac0242db82720b784ab62c467c0dc ]

Currently, it is possible to create an SCTP socket, then switch
auth_enable via sysctl setting to 1 and crash the system on connect:

Oops[#1]:
CPU: 0 PID: 0 Comm: swapper Not tainted 3.14.1-mipsgit-20140415 #1
task: ffffffff8056ce80 ti: ffffffff8055c000 task.ti: ffffffff8055c000
[...]
Call Trace:
[<ffffffff8043c4e8>] sctp_auth_asoc_set_default_hmac+0x68/0x80
[<ffffffff8042b300>] sctp_process_init+0x5e0/0x8a4
[<ffffffff8042188c>] sctp_sf_do_5_1B_init+0x234/0x34c
[<ffffffff804228c8>] sctp_do_sm+0xb4/0x1e8
[<ffffffff80425a08>] sctp_endpoint_bh_rcv+0x1c4/0x214
[<ffffffff8043af68>] sctp_rcv+0x588/0x630
[<ffffffff8043e8e8>] sctp6_rcv+0x10/0x24
[<ffffffff803acb50>] ip6_input+0x2c0/0x440
[<ffffffff8030fc00>] __netif_receive_skb_core+0x4a8/0x564
[<ffffffff80310650>] process_backlog+0xb4/0x18c
[<ffffffff80313cbc>] net_rx_action+0x12c/0x210
[<ffffffff80034254>] __do_softirq+0x17c/0x2ac
[<ffffffff800345e0>] irq_exit+0x54/0xb0
[<ffffffff800075a4>] ret_from_irq+0x0/0x4
[<ffffffff800090ec>] rm7k_wait_irqoff+0x24/0x48
[<ffffffff8005e388>] cpu_startup_entry+0xc0/0x148
[<ffffffff805a88b0>] start_kernel+0x37c/0x398
Code: dd0900b8  000330f8  0126302d <dcc60000> 50c0fff1  0047182a  a48306a0
03e00008  00000000
---[ end trace b530b0551467f2fd ]---
Kernel panic - not syncing: Fatal exception in interrupt

What happens while auth_enable=0 in that case is, that
ep->auth_hmacs is initialized to NULL in sctp_auth_init_hmacs()
when endpoint is being created.

After that point, if an admin switches over to auth_enable=1,
the machine can crash due to NULL pointer dereference during
reception of an INIT chunk. When we enter sctp_process_init()
via sctp_sf_do_5_1B_init() in order to respond to an INIT chunk,
the INIT verification succeeds and while we walk and process
all INIT params via sctp_process_param() we find that
net->sctp.auth_enable is set, therefore do not fall through,
but invoke sctp_auth_asoc_set_default_hmac() instead, and thus,
dereference what we have set to NULL during endpoint
initialization phase.

The fix is to make auth_enable immutable by caching its value
during endpoint initialization, so that its original value is
being carried along until destruction. The bug seems to originate
from the very first days.

Fix in joint work with Daniel Borkmann.

Reported-by: Joshua Kinard <kumba@gentoo.org>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Tested-by: Joshua Kinard <kumba@gentoo.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/net/sctp/structs.h |  4 +++-
 net/sctp/auth.c            | 17 ++++++---------
 net/sctp/endpointola.c     |  3 ++-
 net/sctp/sm_make_chunk.c   | 32 ++++++++++++++-------------
 net/sctp/sm_statefuns.c    |  6 +++---
 net/sctp/socket.c          | 54 ++++++++++++++++++++++------------------------
 net/sctp/sysctl.c          | 38 ++++++++++++++++++++++++++++++--
 7 files changed, 93 insertions(+), 61 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 2174d8da0770..8b31f09dd695 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1245,6 +1245,7 @@ struct sctp_endpoint {
 	/* SCTP-AUTH: endpoint shared keys */
 	struct list_head endpoint_shared_keys;
 	__u16 active_key_id;
+	__u8  auth_enable;
 };
 
 /* Recover the outter endpoint structure. */
@@ -1273,7 +1274,8 @@ struct sctp_endpoint *sctp_endpoint_is_match(struct sctp_endpoint *,
 int sctp_has_association(struct net *net, const union sctp_addr *laddr,
 			 const union sctp_addr *paddr);
 
-int sctp_verify_init(struct net *net, const struct sctp_association *asoc,
+int sctp_verify_init(struct net *net, const struct sctp_endpoint *ep,
+		     const struct sctp_association *asoc,
 		     sctp_cid_t, sctp_init_chunk_t *peer_init,
 		     struct sctp_chunk *chunk, struct sctp_chunk **err_chunk);
 int sctp_process_init(struct sctp_association *, struct sctp_chunk *chunk,
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 8c4fa5dec824..43b871f6cddf 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -387,14 +387,13 @@ nomem:
  */
 int sctp_auth_asoc_init_active_key(struct sctp_association *asoc, gfp_t gfp)
 {
-	struct net *net = sock_net(asoc->base.sk);
 	struct sctp_auth_bytes	*secret;
 	struct sctp_shared_key *ep_key;
 
 	/* If we don't support AUTH, or peer is not capable
 	 * we don't need to do anything.
 	 */
-	if (!net->sctp.auth_enable || !asoc->peer.auth_capable)
+	if (!asoc->ep->auth_enable || !asoc->peer.auth_capable)
 		return 0;
 
 	/* If the key_id is non-zero and we couldn't find an
@@ -441,16 +440,16 @@ struct sctp_shared_key *sctp_auth_get_shkey(
  */
 int sctp_auth_init_hmacs(struct sctp_endpoint *ep, gfp_t gfp)
 {
-	struct net *net = sock_net(ep->base.sk);
 	struct crypto_hash *tfm = NULL;
 	__u16   id;
 
-	/* if the transforms are already allocted, we are done */
-	if (!net->sctp.auth_enable) {
+	/* If AUTH extension is disabled, we are done */
+	if (!ep->auth_enable) {
 		ep->auth_hmacs = NULL;
 		return 0;
 	}
 
+	/* If the transforms are already allocated, we are done */
 	if (ep->auth_hmacs)
 		return 0;
 
@@ -671,12 +670,10 @@ static int __sctp_auth_cid(sctp_cid_t chunk, struct sctp_chunks_param *param)
 /* Check if peer requested that this chunk is authenticated */
 int sctp_auth_send_cid(sctp_cid_t chunk, const struct sctp_association *asoc)
 {
-	struct net  *net;
 	if (!asoc)
 		return 0;
 
-	net = sock_net(asoc->base.sk);
-	if (!net->sctp.auth_enable || !asoc->peer.auth_capable)
+	if (!asoc->ep->auth_enable || !asoc->peer.auth_capable)
 		return 0;
 
 	return __sctp_auth_cid(chunk, asoc->peer.peer_chunks);
@@ -685,12 +682,10 @@ int sctp_auth_send_cid(sctp_cid_t chunk, const struct sctp_association *asoc)
 /* Check if we requested that peer authenticate this chunk. */
 int sctp_auth_recv_cid(sctp_cid_t chunk, const struct sctp_association *asoc)
 {
-	struct net *net;
 	if (!asoc)
 		return 0;
 
-	net = sock_net(asoc->base.sk);
-	if (!net->sctp.auth_enable)
+	if (!asoc->ep->auth_enable)
 		return 0;
 
 	return __sctp_auth_cid(chunk,
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 09b8daac87c8..477dd23a9864 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -69,7 +69,8 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	if (!ep->digest)
 		return NULL;
 
-	if (net->sctp.auth_enable) {
+	ep->auth_enable = net->sctp.auth_enable;
+	if (ep->auth_enable) {
 		/* Allocate space for HMACS and CHUNKS authentication
 		 * variables.  There are arrays that we encode directly
 		 * into parameters to make the rest of the operations easier.
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 26be077b8267..1e06f3b23108 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -218,6 +218,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 			     gfp_t gfp, int vparam_len)
 {
 	struct net *net = sock_net(asoc->base.sk);
+	struct sctp_endpoint *ep = asoc->ep;
 	sctp_inithdr_t init;
 	union sctp_params addrs;
 	size_t chunksize;
@@ -277,7 +278,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	chunksize += vparam_len;
 
 	/* Account for AUTH related parameters */
-	if (net->sctp.auth_enable) {
+	if (ep->auth_enable) {
 		/* Add random parameter length*/
 		chunksize += sizeof(asoc->c.auth_random);
 
@@ -362,7 +363,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	}
 
 	/* Add SCTP-AUTH chunks to the parameter list */
-	if (net->sctp.auth_enable) {
+	if (ep->auth_enable) {
 		sctp_addto_chunk(retval, sizeof(asoc->c.auth_random),
 				 asoc->c.auth_random);
 		if (auth_hmacs)
@@ -2023,7 +2024,7 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 			    /* if the peer reports AUTH, assume that he
 			     * supports AUTH.
 			     */
-			    if (net->sctp.auth_enable)
+			    if (asoc->ep->auth_enable)
 				    asoc->peer.auth_capable = 1;
 			    break;
 		    case SCTP_CID_ASCONF:
@@ -2115,6 +2116,7 @@ static sctp_ierror_t sctp_process_unk_param(const struct sctp_association *asoc,
  * 	SCTP_IERROR_NO_ERROR - continue with the chunk
  */
 static sctp_ierror_t sctp_verify_param(struct net *net,
+					const struct sctp_endpoint *ep,
 					const struct sctp_association *asoc,
 					union sctp_params param,
 					sctp_cid_t cid,
@@ -2165,7 +2167,7 @@ static sctp_ierror_t sctp_verify_param(struct net *net,
 		goto fallthrough;
 
 	case SCTP_PARAM_RANDOM:
-		if (!net->sctp.auth_enable)
+		if (!ep->auth_enable)
 			goto fallthrough;
 
 		/* SCTP-AUTH: Secion 6.1
@@ -2182,7 +2184,7 @@ static sctp_ierror_t sctp_verify_param(struct net *net,
 		break;
 
 	case SCTP_PARAM_CHUNKS:
-		if (!net->sctp.auth_enable)
+		if (!ep->auth_enable)
 			goto fallthrough;
 
 		/* SCTP-AUTH: Section 3.2
@@ -2198,7 +2200,7 @@ static sctp_ierror_t sctp_verify_param(struct net *net,
 		break;
 
 	case SCTP_PARAM_HMAC_ALGO:
-		if (!net->sctp.auth_enable)
+		if (!ep->auth_enable)
 			goto fallthrough;
 
 		hmacs = (struct sctp_hmac_algo_param *)param.p;
@@ -2233,10 +2235,9 @@ fallthrough:
 }
 
 /* Verify the INIT packet before we process it.  */
-int sctp_verify_init(struct net *net, const struct sctp_association *asoc,
-		     sctp_cid_t cid,
-		     sctp_init_chunk_t *peer_init,
-		     struct sctp_chunk *chunk,
+int sctp_verify_init(struct net *net, const struct sctp_endpoint *ep,
+		     const struct sctp_association *asoc, sctp_cid_t cid,
+		     sctp_init_chunk_t *peer_init, struct sctp_chunk *chunk,
 		     struct sctp_chunk **errp)
 {
 	union sctp_params param;
@@ -2277,8 +2278,8 @@ int sctp_verify_init(struct net *net, const struct sctp_association *asoc,
 
 	/* Verify all the variable length parameters */
 	sctp_walk_params(param, peer_init, init_hdr.params) {
-
-		result = sctp_verify_param(net, asoc, param, cid, chunk, errp);
+		result = sctp_verify_param(net, ep, asoc, param, cid,
+					   chunk, errp);
 		switch (result) {
 		    case SCTP_IERROR_ABORT:
 		    case SCTP_IERROR_NOMEM:
@@ -2510,6 +2511,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 	struct sctp_af *af;
 	union sctp_addr_param *addr_param;
 	struct sctp_transport *t;
+	struct sctp_endpoint *ep = asoc->ep;
 
 	/* We maintain all INIT parameters in network byte order all the
 	 * time.  This allows us to not worry about whether the parameters
@@ -2649,7 +2651,7 @@ do_addr_param:
 		goto fall_through;
 
 	case SCTP_PARAM_RANDOM:
-		if (!net->sctp.auth_enable)
+		if (!ep->auth_enable)
 			goto fall_through;
 
 		/* Save peer's random parameter */
@@ -2662,7 +2664,7 @@ do_addr_param:
 		break;
 
 	case SCTP_PARAM_HMAC_ALGO:
-		if (!net->sctp.auth_enable)
+		if (!ep->auth_enable)
 			goto fall_through;
 
 		/* Save peer's HMAC list */
@@ -2678,7 +2680,7 @@ do_addr_param:
 		break;
 
 	case SCTP_PARAM_CHUNKS:
-		if (!net->sctp.auth_enable)
+		if (!ep->auth_enable)
 			goto fall_through;
 
 		asoc->peer.peer_chunks = kmemdup(param.p,
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 0a5f0508c43a..5dcfe8ca7f69 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -358,7 +358,7 @@ sctp_disposition_t sctp_sf_do_5_1B_init(struct net *net,
 
 	/* Verify the INIT chunk before processing it. */
 	err_chunk = NULL;
-	if (!sctp_verify_init(net, asoc, chunk->chunk_hdr->type,
+	if (!sctp_verify_init(net, ep, asoc, chunk->chunk_hdr->type,
 			      (sctp_init_chunk_t *)chunk->chunk_hdr, chunk,
 			      &err_chunk)) {
 		/* This chunk contains fatal error. It is to be discarded.
@@ -525,7 +525,7 @@ sctp_disposition_t sctp_sf_do_5_1C_ack(struct net *net,
 
 	/* Verify the INIT chunk before processing it. */
 	err_chunk = NULL;
-	if (!sctp_verify_init(net, asoc, chunk->chunk_hdr->type,
+	if (!sctp_verify_init(net, ep, asoc, chunk->chunk_hdr->type,
 			      (sctp_init_chunk_t *)chunk->chunk_hdr, chunk,
 			      &err_chunk)) {
 
@@ -1431,7 +1431,7 @@ static sctp_disposition_t sctp_sf_do_unexpected_init(
 
 	/* Verify the INIT chunk before processing it. */
 	err_chunk = NULL;
-	if (!sctp_verify_init(net, asoc, chunk->chunk_hdr->type,
+	if (!sctp_verify_init(net, ep, asoc, chunk->chunk_hdr->type,
 			      (sctp_init_chunk_t *)chunk->chunk_hdr, chunk,
 			      &err_chunk)) {
 		/* This chunk contains fatal error. It is to be discarded.
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index dc496f2bc6c5..e00a041129c2 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3296,10 +3296,10 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
 				      char __user *optval,
 				      unsigned int optlen)
 {
-	struct net *net = sock_net(sk);
+	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_authchunk val;
 
-	if (!net->sctp.auth_enable)
+	if (!ep->auth_enable)
 		return -EACCES;
 
 	if (optlen != sizeof(struct sctp_authchunk))
@@ -3316,7 +3316,7 @@ static int sctp_setsockopt_auth_chunk(struct sock *sk,
 	}
 
 	/* add this chunk id to the endpoint */
-	return sctp_auth_ep_add_chunkid(sctp_sk(sk)->ep, val.sauth_chunk);
+	return sctp_auth_ep_add_chunkid(ep, val.sauth_chunk);
 }
 
 /*
@@ -3329,12 +3329,12 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 				      char __user *optval,
 				      unsigned int optlen)
 {
-	struct net *net = sock_net(sk);
+	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_hmacalgo *hmacs;
 	u32 idents;
 	int err;
 
-	if (!net->sctp.auth_enable)
+	if (!ep->auth_enable)
 		return -EACCES;
 
 	if (optlen < sizeof(struct sctp_hmacalgo))
@@ -3351,7 +3351,7 @@ static int sctp_setsockopt_hmac_ident(struct sock *sk,
 		goto out;
 	}
 
-	err = sctp_auth_ep_set_hmacs(sctp_sk(sk)->ep, hmacs);
+	err = sctp_auth_ep_set_hmacs(ep, hmacs);
 out:
 	kfree(hmacs);
 	return err;
@@ -3367,12 +3367,12 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 				    char __user *optval,
 				    unsigned int optlen)
 {
-	struct net *net = sock_net(sk);
+	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_authkey *authkey;
 	struct sctp_association *asoc;
 	int ret;
 
-	if (!net->sctp.auth_enable)
+	if (!ep->auth_enable)
 		return -EACCES;
 
 	if (optlen <= sizeof(struct sctp_authkey))
@@ -3393,7 +3393,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 		goto out;
 	}
 
-	ret = sctp_auth_set_key(sctp_sk(sk)->ep, asoc, authkey);
+	ret = sctp_auth_set_key(ep, asoc, authkey);
 out:
 	kzfree(authkey);
 	return ret;
@@ -3409,11 +3409,11 @@ static int sctp_setsockopt_active_key(struct sock *sk,
 				      char __user *optval,
 				      unsigned int optlen)
 {
-	struct net *net = sock_net(sk);
+	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_authkeyid val;
 	struct sctp_association *asoc;
 
-	if (!net->sctp.auth_enable)
+	if (!ep->auth_enable)
 		return -EACCES;
 
 	if (optlen != sizeof(struct sctp_authkeyid))
@@ -3425,8 +3425,7 @@ static int sctp_setsockopt_active_key(struct sock *sk,
 	if (!asoc && val.scact_assoc_id && sctp_style(sk, UDP))
 		return -EINVAL;
 
-	return sctp_auth_set_active_key(sctp_sk(sk)->ep, asoc,
-					val.scact_keynumber);
+	return sctp_auth_set_active_key(ep, asoc, val.scact_keynumber);
 }
 
 /*
@@ -3438,11 +3437,11 @@ static int sctp_setsockopt_del_key(struct sock *sk,
 				   char __user *optval,
 				   unsigned int optlen)
 {
-	struct net *net = sock_net(sk);
+	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_authkeyid val;
 	struct sctp_association *asoc;
 
-	if (!net->sctp.auth_enable)
+	if (!ep->auth_enable)
 		return -EACCES;
 
 	if (optlen != sizeof(struct sctp_authkeyid))
@@ -3454,8 +3453,7 @@ static int sctp_setsockopt_del_key(struct sock *sk,
 	if (!asoc && val.scact_assoc_id && sctp_style(sk, UDP))
 		return -EINVAL;
 
-	return sctp_auth_del_key_id(sctp_sk(sk)->ep, asoc,
-				    val.scact_keynumber);
+	return sctp_auth_del_key_id(ep, asoc, val.scact_keynumber);
 
 }
 
@@ -5353,16 +5351,16 @@ static int sctp_getsockopt_maxburst(struct sock *sk, int len,
 static int sctp_getsockopt_hmac_ident(struct sock *sk, int len,
 				    char __user *optval, int __user *optlen)
 {
-	struct net *net = sock_net(sk);
+	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_hmacalgo  __user *p = (void __user *)optval;
 	struct sctp_hmac_algo_param *hmacs;
 	__u16 data_len = 0;
 	u32 num_idents;
 
-	if (!net->sctp.auth_enable)
+	if (!ep->auth_enable)
 		return -EACCES;
 
-	hmacs = sctp_sk(sk)->ep->auth_hmacs_list;
+	hmacs = ep->auth_hmacs_list;
 	data_len = ntohs(hmacs->param_hdr.length) - sizeof(sctp_paramhdr_t);
 
 	if (len < sizeof(struct sctp_hmacalgo) + data_len)
@@ -5383,11 +5381,11 @@ static int sctp_getsockopt_hmac_ident(struct sock *sk, int len,
 static int sctp_getsockopt_active_key(struct sock *sk, int len,
 				    char __user *optval, int __user *optlen)
 {
-	struct net *net = sock_net(sk);
+	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_authkeyid val;
 	struct sctp_association *asoc;
 
-	if (!net->sctp.auth_enable)
+	if (!ep->auth_enable)
 		return -EACCES;
 
 	if (len < sizeof(struct sctp_authkeyid))
@@ -5402,7 +5400,7 @@ static int sctp_getsockopt_active_key(struct sock *sk, int len,
 	if (asoc)
 		val.scact_keynumber = asoc->active_key_id;
 	else
-		val.scact_keynumber = sctp_sk(sk)->ep->active_key_id;
+		val.scact_keynumber = ep->active_key_id;
 
 	len = sizeof(struct sctp_authkeyid);
 	if (put_user(len, optlen))
@@ -5416,7 +5414,7 @@ static int sctp_getsockopt_active_key(struct sock *sk, int len,
 static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 				    char __user *optval, int __user *optlen)
 {
-	struct net *net = sock_net(sk);
+	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_authchunks __user *p = (void __user *)optval;
 	struct sctp_authchunks val;
 	struct sctp_association *asoc;
@@ -5424,7 +5422,7 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 	u32    num_chunks = 0;
 	char __user *to;
 
-	if (!net->sctp.auth_enable)
+	if (!ep->auth_enable)
 		return -EACCES;
 
 	if (len < sizeof(struct sctp_authchunks))
@@ -5460,7 +5458,7 @@ num:
 static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
 				    char __user *optval, int __user *optlen)
 {
-	struct net *net = sock_net(sk);
+	struct sctp_endpoint *ep = sctp_sk(sk)->ep;
 	struct sctp_authchunks __user *p = (void __user *)optval;
 	struct sctp_authchunks val;
 	struct sctp_association *asoc;
@@ -5468,7 +5466,7 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
 	u32    num_chunks = 0;
 	char __user *to;
 
-	if (!net->sctp.auth_enable)
+	if (!ep->auth_enable)
 		return -EACCES;
 
 	if (len < sizeof(struct sctp_authchunks))
@@ -5485,7 +5483,7 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
 	if (asoc)
 		ch = (struct sctp_chunks_param*)asoc->c.auth_chunks;
 	else
-		ch = sctp_sk(sk)->ep->auth_chunk_list;
+		ch = ep->auth_chunk_list;
 
 	if (!ch)
 		goto num;
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 6b36561a1b3b..3e5ac1948607 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -59,8 +59,11 @@ extern int sysctl_sctp_wmem[3];
 static int proc_sctp_do_hmac_alg(struct ctl_table *ctl,
 				int write,
 				void __user *buffer, size_t *lenp,
-
 				loff_t *ppos);
+static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
+			     void __user *buffer, size_t *lenp,
+			     loff_t *ppos);
+
 static struct ctl_table sctp_table[] = {
 	{
 		.procname	= "sctp_mem",
@@ -261,7 +264,7 @@ static struct ctl_table sctp_net_table[] = {
 		.data		= &init_net.sctp.auth_enable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_sctp_do_auth,
 	},
 	{
 		.procname	= "addr_scope_policy",
@@ -342,6 +345,37 @@ static int proc_sctp_do_hmac_alg(struct ctl_table *ctl,
 	return ret;
 }
 
+static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
+			     void __user *buffer, size_t *lenp,
+			     loff_t *ppos)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct ctl_table tbl;
+	int new_value, ret;
+
+	memset(&tbl, 0, sizeof(struct ctl_table));
+	tbl.maxlen = sizeof(unsigned int);
+
+	if (write)
+		tbl.data = &new_value;
+	else
+		tbl.data = &net->sctp.auth_enable;
+
+	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
+
+	if (write) {
+		struct sock *sk = net->sctp.ctl_sock;
+
+		net->sctp.auth_enable = new_value;
+		/* Update the value in the control socket */
+		lock_sock(sk);
+		sctp_sk(sk)->ep->auth_enable = new_value;
+		release_sock(sk);
+	}
+
+	return ret;
+}
+
 int sctp_sysctl_net_register(struct net *net)
 {
 	struct ctl_table *table;
-- 
1.9.3

