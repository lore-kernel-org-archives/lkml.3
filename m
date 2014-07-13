Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbaGMRxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 13:53:20 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37535 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750766AbaGMRxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 13:53:15 -0400
Date: Sun, 13 Jul 2014 18:53:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Subject: Re: [PATCH] Input: ambakmi - Use managed interfaces
Message-ID: <20140713175308.GL21766@n2100.arm.linux.org.uk>
References: <20140713173051.GA4299@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140713173051.GA4299@himangi-Dell>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 11:00:51PM +0530, Himangi Saraogi wrote:
> @@ -23,6 +23,7 @@
>  #include <linux/clk.h>
>  
>  #include <asm/io.h>
> +#include <linux/io.h>

NAK - please include either linux/io.h _or_ asm/io.h but not both.

> @@ -112,19 +113,10 @@ static int amba_kmi_probe(struct amba_device *dev,
>  {
>  	struct amba_kmi_port *kmi;
>  	struct serio *io;
> -	int ret;
> -
> -	ret = amba_request_regions(dev, NULL);
> -	if (ret)
> -		return ret;

I'm /really/ not happy about that going.

> -
> -	kmi = kzalloc(sizeof(struct amba_kmi_port), GFP_KERNEL);
> -	io = kzalloc(sizeof(struct serio), GFP_KERNEL);
> -	if (!kmi || !io) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
>  
> +	io = devm_kzalloc(&dev->dev, sizeof(struct serio), GFP_KERNEL);
> +	if (!io)
> +		return -ENOMEM;
>  
>  	io->id.type	= SERIO_8042;
>  	io->write	= amba_kmi_write;
> @@ -135,32 +127,20 @@ static int amba_kmi_probe(struct amba_device *dev,
>  	io->port_data	= kmi;
>  	io->dev.parent	= &dev->dev;
>  
> +	kmi->base	= devm_ioremap_resource(&dev->dev, &dev->res);
> +	if (IS_ERR(kmi->base))
> +		return PTR_ERR(kmi->base);

NAK.  Look carefully through the above changes to work out why.  Please,
if you don't understand what you're doing, or don't even bother with a
build test of the code you've modified, don't even modify it in the
first place.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
