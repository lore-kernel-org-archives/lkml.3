Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbaAJPYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:24:14 -0500
Received: from smtp.citrix.com ([66.165.176.89]:23760 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbaAJPYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:24:08 -0500
X-IronPort-AV: E=Sophos;i="4.95,638,1384300800"; 
   d="scan'208";a="91705416"
Message-ID: <52D01094.5060102@citrix.com>
Date: Fri, 10 Jan 2014 15:24:04 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: <ian.campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v3 2/9] xen-netback: Change TX path from grant
 copy to mapping
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com> <1389139818-24458-3-git-send-email-zoltan.kiss@citrix.com> <20140109153015.GF12164@zion.uk.xensource.com> <52CFDAEC.5080708@citrix.com> <20140110114534.GE29180@zion.uk.xensource.com>
In-Reply-To: <20140110114534.GE29180@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/14 11:45, Wei Liu wrote:
> On Fri, Jan 10, 2014 at 11:35:08AM +0000, Zoltan Kiss wrote:
> [...]
>>
>>>> @@ -920,6 +852,18 @@ static int xenvif_tx_check_gop(struct xenvif *vif,
>>>>   	err = gop->status;
>>>>   	if (unlikely(err))
>>>>   		xenvif_idx_release(vif, pending_idx, XEN_NETIF_RSP_ERROR);
>>>> +	else {
>>>> +		if (vif->grant_tx_handle[pending_idx] !=
>>>> +			NETBACK_INVALID_HANDLE) {
>>>> +			netdev_err(vif->dev,
>>>> +				"Stale mapped handle! pending_idx %x handle %x\n",
>>>> +				pending_idx, vif->grant_tx_handle[pending_idx]);
>>>> +			BUG();
>>>> +		}
>>>> +		set_phys_to_machine(idx_to_pfn(vif, pending_idx),
>>>> +			FOREIGN_FRAME(gop->dev_bus_addr >> PAGE_SHIFT));
>>>
>>> What happens when you don't have this?
>> Your frags will be filled with garbage. I don't understand exactly
>> what this function does, someone might want to enlighten us? I've
>> took it's usage from classic kernel.
>> Also, it might be worthwhile to check the return value and BUG if
>> it's false, but I don't know what exactly that return value means.
>>
>
> This is actually part of gnttab_map_refs. As you're using hypercall
> directly this becomes very fragile.
>
> So the right thing to do is to fix gnttab_map_refs.
I agree, as I mentioned in other email in this thread, I think that 
should be the topic of an another patchseries. In the meantime, I will 
use gnttab_batch_map instead of the direct hypercall, it handles the 
GNTST_eagain scenario, and I will use set_phys_to_machine the same way 
as m2p_override does:

if (unlikely(!set_phys_to_machine(idx_to_pfn(vif, pending_idx), 
FOREIGN_FRAME(gop->dev_bus_addr >> PAGE_SHIFT))
			BUG();

Zoli
