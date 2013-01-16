Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab3APWrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:47:46 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53861 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab3APWrp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:47:45 -0500
From: Romain KUNTZ <r.kuntz@ipflavors.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 1/1] ipv6: fix header length calculation in ip6_append_data()
Date: Wed, 16 Jan 2013 23:47:40 +0100
Message-Id: <F2E313A0-60C5-49DE-BBB7-BAEF532C0433@ipflavors.com>
Cc: "yoshfuji@linux-ipv6.org Hideaki" <yoshfuji@linux-ipv6.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Romain KUNTZ <r.kuntz@ipflavors.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 net/ipv6/ip6_output.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 5552d13..0c7c03d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1213,10 +1213,10 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 		if (dst_allfrag(rt->dst.path))
 			cork->flags |= IPCORK_ALLFRAG;
 		cork->length = 0;
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
1.7.2.5


