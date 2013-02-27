Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760807Ab3B0TUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:20:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:43650 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab3B0TUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:20:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,750,1355126400"; 
   d="scan'208";a="296763912"
Message-ID: <512E5C62.2030507@linux.intel.com>
Date: Wed, 27 Feb 2013 21:20:02 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [RFC PATCH 3/5] ixgbe: Add support for ndo_ll_poll
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>  <20130227175606.10611.55498.stgit@gitlad.jf.intel.com> <1361990502.15793.0.camel@edumazet-glaptop>
In-Reply-To: <1361990502.15793.0.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/2013 20:41, Eric Dumazet wrote:
> On Wed, 2013-02-27 at 09:56 -0800, Eliezer Tamir wrote:
>
>> @@ -1458,7 +1459,9 @@ static void ixgbe_rx_skb(struct ixgbe_q_vector *q_vector,
>>   {
>>   	struct ixgbe_adapter *adapter = q_vector->adapter;
>>
>> -	if (!(adapter->flags & IXGBE_FLAG_IN_NETPOLL))
>> +	if (ixgbe_qv_ll_polling(q_vector))
>> +		netif_receive_skb(skb);
>> +	else if (!(adapter->flags & IXGBE_FLAG_IN_NETPOLL))
>>   		napi_gro_receive(&q_vector->napi, skb);
>>   	else
>>   		netif_rx(skb);
>
> Interesting reordering issue here.
yes, we need to fix this.
Maybe force a GRO flush when spinning, or maybe disable GRO in a more 
global manner when someone is busy-polling

> Why by-passing GRO stack if its enabled ?
you want to bypass GRO because it adds latency.
