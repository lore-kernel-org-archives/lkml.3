Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbaJCW1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:27:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778AbaJCW0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:26:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Koch <florian.koch1981@gmail.com>
Subject: [PATCH 3.10 133/143] netfilter: nf_conntrack: avoid large timeout for mid-stream pickup
Date: Fri,  3 Oct 2014 14:35:28 -0700
Message-Id: <20141003213318.469004232@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 6547a221871f139cc56328a38105d47c14874cbe upstream.

When loose tracking is enabled (default), non-syn packets cause
creation of new conntracks in established state with default timeout for
established state (5 days).  This causes the table to fill up with UNREPLIED
when the 'new ack' packet happened to be the last-ack of a previous,
already timed-out connection.

Consider:

A 192.168.x.52792 > 10.184.y.80: F, 426:426(0) ack 9237 win 255
B 10.184.y.80 > 192.168.x.52792: ., ack 427 win 123
<61 second pause>
C 10.184.y.80 > 192.168.x.52792: F, 9237:9237(0) ack 427 win 123
D 192.168.x.52792 > 10.184.y.80: ., ack 9238 win 255

B moves conntrack to CLOSE_WAIT and will kill it after 60 second timeout,
C is ignored (FIN set), but last packet (D) causes new ct with 5-days timeout.

Use UNACK timeout (5 minutes) instead to get rid of these entries sooner
when in ESTABLISHED state without having seen traffic in both directions.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Koch <florian.koch1981@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_proto_tcp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1043,6 +1043,12 @@ static int tcp_packet(struct nf_conn *ct
 			nf_ct_kill_acct(ct, ctinfo, skb);
 			return NF_ACCEPT;
 		}
+		/* ESTABLISHED without SEEN_REPLY, i.e. mid-connection
+		 * pickup with loose=1. Avoid large ESTABLISHED timeout.
+		 */
+		if (new_state == TCP_CONNTRACK_ESTABLISHED &&
+		    timeout > timeouts[TCP_CONNTRACK_UNACK])
+			timeout = timeouts[TCP_CONNTRACK_UNACK];
 	} else if (!test_bit(IPS_ASSURED_BIT, &ct->status)
 		   && (old_state == TCP_CONNTRACK_SYN_RECV
 		       || old_state == TCP_CONNTRACK_ESTABLISHED)


