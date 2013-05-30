Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040Ab3E3UB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:01:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:7821 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932546Ab3E3UBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:01:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,772,1363158000"; 
   d="scan'208";a="322119017"
Message-ID: <51A7B009.3030709@linux.intel.com>
Date: Thu, 30 May 2013 23:01:13 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amir Vadai <amirv@mellanox.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v7 net-next 2/5] net: implement support for low latency
 socket polling
References: <20130530114045.12653.79183.stgit@ladj378.jer.intel.com> <20130530114111.12653.25023.stgit@ladj378.jer.intel.com> <51A76B2F.8010904@mellanox.com>
In-Reply-To: <51A76B2F.8010904@mellanox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/2013 18:07, Amir Vadai wrote:
> On 30/05/2013 14:41, Eliezer Tamir wrote:
>> diff --git a/fs/select.c b/fs/select.c
>> @@ -486,6 +488,8 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
>>   			break;
>>   		}
>>
>> +		if (can_poll_ll(ll_time))
>> +			continue;
> I don't see here discrimination between sockets that you want to poll
> and other sockets.
> So it means that select will busy poll every type of file descriptor
> instead of going to sleep.
> Should have a condition with something like sk_valid_ll()

As I said earlier, select and poll are far from complete.
We are working on this.
Right now when you turn this on, all sockets get the same treatment.
sk_valid_ll() can't work here, because we don't have a single socket to 
work with.

At the moment, I think the right way to solve this might be to add
new flags to poll.h So that select/poll can signal to sock_poll
that it wants to busy-wait and sock_poll can tell select/poll that
it has found a socket that can support it.

Remember that the information is dynamic so we can't know in advance
which sockets can busy-poll.

If anyone else has a suggestion I would really like to hear it.

>
>> +static inline void sk_mark_ll(struct sock *sk, struct sk_buff *skb)
>> +{
>> +}
>> +
>> +static inline bool can_poll_ll(unsigned long end_time)
> should use here cycles_t too.

yes

>
>> +{
>> +	return false;
>> +}
>> +
>> +#endif /* CONFIG_NET_LL_RX_POLL */
>> +#endif /* _LINUX_NET_LL_POLL_H */
>
>
> Also, something general about this patch. I think you should split out
> to separate patches all the users of the feature, like you did for TCP.
> I would suggest small patches for UDP, select and poll.

Splitting out the users of the features as you call it will only move 
out about 30 lines of patch, I think it will make reviewing harder since 
you will not be able to see the whole picture in one patch.
But if anyone else thinks this is a good idea, I will do it.

-Eliezer
