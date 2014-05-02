Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaEBOBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 10:01:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:37377 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaEBOBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 10:01:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,972,1389772800"; 
   d="scan'208";a="524963777"
Message-ID: <5363A4E0.2000403@intel.com>
Date: Fri, 02 May 2014 07:00:00 -0700
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jesper Dangaard Brouer <brouer@redhat.com>
CC: Zhouyi Zhou <zhouzhouyi@gmail.com>, davem@davemloft.net,
        steffen.klassert@secunet.com, fan.du@windriver.com,
        dborkman@redhat.com, minipli@googlemail.com, tgraf@suug.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH] netdev: pktgen xmit packet through vlan interface
References: <1399015092-28643-1-git-send-email-zhouzhouyi@gmail.com> <20140502151921.014fbeec@redhat.com>
In-Reply-To: <20140502151921.014fbeec@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/2014 6:19 AM, Jesper Dangaard Brouer wrote:
> On Fri,  2 May 2014 15:18:12 +0800
> Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
>
>> As http://www.spinics.net/lists/netdev/msg165015.html
>> pktgen generates shared packet through vlan interface will cause
>> oops because of duplicate entering tc queue.
>>
>> Try to solve this problem by means of packet clone instead of sharing.
>
> I really don't like adding this stuff to the fast path of pktgen.
>
> Why would you use pktgen on a VLAN?

Its a good way to test qdiscs. When you run pktgen over the VLAN
you exercise the lower devices qdisc.

Although I never submitted a patch like this because I figured it
was a corner case and we would want to keep the hotpath clean.

>
> Why don't you use the "vlan_id" feature available in pktgen, and send
> in the lower real device?
>
>
>
>> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
>> ---
>>   net/core/pktgen.c |   20 +++++++++++++++++---
>>   1 files changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
>> index 0304f98..ced07fc 100644
>> --- a/net/core/pktgen.c
>> +++ b/net/core/pktgen.c
>> @@ -3297,6 +3297,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
>>   	netdev_tx_t (*xmit)(struct sk_buff *, struct net_device *)
>>   		= odev->netdev_ops->ndo_start_xmit;
>>   	struct netdev_queue *txq;
>> +	struct sk_buff *nskb = NULL;
>>   	u16 queue_map;
>>   	int ret;
>>
>> @@ -3347,8 +3348,18 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
>>   		pkt_dev->last_ok = 0;
>>   		goto unlock;
>>   	}
>> -	atomic_inc(&(pkt_dev->skb->users));
>> -	ret = (*xmit)(pkt_dev->skb, odev);
>> +
>> +	if (pkt_dev->clone_skb && is_vlan_dev(odev)) {
>> +		nskb = skb_clone(pkt_dev->skb, GFP_ATOMIC);
>> +		ret = -ENOMEM;
>> +		if (nskb)
>> +			ret = (*xmit)(nskb, odev);
>> +		else
>> +			nskb = ERR_PTR(ret);
>> +	} else {
>> +		atomic_inc(&(pkt_dev->skb->users));
>> +		ret = (*xmit)(pkt_dev->skb, odev);
>> +	}
>>
>>   	switch (ret) {
>>   	case NETDEV_TX_OK:
>> @@ -3372,7 +3383,10 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
>>   	case NETDEV_TX_LOCKED:
>>   	case NETDEV_TX_BUSY:
>>   		/* Retry it next time */
>> -		atomic_dec(&(pkt_dev->skb->users));
>> +		if (nskb && !IS_ERR(nskb))
>> +			kfree_skb(nskb);
>> +		else
>> +			atomic_dec(&(pkt_dev->skb->users));
>>   		pkt_dev->last_ok = 0;
>>   	}
>>   unlock:
>
>
>

