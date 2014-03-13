Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaCMMeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:34:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:5241 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaCMMen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:34:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,647,1389744000"; 
   d="scan'208";a="110982585"
Message-ID: <5321A5D8.3060507@citrix.com>
Date: Thu, 13 Mar 2014 12:34:32 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v7 4/9] xen-netback: Introduce TX grant mapping
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>	 <1394142511-14827-5-git-send-email-zoltan.kiss@citrix.com> <1394705874.25873.19.camel@kazak.uk.xensource.com>
In-Reply-To: <1394705874.25873.19.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/14 10:17, Ian Campbell wrote:
> Pulling out this one comment for the attention on the core Xen/Linux
> maintainers.
>
> On Thu, 2014-03-06 at 21:48 +0000, Zoltan Kiss wrote:
> [...]
>> @@ -343,8 +347,26 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
>>   	vif->pending_prod = MAX_PENDING_REQS;
>>   	for (i = 0; i < MAX_PENDING_REQS; i++)
>>   		vif->pending_ring[i] = i;
>> -	for (i = 0; i < MAX_PENDING_REQS; i++)
>> -		vif->mmap_pages[i] = NULL;
>> +	spin_lock_init(&vif->callback_lock);
>> +	spin_lock_init(&vif->response_lock);
>> +	/* If ballooning is disabled, this will consume real memory, so you
>> +	 * better enable it. The long term solution would be to use just a
>> +	 * bunch of valid page descriptors, without dependency on ballooning
>> +	 */
>
> I wonder if we ought to enforce this via Kconfig? i.e. making
> CONFIG_XEN_BACKEND (or the individual backends) depend on BALLOON (or
> select?) or by making CONFIG_XEN_BALLOON non-optional etc.
I support this idea, but let's have other's views.
>
> IIRC David V was looking into a solution involving auto hotplugging a
> new region to use for this case, but then I guess
> CONFIG_XEN_BALLOON_MEMORY_HOTPLUG would equally need to be enabled.
Yes, if that happens in the near future, we shouldn't be bothered by the 
above right now.

>
>> +	err = alloc_xenballooned_pages(MAX_PENDING_REQS,
>> +				       vif->mmap_pages,
>> +				       false);
> [...]
>

