Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3C0DMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 23:12:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab3C0DMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 23:12:50 -0400
Message-ID: <515263A6.1080709@redhat.com>
Date: Wed, 27 Mar 2013 11:12:38 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, Eric Dumazet <edumazet@google.com>
Subject: Re: [net-next 1/5] macvtap: set transport header before passing skb
 to lower device
References: <1364278799-37285-1-git-send-email-jasowang@redhat.com>  <1364278799-37285-2-git-send-email-jasowang@redhat.com> <1364310407.1716.16.camel@edumazet-glaptop>
In-Reply-To: <1364310407.1716.16.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 11:06 PM, Eric Dumazet wrote:
> On Tue, 2013-03-26 at 14:19 +0800, Jason Wang wrote:
>> Set the transport header for 1) some drivers (e.g ixgbe) needs l4 header 2)
>> precise packet length estimation (introduced in 1def9238) needs l4 header to
>> compute header length.
>>
>> For the packets with partial checksum, the patch just set the transport header
>> to csum_start. Otherwise tries to use skb_flow_dissect() to get l4 offset, if it
>> fails, just pretend no l4 header.
>>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  drivers/net/macvtap.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
>> index a449439..acf6450 100644
>> --- a/drivers/net/macvtap.c
>> +++ b/drivers/net/macvtap.c
>> @@ -21,6 +21,7 @@
>>  #include <net/rtnetlink.h>
>>  #include <net/sock.h>
>>  #include <linux/virtio_net.h>
>> +#include <net/flow_keys.h>
>>  
>>  /*
>>   * A macvtap queue is the central object of this driver, it connects
>> @@ -645,6 +646,7 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
>>  	int vnet_hdr_len = 0;
>>  	int copylen = 0;
>>  	bool zerocopy = false;
>> +	struct flow_keys keys;
>>  
>>  	if (q->flags & IFF_VNET_HDR) {
>>  		vnet_hdr_len = q->vnet_hdr_sz;
>> @@ -725,6 +727,13 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
>>  			goto err_kfree;
>>  	}
>>  
>> +	if (skb->ip_summed == CHECKSUM_PARTIAL)
> where ip_summed is set to this value ?
>
>> +		skb_set_transport_header(skb, skb_checksum_start_offset(skb));
>> +	else if (skb_flow_dissect(skb, &keys))
>> +		skb_set_transport_header(skb, keys.thoff);
>> +	else
>> +		skb_set_transport_header(skb, ETH_HLEN);
>> +
>>  	rcu_read_lock_bh();
>>  	vlan = rcu_dereference_bh(q->vlan);
>>  	/* copy skb_ubuf_info for callback when skb has no error */
> This driver has nice helpers.

Yes, skb_set_partial_csum()
> You should add this code in a helper as well.

Ok
> Because its not clear at this point if csum_start/csum_offset/ip_summed
> are consistent.

Since David has applied the seires, will send patches on top.

Thanks
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

