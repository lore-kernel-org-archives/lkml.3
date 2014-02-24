Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaBXQ4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:56:15 -0500
Received: from smtp.citrix.com ([66.165.176.89]:41716 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbaBXQ4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:56:10 -0500
X-IronPort-AV: E=Sophos;i="4.97,535,1389744000"; 
   d="scan'208";a="105252587"
Message-ID: <530B79A5.7010600@citrix.com>
Date: Mon, 24 Feb 2014 16:56:05 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Zoltan Kiss <zoltan.kiss@schaman.hu>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v5 2/9] xen-netback: Change TX path from grant
 copy to mapping
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com>	 <1390253069-25507-3-git-send-email-zoltan.kiss@citrix.com> <1392745235.23084.60.camel@kazak.uk.xensource.com> <530925D5.4010800@schaman.hu>
In-Reply-To: <530925D5.4010800@schaman.hu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.14.50]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/02/14 22:33, Zoltan Kiss wrote:
> On 18/02/14 17:40, Ian Campbell wrote:
>> +     */
>>> +    skb->pfmemalloc    = false;
>>>   }
>>>
>>>   static int xenvif_get_extras(struct xenvif *vif,
>>> @@ -1372,7 +1341,7 @@ static bool tx_credit_exceeded(struct xenvif 
>>> *vif, unsigned size)
>>
>>> @@ -1581,7 +1535,11 @@ static int xenvif_tx_submit(struct xenvif *vif)
>>>           else if (txp->flags & XEN_NETTXF_data_validated)
>>>               skb->ip_summed = CHECKSUM_UNNECESSARY;
>>>
>>> -        xenvif_fill_frags(vif, skb);
>>> +        xenvif_fill_frags(vif,
>>> +                  skb,
>>> +                  skb_shinfo(skb)->destructor_arg ?
>>> +                  pending_idx :
>>> +                  INVALID_PENDING_IDX
>>
>> Couldn't xenvif_fill_frags calculate the 3rd argument itself given that
>> it has skb in hand.
> We still have to pass pending_idx, as it is no longer in skb->data. I 
> have plans (I've already prototyped it, actually) to move that 
> pending_idx from skb->data to skb->cb, if that happens, this won't be 
> necessary.
> On the other hand, it makes more sense just to just pass pending_idx, 
> and in fill_frags we can decide based on destructor_arg whether do we 
> need it or not.
Actually, I've just moved the skb->cb patch to the beginning of this 
series, so we can completely omit that new parameter from fill_frags.

Zoli
