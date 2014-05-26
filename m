Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaEZNkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:40:07 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60673 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbaEZNkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:40:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Paul Bolle <pebolle@tiscali.nl>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v5 3/5] ARM: Conceal DEBUG_LL_UART_NONE from unsupported platforms
Date: Mon, 26 May 2014 15:39:15 +0200
Message-ID: <6624276.NBS809VbNB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5013253.K6sZTxep7b@wuerfel>
References: <1398355246-29571-1-git-send-email-daniel.thompson@linaro.org> <1400857819-7975-4-git-send-email-daniel.thompson@linaro.org> <5013253.K6sZTxep7b@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:FtRMWiF4HgbPbIidFtPKrwZynrrxbrCZH4fG/jIIqwl
 gz8JbfEEuc6PsoInkz8fS3DeIfwx0nuPUOBhQ398QUYdXe0hnN
 kqMlcqtjfEZ9gxIZNg87sPlQov9Zj/EERiDnidtu/c/tR4Xrsn
 KZ0e1uPVAJFD61zPphtukwfE3Yunkd+TAFZE+WMXnn0Yc8Tmmv
 PPQMtJ7TTk7WaWGcTi31Twro1y/vwzZq8Y3lEYu9oWNvd7J2Ee
 lxVWUu/ojdW2ugemDC9UEOsqkvSUQJuXpX4yarzgHCgewPV300
 07DA/NDYOYgtL9ovCrxsMWdHi1Ns3bpMdq+U8T3uJIea3broR9
 O2nwqlhU4IvuI3MEm7fY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2014 17:35:34 Arnd Bergmann wrote:
> On Friday 23 May 2014 16:10:17 Daniel Thompson wrote:
> > Only a small handful of platforms support DEBUG_LL_UART_NONE but it
> > lurks in the menus of every single platform config ready to break the
> > build. This is an especial problem for defconfigs since it is often
> > selected by default.
> > 
> > This patch limit this choice only to platforms capable of supporting it.
> > 
> > Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> > ---
> >  arch/arm/Kconfig.debug | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> > index eab8ecb..4c8d7db 100644
> > --- a/arch/arm/Kconfig.debug
> > +++ b/arch/arm/Kconfig.debug
> > @@ -842,7 +842,18 @@ choice
> >  
> >       config DEBUG_LL_UART_NONE
> >               bool "No low-level debugging UART"
> > -             depends on !ARCH_MULTIPLATFORM
> > +             depends on ARCH_AT91 || \
> > +                     ARCH_CLPS711X || \
> > +                     ARCH_FOOTBRIDGE || \
> > +                     ARCH_KS8695 || \
> > +                     ARCH_NETX || \
> > +                     ARCH_OMAP1 || \
> > +                     ARCH_SA1100 || \
> > +                     ARCH_S3C24XX || \
> > +                     ARCH_S3C64XX || \
> > +                     ARCH_S5P64X0 || \
> > +                     ARCH_S5PC100 || \
> > +                     ARCH_S5PV210
> >               help
> >                 Say Y here if your platform doesn't provide a UART option
> >                 above. This relies on your platform choosing the right UART
> 
> ARCH_S3C24XX has been moved over in linux-next to use debug/s3c24xx.S.
> A few others will likely move soon (AT91, CLPS711x, S5PV210), as the
> platforms get moved to ARCH_MULTIPLATFORM.
> 
> As an alternative to your patch, we could decide to move the remaining
> files as well.

Follow-up: I also noticed that AT91, CLPS711X, FOOTBRIDGE and all the SAMSUNG
platforms already have an entry in the list, so DEBUG_LL_UART_NONE is redundant
for them. The below change should be enough.

For AT91 this is actually better because the old AT91X40 support doesn't
have working DEBUG_LL support. This gets handled correctly by 
AT91_DEBUG_LL_DBGU0/AT91_DEBUG_LL_DBGU1, but not DEBUG_LL_UART_NONE.

	Arnd

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index fd127d6..cae828a 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -864,7 +864,8 @@ choice
 
 	config DEBUG_LL_UART_NONE
 		bool "No low-level debugging UART"
-		depends on !ARCH_MULTIPLATFORM
+		depends on ARCH_KS8695 || ARCH_NETX || ARCH_OMAP1 || ARCH_SA1100
 		help
 		  Say Y here if your platform doesn't provide a UART option
 		  above. This relies on your platform choosing the right UART

