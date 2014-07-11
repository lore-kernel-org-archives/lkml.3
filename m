Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaGKQFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:05:24 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:43217 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaGKQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:05:22 -0400
Date: Fri, 11 Jul 2014 12:05:17 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and pipes
 in KV
Message-ID: <20140711160516.GC1870@gmail.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:50:02AM +0300, Oded Gabbay wrote:
> To support HSA on KV, we need to limit the number of vmids and pipes
> that are available for radeon's use with KV.
> 
> This patch reserves VMIDs 8-15 for KFD (so radeon can only use VMIDs
> 0-7) and also makes radeon thinks that KV has only a single MEC with a single
> pipe in it
> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

Reviewed-by: Jérôme Glisse <jglisse@redhat.com>

> ---
>  drivers/gpu/drm/radeon/cik.c | 48 ++++++++++++++++++++++----------------------
>  1 file changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
> index 4bfc2c0..e0c8052 100644
> --- a/drivers/gpu/drm/radeon/cik.c
> +++ b/drivers/gpu/drm/radeon/cik.c
> @@ -4662,12 +4662,11 @@ static int cik_mec_init(struct radeon_device *rdev)
>  	/*
>  	 * KV:    2 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 64 Queues total
>  	 * CI/KB: 1 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 32 Queues total
> +	 * Nonetheless, we assign only 1 pipe because all other pipes will
> +	 * be handled by KFD
>  	 */
> -	if (rdev->family == CHIP_KAVERI)
> -		rdev->mec.num_mec = 2;
> -	else
> -		rdev->mec.num_mec = 1;
> -	rdev->mec.num_pipe = 4;
> +	rdev->mec.num_mec = 1;
> +	rdev->mec.num_pipe = 1;
>  	rdev->mec.num_queue = rdev->mec.num_mec * rdev->mec.num_pipe * 8;
>  
>  	if (rdev->mec.hpd_eop_obj == NULL) {
> @@ -4809,28 +4808,24 @@ static int cik_cp_compute_resume(struct radeon_device *rdev)
>  
>  	/* init the pipes */
>  	mutex_lock(&rdev->srbm_mutex);
> -	for (i = 0; i < (rdev->mec.num_pipe * rdev->mec.num_mec); i++) {
> -		int me = (i < 4) ? 1 : 2;
> -		int pipe = (i < 4) ? i : (i - 4);
>  
> -		eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr + (i * MEC_HPD_SIZE * 2);
> +	eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr;
>  
> -		cik_srbm_select(rdev, me, pipe, 0, 0);
> +	cik_srbm_select(rdev, 0, 0, 0, 0);
>  
> -		/* write the EOP addr */
> -		WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
> -		WREG32(CP_HPD_EOP_BASE_ADDR_HI, upper_32_bits(eop_gpu_addr) >> 8);
> +	/* write the EOP addr */
> +	WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
> +	WREG32(CP_HPD_EOP_BASE_ADDR_HI, upper_32_bits(eop_gpu_addr) >> 8);
>  
> -		/* set the VMID assigned */
> -		WREG32(CP_HPD_EOP_VMID, 0);
> +	/* set the VMID assigned */
> +	WREG32(CP_HPD_EOP_VMID, 0);
> +
> +	/* set the EOP size, register value is 2^(EOP_SIZE+1) dwords */
> +	tmp = RREG32(CP_HPD_EOP_CONTROL);
> +	tmp &= ~EOP_SIZE_MASK;
> +	tmp |= order_base_2(MEC_HPD_SIZE / 8);
> +	WREG32(CP_HPD_EOP_CONTROL, tmp);
>  
> -		/* set the EOP size, register value is 2^(EOP_SIZE+1) dwords */
> -		tmp = RREG32(CP_HPD_EOP_CONTROL);
> -		tmp &= ~EOP_SIZE_MASK;
> -		tmp |= order_base_2(MEC_HPD_SIZE / 8);
> -		WREG32(CP_HPD_EOP_CONTROL, tmp);
> -	}
> -	cik_srbm_select(rdev, 0, 0, 0, 0);
>  	mutex_unlock(&rdev->srbm_mutex);
>  
>  	/* init the queues.  Just two for now. */
> @@ -5876,8 +5871,13 @@ int cik_ib_parse(struct radeon_device *rdev, struct radeon_ib *ib)
>   */
>  int cik_vm_init(struct radeon_device *rdev)
>  {
> -	/* number of VMs */
> -	rdev->vm_manager.nvm = 16;
> +	/*
> +	 * number of VMs
> +	 * VMID 0 is reserved for Graphics
> +	 * radeon compute will use VMIDs 1-7
> +	 * KFD will use VMIDs 8-15
> +	 */
> +	rdev->vm_manager.nvm = 8;
>  	/* base offset of vram pages */
>  	if (rdev->flags & RADEON_IS_IGP) {
>  		u64 tmp = RREG32(MC_VM_FB_OFFSET);
> -- 
> 1.9.1
> 
