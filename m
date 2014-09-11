Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaIKJzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:55:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44028 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751138AbaIKJzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:55:23 -0400
Date: Thu, 11 Sep 2014 11:55:19 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Johan Hovold <johan@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Johan Hovold <jhovold@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3 5/8] rtc: at91sam9: make use of syscon/regmap to
 access GPBR registers
Message-ID: <20140911115519.52334db8@bbrezillon>
In-Reply-To: <20140911094100.GB12295@localhost>
References: <1410425767-17874-1-git-send-email-boris.brezillon@free-electrons.com>
	<1410425767-17874-6-git-send-email-boris.brezillon@free-electrons.com>
	<20140911094100.GB12295@localhost>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 11:41:00 +0200
Johan Hovold <johan@kernel.org> wrote:

> On Thu, Sep 11, 2014 at 10:56:04AM +0200, Boris BREZILLON wrote:
> > The GPBR registers are not part of the RTT block and thus should not be
> > defined in the reg property of the rtt node.
> > 
> > Use syscon to provide a proper DT representation and reference the GPBR
> > syscon device in a new "atmel,time-reg" property which store both the
> > syscon device phandle and the register offset within the GPBR block.
> > 
> > When using non DT boards, we won't be able to retrieve the syscon regmap,
> > hence we need to create our own regmap using the memory region defined
> > in the 2nd memory resource assigned to the RTT platform device.
> > 
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > 
> > Conflicts:
> > 	drivers/rtc/rtc-at91sam9.c
> 
> You probably don't want this here.

Absolutely, it's a rebase leftover :-).
I'll remove this line from the commit message.

> 
> > ---
> >  drivers/rtc/Kconfig        |  1 +
> >  drivers/rtc/rtc-at91sam9.c | 58 +++++++++++++++++++++++++++++++++++++++-------
> >  2 files changed, 50 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> > index a168e96..7d76da8 100644
> > --- a/drivers/rtc/Kconfig
> > +++ b/drivers/rtc/Kconfig
> > @@ -1081,6 +1081,7 @@ config RTC_DRV_AT91RM9200
> >  config RTC_DRV_AT91SAM9
> >  	tristate "AT91SAM9x/AT91CAP9 RTT as RTC"
> >  	depends on ARCH_AT91 && !(ARCH_AT91RM9200 || ARCH_AT91X40)
> > +	select MFD_SYSCON
> >  	help
> >  	  RTC driver for the Atmel AT91SAM9x and AT91CAP9 internal RTT
> >  	  (Real Time Timer). These timers are powered by the backup power
> > diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
> > index d72c34d..b953545 100644
> > --- a/drivers/rtc/rtc-at91sam9.c
> > +++ b/drivers/rtc/rtc-at91sam9.c
> > @@ -21,6 +21,8 @@
> >  #include <linux/slab.h>
> >  #include <linux/platform_data/atmel.h>
> >  #include <linux/io.h>
> > +#include <linux/mfd/syscon.h>
> > +#include <linux/regmap.h>
> >  
> >  /*
> >   * This driver uses two configurable hardware resources that live in the
> > @@ -72,7 +74,8 @@ struct sam9_rtc {
> >  	void __iomem		*rtt;
> >  	struct rtc_device	*rtcdev;
> >  	u32			imr;
> > -	void __iomem		*gpbr;
> > +	struct regmap		*gpbr;
> > +	unsigned int		gpbr_offset;
> >  	int 			irq;
> >  };
> >  
> > @@ -81,10 +84,18 @@ struct sam9_rtc {
> >  #define rtt_writel(rtc, field, val) \
> >  	writel((val), (rtc)->rtt + AT91_RTT_ ## field)
> >  
> > -#define gpbr_readl(rtc) \
> > -	readl((rtc)->gpbr)
> > -#define gpbr_writel(rtc, val) \
> > -	writel((val), (rtc)->gpbr)
> > +static inline unsigned int gpbr_readl(struct sam9_rtc *rtc) {
> 
> Brace placement. Did you run checkpatch on the rest of the series?

Actually, I did last time I submitted, but forgot to run it this time.
Sorry, for the inconvenience, I'll fix that.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
