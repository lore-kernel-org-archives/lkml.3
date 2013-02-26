Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab3BZX6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:58:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999Ab3BZX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Romain Kuntz <r.kuntz@ipflavors.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 126/150] xfrm: release neighbor upon dst destruction
Date: Tue, 26 Feb 2013 15:56:23 -0800
Message-Id: <20130226235537.228929650@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Romain KUNTZ <r.kuntz@ipflavors.com>

[ Upstream commit 18cf0d0784b4a634472ed24d0d7ca1c721d93e90 ]

Neighbor is cloned in xfrm6_fill_dst but seems to never be released.
Neighbor entry should be released when XFRM6 dst entry is destroyed
in xfrm6_dst_destroy, otherwise references may be kept forever on
the device pointed by the neighbor entry.

I may not have understood all the subtleties of XFRM & dst so I would
be happy to receive comments on this patch.

Signed-off-by: Romain Kuntz <r.kuntz@ipflavors.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/xfrm6_policy.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -236,6 +236,8 @@ static void xfrm6_dst_destroy(struct dst
 {
 	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
 
+	if (likely(xdst->u.rt6.n))
+		neigh_release(xdst->u.rt6.n);
 	if (likely(xdst->u.rt6.rt6i_idev))
 		in6_dev_put(xdst->u.rt6.rt6i_idev);
 	dst_destroy_metrics_generic(dst);


