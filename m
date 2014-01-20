Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaATREx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:04:53 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:7473 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbaATREv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:04:51 -0500
X-IronPort-AV: E=Sophos;i="4.95,691,1384300800"; 
   d="scan'208";a="92486622"
Message-ID: <52DD5730.8080803@citrix.com>
Date: Mon, 20 Jan 2014 17:04:48 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: <ian.campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v4 2/9] xen-netback: Change TX path from grant
 copy to mapping
References: <1389731995-9887-1-git-send-email-zoltan.kiss@citrix.com> <1389731995-9887-3-git-send-email-zoltan.kiss@citrix.com> <20140116000107.GB5331@zion.uk.xensource.com>
In-Reply-To: <20140116000107.GB5331@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/14 00:01, Wei Liu wrote:
> On Tue, Jan 14, 2014 at 08:39:48PM +0000, Zoltan Kiss wrote:
>> v3:
>> - delete a surplus checking from tx_action
>> - remove stray line
>> - squash xenvif_idx_unmap changes into the first patch
>> - init spinlocks
>> - call map hypercall directly instead of gnttab_map_refs()
>> - fix unmapping timeout in xenvif_free()
>>
>> v4:
>> - fix indentations and comments
>> - handle errors of set_phys_to_machine
>
> There's no call to set_phys_to_machine in this patch. Did I miss
> something?
I've made several changes between v3 and v4 about the grant mapping 
stuff, this was an earlier concept, not the one I've finally sent in. It 
should be the same comment as in the first patch: "go back to 
gnttab_map_refs, now we rely on API changes"

>> --- a/drivers/net/xen-netback/interface.c
>> +++ b/drivers/net/xen-netback/interface.c
>> @@ -123,7 +123,9 @@ static int xenvif_start_xmit(struct sk_buff *skb, struct net_device *dev)
>>   	BUG_ON(skb->dev != dev);
>>
>>   	/* Drop the packet if vif is not ready */
>> -	if (vif->task == NULL || !xenvif_schedulable(vif))
>> +	if (vif->task == NULL ||
>> +	    vif->dealloc_task == NULL ||
>> +	    !xenvif_schedulable(vif))
>>   		goto drop;
>>
>>   	/* At best we'll need one slot for the header and one for each
>> @@ -345,8 +347,26 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
>
> At the beginning of the function there's BUG_ON checks for vif->task. I
> would suggest you do the same for vif->dealloc_task, just to be
> consistent.
I guess you mean in xenvif_connect. Applied.

>> @@ -431,6 +452,16 @@ int xenvif_connect(struct xenvif *vif, unsigned long tx_ring_ref,
>>   		goto err_rx_unbind;
>>   	}
>>
>> +	vif->dealloc_task = kthread_create(xenvif_dealloc_kthread,
>> +					   (void *)vif,
>> +					   "%s-dealloc",
>> +					   vif->dev->name);
>> +	if (IS_ERR(vif->dealloc_task)) {
>> +		pr_warn("Could not allocate kthread for %s\n", vif->dev->name);
>> +		err = PTR_ERR(vif->dealloc_task);
>> +		goto err_rx_unbind;
>> +	}
>> +
>>   	vif->task = task;
>
> Please move this line before the above hunk. Don't separate it from
> corresponding kthread_create.
Done, I've also used task for dealloc thread creation, the same way as 
the rx thread does.

> Last but not least, though I've looked at this patch for several rounds
> and and the basic logic looks correct to me, I would like it to go
> through XenRT tests if possible -- eye inspection is error-prone to such
> complicated change. (If I'm not mistaken you once told me you've done
> regression tests already. That would be neat!)
Yes, that's ongoing, I don't expect the patches to be accepted before 
they pass XenRT.
