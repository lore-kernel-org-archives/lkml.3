Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaJKKeI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 06:34:08 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:49074 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaJKKeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 06:34:04 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Sat, 11 Oct 2014 12:31:17 +0200
From: Johan Hovold <johan@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Johan Hovold <johan@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] rtc: omap: add support for pmic_power_en
Message-ID: <20141011103117.GE18988@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-10-git-send-email-johan@kernel.org>
 <20141010180721.GV31348@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010180721.GV31348@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 01:07:27PM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Oct 09, 2014 at 09:06:31PM +0200, Johan Hovold wrote:
> > @@ -124,11 +138,18 @@
> >   */
> >  #define OMAP_RTC_HAS_POWER_UP_RESET	BIT(3)
> >  
> > +/*
> > + * Some RTC IP revisions can control an external PMIC via the pmic_power_en
> > + * pin.
> > + */
> > +#define OMAP_RTC_HAS_PMIC_MODE		BIT(4)
> > +
> >  static void __iomem	*rtc_base;
> >  
> >  #define rtc_read(addr)		readb(rtc_base + (addr))
> >  #define rtc_write(val, addr)	writeb(val, rtc_base + (addr))
> >  
> > +#define rtc_readl(addr)		readl(rtc_base + (addr))
> 
> looks like this should be part of another patch. Or, at a minimum (since
> it's so minor), it deserves a mention on commit log.

Ok, I'll add it separately.

> >  #define rtc_writel(val, addr)	writel(val, rtc_base + (addr))
> >  
> >  
> > @@ -338,6 +359,61 @@ static int omap_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
> >  	return 0;
> >  }
> >  
> > +static struct platform_device *omap_rtc_power_off_dev;
> > +
> > +/*
> > + * omap_rtc_poweroff: RTC-controlled power off
> > + *
> > + * The RTC can be used to control an external PMIC via the pmic_power_en pin,
> > + * which can be configured to transition to OFF on ALARM2 events.
> > + *
> > + * Notes:
> > + * The two-second alarm offset is the shortest offset possible as the alarm
> > + * registers must be set before the next timer update and the offset
> > + * calculation is to heavy for everything to be done within a single access
> 
> s/to/too

Thanks.

> > @@ -425,10 +505,12 @@ static int __init omap_rtc_probe(struct platform_device *pdev)
> >  		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
> >  	}
> >  
> > -	/* clear pending irqs, and set 1/second periodic,
> > -	 * which we'll use instead of update irqs
> > +	/*
> > +	 * disable interrupts
> > +	 *
> > +	 * NOTE: ALARM2 is not cleared on AM3352 if rtc_write (writeb) is used
> >  	 */
> > -	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
> > +	rtc_writel(0, OMAP_RTC_INTERRUPTS_REG);
> 
> bug fix, should be part of a separate patch and Cc stable :-)

Yeah, I guess you're right. Even though ALARM2 would never have been set
by Linux before this patch we might as well fix this separately.

Thanks,
Johan
