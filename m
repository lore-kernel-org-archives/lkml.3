Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaAMOhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:37:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaAMO1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:27:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 86/96] net: inet_diag: zero out uninitialized idiag_{src,dst} fields
Date: Mon, 13 Jan 2014 14:24:49 +0000
Message-Id: <1389623099-18783-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit b1aac815c0891fe4a55a6b0b715910142227700f upstream.

Jakub reported while working with nlmon netlink sniffer that parts of
the inet_diag_sockid are not initialized when r->idiag_family != AF_INET6.
That is, fields of r->id.idiag_src[1 ... 3], r->id.idiag_dst[1 ... 3].

In fact, it seems that we can leak 6 * sizeof(u32) byte of kernel [slab]
memory through this. At least, in udp_dump_one(), we allocate a skb in ...

  rep = nlmsg_new(sizeof(struct inet_diag_msg) + ..., GFP_KERNEL);

... and then pass that to inet_sk_diag_fill() that puts the whole struct
inet_diag_msg into the skb, where we only fill out r->id.idiag_src[0],
r->id.idiag_dst[0] and leave the rest untouched:

  r->id.idiag_src[0] = inet->inet_rcv_saddr;
  r->id.idiag_dst[0] = inet->inet_daddr;

struct inet_diag_msg embeds struct inet_diag_sockid that is correctly /
fully filled out in IPv6 case, but for IPv4 not.

So just zero them out by using plain memset (for this little amount of
bytes it's probably not worth the extra check for idiag_family == AF_INET).

Similarly, fix also other places where we fill that out.

Reported-by: Jakub Zawadzki <darkjames-ws@darkjames.pl>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/inet_diag.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 232560a..e530c31 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -110,6 +110,10 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 
 	r->id.idiag_sport = inet->inet_sport;
 	r->id.idiag_dport = inet->inet_dport;
+
+	memset(&r->id.idiag_src, 0, sizeof(r->id.idiag_src));
+	memset(&r->id.idiag_dst, 0, sizeof(r->id.idiag_dst));
+
 	r->id.idiag_src[0] = inet->inet_rcv_saddr;
 	r->id.idiag_dst[0] = inet->inet_daddr;
 
@@ -227,12 +231,19 @@ static int inet_twsk_diag_fill(struct inet_timewait_sock *tw,
 
 	r->idiag_family	      = tw->tw_family;
 	r->idiag_retrans      = 0;
+
 	r->id.idiag_if	      = tw->tw_bound_dev_if;
 	sock_diag_save_cookie(tw, r->id.idiag_cookie);
+
 	r->id.idiag_sport     = tw->tw_sport;
 	r->id.idiag_dport     = tw->tw_dport;
+
+	memset(&r->id.idiag_src, 0, sizeof(r->id.idiag_src));
+	memset(&r->id.idiag_dst, 0, sizeof(r->id.idiag_dst));
+
 	r->id.idiag_src[0]    = tw->tw_rcv_saddr;
 	r->id.idiag_dst[0]    = tw->tw_daddr;
+
 	r->idiag_state	      = tw->tw_substate;
 	r->idiag_timer	      = 3;
 	r->idiag_expires      = DIV_ROUND_UP(tmo * 1000, HZ);
@@ -714,8 +725,13 @@ static int inet_diag_fill_req(struct sk_buff *skb, struct sock *sk,
 
 	r->id.idiag_sport = inet->inet_sport;
 	r->id.idiag_dport = ireq->rmt_port;
+
+	memset(&r->id.idiag_src, 0, sizeof(r->id.idiag_src));
+	memset(&r->id.idiag_dst, 0, sizeof(r->id.idiag_dst));
+
 	r->id.idiag_src[0] = ireq->loc_addr;
 	r->id.idiag_dst[0] = ireq->rmt_addr;
+
 	r->idiag_expires = jiffies_to_msecs(tmo);
 	r->idiag_rqueue = 0;
 	r->idiag_wqueue = 0;
-- 
1.8.3.2

