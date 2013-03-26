Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414Ab3CZJs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:48:59 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:60154 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795Ab3CZJsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:48:55 -0400
Date: Tue, 26 Mar 2013 09:48:48 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 2/3] mfd: db8500-prcmu: Fetch the PRCMU TCDM base address
 from Device Tree
Message-ID: <20130326094848.GA14151@gmail.com>
References: <1364223758-17621-1-git-send-email-lee.jones@linaro.org>
 <1364223758-17621-2-git-send-email-lee.jones@linaro.org>
 <201303251540.51104.arnd@arndb.de>
 <20130325164600.GA11734@gmail.com>
 <CACRpkdbn4WARSp7_MUpCZTghTrsPYvsa9GEUC31T7nP_=9oZag@mail.gmail.com>
 <20130326081704.GB11734@gmail.com>
 <CACRpkdZxU197moM_00UQr-tHdip4b50c+CfYkR5OK+MbwsE-aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZxU197moM_00UQr-tHdip4b50c+CfYkR5OK+MbwsE-aw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013, Linus Walleij wrote:

> On Tue, Mar 26, 2013 at 9:17 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Mon, 25 Mar 2013, Linus Walleij wrote:
> >> On Mon, Mar 25, 2013 at 5:46 PM, Lee Jones <lee.jones@linaro.org> wrote:
> >>
> >> >> >         res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> >> >> >                                            "prcmu-tcpm");
> >> >> >         if (!res) {
> >> >> > -               dev_err(&pdev->dev,
> >> >> > -                       "Error: no prcmu tcpm memory region provided\n");
> >> >> > -               return;
> >> >> > -       }
> >> >> > -       tcpm_base = ioremap(res->start, resource_size(res));
> >> >> > +               if (np) {
> >> >> > +                       tcpm_np = of_find_node_by_name(np->parent,
> >> >> > +                                                      "prcmu-tcpm-per4");
> >> >> > +                       if (!tcpm_np) {
> >> >> > +                               dev_err(&pdev->dev,
> >> >> > +                                       "no prcmu tcpm mem region provided\n");
> >> >> > +                               return;
> >> >> > +                       }
> >> >> > +                       tcpm_base = of_iomap(tcpm_np, 0);
> >> >> > +               }
> >> >> > +       } else
> >> >> > +               tcpm_base = ioremap(res->start, resource_size(res));
> >> >> > +
> >> >>
> >> >> Why don't you just add these extra registers to the prcmu node itself like
> >> >>
> >> >> diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
> >> >> index 9de9309..6ee6c31 100644
> >> >> --- a/arch/arm/boot/dts/dbx5x0.dtsi
> >> >> +++ b/arch/arm/boot/dts/dbx5x0.dtsi
> >> >> @@ -191,8 +191,8 @@
> >> >>
> >> >>               prcmu: prcmu@80157000 {
> >> >>                       compatible = "stericsson,db8500-prcmu";
> >> >> -                     reg = <0x80157000 0x1000>;
> >> >> -                     reg-names = "prcmu";
> >> >> +                     reg = <0x80157000 0x1000>, <0x801b0000 0x1000>, <0x801b8000 0x1000>;
> >> >> +                     reg-names = "prcmu", "prcmu-tcpm", "prcmu-tcdm-per4";
> >> >>                       interrupts = <0 47 0x4>;
> >> >>                       #address-cells = <1>;
> >> >>                       #size-cells = <1>;
> >> >>
> >> >>
> >> >> and document those in the prcmu binding?
> >> >>
> >> >> That would keep the code simpler and the same for both cases.
> >> >
> >> > I'm not sure you can. These addresses differ from platform to
> >> > platform, so I'd need to provide the base PRCMU address in
> >> > dbx5x0.dtsi, then the other two in the dts files. Can you do that?
> >>
> >> Better ask on devicetree-discuss.
> >>
> >> What it reflects are differences between SoC:s, so I think the
> >> right solution is to split it in a three-layer cake:
> >>
> >> dbx5x0.dtsi -> included by
> >> db8500.dtsi -> included by
> >> snowball/hrefv60plus.dts
> >>
> >> dbx5x0.dtsi -> included by
> >> dbx540.dtsi -> included by
> >> ccu9540/ccu8540.dts
> >>
> >> Here you may insert the reg property into the node at the
> >> db8500.dtsi or dbx540.dtsi layer.
> >
> > It's easy done, if that's the right way.
> >
> >> If you prefer I can cook a patch...
> >
> > ... and I'm fine to do it.
> >
> > [5 mins later]
> >
> > Hmm... it appears that in STE's kernel, the same address is used for
> > all SoCs:
> >
> >   #define U8500_PRCMU_TCDM_BASE    (U8500_PER4_BASE + 0x68000)
> 
> Yes that's correct...
> 
> > However, in Mainline there is another definition:
> >
> >   #define U9540_PRCMU_TCDM_BASE    (U8500_PER4_BASE + 0x6A000)
> >
> > ... which doesn't seem to be in use anywhere - even for the u9540.
> >
> > What's the deal big-man?
> 
> Probably there was another address at some point in some FPGA or
> early silicon and it now needs fixing.
> 
> So you should be able to use the same thing on all ASICs, put one
> single value in the dbx5x0.dtsi *and* fix this bug at the same time,
> good!

Bit for information for you. 

I have confirmed that the address locations are the same for
all SoCs are the same. However, the size of the TCDM changes from 4k
on the db8500 to 12k on the db8540.

Is there a way we can increase the size for the db8540 without
creating an entire new DTS file? Seems overkill.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
