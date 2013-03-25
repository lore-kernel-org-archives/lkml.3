Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab3CYQqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:46:08 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:61416 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086Ab3CYQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:46:06 -0400
Date: Mon, 25 Mar 2013 16:46:00 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 2/3] mfd: db8500-prcmu: Fetch the PRCMU TCDM base address
 from Device Tree
Message-ID: <20130325164600.GA11734@gmail.com>
References: <1364223758-17621-1-git-send-email-lee.jones@linaro.org>
 <1364223758-17621-2-git-send-email-lee.jones@linaro.org>
 <201303251540.51104.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303251540.51104.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >         res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> >                                            "prcmu-tcpm");
> >         if (!res) {
> > -               dev_err(&pdev->dev,
> > -                       "Error: no prcmu tcpm memory region provided\n");
> > -               return;
> > -       }
> > -       tcpm_base = ioremap(res->start, resource_size(res));
> > +               if (np) {
> > +                       tcpm_np = of_find_node_by_name(np->parent,
> > +                                                      "prcmu-tcpm-per4");
> > +                       if (!tcpm_np) {
> > +                               dev_err(&pdev->dev,
> > +                                       "no prcmu tcpm mem region provided\n");
> > +                               return;
> > +                       }
> > +                       tcpm_base = of_iomap(tcpm_np, 0);
> > +               }
> > +       } else
> > +               tcpm_base = ioremap(res->start, resource_size(res));
> > +
> 
> Why don't you just add these extra registers to the prcmu node itself like
> 
> diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
> index 9de9309..6ee6c31 100644
> --- a/arch/arm/boot/dts/dbx5x0.dtsi
> +++ b/arch/arm/boot/dts/dbx5x0.dtsi
> @@ -191,8 +191,8 @@
>  
>  		prcmu: prcmu@80157000 {
>  			compatible = "stericsson,db8500-prcmu";
> -			reg = <0x80157000 0x1000>;
> -			reg-names = "prcmu";
> +			reg = <0x80157000 0x1000>, <0x801b0000 0x1000>, <0x801b8000 0x1000>;
> +			reg-names = "prcmu", "prcmu-tcpm", "prcmu-tcdm-per4";
>  			interrupts = <0 47 0x4>;
>  			#address-cells = <1>;
>  			#size-cells = <1>;
> 
> 
> and document those in the prcmu binding?
> 
> That would keep the code simpler and the same for both cases.

I'm not sure you can. These addresses differ from platform to
platform, so I'd need to provide the base PRCMU address in
dbx5x0.dtsi, then the other two in the dts files. Can you do that?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
