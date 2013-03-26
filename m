Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3CZSCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:02:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab3CZRgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:04 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=PzjLC5KngAMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=W1IfmlWVB78A:10 a=LX4ocfrYAAAA:8 a=7ZN4cI0QAAAA:8 a=J1Y8HTJGAAAA:8 a=A6JhlzONrO9bIP6th7sA:9 a=kn0Bwszx2mEA:10 a=Vn2gH7L4UmAA:10 a=4N9Db7Z2_RYA:10 a=fKtNf-Ps0EyWsQm9:21 a=ji_1UgaFNwukY5pl:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173601.595507584@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Romain Kuntz <r.kuntz@ipflavors.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 11/86] ipv6: fix header length calculation in ip6_append_data()
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0011-ipv6-fix-header-length-calculation-in-ip6_append_dat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 net/ipv6/ip6_output.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 5b2d63e..3d485ec 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1287,10 +1287,10 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
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
-- 
1.7.10.4


