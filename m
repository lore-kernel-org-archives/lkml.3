Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbaCUTHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:07:48 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:20946
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbaCUTHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:07:46 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z579ehzbb2dI98dI9371Ie0eah1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
X-WSS-ID: 0N2SVSU-07-9C8-02
X-M-MSG: 
Message-ID: <532C8DFD.7020605@amd.com>
Date: Fri, 21 Mar 2014 14:07:41 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>, <kim.naru@amd.com>, <jay.cornwall@amd.com>
Subject: Re: [PATCH V2] iommu/amd: Fix logic to determine and checking max
 PASID
References: <1394067258-5968-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1394067258-5968-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,

Do you have any concerns about the V2 of this patch?

Thanks,

Suravee

On 3/5/2014 6:54 PM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>
> In reality, the spec can only support 16-bit PASID since
> INVALIDATE_IOTLB_PAGES and COMPLETE_PPR_REQUEST commands only allow 16-bit
> PASID. So, we updated the PASID_MASK accordingly and invoke BUG_ON
> if the hardware is reporting PASmax more than 16-bit.
>
> Besides, max PASID is defined as ((2^(PASmax+1)) - 1). The current does not
> determine this correctly.
>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Tested-by: Jay Cornwall <Jay.Cornwall@amd.com>
> ---
>   drivers/iommu/amd_iommu.c       |    4 ++--
>   drivers/iommu/amd_iommu_init.c  |   16 +++++++++-------
>   drivers/iommu/amd_iommu_types.h |   11 ++++++++---
>   3 files changed, 19 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> index faf0da4..66ef2cb 100644
> --- a/drivers/iommu/amd_iommu.c
> +++ b/drivers/iommu/amd_iommu.c
> @@ -963,7 +963,7 @@ static void build_inv_iommu_pasid(struct iommu_cmd *cmd, u16 domid, int pasid,
>
>   	address &= ~(0xfffULL);
>
> -	cmd->data[0]  = pasid & PASID_MASK;
> +	cmd->data[0]  = pasid;
>   	cmd->data[1]  = domid;
>   	cmd->data[2]  = lower_32_bits(address);
>   	cmd->data[3]  = upper_32_bits(address);
> @@ -1001,7 +1001,7 @@ static void build_complete_ppr(struct iommu_cmd *cmd, u16 devid, int pasid,
>
>   	cmd->data[0]  = devid;
>   	if (gn) {
> -		cmd->data[1]  = pasid & PASID_MASK;
> +		cmd->data[1]  = pasid;
>   		cmd->data[2]  = CMD_INV_IOMMU_PAGES_GN_MASK;
>   	}
>   	cmd->data[3]  = tag & 0x1ff;
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index 28b4bea..b76c58d 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -150,7 +150,7 @@ int amd_iommus_present;
>   bool amd_iommu_np_cache __read_mostly;
>   bool amd_iommu_iotlb_sup __read_mostly = true;
>
> -u32 amd_iommu_max_pasids __read_mostly = ~0;
> +u32 amd_iommu_max_pasid __read_mostly = ~0;
>
>   bool amd_iommu_v2_present __read_mostly;
>   bool amd_iommu_pc_present __read_mostly;
> @@ -1231,14 +1231,16 @@ static int iommu_init_pci(struct amd_iommu *iommu)
>
>   	if (iommu_feature(iommu, FEATURE_GT)) {
>   		int glxval;
> -		u32 pasids;
> -		u64 shift;
> +		u32 max_pasid;
> +		u64 pasmax;
>
> -		shift   = iommu->features & FEATURE_PASID_MASK;
> -		shift >>= FEATURE_PASID_SHIFT;
> -		pasids  = (1 << shift);
> +		pasmax = iommu->features & FEATURE_PASID_MASK;
> +		pasmax >>= FEATURE_PASID_SHIFT;
> +		max_pasid  = (1 << (pasmax + 1)) - 1;
>
> -		amd_iommu_max_pasids = min(amd_iommu_max_pasids, pasids);
> +		amd_iommu_max_pasid = min(amd_iommu_max_pasid, max_pasid);
> +
> +		BUG_ON(amd_iommu_max_pasid & ~PASID_MASK);
>
>   		glxval   = iommu->features & FEATURE_GLXVAL_MASK;
>   		glxval >>= FEATURE_GLXVAL_SHIFT;
> diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
> index e400fbe..55ba46b 100644
> --- a/drivers/iommu/amd_iommu_types.h
> +++ b/drivers/iommu/amd_iommu_types.h
> @@ -98,7 +98,12 @@
>   #define FEATURE_GLXVAL_SHIFT	14
>   #define FEATURE_GLXVAL_MASK	(0x03ULL << FEATURE_GLXVAL_SHIFT)
>
> -#define PASID_MASK		0x000fffff
> +/* Note:
> + * The current driver only support 16-bit PASID.
> + * Currently, hardware only implement upto 16-bit PASID
> + * even though the spec says it could have upto 20 bits.
> + */
> +#define PASID_MASK		0x0000ffff
>
>   /* MMIO status bits */
>   #define MMIO_STATUS_EVT_INT_MASK	(1 << 1)
> @@ -696,8 +701,8 @@ extern unsigned long *amd_iommu_pd_alloc_bitmap;
>    */
>   extern u32 amd_iommu_unmap_flush;
>
> -/* Smallest number of PASIDs supported by any IOMMU in the system */
> -extern u32 amd_iommu_max_pasids;
> +/* Smallest max PASID supported by any IOMMU in the system */
> +extern u32 amd_iommu_max_pasid;
>
>   extern bool amd_iommu_v2_present;
>
>


