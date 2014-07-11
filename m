Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaGKQeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:34:44 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:36767 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaGKQen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:34:43 -0400
Date: Fri, 11 Jul 2014 12:34:38 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH 07/83] drm/radeon: Add kfd-->kgd interface of locking
 srbm_gfx_cntl register
Message-ID: <20140711163437.GH1870@gmail.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-6-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405029027-6085-6-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:50:07AM +0300, Oded Gabbay wrote:
> This patch adds a new interface to kfd2kgd_calls structure, which
> allows the kfd to lock and unlock the srbm_gfx_cntl register

Why does kfd needs to lock this register if kfd can not access
any of those register ? This sounds broken to me, exposing a
driver internal mutex to another driver is not something i am
fan of.

Cheers,
Jérôme

> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> ---
>  drivers/gpu/drm/radeon/radeon_kfd.c | 20 ++++++++++++++++++++
>  include/linux/radeon_kfd.h          |  4 ++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
> index 66ee36b..594020e 100644
> --- a/drivers/gpu/drm/radeon/radeon_kfd.c
> +++ b/drivers/gpu/drm/radeon/radeon_kfd.c
> @@ -43,6 +43,10 @@ static void unkmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem);
>  
>  static uint64_t get_vmem_size(struct kgd_dev *kgd);
>  
> +static void lock_srbm_gfx_cntl(struct kgd_dev *kgd);
> +static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd);
> +
> +
>  static const struct kfd2kgd_calls kfd2kgd = {
>  	.allocate_mem = allocate_mem,
>  	.free_mem = free_mem,
> @@ -51,6 +55,8 @@ static const struct kfd2kgd_calls kfd2kgd = {
>  	.kmap_mem = kmap_mem,
>  	.unkmap_mem = unkmap_mem,
>  	.get_vmem_size = get_vmem_size,
> +	.lock_srbm_gfx_cntl = lock_srbm_gfx_cntl,
> +	.unlock_srbm_gfx_cntl = unlock_srbm_gfx_cntl,
>  };
>  
>  static const struct kgd2kfd_calls *kgd2kfd;
> @@ -233,3 +239,17 @@ static uint64_t get_vmem_size(struct kgd_dev *kgd)
>  
>  	return rdev->mc.real_vram_size;
>  }
> +
> +static void lock_srbm_gfx_cntl(struct kgd_dev *kgd)
> +{
> +	struct radeon_device *rdev = (struct radeon_device *)kgd;
> +
> +	mutex_lock(&rdev->srbm_mutex);
> +}
> +
> +static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd)
> +{
> +	struct radeon_device *rdev = (struct radeon_device *)kgd;
> +
> +	mutex_unlock(&rdev->srbm_mutex);
> +}
> diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
> index c7997d4..40b691c 100644
> --- a/include/linux/radeon_kfd.h
> +++ b/include/linux/radeon_kfd.h
> @@ -81,6 +81,10 @@ struct kfd2kgd_calls {
>  	void (*unkmap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem);
>  
>  	uint64_t (*get_vmem_size)(struct kgd_dev *kgd);
> +
> +	/* SRBM_GFX_CNTL mutex */
> +	void (*lock_srbm_gfx_cntl)(struct kgd_dev *kgd);
> +	void (*unlock_srbm_gfx_cntl)(struct kgd_dev *kgd);
>  };
>  
>  bool kgd2kfd_init(unsigned interface_version,
> -- 
> 1.9.1
> 
