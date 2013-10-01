Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab3JASON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:14:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50410 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3JASOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:14:12 -0400
Message-ID: <524B10F0.7000301@wwwdotorg.org>
Date: Tue, 01 Oct 2013 12:14:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arto Merilainen <amerilainen@nvidia.com>
CC: tbergstrom@nvidia.com, treding@nvidia.com, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkulkarni@nvidia.com
Subject: Re: [PATCHv3 2/4] drm/tegra: Add runtime pm support for gr2d
References: <1380024325-18280-1-git-send-email-amerilainen@nvidia.com> <1380024325-18280-3-git-send-email-amerilainen@nvidia.com>
In-Reply-To: <1380024325-18280-3-git-send-email-amerilainen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 06:05 AM, Arto Merilainen wrote:
> From: Mayuresh Kulkarni <mkulkarni@nvidia.com>
> 
> This far we have enabled gr2d clock on device probe and disabled
> it on device deinitialisation. This patch adds runtime pm support
> for the hardware unit allowing dynamic power management. If pm
> runtime is not enabled, gr2d clock is enabled in device probe and

> diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c

> @@ -327,11 +336,48 @@ static int __exit gr2d_remove(struct platform_device *pdev)
>  		host1x_syncpt_free(gr2d->client.syncpts[i]);
>  
>  	host1x_channel_free(gr2d->channel);
> +
> +	if (pm_runtime_enabled(&pdev->dev))
> +		pm_runtime_disable(&pdev->dev);
> +	else
> +		gr2d_runtime_suspend(&pdev->dev);

This code is slightly different to the code in e.g.
sound/soc/tegra/tegra20_i2s.c:remove(), whereas the code in probe() is
identical. I'm not sure whether there's some advantage in this version?
If so, perhaps the sound drivers should be updated to be consistent. If
not, perhaps this driver should do the same thing as the I2S driver, so
we keep the drivers consistent, and provide the same "example" code
everywhere.

> +static int gr2d_runtime_suspend(struct device *dev)
> +{
> +	struct gr2d *gr2d;
> +
> +	gr2d = dev_get_drvdata(dev);
> +	if (!gr2d)
> +		return -EINVAL;

Presumably, gr2d will never be NULL here, unless there's some chronic
bug. Can't we re-write those last 5 lines as simply:

	struct gr2d *grd2 = dev_get_drvdata(dev);

If that's not valid, we should probably update the audio drivers (and
perhaps others) too.
