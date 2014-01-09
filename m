Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaAITM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:12:58 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47096 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaAITMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:12:47 -0500
Date: Thu, 9 Jan 2014 11:12:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V1] input: use device managed memory in da9052
 touchscreen driver
Message-ID: <20140109191236.GA28020@core.coreip.homeip.net>
References: <201401091252.s09CqsOr042762@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201401091252.s09CqsOr042762@swsrvapps-02.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anthony,

On Thu, Jan 09, 2014 at 12:51:37PM +0000, Anthony Olech wrote:
> The touchscreen component driver for the da9052/3 Dialog PMICs
> is changed to use device managed memory allocation.
> 
> This results in simpler error paths as failures in the probe()
> function do not require explicit calls to free the devm_...
> allocated memory.
> The allocation functions used in this driver are:
>     devm_kzalloc()
>     devm_input_allocate_device()
>     devm_request_threaded_irq()
> 
> Suggested-by: Huqiu Liu <liuhq11@mails.tsinghua.edu.cn>
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> ---
> This patch is relative to linux-next repository tag next-20140109
> 
> Many thanks to Huqiu Liu who instigated this patch.
> 
>  drivers/input/touchscreen/da9052_tsi.c |   62 ++++++++++++++++----------------
>  1 file changed, 30 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/da9052_tsi.c b/drivers/input/touchscreen/da9052_tsi.c
> index ab64d58..dcc4cf1 100644
> --- a/drivers/input/touchscreen/da9052_tsi.c
> +++ b/drivers/input/touchscreen/da9052_tsi.c
> @@ -233,18 +233,30 @@ static int da9052_ts_probe(struct platform_device *pdev)
>  	struct da9052_tsi *tsi;
>  	struct input_dev *input_dev;
>  	int error;
> +	int pdown_irq;
> +	int ready_irq;
>  
>  	da9052 = dev_get_drvdata(pdev->dev.parent);
>  	if (!da9052)
>  		return -EINVAL;
>  
> -	tsi = kzalloc(sizeof(struct da9052_tsi), GFP_KERNEL);
> -	input_dev = input_allocate_device();
> -	if (!tsi || !input_dev) {
> -		error = -ENOMEM;
> -		goto err_free_mem;
> -	}
> +	pdown_irq = regmap_irq_get_virq(da9052->irq_data, DA9052_IRQ_PENDOWN);
> +	if (pdown_irq < 0)
> +		return pdown_irq;
...
>  
> -	error = da9052_request_irq(tsi->da9052, DA9052_IRQ_PENDOWN,
> -				"pendown-irq", da9052_ts_pendwn_irq, tsi);
> +	error = devm_request_threaded_irq(&pdev->dev, pdown_irq,
> +				NULL, da9052_ts_pendwn_irq,
> +				IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +				"pendown-irq", tsi);

I am uncomfortable with the touchscreen portion of this driver ignoring
the framework of it's MFD core and mixing native IRQ management with the
ones done through the core.

What would happen if somebody changes da9052_request_irq() to do some
thing more than it is doing now so that your open-coded duplicate of the
same in da9052_ts_probe() is no longer equivalent? Or
da9052_disable_irq() no longer works correctly with IRQs allocated by
this sub-module?

Thanks.

-- 
Dmitry
