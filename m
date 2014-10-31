Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760911AbaJaGHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 02:07:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759915AbaJaGHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 02:07:24 -0400
Message-ID: <5453270F.3090300@redhat.com>
Date: Fri, 31 Oct 2014 14:07:11 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] virtio_net: fix use after free
References: <1413378878-28118-1-git-send-email-mst@redhat.com> <1414726609.499.6.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1414726609.499.6.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 11:36 AM, Eric Dumazet wrote:
> On Wed, 2014-10-15 at 16:23 +0300, Michael S. Tsirkin wrote:
>> commit 0b725a2ca61bedc33a2a63d0451d528b268cf975
>>     net: Remove ndo_xmit_flush netdev operation, use signalling instead.
>>
>> added code that looks at skb->xmit_more after the skb has
>> been put in TX VQ. Since some paths process the ring and free the skb
>> immediately, this can cause use after free.
>>
>> Fix by storing xmit_more in a local variable.
>>
>> Cc: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> ---
>>
>> David, am I using the API correctly?
>> Seems to work for me.
>> You used __netif_subqueue_stopped but that seems to use
>> a slightly more expensive test_bit internally.
>> The reason I added a variable for the txq here is because it's handy for
>> BQL patch later on.
>>
>>
>>  drivers/net/virtio_net.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 3d0ce44..13d0a8b 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -920,6 +920,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>>  	int qnum = skb_get_queue_mapping(skb);
>>  	struct send_queue *sq = &vi->sq[qnum];
>>  	int err;
>> +	struct netdev_queue *txq = netdev_get_tx_queue(dev, qnum);
>> +	bool kick = !skb->xmit_more;
>>  
>>  	/* Free up any pending old buffers before queueing new ones. */
>>  	free_old_xmit_skbs(sq);
>> @@ -956,7 +958,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>>  		}
>>  	}
>>  
>> -	if (__netif_subqueue_stopped(dev, qnum) || !skb->xmit_more)
>> +	if (kick || netif_xmit_stopped(txq))
>>  		virtqueue_kick(sq->vq);
>>  
>>  	return NETDEV_TX_OK;
> I must say I am kind of confused by this patch.
>
> Why the skb_orphan(skb) & nf_reset(skb) do not have the same issue ?
>

Since they are called before the possible free_old_xmit_skbs(), skb
won't get freed at this time.
