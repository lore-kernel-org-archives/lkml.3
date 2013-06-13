Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab3FMPPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:15:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39062 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3FMPPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:15:02 -0400
Message-ID: <51B9E1F2.3090404@wwwdotorg.org>
Date: Thu, 13 Jun 2013 09:14:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mayuresh Kulkarni <mkulkarni@nvidia.com>
CC: tbergstrom@nvidia.com, amerilainen@nvidia.com,
        thierry.reding@avionic-design.de, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] gpu: host1x: add runtime pm support for gr2d
References: <1371117218-2326-1-git-send-email-mkulkarni@nvidia.com> <1371117218-2326-3-git-send-email-mkulkarni@nvidia.com>
In-Reply-To: <1371117218-2326-3-git-send-email-mkulkarni@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 03:53 AM, Mayuresh Kulkarni wrote:

Patch description?


> diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c

> +#ifdef CONFIG_PM_RUNTIME
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_get_sync(&pdev->dev);
> +#else
>  	err = clk_prepare_enable(gr2d->clk);
>  	if (err) {
>  		dev_err(dev, "cannot turn on clock\n");
>  		return err;
>  	}
> +#endif

The #else block here is a cut/paste of the body of
gr2d_runtime_resume(). It'd be better to call that function instead. The
following is what I ended up with in the Tegra ASoC driver in order to
support runtime PM on or off:

        pm_runtime_enable(&pdev->dev);
        if (!pm_runtime_enabled(&pdev->dev)) {
                ret = tegra20_i2s_runtime_resume(&pdev->dev);
                if (ret)
                        goto err_pm_disable;
        }

> @@ -328,10 +338,51 @@ static int __exit gr2d_remove(struct platform_device *pdev)
>  
>  	host1x_channel_free(gr2d->channel);
>  	clk_disable_unprepare(gr2d->clk);

Don't you need to remove that clk disable, or make it conditional upon
!PM_RUNTIME?

> +#ifdef CONFIG_PM_RUNTIME
> +	pm_runtime_disable(&pdev->dev);
> +#endif

Similarly, perhaps something like the following here:

        pm_runtime_disable(&pdev->dev);
        if (!pm_runtime_status_suspended(&pdev->dev))
                tegra20_i2s_runtime_suspend(&pdev->dev);

> @ -591,10 +592,18 @@ int host1x_job_submit(struct host1x_job *job)
>  {
>  	struct host1x *host = dev_get_drvdata(job->channel->dev->parent);
>  
> +#ifdef CONFIG_PM_RUNTIME
> +	pm_runtime_get_sync(job->channel->dev);
> +#endif
> +
>  	return host1x_hw_channel_submit(host, job);
>  }
>  
>  int host1x_job_complete(struct host1x_job *job)
>  {
> +#ifdef CONFIG_PM_RUNTIME
> +	return pm_runtime_put(job->channel->dev);
> +#else
>  	return 0;
> +#endif
>  }

I don't think you need any of those ifdefs; simply call the
pm_runtime_*() functions all the time, and they'll be successful no-ops
if !PM_RUNTIME.
