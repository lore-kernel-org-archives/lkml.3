Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab3CZRv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:51:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30328 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab3CZRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:19 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=gHOTU00wqxcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Bpd_JS36I2UA:10 a=LX4ocfrYAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=kn0Bwszx2mEA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173612.596554314@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Romain Kuntz <r.kuntz@ipflavors.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 80/86] xfrm: release neighbor upon dst destruction
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0080-xfrm-release-neighbor-upon-dst-destruction.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Romain KUNTZ <r.kuntz@ipflavors.com>

[ Upstream commit 2894f6da7e382a42948cc42ab52148dddf281c48 ]

Neighbor is cloned in xfrm6_fill_dst but seems to never be released.
Neighbor entry should be released when XFRM6 dst entry is destroyed
in xfrm6_dst_destroy, otherwise references may be kept forever on
the device pointed by the neighbor entry.

I may not have understood all the subtleties of XFRM & dst so I would
be happy to receive comments on this patch.

Signed-off-by: Romain Kuntz <r.kuntz@ipflavors.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv6/xfrm6_policy.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index f8c4c08..bf6912e 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -236,6 +236,8 @@ static void xfrm6_dst_destroy(struct dst_entry *dst)
 {
 	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
 
+	if (likely(xdst->u.rt6.n))
+		neigh_release(xdst->u.rt6.n);
 	if (likely(xdst->u.rt6.rt6i_idev))
 		in6_dev_put(xdst->u.rt6.rt6i_idev);
 	dst_destroy_metrics_generic(dst);
-- 
1.7.10.4


