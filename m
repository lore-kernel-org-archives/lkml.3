Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaDATJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 15:09:50 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30237 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaDATJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 15:09:46 -0400
X-IronPort-AV: E=Sophos;i="4.97,775,1389744000"; 
   d="scan'208";a="115839614"
Message-ID: <533B0EF8.6000900@citrix.com>
Date: Tue, 1 Apr 2014 20:09:44 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <paul.durrant@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v2 2/2] xen-netback: Grant copy the header instead
 of map and memcpy
References: <1396278539-27639-1-git-send-email-zoltan.kiss@citrix.com>	 <1396278539-27639-2-git-send-email-zoltan.kiss@citrix.com> <1396352440.8667.117.camel@kazak.uk.xensource.com>
In-Reply-To: <1396352440.8667.117.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/14 12:40, Ian Campbell wrote:
> On Mon, 2014-03-31 at 16:08 +0100, Zoltan Kiss wrote:
>>
>>   check_frags:
>> -	for (i = start; i < nr_frags; i++) {
>> +	for (i = 0; i < nr_frags; i++, gop_map++) {
>>   		int j, newerr;
>>
>>   		pending_idx = frag_get_pending_idx(&shinfo->frags[i]);
>> -		tx_info = &vif->pending_tx_info[pending_idx];
>>
>>   		/* Check error status: if okay then remember grant handle. */
>> -		newerr = (++gop_map)->status;
>> +		newerr = (gop_map)->status;
>
> You've reworked the handling of gop_map and when and where it is
> incremented, which might be a legit cleanup but does it relate to the
> bulk of this change somehow that I'm missing?
That original "++gop_map" assumed the header was also grant mapped, and 
incremented the pointer first here, which is wrong now.

>
>>   [...]
>>   		__skb_put(skb, data_len);
>> +		vif->tx_copy_ops[*copy_ops].source.u.ref = txreq.gref;
>> +		vif->tx_copy_ops[*copy_ops].source.domid = vif->domid;
>> +		vif->tx_copy_ops[*copy_ops].source.offset = txreq.offset;
>> +
>> +		vif->tx_copy_ops[*copy_ops].dest.u.gmfn =
>> +			virt_to_mfn(skb->data);
>> +		vif->tx_copy_ops[*copy_ops].dest.domid = DOMID_SELF;
>> +		vif->tx_copy_ops[*copy_ops].dest.offset =
>> +			offset_in_page(skb->data);
>> +
>> +		vif->tx_copy_ops[*copy_ops].len = data_len;
>> +		vif->tx_copy_ops[*copy_ops].flags = GNTCOPY_source_gref;
>
> We have gnttab_set_map_op. Should we have gnttap_set_copy_op too?
This is the only place at the moment when we do this, so I wouldn't 
bother to do it.

>
>> -	BUG_ON(ret);
>> +	else {
>> +		gnttab_batch_copy(vif->tx_copy_ops, nr_cops);
>> +		if (nr_mops != 0) {
>
>
> if (nr_mops) would do.
>
>> +			ret = gnttab_map_refs(vif->tx_map_ops,
>
> So we use gnttab_batch_copy and gnttab_map_refs.
>
> Shouldn't we either use gnttab_batch_copy and gnttab_batch_map or
> gnttab_copy gnttab_map_refs. (where gnttab_copy might be a bare
> GNTTABOP_copy or might be a helper wrapper).
>
> The point of the batch interface is to handle page unsharing etc, but
> doing it only for copies seems like a waste one way or another.
The difference between gnttab_batch_map and gnttab_map_refs is that the 
latter calls set_foreign_p2m_mapping, which we need for sure.
gnttab_batch_copy calls the hypercall and tries again if op->status == 
GNTST_eagain. I think that's exactly what we need here as well.
The naming might be confusing indeed, but that should be the topic of an 
another patch.

Zoli
