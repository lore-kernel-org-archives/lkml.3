Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3LQPI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:08:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:42810 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab3LQPI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:08:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,502,1384329600"; 
   d="scan'208";a="453651974"
Date: Tue, 17 Dec 2013 10:08:23 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Rajiv Shanmugam Madeswaran <smrajiv15@gmail.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] block: nvme-core: Scatter gather list support in
 the NVMe Block Driver
Message-ID: <20131217150823.GM6900@linux.intel.com>
References: <1387283114-19146-1-git-send-email-smrajiv15@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387283114-19146-1-git-send-email-smrajiv15@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 05:55:14PM +0530, Rajiv Shanmugam Madeswaran wrote:
> Hi matthew,  Thanks for your suggestion. I have made the following changes in the block driver.
> 
> 1. As far as SGL is concerned I could see slender increase in the iops when compared to PRP. For Ex: consider a scatter
>    gather list point to a segment which is contiguous and it is multiples of 4k.
>    In case of PRP it may take more than one entry for an individual IO transfer. As each of the PRP entry point to 4k size.
>    In case of SGL it could be formed as a single data block descriptor. In that case the processing logic of SGL becomes
>    simpler than PRP. But this kind of entry from the block layer is minimal. so,SGL can perform well at such scenarios.

You're speculating, or you've measured?  Processing an SGL is more
complex for the device than processing a PRP list.  I would expect a
device to be able to process more IOPS using PRPs than SGLs.

I can see SGLs being faster for:

 - The case where we would currently send more than one command (ie we hit
   the nvme_split_and_submit() case in nvme_map_bio(), which is the case
   when a buffer is not virtually contiguous)
 - The case where we can describe the user buffer using a single SGL but would
   require more than 2 PRPs (so physically contiguous, but crosses more than
   one page boundary).  In this case, we can describe everything with a single
   command and we don't need a PRP list.
 - There is probably a case when the SGL is significantly shorter than
   the equivalent PRP list.  That's going to vary depending on the drive.

Really though, it needs someone with some hardware to measure before I'm
going to take a patch to enable SGLs.  And I'd dearly love to see macro
benchmarks (eg a kernel compile or a MySQL run) more than "I did this dd
operation and ..."

> 2. I have handled the driver to work with multiple controllers by adding following parameters in nvme_dev structure.
> 
> /* following function pointer sets the type of data transfer
> +  * based on the controller support.it may be either SGL or PRP.
> +  * This function pointers are assigned during initialization.
> +  */
> +
> +  struct nvme_iod *
> +  (*alloc_iod)(unsigned nseg, unsigned nbytes, gfp_t gfp);
> +
> +  int (*setup_xfer)(struct nvme_dev *dev, struct nvme_common_command *cmd,
> +                    struct nvme_iod *iod, int total_len, gfp_t gfp);
> +
> +  void (*release_iod)(struct nvme_dev *dev, struct nvme_iod *iod);
> 
>    So, depending on the driver instance the corresponding mode of transfer will be called during IO.

As I've said, I think this decision needs to be taken on a per-command
basis, not a per-device basis.

> +	dev->sgls = le32_to_cpup(&ctrl->sgls);
> +
> +	if (use_sgl) {
> +		if (NVME_CTRL_SUPP_SGL(dev->sgls)) {
> +			dev->alloc_iod = nvme_alloc_iod_sgl;
> +			dev->setup_xfer = nvme_setup_sgls;
> +			dev->release_iod = nvme_free_iod_sgl;
> +		} else
> +			goto enable_prp;
> +	} else {
> + enable_prp:
> +		dev->alloc_iod = nvme_alloc_iod;
> +		dev->setup_xfer = nvme_setup_prps;
> +		dev->release_iod = nvme_free_iod;
> +	}

Why not simply:

+	if (use_sgl && NVME_CTRL_SUPP_SGL(dev->sgls)) {
+		dev->alloc_iod = nvme_alloc_iod_sgl;
...
+	} else {
...

> @@ -68,7 +68,9 @@ struct nvme_id_ctrl {
>  	__u8			vwc;
>  	__le16			awun;
>  	__le16			awupf;
> -	__u8			rsvd530[1518];
> +	__u8			rsvd530[6];
> +	__le32			sgls;
> +	__u8			rsvd540[1518];

That can't be right.  Maybe it's 1508 bytes long?

>  	struct nvme_id_power_state	psd[32];
>  	__u8			vs[1024];
>  };
