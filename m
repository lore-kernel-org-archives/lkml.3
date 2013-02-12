Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab3BLVGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:06:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3BLUfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Romain Kuntz <r.kuntz@ipflavors.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 22/61] ipv6: fix header length calculation in ip6_append_data()
Date: Tue, 12 Feb 2013 12:34:42 -0800
Message-Id: <20130212203421.410400416@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1279,10 +1279,10 @@ int ip6_append_data(struct sock *sk, int
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


