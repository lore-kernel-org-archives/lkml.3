Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3DVFbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:31:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47358 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3DVFbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:31:38 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5174CB26.9060908@jp.fujitsu.com>
Date: Mon, 22 Apr 2013 14:31:18 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: wei@aristanetworks.com
CC: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] intel-iommu: Disable DMA Remapping when intel_iommu=off
References: <1366441080-5937-1-git-send-email-wei@aristanetworks.com>
In-Reply-To: <1366441080-5937-1-git-send-email-wei@aristanetworks.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/20 15:58), Wei Hu wrote:
> On a VT-d capable machine Linux will enable IOMMU by default. If it
> then kexec's a second kernel with intel_iommu=off, this second kernel
> will leave the DMA remapping engine on with no code handling it. The
> symptom is at least USB and SATA drives stop working. This patch fixes
> the problem by always disabling DMA remapping when intel_iommu=off.

Even when second kernel boots up with intel_iommu=on, dma-remapping need
to be disabled as well before it is initialized and enabled again in
init_dmars(). So, how about something like this?

        for_each_drhd_unit(drhd) {
                struct dmar_drhd_unit *drhd;
                if (drhd->ignored)
                        continue;

                iommu = drhd->iommu;
                if (iommu->gcmd & DMA_GCMD_TE)
                        iommu_disable_translation(iommu);
        }

Note, if you agree above code and fix your patch like this, you need
additinal fix to set iommu->gcmd flag sinse gcmd is always zero here.
See first hunk of this patch.
https://lkml.org/lkml/2013/3/20/707

Thanks,
Takao Indoh


> 
> Signed-off-by: Wei Hu <wei@aristanetworks.com>
> ---
>   drivers/iommu/intel-iommu.c |    6 +++++-
>   1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 0099667..0b8f8bb 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -3681,8 +3681,12 @@ int __init intel_iommu_init(void)
>   		return 	-ENODEV;
>   	}
>   
> -	if (no_iommu || dmar_disabled)
> +	if (no_iommu || dmar_disabled) {
> +		struct dmar_drhd_unit *drhd;
> +		for_each_drhd_unit(drhd)
> +			iommu_disable_translation(drhd->iommu);
>   		return -ENODEV;
> +	}
>   
>   	if (iommu_init_mempool()) {
>   		if (force_on)
> 

