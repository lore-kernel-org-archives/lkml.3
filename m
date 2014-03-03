Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaCCTSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:18:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55939 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaCCS4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:56:17 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>, Harald Welte <laforge@gnumonks.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 01/67] netfilter: nf_nat: fix access to uninitialized buffer in IRC NAT helper
Date: Mon,  3 Mar 2014 10:54:49 -0800
Message-Id: <1393872955-28810-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit 2690d97ade05c5325cbf7c72b94b90d265659886 upstream.

Commit 5901b6be885e attempted to introduce IPv6 support into
IRC NAT helper. By doing so, the following code seemed to be removed
by accident:

  ip = ntohl(exp->master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip);
  sprintf(buffer, "%u %u", ip, port);
  pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n", buffer, &ip, port);

This leads to the fact that buffer[] was left uninitialized and
contained some stack value. When we call nf_nat_mangle_tcp_packet(),
we call strlen(buffer) on excatly this uninitialized buffer. If we
are unlucky and the skb has enough tailroom, we overwrite resp. leak
contents with values that sit on our stack into the packet and send
that out to the receiver.

Since the rather informal DCC spec [1] does not seem to specify
IPv6 support right now, we log such occurences so that admins can
act accordingly, and drop the packet. I've looked into XChat source,
and IPv6 is not supported there: addresses are in u32 and print
via %u format string.

Therefore, restore old behaviour as in IPv4, use snprintf(). The
IRC helper does not support IPv6 by now. By this, we can safely use
strlen(buffer) in nf_nat_mangle_tcp_packet() and prevent a buffer
overflow. Also simplify some code as we now have ct variable anyway.

  [1] http://www.irchelp.org/irchelp/rfc/ctcpspec.html

Fixes: 5901b6be885e ("netfilter: nf_nat: support IPv6 in IRC NAT helper")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ kamal: backport to 3.8 for CVE-2014-1690 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/netfilter/nf_nat_irc.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 1fedee6..915be4f 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -34,10 +34,14 @@ static unsigned int help(struct sk_buff *skb,
 			 struct nf_conntrack_expect *exp)
 {
 	char buffer[sizeof("4294967296 65635")];
+	struct nf_conn *ct = exp->master;
+	union nf_inet_addr newaddr;
 	u_int16_t port;
 	unsigned int ret;
 
 	/* Reply comes from server. */
+	newaddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3;
+
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = nf_nat_follow_master;
@@ -59,11 +63,29 @@ static unsigned int help(struct sk_buff *skb,
 	if (port == 0)
 		return NF_DROP;
 
-	ret = nf_nat_mangle_tcp_packet(skb, exp->master, ctinfo,
-				       protoff, matchoff, matchlen, buffer,
-				       strlen(buffer));
+	/* strlen("\1DCC CHAT chat AAAAAAAA P\1\n")=27
+	 * strlen("\1DCC SCHAT chat AAAAAAAA P\1\n")=28
+	 * strlen("\1DCC SEND F AAAAAAAA P S\1\n")=26
+	 * strlen("\1DCC MOVE F AAAAAAAA P S\1\n")=26
+	 * strlen("\1DCC TSEND F AAAAAAAA P S\1\n")=27
+	 *
+	 * AAAAAAAAA: bound addr (1.0.0.0==16777216, min 8 digits,
+	 *                        255.255.255.255==4294967296, 10 digits)
+	 * P:         bound port (min 1 d, max 5d (65635))
+	 * F:         filename   (min 1 d )
+	 * S:         size       (min 1 d )
+	 * 0x01, \n:  terminators
+	 */
+	/* AAA = "us", ie. where server normally talks to. */
+	snprintf(buffer, sizeof(buffer), "%u %u", ntohl(newaddr.ip), port);
+	pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n",
+		 buffer, &newaddr.ip, port);
+
+	ret = nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff, matchoff,
+				       matchlen, buffer, strlen(buffer));
 	if (ret != NF_ACCEPT)
 		nf_ct_unexpect_related(exp);
+
 	return ret;
 }
 
-- 
1.8.3.2

