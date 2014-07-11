Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaGKQ1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:27:55 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:48439 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaGKQ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:27:54 -0400
Date: Fri, 11 Jul 2014 12:27:49 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH 05/83] drm/radeon: Add kfd-->kgd interface to get virtual
 ram size
Message-ID: <20140711162748.GF1870@gmail.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-4-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405029027-6085-4-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:50:05AM +0300, Oded Gabbay wrote:
> This patch adds a new interface to kfd2kgd_calls structure so that
> the kfd driver could get the virtual ram size of a specific
> radeon device.
> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

What is vmem_size ? This need to be documented. I assume this is the
number of bits the gpu can handle and i would assume that the minimum
requirement is that the device have at least as many bit as the cpu ?
ie on 48bits x86-64 the hardware also needs to support that.

Otherwise this sounds like broken things can happen.

Cheers,
Jérôme

> ---
>  drivers/gpu/drm/radeon/radeon_kfd.c | 12 ++++++++++++
>  include/linux/radeon_kfd.h          |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
> index 7c7f808..1b859b5 100644
> --- a/drivers/gpu/drm/radeon/radeon_kfd.c
> +++ b/drivers/gpu/drm/radeon/radeon_kfd.c
> @@ -25,7 +25,10 @@
>  #include <drm/drmP.h>
>  #include "radeon.h"
>  
> +static uint64_t get_vmem_size(struct kgd_dev *kgd);
> +
>  static const struct kfd2kgd_calls kfd2kgd = {
> +	.get_vmem_size = get_vmem_size,
>  };
>  
>  static const struct kgd2kfd_calls *kgd2kfd;
> @@ -92,3 +95,12 @@ void radeon_kfd_device_fini(struct radeon_device *rdev)
>  		rdev->kfd = NULL;
>  	}
>  }
> +
> +static uint64_t get_vmem_size(struct kgd_dev *kgd)
> +{
> +	struct radeon_device *rdev = (struct radeon_device *)kgd;
> +
> +	BUG_ON(kgd == NULL);
> +
> +	return rdev->mc.real_vram_size;
> +}
> diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
> index 59785e9..28cddf5 100644
> --- a/include/linux/radeon_kfd.h
> +++ b/include/linux/radeon_kfd.h
> @@ -57,6 +57,7 @@ struct kgd2kfd_calls {
>  };
>  
>  struct kfd2kgd_calls {
> +	uint64_t (*get_vmem_size)(struct kgd_dev *kgd);
>  };
>  
>  bool kgd2kfd_init(unsigned interface_version,
> -- 
> 1.9.1
> 
