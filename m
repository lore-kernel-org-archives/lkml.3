Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaJGNd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:33:27 -0400
Received: from sym2.noone.org ([178.63.92.236]:57080 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbaJGNd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:33:26 -0400
Date: Tue, 7 Oct 2014 15:33:22 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: opencores-kbd: Switch to using managed resources
Message-ID: <20141007133322.GL3279@distanz.ch>
References: <1412681501-28072-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412681501-28072-1-git-send-email-pramod.gurav@smartplayin.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-07 at 13:31:41 +0200, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:
> This change switch to managed resources to simplifies error handling
> and module unloading and does away with platform_driver remove function.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/input/keyboard/opencores-kbd.c |   54 ++++++++------------------------
>  1 file changed, 13 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/input/keyboard/opencores-kbd.c b/drivers/input/keyboard/opencores-kbd.c
> index 7b9b441..ecacb87 100644
> --- a/drivers/input/keyboard/opencores-kbd.c
> +++ b/drivers/input/keyboard/opencores-kbd.c
> @@ -56,27 +56,27 @@ static int opencores_kbd_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	opencores_kbd = kzalloc(sizeof(*opencores_kbd), GFP_KERNEL);
> -	input = input_allocate_device();
> +	opencores_kbd = devm_kzalloc(&pdev->dev, sizeof(*opencores_kbd),
> +				     GFP_KERNEL);
> +	input = devm_input_allocate_device(&pdev->dev);
>  	if (!opencores_kbd || !input) {
>  		dev_err(&pdev->dev, "failed to allocate device structures\n");
> -		error = -ENOMEM;
> -		goto err_free_mem;
> +		return -ENOMEM;
>  	}
>  
>  	opencores_kbd->addr_res = res;
> -	res = request_mem_region(res->start, resource_size(res), pdev->name);
> +	res = devm_request_mem_region(&pdev->dev, res->start,
> +				      resource_size(res), pdev->name);
>  	if (!res) {
>  		dev_err(&pdev->dev, "failed to request I/O memory\n");
> -		error = -EBUSY;
> -		goto err_free_mem;
> +		return -EBUSY;
>  	}
>  
> -	opencores_kbd->addr = ioremap(res->start, resource_size(res));
> +	opencores_kbd->addr = devm_ioremap(&pdev->dev, res->start,
> +					   resource_size(res));

You could use devm_ioremap_resource() here and get rid of the call to
devm_request_mem_region() and the check for !res above, i.e. something
like:

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	[...]
	opencores_kbd->addr = devm_ioremap_resource(&pdev->dev, res);
	if (!opencores_kbd->addr) {
		dev_err(&pdev->dev, "failed to remap I/O memory\n");
		return -ENXIO;
	}

>  	if (!opencores_kbd->addr) {
>  		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> -		error = -ENXIO;
> -		goto err_rel_mem;
> +		return -ENXIO;
>  	}
>  
>  	opencores_kbd->input = input;
> @@ -109,54 +109,26 @@ static int opencores_kbd_probe(struct platform_device *pdev)
>  	}
>  	__clear_bit(KEY_RESERVED, input->keybit);
>  
> -	error = request_irq(irq, &opencores_kbd_isr,
> +	error = devm_request_irq(&pdev->dev, irq, &opencores_kbd_isr,
>  			    IRQF_TRIGGER_RISING, pdev->name, opencores_kbd);

The second line should be aligned to the opening parenthesis:

	error = devm_request_irq(&pdev->dev, irq, &opencores_kbd_isr,
				 IRQF_TRIGGER_RISING, pdev->name, opencores_kbd);
