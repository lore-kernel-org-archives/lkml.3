Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaDDPN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:13:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:1780 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbaDDPN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:13:56 -0400
X-IronPort-AV: E=Sophos;i="4.97,795,1389744000"; 
   d="scan'208";a="116834038"
Message-ID: <533ECC32.5070302@citrix.com>
Date: Fri, 4 Apr 2014 17:13:54 +0200
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] xen-blkback: only attach blkback if the required features
 are met
References: <1396622471-13114-1-git-send-email-roger.pau@citrix.com> <533EC966.7030101@citrix.com>
In-Reply-To: <533EC966.7030101@citrix.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 17:01, David Vrabel wrote:
> On 04/04/14 15:41, Roger Pau Monne wrote:
>> Blkback cannot work properly on auto-translated guests if Xen doesn't
>> update the IOMMU when performing grant maps/unmaps, so only attach if
>> the newly introduced XENFEAT_hvm_gntmap_supports_iommu is found.
> 
> Can you explain the problem in more detail and which guest
> configurations are affected?
> 
> This isn't a problem that is specific to blkback, but any backend that
> grant maps and passes the foreign pages to a device so there needs to be
> a generic solution.
> 
> Why can't this be fixed by having the swiotlb bounce foreign pages?

Yes, it could be fixed with that, FreeBSD has been doing it for a long time.

But since nobody has complained about this, and the issue has been there
for a long time, I'm not sure it's worth adding all the bounce buffer
code for what seems to be an unused configuration.

Also, since Linux also supports PV, I would just say that if you want to
use driver domains you are forced to use PV guests (or have a recent Xen
version that properly updates the IOMMU on grant map/unmap).

>> --- a/drivers/block/xen-blkback/blkback.c
>> +++ b/drivers/block/xen-blkback/blkback.c
>> @@ -1381,6 +1381,18 @@ static int __init xen_blkif_init(void)
>>  	if (!xen_domain())
>>  		return -ENODEV;
>>  
>> +#ifdef CONFIG_X86
>> +	if (xen_feature(XENFEAT_auto_translated_physmap) &&
>> +	    !xen_feature(XENFEAT_hvm_gntmap_supports_iommu)) {
>> +		/*
>> +		 * blkback cannot work properly on auto-translated guests
>> +		 * if grant table mappings don't update the IOMMU entries.
>> +		 */
>> +		pr_debug(DRV_PFX "Disabling blkback because Xen is missing feature XENFEAT_hvm_gntmap_supports_iommu\n");
>> +		return -ENODEV;
>> +	}
>> +#endif /* CONFIG_X86 */
> 
> Why CONFIG_X86?

ARM has a bounce buffer for foreign pages, so this is not needed.

> 
> David
> 

