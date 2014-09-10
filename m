Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaIJQ0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:26:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:39329 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaIJQ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:26:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19f3abuKXjW0WsN4+jnC408
Date: Wed, 10 Sep 2014 16:25:59 +0000
From: Tony Lindgren <tony@atomide.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>, Balaji T K <balajitk@ti.com>,
        Nishanth Menon <nm@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/3] omap-dma: Allow compile-testing omap1_camera driver
Message-ID: <20140910162559.GC1058@atomide.com>
References: <20140909124306.2d5a0d76@canb.auug.org.au>
 <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <20140909144157.GF12361@n2100.arm.linux.org.uk>
 <20140909123654.37d60f38.m.chehab@samsung.com>
 <20140909145217.4bce41b0@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140909145217.4bce41b0@recife.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mauro Carvalho Chehab <mchehab@infradead.org> [140909 17:52]:
> Em Tue, 09 Sep 2014 12:36:54 -0300
> Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
> 
> > Em Tue, 9 Sep 2014 15:41:58 +0100
> > Russell King - ARM Linux <linux@arm.linux.org.uk> escreveu:
> > 
> > > On Tue, Sep 09, 2014 at 11:38:17AM -0300, Mauro Carvalho Chehab wrote:
> > > > We want to be able to COMPILE_TEST the omap1_camera driver.
> > > > It compiles fine, but it fails linkediting:
> > > > 
> > > > ERROR: "omap_stop_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > > > ERROR: "omap_start_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > > > ERROR: "omap_dma_link_lch" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > > > ERROR: "omap_set_dma_dest_burst_mode" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > > > ERROR: "omap_set_dma_src_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > > > ERROR: "omap_request_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > > > ERROR: "omap_set_dma_transfer_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > > > ERROR: "omap_set_dma_dest_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > > > ERROR: "omap_free_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > > > 
> > > > So, add some stub functions to avoid it.
> > > 
> > > The real answer to this is to find someone who still uses it, and convert
> > > it to the DMA engine API.  If there's no users, the driver might as well
> > > be killed off.
> > 
> > Hmm... it seems that there are still several drivers still relying on
> > the functions declared at: omap-dma.h:
> > 
> > $ grep extern include/linux/omap-dma.h |perl -ne 'print "$1\n" if (m/extern\s\S+\s(.*)\(/)' >funcs && git grep -f funcs -l
> > arch/arm/mach-omap1/pm.c
> > arch/arm/mach-omap2/pm24xx.c
> > arch/arm/plat-omap/dma.c
> > drivers/dma/omap-dma.c
> > drivers/media/platform/omap/omap_vout_vrfb.c
> > drivers/media/platform/omap3isp/isphist.c
> > drivers/media/platform/soc_camera/omap1_camera.c
> > drivers/mtd/onenand/omap2.c
> > drivers/usb/gadget/udc/omap_udc.c
> > drivers/usb/musb/tusb6010_omap.c
> > drivers/video/fbdev/omap/omapfb_main.c
> > include/linux/omap-dma.h
> > 
> > Perhaps we can remove the header and mark all the above as BROKEN.

No, not quite yet. That would currently cause major issues for omap2
and omap3.
 
> > If nobody fixes, we can strip all of them from the Kernel.
> 
> Are all the functions declared at omap-dma.h part of the
> old DMA API that should be deprecated?

For the drivers yes. For the platform code, there are few functions
needed, that's at least omap_dma_global_context_save()
and omap_dma_global_context_restore(). But those can be in a local
header file in arch/arm/plat-omap/include/plat.
 
> If so, it seems that the OMAP2 and OMAP3 also depends on this 
> thing, as all the PM code for OMAP depends on the functions
> declared inside omap-dma.h, and marking them as BROKEN
> causes compilation to failure:
> 
> arch/arm/mach-omap2/built-in.o: In function `omap3_save_scratchpad_contents':
> :(.text+0x798): undefined reference to `omap3_restore_3630'
> :(.text+0x7a8): undefined reference to `omap3_restore'
> :(.text+0x7ac): undefined reference to `omap3_restore_es3'
> arch/arm/mach-omap2/built-in.o: In function `omap3_sram_restore_context':
> :(.text+0x925c): undefined reference to `omap_push_sram_idle'
> arch/arm/mach-omap2/built-in.o: In function `option_set':
> :(.text+0xc15c): undefined reference to `omap3_pm_off_mode_enable'
> arch/arm/mach-omap2/built-in.o: In function `pwrdm_suspend_set':
> :(.text+0xc1a0): undefined reference to `omap3_pm_set_suspend_state'
> arch/arm/mach-omap2/built-in.o: In function `pwrdm_suspend_get':
> :(.text+0xc1e4): undefined reference to `omap3_pm_get_suspend_state'
> arch/arm/mach-omap2/built-in.o: In function `omap3_enter_idle_bm':
> :(.text+0xc7ec): undefined reference to `omap_sram_idle'
> :(.text+0xc848): undefined reference to `pm34xx_errata'
> arch/arm/mach-omap2/built-in.o: In function `omap2420_init_late':
> :(.init.text+0xf64): undefined reference to `omap2_pm_init'
> arch/arm/mach-omap2/built-in.o: In function `omap2430_init_late':
> :(.init.text+0x1024): undefined reference to `omap2_pm_init'
> arch/arm/mach-omap2/built-in.o: In function `omap3_init_late':
> :(.init.text+0x1248): undefined reference to `omap3_pm_init'
> arch/arm/mach-omap2/built-in.o: In function `omap3430_init_late':
> :(.init.text+0x1264): undefined reference to `omap3_pm_init'
> arch/arm/mach-omap2/built-in.o: In function `omap35xx_init_late':
> :(.init.text+0x1280): undefined reference to `omap3_pm_init'
> arch/arm/mach-omap2/built-in.o: In function `omap3630_init_late':
> :(.init.text+0x129c): undefined reference to `omap3_pm_init'
> arch/arm/mach-omap2/built-in.o: In function `am35xx_init_late':
> :(.init.text+0x12b8): undefined reference to `omap3_pm_init'
> arch/arm/mach-omap2/built-in.o::(.init.text+0x12d4): more undefined references to `omap3_pm_init' follow
> 
> This was compiled with allmodconfig on arm, with COMPILE_TEST
> disabled (a few sub-archs disabled too), to avoid spurious
> unrelated compilation issues).

OK thanks for pointing that out. I'll take a look at dealing with the
with omap_dma_global_context_save() and omap_dma_global_context_restore()
to fix the above.
 
> Am I missing something?
> 
> BTW, CONFIG_PM is auto-selected by ARCH_OMAP3.
> 
> And those are the functions that the OMAP3 code uses from omap-dma.h:
> 
> arch/arm/mach-omap2/pm34xx.c:92:2: error: implicit declaration of function ‘omap_dma_global_context_save’ [-Werror=implicit-function-declaration]
> arch/arm/mach-omap2/pm34xx.c:103:2: error: implicit declaration of function ‘omap_dma_global_context_restore’ [-Werror=implicit-function-declaration]
> arch/arm/mach-omap2/pm24xx.c:170:2: error: implicit declaration of function ‘omap_dma_running’ [-Werror=implicit-function-declaration]
> 
> Just enabling this won't work, as the code at arch/arm/plat-omap/dma.c
> depends on several other functions inside omap-dma.h.

OK so looks like omap_dma_running() is needed by the platform code too,
it's the same story.
 
> From: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Subject: [PATCH] omap-dma: remove deprecated omap-dma.h API
> 
> We want to be able to COMPILE_TEST the omap1_camera driver.
> It compiles fine, but it fails linkediting:
> 
> ERROR: "omap_stop_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_start_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_dma_link_lch" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_set_dma_dest_burst_mode" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_set_dma_src_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_request_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_set_dma_transfer_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_set_dma_dest_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> ERROR: "omap_free_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> 
> That's because OMAP1 is using a legacy deprecated API.
> Instead of fixing it, the right thing to do is to convert the
> remaining OMAP drivers that use the legacy API to the standard
> DMA API.
> 
> While this doesn't happen, let's mark the broken stuff with
> BROKEN.

As pointed out, the proper fix for the above is to remove the broken
driver that nobody is using. Or update it to use dmaengine API if
somebody is still using it.

> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -11,6 +11,16 @@ config ARCH_OMAP2
>  	select CPU_V6
>  	select SOC_HAS_OMAP2_SDRC
>  
> +config OMAP2_PM24XX
> +	bool
> +	depends on ARCH_OMAP2
> +	depends on BROKEN
> +
> +config OMAP2_PM34XX
> +	bool
> +	depends on ARCH_OMAP3
> +	depends on BROKEN
> +

And all this should not be needed, I'll move those to a local platform
specific header file.

Regards,

Tony
