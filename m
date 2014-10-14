Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaJNQw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:52:28 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37818 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaJNQw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:52:27 -0400
MIME-Version: 1.0
In-Reply-To: <1411591537-31636-4-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
	<1411591537-31636-4-git-send-email-oded.gabbay@amd.com>
Date: Tue, 14 Oct 2014 12:52:26 -0400
Message-ID: <CADnq5_NsmJigAimosC1Z8iGc-1nVSw9W7ROWaU5u_vR-BC5X_A@mail.gmail.com>
Subject: Re: [PATCH v4 03/23] drm/radeon: Report doorbell configuration to amdkfd
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
> radeon and amdkfd share the doorbell aperture.
> radeon sets it up, takes the doorbells required for its own rings
> and reports the setup to amdkfd.
> radeon reserved doorbells are at the start of the doorbell aperture.
>
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>  drivers/gpu/drm/radeon/radeon.h        |  4 ++++
>  drivers/gpu/drm/radeon/radeon_device.c | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
>
> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> index bb75e57..67d249a 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -697,6 +697,10 @@ struct radeon_doorbell {
>
>  int radeon_doorbell_get(struct radeon_device *rdev, u32 *page);
>  void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell);
> +void radeon_doorbell_get_kfd_info(struct radeon_device *rdev,
> +                                 phys_addr_t *aperture_base,
> +                                 size_t *aperture_size,
> +                                 size_t *start_offset);
>
>  /*
>   * IRQS.
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index e84a76e..da3035f 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -373,6 +373,37 @@ void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell)
>                 __clear_bit(doorbell, rdev->doorbell.used);
>  }
>
> +/**
> + * radeon_doorbell_get_kfd_info - Report doorbell configuration required to
> + *                                setup KFD
> + *
> + * @rdev: radeon_device pointer
> + * @aperture_base: output returning doorbell aperture base physical address
> + * @aperture_size: output returning doorbell aperture size in bytes
> + * @start_offset: output returning # of doorbell bytes reserved for radeon.
> + *
> + * Radeon and the KFD share the doorbell aperture. Radeon sets it up,
> + * takes doorbells required for its own rings and reports the setup to KFD.
> + * Radeon reserved doorbells are at the start of the doorbell aperture.
> + */
> +void radeon_doorbell_get_kfd_info(struct radeon_device *rdev,
> +                                 phys_addr_t *aperture_base,
> +                                 size_t *aperture_size,
> +                                 size_t *start_offset)
> +{
> +       /* The first num_doorbells are used by radeon.
> +        * KFD takes whatever's left in the aperture. */
> +       if (rdev->doorbell.size > rdev->doorbell.num_doorbells * sizeof(u32)) {
> +               *aperture_base = rdev->doorbell.base;
> +               *aperture_size = rdev->doorbell.size;
> +               *start_offset = rdev->doorbell.num_doorbells * sizeof(u32);
> +       } else {
> +               *aperture_base = 0;
> +               *aperture_size = 0;
> +               *start_offset = 0;
> +       }
> +}
> +
>  /*
>   * radeon_wb_*()
>   * Writeback is the the method by which the the GPU updates special pages
> --
> 1.9.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
