Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaACDND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:13:03 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:53796 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaACDM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:12:56 -0500
Message-ID: <52C62A52.8050003@huawei.com>
Date: Fri, 3 Jan 2014 11:11:14 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <edumazet@google.com>, <kaber@trash.net>, <peterz@infradead.org>,
        <honkiko@gmail.com>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <containers@lists.linux-foundation.org>, <jhs@mojatatu.com>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: [RFC PATCH net-next 3/4] veth: backup classid befor switch net_ns
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


dev_forward_skb will clear skb->sk, so we need save classid
before that, otherwise the skb can not be under control by
net_cls.

Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
---
 drivers/net/veth.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 2ec2041..ce43a2d 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -18,6 +18,7 @@
 #include <net/xfrm.h>
 #include <linux/veth.h>
 #include <linux/module.h>
+#include <net/cls_cgroup.h>

 #define DRV_NAME	"veth"
 #define DRV_VERSION	"1.0"
@@ -123,6 +124,12 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	    rcv->features & NETIF_F_RXCSUM)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;

+	/**
+	 * dev_forward_sbk will clear skb->sk, so save
+	 * skb->sk->sk_classid for Qos
+	 */
+	bk_cls_classid(skb);
+
 	if (likely(dev_forward_skb(rcv, skb) == NET_RX_SUCCESS)) {
 		struct pcpu_vstats *stats = this_cpu_ptr(dev->vstats);

-- 
1.8.2.2


