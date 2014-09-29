Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaI2Mtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:49:42 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47089 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaI2Mtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:49:40 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [git pull] Devicetree changes for v3.15
To: Jason Cooper <jason@lakedaemon.net>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@linaro.org>
In-Reply-To: <20140926141943.GC23926@titan.lakedaemon.net>
References: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail.com>
	<CACRpkdZoo=P7uTO1rNDD_HUPjfAk26C0=mNYPoZmTV0wcO3V-w@mail.gmail.com>
	<20140926141943.GC23926@titan.lakedaemon.net>
Date: Mon, 29 Sep 2014 13:49:22 +0100
Message-Id: <20140929124922.CBE9FC4150A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014 10:19:43 -0400
, Jason Cooper <jason@lakedaemon.net>
 wrote:
> Linus,
> 
> On Fri, Sep 26, 2014 at 02:30:53PM +0200, Linus Walleij wrote:
> > On Tue, Apr 1, 2014 at 12:15 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > 
> > > Here are the dt changes I've got queued up for v3.15. The full
> > > description is below in the tag. Please pull.
> > (...)
> > > Jason Cooper (1):
> > >       kbuild: dtbs_install: new make target
> 
> Exact patch is:
> 
>   f4d4ffc03efc kbuild: dtbs_install: new make target
> 
> > After this patch a while back I have observed the following behaviour
> > of the kernel build:
> > 
> > make zImage
> > make zImage
> > -> incremental build, just relink
> > 
> > make zImage
> > make dtbs
> > make zImage
> > -> The whole kernel gets rebuilt
> > 
> > So now if I happen to recompile my device trees, I suddenly want
> > the entire zImage to be rebuilt to? It's by definition not changes that
> > affect the kernel build :-(
> > 
> > I noticed this because my build scripts calls make dtbs && make zImage,
> > and started to rebuild absolutely everything all the time.
> > 
> > Do you think this can be fixed? It's quite simple to reproduce...
> 
> Does the attached fix your problem?
> 
> thx,
> 
> Jason.
> 
> ----------->8------------------------------------------
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index 0ce9d0f71f2a..a88b13af58d2 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -313,7 +313,9 @@ $(INSTALL_TARGETS):
>  	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $(boot)/dts/$@
>  
>  PHONY += dtbs dtbs_install
> -dtbs dtbs_install: prepare scripts
> +dtbs: scripts
> +	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $@
> +dtbs_install: prepare scripts
>  	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $@
>  
>  # We use MRPROPER_FILES and CLEAN_FILES now

Is this the right fix though? It seems that it would fix the problem for
the dtbs target, but would still cause a kernel rebuild for
dtbs_install. Why does dtbs_install need to depend on the 'prepare'
target?

g.

