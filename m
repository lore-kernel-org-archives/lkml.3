Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaKDJVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:21:08 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:48226 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbaKDJVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:21:04 -0500
Date: Tue, 4 Nov 2014 09:20:59 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mfd: tc6393xb fail ohci suspend if full state restore is
 required
Message-ID: <20141104092059.GM17577@x1>
References: <1414171197-18620-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414171197-18620-1-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Dmitry Eremin-Solenikov wrote:

> Some boards with TC6393XB chip require full state restore during system
> resume thanks to chip's VCC being cut off during suspend (Sharp SL-6000
> tosa is one of them). Failing to do so would result in ohci Oops on
> resume due to internal memory contentes being changed. Fail ohci suspend
> on tc6393xb is full state restore is required.
> 
> Recommended workaround is to unbind tmio-ohci driver before suspend and
> rebind it after resume.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mfd/tc6393xb.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
> index 11c19e5..48579e5 100644
> --- a/drivers/mfd/tc6393xb.c
> +++ b/drivers/mfd/tc6393xb.c
> @@ -263,6 +263,17 @@ static int tc6393xb_ohci_disable(struct platform_device *dev)
>  	return 0;
>  }
>  
> +static int tc6393xb_ohci_suspend(struct platform_device *dev)
> +{
> +	struct tc6393xb_platform_data *tcpd = dev_get_platdata(dev->dev.parent);
> +
> +	/* We can't properly store/restore OHCI state, so fail here */
> +	if (tcpd->resume_restore)
> +		return -EBUSY;
> +
> +	return tc6393xb_ohci_disable(dev);
> +}
> +
>  static int tc6393xb_fb_enable(struct platform_device *dev)
>  {
>  	struct tc6393xb *tc6393xb = dev_get_drvdata(dev->dev.parent);
> @@ -403,7 +414,7 @@ static struct mfd_cell tc6393xb_cells[] = {
>  		.num_resources = ARRAY_SIZE(tc6393xb_ohci_resources),
>  		.resources = tc6393xb_ohci_resources,
>  		.enable = tc6393xb_ohci_enable,
> -		.suspend = tc6393xb_ohci_disable,
> +		.suspend = tc6393xb_ohci_suspend,
>  		.resume = tc6393xb_ohci_enable,
>  		.disable = tc6393xb_ohci_disable,
>  	},

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
