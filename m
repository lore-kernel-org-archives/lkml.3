Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3BEWyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:54:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59372 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab3BEWyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:54:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Subject: Re: [PATCH 12/15] USB: gadget/freescale: disable non-multiplatform drivers
Date: Tue, 5 Feb 2013 22:54:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-usb@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <20130205170027.GB1081@kroah.com> <20130205213710.GA3739@arwen.pp.htv.fi>
In-Reply-To: <20130205213710.GA3739@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302052254.00426.arnd@arndb.de>
X-Provags-ID: V02:K0:gzyER0hnZTdbUIsR/fDgt7PftuUq9lazdMKtLE8ZQW2
 uz6lm/WrJNFOCAz70czq02QVTcfc9kbdHfw8/ghF0RDcvBw6lj
 vstabZRx5di5ArBb8z/TWIxw2CSOy6c1ESZtHDIZVaySp9y9pN
 B5usG546yo6f92z46QrGHpHFqB4kS7xJ9lFMS20BDOjIFBHFuZ
 ny3k3EBf8+SS2IvvHxg5PAl6MzheKanv5bP3mLG7Ce9nH2JmdR
 ftXTPGLlcBspgjT4r1afLKQUrNz3bshdmAf4IBDWmjQ+qF432o
 M2uFuuVy+OOyzcKSg8CQn/YP1l9U2pGawKgy3xJDZ2L58lvNJZ
 0VBrewZJNfEke5jieTwE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2013, Felipe Balbi wrote:
> [linus/master] Merge branch 'fix-max-write' of git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm
> 
> It's building find for me:
> 
> $ crossmake drivers/usb/gadget/fsl_udc_core.o \
>         drivers/usb/gadget/fsl_mxc_udc.o > /dev/null
> 
> (crossmake is an alias to make ARCH=arm)
> 
> Arnd, are you maybe missing a merge of v3.8-rc6 ?
>
> I can see that imx_udc.c is broken still, but there are no maintainers
> for that driver. I'm adding Sascha to Cc list, maybe he knows someone
> who can help, but if this driver isn't fixed in 2 merge windows, I will
> schedule for removal from tree and someone else will have to
> re-introduce it later without all the bogus includes.

Ah, I see what happened now: I submitted a patch that lumped together
two patches, disabling both fsl_mxc_udc and imx_udc. You already had
a fix for the first one, so I dropped my patch, but now I see the
build error for the second one that my patch was avoiding.

The last patch to imx_udc that seems to have seen more than just
build testing was probably "USB: gadget: imx_udc: don't queue more
data when zlp is to be sent", while fsl_mxc_udc looks actively
maintained. It's not completely clear to me whether these
are actually two drivers for the same hardware, of whether
imx_udc is the i.mx1 variant and fsl_mxc_udc is the i.mx2 variant.

What I can say is that no platform in the kernel currently defines
an "imx_udc" platform_device, so it is certainly unused, and has
been since at least e08300043e in 2010.

I would suggest that we mark the imx_udc driver as 'depends on
BROKEN' right away, since no in-tree user needs it, and any
out of tree user is already broken in 3.8. I also wouldn't
mind removing the driver unless the imx maintainers have
a plan for it.

> ---- build breaks ---
> 
> sound/soc/fsl/imx-pcm.c: In function 'snd_imx_pcm_mmap':
> sound/soc/fsl/imx-pcm.c:28:2: error: 'KBUILD_MODNAME' undeclared (first use in this function)
> sound/soc/fsl/imx-pcm.c:28:2: note: each undeclared identifier is
> reported only once for each function it appears in
> make[3]: *** [sound/soc/fsl/imx-pcm.o] Error 1
> 
> drivers/video/omap2/dss/dss.c: In function 'dss_calc_clock_div':
> drivers/video/omap2/dss/dss.c:572:20: error:
> 'CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK' undeclared (first use in this function)
> drivers/video/omap2/dss/dss.c:572:20: note: each undeclared identifier
> is reported only once for each function it appears in
> make[4]: *** [drivers/video/omap2/dss/dss.o] Error 1

Yes, I submitted patches for these, too, and like this case, we decided
to drop my patch in favor of a better fix, which has not yet gone
in. Today I sent emails about these as well, in the hope that we
can find a solution.

	Arnd
