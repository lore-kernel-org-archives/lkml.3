Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaJBNn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:43:29 -0400
Received: from lists.s-osg.org ([54.187.51.154]:39073 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbaJBNn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:43:27 -0400
Date: Thu, 2 Oct 2014 10:43:21 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] s5p-fimc: Only build suspend/resume for PM
Message-ID: <20141002104321.0b5b6aa2@recife.lan>
In-Reply-To: <1412239691-28719-1-git-send-email-thierry.reding@gmail.com>
References: <1412239691-28719-1-git-send-email-thierry.reding@gmail.com>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 02 Oct 2014 10:48:11 +0200
Thierry Reding <thierry.reding@gmail.com> escreveu:

> From: Thierry Reding <treding@nvidia.com>
> 
> If power management is disabled these functions become unused, so there
> is no reason to build them. This fixes a couple of build warnings when
> PM(_SLEEP,_RUNTIME) is not enabled.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/media/platform/exynos4-is/fimc-core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
> index b70fd996d794..8e7435bfa1f9 100644
> --- a/drivers/media/platform/exynos4-is/fimc-core.c
> +++ b/drivers/media/platform/exynos4-is/fimc-core.c
> @@ -832,6 +832,7 @@ err:
>  	return -ENXIO;
>  }
>  
> +#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
>  static int fimc_m2m_suspend(struct fimc_dev *fimc)
>  {
>  	unsigned long flags;
> @@ -870,6 +871,7 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
>  
>  	return 0;
>  }
> +#endif

The patch obviously is correct, but I'm wandering if aren't there a way
to avoid the if/endif.

Not tested here, but perhaps if we mark those functions as inline, the
C compiler would do the right thing without generating any warnings.

If not, maybe we could use some macro like:

#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
	#define PM_SLEEP_FUNC
#else
	#define PM_SLEEP_FUNC	inline
#endif

And put it at pm.h.

That should be enough to shut up to warning without adding any footprint
if PM is disabled.

Regards,
Mauro
