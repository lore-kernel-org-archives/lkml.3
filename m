Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaHDGQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 02:16:24 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:58642 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaHDGQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 02:16:23 -0400
Date: Mon, 4 Aug 2014 08:13:23 +0200
From: Veaceslav Falico <vfalico@gmail.com>
To: lichunhe@huawei.com
Cc: j.vosburgh@gmail.com, andy@greyhouse.net, linux-kernel@vger.kernel.org,
        dingtianhong@huawei.com, qianhuibin@huawei.com
Subject: Re: [PATCH net/net-next] bonding:Don't received packets if bonding
 is not up
Message-ID: <20140804061322.GA9348@mikrodark.usersys.redhat.com>
References: <1407122113-3184-1-git-send-email-lichunhe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1407122113-3184-1-git-send-email-lichunhe@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 11:15:13AM +0800, lichunhe@huawei.com wrote:
>From: Chunhe Li <lichunhe@huawei.com>
>
>If the bonding device is down, it should not receive packets
>to network stack or other upper flow stack.

This breaks arp monitoring and 802.3ad modes, as they won't ever come up.

Also, please cc netdev next times.

>
>Signed-off-by: Chunhe Li <lichunhe@huawei.com>
>---
> drivers/net/bonding/bond_main.c | 9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 701f86c..48a127b 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1110,6 +1110,12 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
> 	int (*recv_probe)(const struct sk_buff *, struct bonding *,
> 			  struct slave *);
> 	int ret = RX_HANDLER_ANOTHER;
>+
>+	slave = bond_slave_get_rcu(skb->dev);
>+	bond = slave->bond;
>+
>+	if (unlikely(!(bond->dev->flags & IFF_UP)))
>+		return RX_HANDLER_PASS;
>
> 	skb = skb_share_check(skb, GFP_ATOMIC);
> 	if (unlikely(!skb))
>@@ -1117,9 +1123,6 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
>
> 	*pskb = skb;
>
>-	slave = bond_slave_get_rcu(skb->dev);
>-	bond = slave->bond;
>-
> 	recv_probe = ACCESS_ONCE(bond->recv_probe);
> 	if (recv_probe) {
> 		ret = recv_probe(skb, bond, slave);
>-- 
>1.9.2.0
>
>
