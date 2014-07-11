Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaGKQQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:16:40 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:57386 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbaGKQQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:16:39 -0400
Date: Fri, 11 Jul 2014 12:16:34 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH 03/83] drm/radeon: Report doorbell configuration to kfd
Message-ID: <20140711161632.GD1870@gmail.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-2-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405029027-6085-2-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:50:03AM +0300, Oded Gabbay wrote:
> Radeon and KFD share the doorbell aperture.
> Radeon sets it up, takes the doorbells required for its own rings
> and reports the setup to KFD.
> Radeon reserved doorbells are at the start of the doorbell aperture.
> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

I would need some refreshing on doorbell. You want to map it to userspace
but at the same time it is use by the radeon kernel driver when dispatching
on the compute ring (iirc the gfx ring does not use it).

So now my worry is, given usermapping is done on page granularity, what
would block one process from writting to another process doorbell ? Again
iirc the doorbell is actualy the wptr for the ring buffer associated with
said doorbell (thought i forget how doorbell are associated with a ring).

This sounds really bad.

Cheers,
Jérôme

> ---
>  drivers/gpu/drm/radeon/radeon.h        |  4 ++++
>  drivers/gpu/drm/radeon/radeon_device.c | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
> index 7cda75d..4e7e41f 100644
> --- a/drivers/gpu/drm/radeon/radeon.h
> +++ b/drivers/gpu/drm/radeon/radeon.h
> @@ -676,6 +676,10 @@ struct radeon_doorbell {
>  
>  int radeon_doorbell_get(struct radeon_device *rdev, u32 *page);
>  void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell);
> +void radeon_doorbell_get_kfd_info(struct radeon_device *rdev,
> +				  phys_addr_t *aperture_base,
> +				  size_t *aperture_size,
> +				  size_t *start_offset);
>  
>  /*
>   * IRQS.
> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
> index 03686fa..98538d2 100644
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -328,6 +328,37 @@ void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell)
>  		__clear_bit(doorbell, rdev->doorbell.used);
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
> +				  phys_addr_t *aperture_base,
> +				  size_t *aperture_size,
> +				  size_t *start_offset)
> +{
> +	/* The first num_doorbells are used by radeon.
> +	 * KFD takes whatever's left in the aperture. */
> +	if (rdev->doorbell.size > rdev->doorbell.num_doorbells * sizeof(u32)) {
> +		*aperture_base = rdev->doorbell.base;
> +		*aperture_size = rdev->doorbell.size;
> +		*start_offset = rdev->doorbell.num_doorbells * sizeof(u32);
> +	} else {
> +		*aperture_base = 0;
> +		*aperture_size = 0;
> +		*start_offset = 0;
> +	}
> +}
> +
>  /*
>   * radeon_wb_*()
>   * Writeback is the the method by which the the GPU updates special pages
> -- 
> 1.9.1
> 
