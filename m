Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab3KMF6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 00:58:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3KMF6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 00:58:17 -0500
Message-ID: <528314E9.1020000@redhat.com>
Date: Wed, 13 Nov 2013 13:58:01 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Rose <gregory.v.rose@intel.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Subject: Re: [PATCH net 2/2] macvtap: limit head length of skb allocated
References: <1384250577-20330-1-git-send-email-jasowang@redhat.com>	<1384250577-20330-2-git-send-email-jasowang@redhat.com> <20131112094501.0000358d@unknown>
In-Reply-To: <20131112094501.0000358d@unknown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 01:45 AM, Greg Rose wrote:
> On Tue, 12 Nov 2013 18:02:57 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> We currently use hdr_len as a hint of head length which is advertised
>> by guest. But when guest advertise a very big value, it can lead to
>> an 64K+ allocating of kmalloc() which has a very high possibility of
>> failure when host memory is fragmented or under heavy stress. The
>> huge hdr_len also reduce the effect of zerocopy or even disable if a
>> gso skb is linearized in guest.
>>
>> To solves those issues, this patch introduces an upper limit
>> (PAGE_SIZE) of the head, which guarantees an order 0 allocation each
>> time.
>>
>> Cc: Stefan Hajnoczi <stefanha@redhat.com>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>> The patch was needed for stable.
>> ---
>>  drivers/net/macvtap.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
>> index 9dccb1e..7ee6f9d 100644
>> --- a/drivers/net/macvtap.c
>> +++ b/drivers/net/macvtap.c
>> @@ -523,6 +523,11 @@ static inline struct sk_buff
>> *macvtap_alloc_skb(struct sock *sk, size_t prepad, int noblock, int
>> *err) {
>>  	struct sk_buff *skb;
>> +	int good_linear = SKB_MAX_HEAD(prepad);
>> +
>> +	/* Don't use huge linear part */
>> +	if (linear > good_linear)
>> +		linear = good_linear;
>>  
>>  	/* Under a page?  Don't bother with paged skb. */
>>  	if (prepad + len < PAGE_SIZE || !linear)
> I see no problem with this or the tuntap patch except that in both
> cases kernel coding style would prefer that you align the local
> variable declarations in a reverse pyramid, longest at the beginning,
> shortest at the end.
>
> - Greg

Sure, will do it in V2.
Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

