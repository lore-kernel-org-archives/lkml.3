Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaBLIlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:41:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50054 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbaBLINs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:48 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Jakub Zawadzki" <darkjames-ws@darkjames.pl>,
        "Daniel Borkmann" <dborkman@redhat.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.830956410@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 07/79] net: inet_diag: zero out uninitialized
 idiag_{src,dst}  fields
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit b1aac815c0891fe4a55a6b0b715910142227700f ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/inet_diag.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index ccee270..b1508bd 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -119,6 +119,10 @@ static int inet_csk_diag_fill(struct sock *sk,
 
 	r->id.idiag_sport = inet->inet_sport;
 	r->id.idiag_dport = inet->inet_dport;
+
+	memset(&r->id.idiag_src, 0, sizeof(r->id.idiag_src));
+	memset(&r->id.idiag_dst, 0, sizeof(r->id.idiag_dst));
+
 	r->id.idiag_src[0] = inet->inet_rcv_saddr;
 	r->id.idiag_dst[0] = inet->inet_daddr;
 
@@ -209,13 +213,20 @@ static int inet_twsk_diag_fill(struct inet_timewait_sock *tw,
 
 	r->idiag_family	      = tw->tw_family;
 	r->idiag_retrans      = 0;
+
 	r->id.idiag_if	      = tw->tw_bound_dev_if;
 	r->id.idiag_cookie[0] = (u32)(unsigned long)tw;
 	r->id.idiag_cookie[1] = (u32)(((unsigned long)tw >> 31) >> 1);
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
@@ -598,8 +609,13 @@ static int inet_diag_fill_req(struct sk_buff *skb, struct sock *sk,
 
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

