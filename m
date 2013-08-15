Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3HOVHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:07:51 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:45038 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3HOVHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:07:49 -0400
Message-ID: <520D4328.5000305@cogentembedded.com>
Date: Fri, 16 Aug 2013 01:07:52 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] bond: Don't set skb->queue_mapping in netpoll.
References: <1376555808-6531-1-git-send-email-tm@tao.ma>
In-Reply-To: <1376555808-6531-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 12:36 PM, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>

> When we are using netpoll, we don't go through the normal
> transmit process. In this case, bond_select_queue is not called
> and qdisc_skb_cb(skb)->slave_dev_queue_mapping isn't set.

> So when netpoll_send_skb_on_dev calls ndo_start_xmit and we
> enter bond_dev_queue_xmit, we will set skb->queue_mapping to
> an invalid value and in some cases cause the driver panic the
> kernel(We meet with bnx2 panic because of a very large queue_mapping).

> This patch skip skb->queue_mapping if we find we are in netpoll.

> CC: "David S. Miller" <davem@davemloft.net>
> CC: Cong Wang <amwang@redhat.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>   drivers/net/bonding/bond_main.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)

> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 07f257d..97b2f52 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -405,12 +405,13 @@ int bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
>
>   	BUILD_BUG_ON(sizeof(skb->queue_mapping) !=
>   		     sizeof(qdisc_skb_cb(skb)->slave_dev_queue_mapping));
> -	skb->queue_mapping = qdisc_skb_cb(skb)->slave_dev_queue_mapping;
>
>   	if (unlikely(netpoll_tx_running(bond->dev)))
>   		bond_netpoll_send_skb(bond_get_slave_by_dev(bond, slave_dev), skb);
> -	else
> +	else {
> +		skb->queue_mapping = qdisc_skb_cb(skb)->slave_dev_queue_mapping;
>   		dev_queue_xmit(skb);
> +	}

     According to Documentation/CodingStyle, both arms of the *if* statement 
should have {} if one arm has them.

WBR, Sergei


