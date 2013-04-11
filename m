Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015Ab3DKUji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:39:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3DKUZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:58 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=S3k0jK8oje4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=yXktzNqmhe8A:10 a=J1Y8HTJGAAAA:8 a=xO8Y1Q4gfh1P_ipYzY4A:9 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202547.077972939@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Ward <david.ward@ll.mit.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 005/171 ] net/ipv4: Ensure that location of timestamp option is stored
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0005-net-ipv4-Ensure-that-location-of-timestamp-option-is.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: David Ward <david.ward@ll.mit.edu>

[ Upstream commit 4660c7f498c07c43173142ea95145e9dac5a6d14 ]

This is needed in order to detect if the timestamp option appears
more than once in a packet, to remove the option if the packet is
fragmented, etc. My previous change neglected to store the option
location when the router addresses were prespecified and Pointer >
Length. But now the option location is also stored when Flag is an
unrecognized value, to ensure these option handling behaviors are
still performed.

Signed-off-by: David Ward <david.ward@ll.mit.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/ip_options.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index 1dc01f9..98e6916 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -370,7 +370,6 @@ int ip_options_compile(struct net *net,
 				}
 				switch (optptr[3]&0xF) {
 				      case IPOPT_TS_TSONLY:
-					opt->ts = optptr - iph;
 					if (skb)
 						timeptr = &optptr[optptr[2]-1];
 					opt->ts_needtime = 1;
@@ -381,7 +380,6 @@ int ip_options_compile(struct net *net,
 						pp_ptr = optptr + 2;
 						goto error;
 					}
-					opt->ts = optptr - iph;
 					if (rt)  {
 						spec_dst_fill(&spec_dst, skb);
 						memcpy(&optptr[optptr[2]-1], &spec_dst, 4);
@@ -396,7 +394,6 @@ int ip_options_compile(struct net *net,
 						pp_ptr = optptr + 2;
 						goto error;
 					}
-					opt->ts = optptr - iph;
 					{
 						__be32 addr;
 						memcpy(&addr, &optptr[optptr[2]-1], 4);
@@ -429,12 +426,12 @@ int ip_options_compile(struct net *net,
 					pp_ptr = optptr + 3;
 					goto error;
 				}
-				opt->ts = optptr - iph;
 				if (skb) {
 					optptr[3] = (optptr[3]&0xF)|((overflow+1)<<4);
 					opt->is_changed = 1;
 				}
 			}
+			opt->ts = optptr - iph;
 			break;
 		      case IPOPT_RA:
 			if (optlen < 4) {
-- 
1.7.10.4


