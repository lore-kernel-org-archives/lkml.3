Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161986Ab3LFWOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:14:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3LFVxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fan Du <fan.du@windriver.com>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 26/58] xfrm: Release dst if this dst is improper for vti tunnel
Date: Fri,  6 Dec 2013 13:51:57 -0800
Message-Id: <20131206214847.332976575@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "fan.du" <fan.du@windriver.com>

[ Upstream commit 236c9f84868534c718b6889aa624de64763281f9 ]

After searching rt by the vti tunnel dst/src parameter,
if this rt has neither attached to any transformation
nor the transformation is not tunnel oriented, this rt
should be released back to ip layer.

otherwise causing dst memory leakage.

Signed-off-by: Fan Du <fan.du@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_vti.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -350,6 +350,7 @@ static netdev_tx_t vti_tunnel_xmit(struc
 	if (!rt->dst.xfrm ||
 	    rt->dst.xfrm->props.mode != XFRM_MODE_TUNNEL) {
 		dev->stats.tx_carrier_errors++;
+		ip_rt_put(rt);
 		goto tx_error_icmp;
 	}
 	tdev = rt->dst.dev;


