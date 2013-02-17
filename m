Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab3BQXCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:02:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45764 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755131Ab3BQWzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:40 -0500
Message-Id: <20130217225006.756092338@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:45 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Romain KUNTZ <r.kuntz@ipflavors.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 44/66] ipv6: fix header length calculation in  ip6_append_data()
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain KUNTZ <r.kuntz@ipflavors.com>

[ Upstream commit 7efdba5bd9a2f3e2059beeb45c9fa55eefe1bced ]

Commit 299b0767 (ipv6: Fix IPsec slowpath fragmentation problem)
has introduced a error in the header length calculation that
provokes corrupted packets when non-fragmentable extensions
headers (Destination Option or Routing Header Type 2) are used.

rt->rt6i_nfheader_len is the length of the non-fragmentable
extension header, and it should be substracted to
rt->dst.header_len, and not to exthdrlen, as it was done before
commit 299b0767.

This patch reverts to the original and correct behavior. It has
been successfully tested with and without IPsec on packets
that include non-fragmentable extensions headers.

Signed-off-by: Romain Kuntz <r.kuntz@ipflavors.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/ip6_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ae98e09..3ccd9b2 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1284,10 +1284,10 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 		cork->length = 0;
 		sk->sk_sndmsg_page = NULL;
 		sk->sk_sndmsg_off = 0;
-		exthdrlen = (opt ? opt->opt_flen : 0) - rt->rt6i_nfheader_len;
+		exthdrlen = (opt ? opt->opt_flen : 0);
 		length += exthdrlen;
 		transhdrlen += exthdrlen;
-		dst_exthdrlen = rt->dst.header_len;
+		dst_exthdrlen = rt->dst.header_len - rt->rt6i_nfheader_len;
 	} else {
 		rt = (struct rt6_info *)cork->dst;
 		fl6 = &inet->cork.fl.u.ip6;


