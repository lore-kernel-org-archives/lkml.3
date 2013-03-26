Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965487Ab3CZPYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:24:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54182 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965410Ab3CZPYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Ward <david.ward@ll.mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 141/150] net/ipv4: Ensure that location of timestamp option is stored
Date: Tue, 26 Mar 2013 15:20:40 +0000
Message-Id: <1364311249-14454-142-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ward <david.ward@ll.mit.edu>

commit 4660c7f498c07c43173142ea95145e9dac5a6d14 upstream.

This is needed in order to detect if the timestamp option appears
more than once in a packet, to remove the option if the packet is
fragmented, etc. My previous change neglected to store the option
location when the router addresses were prespecified and Pointer >
Length. But now the option location is also stored when Flag is an
unrecognized value, to ensure these option handling behaviors are
still performed.

Signed-off-by: David Ward <david.ward@ll.mit.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_options.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index 708b994..ba9eb94 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -360,7 +360,6 @@ int ip_options_compile(struct net *net,
 				}
 				switch (optptr[3]&0xF) {
 				      case IPOPT_TS_TSONLY:
-					opt->ts = optptr - iph;
 					if (skb)
 						timeptr = &optptr[optptr[2]-1];
 					opt->ts_needtime = 1;
@@ -371,7 +370,6 @@ int ip_options_compile(struct net *net,
 						pp_ptr = optptr + 2;
 						goto error;
 					}
-					opt->ts = optptr - iph;
 					if (rt)  {
 						memcpy(&optptr[optptr[2]-1], &rt->rt_spec_dst, 4);
 						timeptr = &optptr[optptr[2]+3];
@@ -385,7 +383,6 @@ int ip_options_compile(struct net *net,
 						pp_ptr = optptr + 2;
 						goto error;
 					}
-					opt->ts = optptr - iph;
 					{
 						__be32 addr;
 						memcpy(&addr, &optptr[optptr[2]-1], 4);
@@ -418,12 +415,12 @@ int ip_options_compile(struct net *net,
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
1.8.1.2

