Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbaAHONY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:13:24 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:44543 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaAHONU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:13:20 -0500
X-IronPort-AV: E=Sophos;i="4.95,624,1384300800"; 
   d="scan'208";a="88721708"
Message-ID: <52CD5CF8.4000004@citrix.com>
Date: Wed, 8 Jan 2014 14:13:12 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v3 6/9] xen-netback: Handle guests with too many
 frags
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com>		 <1389139818-24458-7-git-send-email-zoltan.kiss@citrix.com>	 <1389147141.26646.74.camel@edumazet-glaptop2.roam.corp.google.com>	 <52CD5785.4050402@citrix.com> <1389189272.26646.89.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1389189272.26646.89.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 13:54, Eric Dumazet wrote:
> On Wed, 2014-01-08 at 13:49 +0000, Zoltan Kiss wrote:
>> On 08/01/14 02:12, Eric Dumazet wrote:
>>> On Wed, 2014-01-08 at 00:10 +0000, Zoltan Kiss wrote:
>>>
>>>>
>>>> +		if (skb_shinfo(skb)->frag_list) {
>>>> +			nskb = skb_shinfo(skb)->frag_list;
>>>> +			xenvif_fill_frags(vif, nskb, INVALID_PENDING_IDX);
>>>> +			skb->len += nskb->len;
>>>> +			skb->data_len += nskb->len;
>>>> +			skb->truesize += nskb->truesize;
>>>> +			skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
>>>> +			skb_shinfo(nskb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
>>>> +			vif->tx_zerocopy_sent += 2;
>>>> +			nskb = skb;
>>>> +
>>>> +			skb = skb_copy_expand(skb,
>>>> +					0,
>>>> +					0,
>>>> +					GFP_ATOMIC | __GFP_NOWARN);
>>>
>>> skb can be NULL here
>>
>> Thanks, fixed that.
>
> BTW, I am not sure why you copy the skb.
>
> Is it to get rid of frag_list, and why ?

Yes, it is to get rid of the frag_list, just to be on the safe side. I'm 
not sure if it is normal to send a big skb with MAX_SKB_FRAGS frags plus 
an empty skb on the frag_list with one frag, so I just consolidate them 
here. This scenario shouldn't happen very often anyway, even guests 
which can send more than MAX_SKB_FRAGS slots tends to do it rarely.

Zoli

