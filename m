Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaATRsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:48:04 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:49030 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaATRsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:48:00 -0500
X-IronPort-AV: E=Sophos;i="4.95,691,1384300800"; 
   d="scan'208";a="92503204"
Message-ID: <52DD614D.5080604@citrix.com>
Date: Mon, 20 Jan 2014 17:47:57 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: <ian.campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v4 8/9] xen-netback: Timeout packets in RX path
References: <1389731995-9887-1-git-send-email-zoltan.kiss@citrix.com> <1389731995-9887-9-git-send-email-zoltan.kiss@citrix.com> <20140116000334.GE5331@zion.uk.xensource.com> <52D98427.1060103@citrix.com> <20140120165356.GF11681@zion.uk.xensource.com>
In-Reply-To: <20140120165356.GF11681@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/14 16:53, Wei Liu wrote:
>>>> @@ -559,7 +579,7 @@ void xenvif_free(struct xenvif *vif)
>>>>   		if (vif->grant_tx_handle[i] != NETBACK_INVALID_HANDLE) {
>>>>   			unmap_timeout++;
>>>>   			schedule_timeout(msecs_to_jiffies(1000));
>>>> -			if (unmap_timeout > 9 &&
>>>> +			if (unmap_timeout > ((rx_drain_timeout_msecs/1000) * DIV_ROUND_UP(XENVIF_QUEUE_LENGTH, (XEN_NETIF_RX_RING_SIZE / MAX_SKB_FRAGS))) &&
>>>
>>> This line is really too long. And what's the rationale behind this long
>>> expression?
>> It calculates how many times you should ditch the internal queue of
>> an another (maybe stucked) vif before Qdisc empties it's actual
>> content. After that there shouldn't be any mapped handle left, so we
>> should start printing these messages. Actually it should use
>> vif->dev->tx_queue_len, and yes, it is probably better to move it to
>> the beginning of the function into a new variable, and use that
>> here.
>>
>
> Why is relative to tx queue length?
>
> What's the meaning of drain_timeout multipled by the last part
> (DIV_ROUND_UP)?
>
> If you proposed to use vif->dev->tx_queue_len to replace DIV_ROUND_UP
> then ignore the above question. But I still don't understand the
> rationale behind this. Could you elaborate a bit more? Wouldn't
> rx_drain_timeout_msecs/1000 along suffice?

Here we want to avoid timeout messages if an skb can be legitimatly 
stucked somewhere else. As we discussed earlier, realisticly this could 
be an another vif's internal or QDisc queue. That another vif also has 
this rx_drain_timeout_msecs timeout, but now with Paul's recent changes 
the timer only ditches the internal queue. After that, the QDisc queue 
can put in worst case XEN_NETIF_RX_RING_SIZE / MAX_SKB_FRAGS skbs into 
that another vif's internal queue, so we need several rounds of such 
timeouts until we can be sure that no another vif should have skb's from 
us. We are not sending more skb's, so newly stucked packets are not 
interesting for us here.
But actually using the current vif's queue length is not relevant in 
this calculation, as it doesn't mean other vif's has the same. I think 
it is better to stick with XENVIF_QUEUE_LENGTH.
I've added this explanation as a comment and moved the calculation into 
a separate variable, so it doesn't cause such long lines.

Zoli
