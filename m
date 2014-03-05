Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbaCEWsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:48:20 -0500
Received: from [216.32.181.181] ([216.32.181.181]:51353 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932105AbaCEWsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:48:16 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
X-WSS-ID: 0N1ZJAC-07-6XH-02
X-M-MSG: 
Message-ID: <5317A962.10004@amd.com>
Date: Wed, 5 Mar 2014 16:46:58 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kim.naru@amd.com>, <jay.cornwall@amd.com>
Subject: Re: [PATCH] iommu/amd: Fix logics to determine and checking max PASID
References: <1394046068-3858-1-git-send-email-suravee.suthikulpanit@amd.com> <20140305223544.GA2813@8bytes.org>
In-Reply-To: <20140305223544.GA2813@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,

Other commands can still support upto 20-bit PASID. As I mentioned, 
there is still no system with more than 16-bit PASID.

Either way, I have also replaced the PASID_MASK with the value derived 
from MMIOx30h[PASmax] of the IOMMU Extended Feature register instead.
This should allow us not to have to change the mask things again for 
future hardware.

We just need to revisit this BUG_ON() part when the new spec comes.

Suravee


On 3/5/2014 4:35 PM, Joerg Roedel wrote:
> On Wed, Mar 05, 2014 at 01:01:08PM -0600, suravee.suthikulpanit@amd.com wrote:
>>   drivers/iommu/amd_iommu.c       |   26 +++++++++++++++++++++++---
>>   drivers/iommu/amd_iommu_init.c  |   15 ++++++++-------
>>   drivers/iommu/amd_iommu_types.h |    6 ++----
>>   drivers/iommu/amd_iommu_v2.c    |    2 +-
>>   4 files changed, 34 insertions(+), 15 deletions(-)
>
> Hmm, this looks a bit complicated. Since the inv_iotlb_pasid and
> complete_ppr command only support 16 bit pasids by specification, there
> is no way to support pasids with more than 16 bits in general anymore. I
> think the best way to handle it is to just change the PASID_MASK to
> 0x0000ffff.
>
>>   static void build_inv_iotlb_pasid(struct iommu_cmd *cmd, u16 devid, int pasid,
>>   				  int qdep, u64 address, bool size)
>>   {
>> +	/* Note:
>> +	 * This command supports only 16-bit PASID.
>> +	 * Currently, hardware only implement upto 16-bit PASID
>> +	 * even though the spec says it could have upto 20 bits.
>> +	 * This is likely to be updated in the future revision of
>> +	 * IOMMU specs when the hardware with PASID > 16 bits
>> +	 * become available.
>> +	 */
>> +	BUG_ON(pasid > 0xFFFF);
>
> We can keep this as BUG_ON(pasid & ~PASID_MASK), but then ...
>
>> -		cmd->data[1]  = pasid & PASID_MASK;
>> +		cmd->data[1]  = pasid & amd_iommu_max_pasid;
>
> ... masking out the other bits is redundant.
>
>
> 	Joerg
>
>
>


