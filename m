Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaJ1A0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:26:18 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:46340 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752369AbaJ1A0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:26:15 -0400
Date: Tue, 28 Oct 2014 00:25:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johan Hovold <johan@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141028002552.GX12379@n2100.arm.linux.org.uk>
References: <1412881594-25678-1-git-send-email-johan@kernel.org> <1413913086-12730-1-git-send-email-johan@kernel.org> <20141024160845.GM26941@saruman> <20141024190251.GB19377@localhost> <20141024192540.GD11455@saruman> <20141024192948.GE11455@saruman> <20141024193655.GD19377@localhost> <20141024194442.GG11455@saruman> <20141024195532.GF19377@localhost> <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 04:22:51PM -0700, Andrew Morton wrote:
> On Fri, 24 Oct 2014 21:55:32 +0200 Johan Hovold <johan@kernel.org> wrote:
> > I will. :) Just wanted to see whether Andrew preferred I resend the
> > whole series or just that one patch first.
> > 
> > The diff is minimal:
> > 
> > diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> > index e74750f00b18..e4f97ad9eb21 100644
> > --- a/drivers/rtc/rtc-omap.c
> > +++ b/drivers/rtc/rtc-omap.c
> > @@ -423,6 +423,8 @@ static void omap_rtc_power_off(void)
> >         val = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
> >         rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
> >                         val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
> > +
> > +       mdelay(2000);
> >  }
> 
> Yes, having read this threadlet: we need a very good comment in there
> explaining what's going on, please.
> 
> Do we even need this delay on anything other than arm?  Or even on all arm?

I think I've already commented on the behaviour of the reboot syscalls
such as power off which can return to userspace, pointing out that
x86 can return to userspace.

As long as x86 can return to userspace, I see no harm in ARM returning
to userspace.  If a driver which is hooking into the power off stuff
is unable to immediately shut off the power (wtf it can't for 2 sec
I've no idea) then having that driver work around that hardware's
specific brokenness with a delay seems entirely reasonable.

That allows those SoCs which can do the right thing to do the right
thing without being hindered by such silliness.  And it also stops
the next person coming along and bumping the delay from 2 to 3, to 5,
and then what... 10 seconds?

Keeping it in the driver means that the workaround for the broken
hardware is kept with the driver for the broken hardware - exactly
where it should be.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
