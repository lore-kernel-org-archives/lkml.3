Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3CZXQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:16:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53310 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab3CZXBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:01:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Ward <david.ward@ll.mit.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 03/49] net/ipv4: Ensure that location of timestamp option is stored
Date: Tue, 26 Mar 2013 16:01:00 -0700
Message-Id: <20130326225839.915187592@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_options.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -358,7 +358,6 @@ int ip_options_compile(struct net *net,
 				}
 				switch (optptr[3]&0xF) {
 				      case IPOPT_TS_TSONLY:
-					opt->ts = optptr - iph;
 					if (skb)
 						timeptr = &optptr[optptr[2]-1];
 					opt->ts_needtime = 1;
@@ -369,7 +368,6 @@ int ip_options_compile(struct net *net,
 						pp_ptr = optptr + 2;
 						goto error;
 					}
-					opt->ts = optptr - iph;
 					if (rt)  {
 						memcpy(&optptr[optptr[2]-1], &rt->rt_spec_dst, 4);
 						timeptr = &optptr[optptr[2]+3];
@@ -383,7 +381,6 @@ int ip_options_compile(struct net *net,
 						pp_ptr = optptr + 2;
 						goto error;
 					}
-					opt->ts = optptr - iph;
 					{
 						__be32 addr;
 						memcpy(&addr, &optptr[optptr[2]-1], 4);
@@ -416,12 +413,12 @@ int ip_options_compile(struct net *net,
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


