Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbaCEWfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:35:50 -0500
Received: from 8bytes.org ([85.214.48.195]:33474 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496AbaCEWft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:35:49 -0500
Date: Wed, 5 Mar 2014 23:35:45 +0100
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kim.naru@amd.com, jay.cornwall@amd.com
Subject: Re: [PATCH] iommu/amd: Fix logics to determine and checking max PASID
Message-ID: <20140305223544.GA2813@8bytes.org>
References: <1394046068-3858-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394046068-3858-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar  5 23:35:47 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5317a6c320861073413135
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:01:08PM -0600, suravee.suthikulpanit@amd.com wrote:
>  drivers/iommu/amd_iommu.c       |   26 +++++++++++++++++++++++---
>  drivers/iommu/amd_iommu_init.c  |   15 ++++++++-------
>  drivers/iommu/amd_iommu_types.h |    6 ++----
>  drivers/iommu/amd_iommu_v2.c    |    2 +-
>  4 files changed, 34 insertions(+), 15 deletions(-)

Hmm, this looks a bit complicated. Since the inv_iotlb_pasid and
complete_ppr command only support 16 bit pasids by specification, there
is no way to support pasids with more than 16 bits in general anymore. I
think the best way to handle it is to just change the PASID_MASK to
0x0000ffff.

>  static void build_inv_iotlb_pasid(struct iommu_cmd *cmd, u16 devid, int pasid,
>  				  int qdep, u64 address, bool size)
>  {
> +	/* Note:
> +	 * This command supports only 16-bit PASID.
> +	 * Currently, hardware only implement upto 16-bit PASID
> +	 * even though the spec says it could have upto 20 bits.
> +	 * This is likely to be updated in the future revision of
> +	 * IOMMU specs when the hardware with PASID > 16 bits
> +	 * become available.
> +	 */
> +	BUG_ON(pasid > 0xFFFF);

We can keep this as BUG_ON(pasid & ~PASID_MASK), but then ...

> -		cmd->data[1]  = pasid & PASID_MASK;
> +		cmd->data[1]  = pasid & amd_iommu_max_pasid;

... masking out the other bits is redundant.


	Joerg


