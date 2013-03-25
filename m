Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab3CYWJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:09:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52967 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933484Ab3CYWJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:09:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 3/4] dw_dmac: make build of DT related methods optional
Date: Mon, 25 Mar 2013 22:09:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org, "spear-devel" <spear-devel@list.st.com>
References: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com> <201303221519.14108.arnd@arndb.de> <1364202254.18714.101.camel@smile>
In-Reply-To: <1364202254.18714.101.camel@smile>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303252209.30634.arnd@arndb.de>
X-Provags-ID: V02:K0:74U/nKLd2wzWIA7MAgN+okaPuhRS4Q/TjfD1EZZFyoD
 ZgjxGtuT44olOwQyLkZW4FXBgXR0cHz0ci0R+bG2sWJWSfEo13
 w6aQTe+E2grDfmKWTnhifShez5Kwt1SZ/WYUN4ujB4b/JG6x/q
 9vdg+nHhL856O8Oq7fJTwlOTTx+haQnvYr2OVEWirBYhzCFDss
 A40qR4Q5iLSwYyAEi866RhJio8VmlSvSAyXuvHq8CAyLPVecQe
 81ir39xegnaf723rXbdHwexTjL9MbjodLNePVsFfPP9MGE14Uu
 l8a6SkECIOfaqg8ZGgOrfI7Uk/zc2+F6Vu/DjEA4Tk44pt0x4q
 mqIIC0fwPxs046jTnr0c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, Andy Shevchenko wrote:
> > I generally prefer to have all driver code be compiled  all the time
> > to catch build regressions independent of the configuration, and leave
> > the #ifdefs in header files that provide the interfaces.
> 
> I don't. For checking we have special make targets:
> 
>   allnoconfig     - New config where all options are answered with no
>   allyesconfig    - New config where all options are accepted with yes
>   allmodconfig    - New config selecting modules when possible
>   alldefconfig    - New config with all symbols set to default

That will only help on architectures that support CONFIG_OF, although
that probably includes all the common ones except s390 and ia64 nowadays.

> >       if (IS_ENABLED(CONFIG_OF)) && pdev->dev.of_node) {
> >               err = of_dma_controller_register(pdev->dev.of_node,
> >                                                dw_dma_of_xlate, dw);
> >               if (err)
> >                       dev_err(&pdev->dev,
> >                               "could not register of_dma_controller\n");
> >       }
> > 
> > Or alternatively, we can change the of_dma_controller_register() stub to
> > return 0 if CONFIG_OF is disabled. That would also take care of similar
> > code in other dma engine drivers.
> 
> Actually to be aligned with other dmaengine code it should return
> -ENOSYS. And by description ENOSYS seems  suitable for "not implemented"
> cases.

I think we use ENOSYS normally when the absence of the interface is
a fatal error, which it would not be here. This case I think is more
like the clk and regulator interfaces, where you want to bail out
if the functions return an actual error but not if the subsystem is
compiled out.

> What about to move all CONFIG_OF stuff into separate file?

Seems not worth it, and still would lead to the code not being
compile tested by default. Right now, there are two small functions,
and I would hope we can turn that into a single even smaller
function eventually if we get right of the silly requirement to
go through a filter function here.

	Arnd
