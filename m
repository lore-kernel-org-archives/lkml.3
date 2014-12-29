Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaL2Mm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:42:29 -0500
Received: from pegasos-out.vodafone.de ([80.84.1.38]:52624 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaL2Mm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:42:27 -0500
X-Spam-Flag: NO
X-Spam-Score: 0.157
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=softfail
	(invalid, public key: DNS query timeout for
	mail._domainkey.vodafone.de) header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de 6184F600098
Message-ID: <54A14C0C.8090401@vodafone.de>
Date: Mon, 29 Dec 2014 13:41:48 +0100
From: =?ISO-8859-15?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oded Gabbay <oded.gabbay@amd.com>, dri-devel@lists.freedesktop.org,
        Alexander Deucher <Alexander.Deucher@amd.com>
CC: linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        LKP ML <lkp@01.org>, ak@linux.intel.com, rusty@rustcorp.com.au,
        airlied@linux.ie
Subject: Re: [PATCH v2] drm/radeon: Init amdkfd only if it was compiled
References: <1419843586-29864-1-git-send-email-oded.gabbay@amd.com>
In-Reply-To: <1419843586-29864-1-git-send-email-oded.gabbay@amd.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.12.2014 um 09:59 schrieb Oded Gabbay:
> This patch changes the radeon_kfd_init(), which is used to initialize the
> interface between radeon and amdkfd, so the interface will be initialized only
> if amdkfd was build, either as module or inside the kernel image.
>
> In the modules case, the symbol_request() will be used (same as old code). In
> the in-image compilation case, a direct call to kgd2kfd_init() will be done.
> For other cases, radeon_kfd_init() will just return false.
>
> This patch is necessary because in case of the following specific
> configuration: kernel 32-bit, no modules support, random kernel base and no
> hibernation, the symbol_request() doesn't work as expected - it doesn't return
> NULL if the symbol doesn't exists - which makes the kernel panic.
>
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>

Using symbol_request() in general doesn't seem to be such a good idea, 
because it breaks symbol versioning and as far as I can see is only very 
rarely used in drivers (AFAIK only V4L drivers).

But for the moment I don't have another idea either except for always 
loading the module which on most hardware is completely unnecessary. 
Maybe we should consider restructuring the module load dependencies in 
the next kernel release.

For now the patch is Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
>   drivers/gpu/drm/radeon/radeon_kfd.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
> index 242fd8b..d3e78b4 100644
> --- a/drivers/gpu/drm/radeon/radeon_kfd.c
> +++ b/drivers/gpu/drm/radeon/radeon_kfd.c
> @@ -101,6 +101,7 @@ static const struct kgd2kfd_calls *kgd2kfd;
>   
>   bool radeon_kfd_init(void)
>   {
> +#if defined(CONFIG_HSA_AMD_MODULE)
>   	bool (*kgd2kfd_init_p)(unsigned, const struct kfd2kgd_calls*,
>   				const struct kgd2kfd_calls**);
>   
> @@ -117,6 +118,17 @@ bool radeon_kfd_init(void)
>   	}
>   
>   	return true;
> +#elif defined(CONFIG_HSA_AMD)
> +	if (!kgd2kfd_init(KFD_INTERFACE_VERSION, &kfd2kgd, &kgd2kfd)) {
> +		kgd2kfd = NULL;
> +
> +		return false;
> +	}
> +
> +	return true;
> +#else
> +	return false;
> +#endif
>   }
>   
>   void radeon_kfd_fini(void)

