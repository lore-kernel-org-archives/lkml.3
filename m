Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaJNQuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:50:32 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:54203 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbaJNQu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:50:29 -0400
MIME-Version: 1.0
In-Reply-To: <1411591537-31636-2-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
	<1411591537-31636-2-git-send-email-oded.gabbay@amd.com>
Date: Tue, 14 Oct 2014 12:50:28 -0400
Message-ID: <CADnq5_NiY0MZz0ohp7aoOGu_tZLNYfGqabVAoXNUHMX9wcraGg@mail.gmail.com>
Subject: Re: [PATCH v4 01/23] drm/radeon: reduce number of free VMIDs and
 pipes in KV
From: Alex Deucher <alexdeucher@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 4:45 PM, Oded Gabbay <oded.gabbay@amd.com> wrote:
> To support HSA on KV, we need to limit the number of vmids and pipes
> that are available for radeon's use with KV.
>
> This patch reserves VMIDs 8-15 for amdkfd (so radeon can only use VMIDs
> 0-7) and also makes radeon thinks that KV has only a single MEC with a single
> pipe in it
>
> v3: Use define for static vmid allocation in radeon
>
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/radeon/cik.c  | 48 +++++++++++++++++++++----------------------
>  drivers/gpu/drm/radeon/cikd.h |  2 ++
>  2 files changed, 26 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
> index 0d761f7..1530e37 100644
> --- a/drivers/gpu/drm/radeon/cik.c
> +++ b/drivers/gpu/drm/radeon/cik.c
> @@ -4678,12 +4678,11 @@ static int cik_mec_init(struct radeon_device *rdev)
>         /*
>          * KV:    2 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 64 Queues total
>          * CI/KB: 1 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 32 Queues total
> +        * Nonetheless, we assign only 1 pipe because all other pipes will
> +        * be handled by KFD
>          */
> -       if (rdev->family == CHIP_KAVERI)
> -               rdev->mec.num_mec = 2;
> -       else
> -               rdev->mec.num_mec = 1;
> -       rdev->mec.num_pipe = 4;
> +       rdev->mec.num_mec = 1;
> +       rdev->mec.num_pipe = 1;
>         rdev->mec.num_queue = rdev->mec.num_mec * rdev->mec.num_pipe * 8;
>
>         if (rdev->mec.hpd_eop_obj == NULL) {
> @@ -4825,28 +4824,24 @@ static int cik_cp_compute_resume(struct radeon_device *rdev)
>
>         /* init the pipes */
>         mutex_lock(&rdev->srbm_mutex);
> -       for (i = 0; i < (rdev->mec.num_pipe * rdev->mec.num_mec); i++) {
> -               int me = (i < 4) ? 1 : 2;
> -               int pipe = (i < 4) ? i : (i - 4);
>
> -               eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr + (i * MEC_HPD_SIZE * 2);
> +       eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr;
>
> -               cik_srbm_select(rdev, me, pipe, 0, 0);
> +       cik_srbm_select(rdev, 0, 0, 0, 0);
>
> -               /* write the EOP addr */
> -               WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
> -               WREG32(CP_HPD_EOP_BASE_ADDR_HI, upper_32_bits(eop_gpu_addr) >> 8);
> +       /* write the EOP addr */
> +       WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
> +       WREG32(CP_HPD_EOP_BASE_ADDR_HI, upper_32_bits(eop_gpu_addr) >> 8);
>
> -               /* set the VMID assigned */
> -               WREG32(CP_HPD_EOP_VMID, 0);
> +       /* set the VMID assigned */
> +       WREG32(CP_HPD_EOP_VMID, 0);
> +
> +       /* set the EOP size, register value is 2^(EOP_SIZE+1) dwords */
> +       tmp = RREG32(CP_HPD_EOP_CONTROL);
> +       tmp &= ~EOP_SIZE_MASK;
> +       tmp |= order_base_2(MEC_HPD_SIZE / 8);
> +       WREG32(CP_HPD_EOP_CONTROL, tmp);
>
> -               /* set the EOP size, register value is 2^(EOP_SIZE+1) dwords */
> -               tmp = RREG32(CP_HPD_EOP_CONTROL);
> -               tmp &= ~EOP_SIZE_MASK;
> -               tmp |= order_base_2(MEC_HPD_SIZE / 8);
> -               WREG32(CP_HPD_EOP_CONTROL, tmp);
> -       }
> -       cik_srbm_select(rdev, 0, 0, 0, 0);
>         mutex_unlock(&rdev->srbm_mutex);
>
>         /* init the queues.  Just two for now. */
> @@ -5900,8 +5895,13 @@ int cik_ib_parse(struct radeon_device *rdev, struct radeon_ib *ib)
>   */
>  int cik_vm_init(struct radeon_device *rdev)
>  {
> -       /* number of VMs */
> -       rdev->vm_manager.nvm = 16;
> +       /*
> +        * number of VMs
> +        * VMID 0 is reserved for System
> +        * radeon graphics/compute will use VMIDs 1-7
> +        * amdkfd will use VMIDs 8-15
> +        */
> +       rdev->vm_manager.nvm = RADEON_NUM_OF_VMIDS;
>         /* base offset of vram pages */
>         if (rdev->flags & RADEON_IS_IGP) {
>                 u64 tmp = RREG32(MC_VM_FB_OFFSET);
> diff --git a/drivers/gpu/drm/radeon/cikd.h b/drivers/gpu/drm/radeon/cikd.h
> index 0c6e1b5..fae4d0c 100644
> --- a/drivers/gpu/drm/radeon/cikd.h
> +++ b/drivers/gpu/drm/radeon/cikd.h
> @@ -30,6 +30,8 @@
>  #define CIK_RB_BITMAP_WIDTH_PER_SH     2
>  #define HAWAII_RB_BITMAP_WIDTH_PER_SH  4
>
> +#define RADEON_NUM_OF_VMIDS    8
> +
>  /* DIDT IND registers */
>  #define DIDT_SQ_CTRL0                                     0x0
>  #       define DIDT_CTRL_EN                               (1 << 0)
> --
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
