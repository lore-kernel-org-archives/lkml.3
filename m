Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab3K0Uqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:46:31 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:32969 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab3K0Uq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:46:29 -0500
Date: Wed, 27 Nov 2013 22:46:21 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Felipe Balbi <balbi@ti.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 00/13] mfd: menelaus: a few cleanups
Message-ID: <20131127204621.GI24645@blackmetal.musicnaut.iki.fi>
References: <1385579217-20127-1-git-send-email-balbi@ti.com>
 <20131127200247.GH24645@blackmetal.musicnaut.iki.fi>
 <20131127201149.GB20734@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127201149.GB20734@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 27, 2013 at 02:11:49PM -0600, Felipe Balbi wrote:
> On Wed, Nov 27, 2013 at 10:02:47PM +0200, Aaro Koskinen wrote:
> > On Wed, Nov 27, 2013 at 01:06:44PM -0600, Felipe Balbi wrote:
> > > few cleanups on the old menelaus driver. I don't have
> > > HW to test these patches, maybe Aaro can help here ?
> > 
> > Hmm, I got:
> > 
> > [    1.330000] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> > [    1.340000] pgd = c0004000
> > [    1.340000] [00000000] *pgd=00000000
> > [    1.350000] Internal error: Oops: 17 [#1] ARM
> > [    1.350000] CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-rc1-n8x0_tiny-los.git-729021f-00018-g74a0f39 #2
> > [    1.350000] task: c782c000 ti: c782e000 task.ti: c782e000
> > [    1.350000] PC is at mutex_lock+0x0/0x20
> > [    1.350000] LR is at __irq_get_desc_lock+0x6c/0x88
[...]
> > [    1.350000] [<c016745c>] (mutex_lock+0x0/0x20) from [<c00509ac>] (__irq_get_desc_lock+0x6c/0x88)
> > [    1.350000] [<c00509ac>] (__irq_get_desc_lock+0x6c/0x88) from [<c0053518>] (__irq_set_handler+0x24/0x128)
> > [    1.350000] [<c0053518>] (__irq_set_handler+0x24/0x128) from [<c013ec80>] (menelaus_probe+0xbc/0x280)
> > [    1.350000] [<c013ec80>] (menelaus_probe+0xbc/0x280) from [<c0140ab8>] (i2c_device_probe+0x98/0xc0)

[...]

> hmm, irq_set_chip_and_handler() will call back into the irq_chip we just
> registered, so my ->irq_bus_lock needs to have everything setup
> (chip_data my mutex), this should solve it:

Yes, that fixes it. Seems to work fine now.

A.

> diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> index 376f01d..c9bd2fb 100644
> --- a/drivers/mfd/menelaus.c
> +++ b/drivers/mfd/menelaus.c
> @@ -1232,6 +1232,7 @@ static int menelaus_probe(struct i2c_client *client,
>  
>  	the_menelaus = m;
>  	m->client = client;
> +	mutex_init(&m->lock);
>  
>  	irq_base = irq_alloc_descs(-1, 0, MENELAUS_NR_IRQS, 0);
>  	if (irq_base < 0) {
> @@ -1245,10 +1246,10 @@ static int menelaus_probe(struct i2c_client *client,
>  	m->irq_base = irq_base;
>  
>  	for (i = irq_base; i < irq_base + MENELAUS_NR_IRQS; i++) {
> +		irq_set_chip_data(i, m);
>  		irq_set_chip_and_handler(i, &menelaus_irq_chip,
>  				handle_simple_irq);
>  		irq_set_nested_thread(i, 1);
> -		irq_set_chip_data(i, m);
>  		set_irq_flags(i, IRQF_VALID);
>  	}
>  
> @@ -1280,8 +1281,6 @@ static int menelaus_probe(struct i2c_client *client,
>  		}
>  	}
>  
> -	mutex_init(&m->lock);
> -
>  	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);
>  
>  	val = menelaus_read_reg(m, MENELAUS_VCORE_CTRL1);
> 
> 
> let me know when you can, and I'll meld these hunks to proper patch.
> 
> -- 
> balbi
