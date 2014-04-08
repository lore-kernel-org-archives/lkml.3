Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbaDHHgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:36:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46578 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaDHHgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:36:41 -0400
Date: Tue, 8 Apr 2014 09:36:24 +0200
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>
Subject: Re: [PATCH] drm/radeon: memory leak on bo reservation failure.
Message-ID: <20140408073556.GA15513@chrystal.home>
References: <1395159412-12377-1-git-send-email-quentin.casasnovas@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395159412-12377-1-git-send-email-quentin.casasnovas@oracle.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Dave?

On Tue, Mar 18, 2014 at 05:16:52PM +0100, Quentin Casasnovas wrote:
> On bo reservation failure, we end up leaking fpriv.
> 
> Fixes: 5e386b574cf7e1 ("drm/radeon: fix missing bo reservation")
> Cc: stable@vger.kernel.org
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> ---
>  drivers/gpu/drm/radeon/radeon_kms.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
> index 66ed3ea..51cda80 100644
> --- a/drivers/gpu/drm/radeon/radeon_kms.c
> +++ b/drivers/gpu/drm/radeon/radeon_kms.c
> @@ -546,8 +546,11 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
>  		radeon_vm_init(rdev, &fpriv->vm);
>  
>  		r = radeon_bo_reserve(rdev->ring_tmp_bo.bo, false);
> -		if (r)
> +		if (r) {
> +			radeon_vm_fini(rdev, &fpriv->vm);
> +			kfree(fpriv);
>  			return r;
> +		}
>  
>  		/* map the ib pool buffer read only into
>  		 * virtual address space */
> -- 
> 1.8.3.2
> 
