Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422789AbaGRRr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:47:59 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:48695 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030518AbaGRRr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:47:58 -0400
X-IronPort-AV: E=Sophos;i="5.01,686,1400025600"; 
   d="scan'208";a="154173356"
Message-ID: <53C95DCB.90806@citrix.com>
Date: Fri, 18 Jul 2014 18:47:55 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net 1/4] xen-netback: Fix handling frag_list on grant
 op error path
References: <1405624192-21722-1-git-send-email-zoltan.kiss@citrix.com> <1405624192-21722-2-git-send-email-zoltan.kiss@citrix.com> <20140718152435.GN7142@zion.uk.xensource.com>
In-Reply-To: <20140718152435.GN7142@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/14 16:24, Wei Liu wrote:
> On Thu, Jul 17, 2014 at 08:09:49PM +0100, Zoltan Kiss wrote:
>> The error handling for skb's with frag_list was completely wrong, it caused
>> double unmap attempts to happen if the error was on the first skb. Move it to
>> the right place in the loop.
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> Reported-by: Armin Zentai <armin.zentai@ezit.hu>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: xen-devel@lists.xenproject.org
>> ---
>> diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
>> index 1844a47..604ff71 100644
>> --- a/drivers/net/xen-netback/netback.c
>> +++ b/drivers/net/xen-netback/netback.c
>> @@ -1030,10 +1030,16 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
>>   {
>>   	struct gnttab_map_grant_ref *gop_map = *gopp_map;
>>   	u16 pending_idx = XENVIF_TX_CB(skb)->pending_idx;
>> +	/* This points to the shinfo of the actually checked skb, which could be
>> +	 * either the first or the one on the frag_list
>> +	 */
>
> I think "checked skb" should be "skb being checked". Feel free to
> disagree as I'm not native English speaker. :-/
>
>>   	struct skb_shared_info *shinfo = skb_shinfo(skb);
>> +	/* If this is non-NULL, we are currently checking the frag_list skb, and
>> +	 * this points to the shinfo of the first one
>> +	 */
>> +	struct skb_shared_info *first_shinfo = NULL;
>>   	int nr_frags = shinfo->nr_frags;
>>   	int i, err;
>> -	struct sk_buff *first_skb = NULL;
>>
>>   	/* Check status of header. */
>>   	err = (*gopp_copy)->status;
>> @@ -1086,31 +1092,28 @@ check_frags:
>>   			xenvif_idx_unmap(queue, pending_idx);
>>   		}
>>
>> +		/* And if we found the error while checking the frag_list, unmap
>> +		 * the first skb's frags
>> +		 */
>> +		if (first_shinfo) {
>> +			for (j = 0; j < first_shinfo->nr_frags; j++) {
>> +				pending_idx = frag_get_pending_idx(&first_shinfo->frags[j]);
>> +				xenvif_idx_unmap(queue, pending_idx);
>> +			}
>> +		}
>> +
>>   		/* Remember the error: invalidate all subsequent fragments. */
>>   		err = newerr;
>>   	}
>>
>> -	if (skb_has_frag_list(skb)) {
>> -		first_skb = skb;
>> -		skb = shinfo->frag_list;
>> -		shinfo = skb_shinfo(skb);
>> +	if (skb_has_frag_list(skb) && !first_shinfo) {
>
> Will it ever come to the point that we have another skb in this skb's
> frag list? Is there any reason prevents you from looping over the
> (possible) subsequent skbs? I guess if the error is deep in the list
> it's a bit hard to bookkeep...
>
>> +		first_shinfo = skb_shinfo(skb);
>> +		shinfo = skb_shinfo(skb_shinfo(skb)->frag_list);
>
> In that case I would suggest you add
> BUG_ON(skb_has_frag_list(skb_shinfo(skb)->frag_list)). I think having
> more nested frag_list should be a bug in current design.

There are already 3 things which prevents this
- in count_requests we drop the packet if it has more than 
XEN_NETBK_LEGACY_SLOTS_MAX slots
- in get_requests there is a BUG_ON(frag_overflow > MAX_SKB_FRAGS), 
which shouldn't really due to the prev point
- in the same funciont we create a frag_list skb exactly once
