Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab3CZRo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:44:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17762 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3CZRoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:44:54 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Nl3UcOKRD-YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=WNiV9POtdYwA:10 a=mK_AVkanAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=9xyTavCNlvEA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173608.882027034@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 56/86] rtnl: fix info leak on RTM_GETLINK request for VF devices
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0056-rtnl-fix-info-leak-on-RTM_GETLINK-request-for-VF-dev.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 84d73cd3fb142bf1298a8c13fd4ca50fd2432372 ]

Initialize the mac address buffer with 0 as the driver specific function
will probably not fill the whole buffer. In fact, all in-kernel drivers
fill only ETH_ALEN of the MAX_ADDR_LEN bytes, i.e. 6 of the 32 possible
bytes. Therefore we currently leak 26 bytes of stack memory to userland
via the netlink interface.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/rtnetlink.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2c5a0a0..4908588 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -976,6 +976,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb, struct net_device *dev,
 			 * report anything.
 			 */
 			ivi.spoofchk = -1;
+			memset(ivi.mac, 0, sizeof(ivi.mac));
 			if (dev->netdev_ops->ndo_get_vf_config(dev, i, &ivi))
 				break;
 			vf_mac.vf =
-- 
1.7.10.4


