Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaJ0XWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 19:22:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaJ0XWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 19:22:52 -0400
Date: Mon, 27 Oct 2014 16:22:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Felipe Balbi <balbi@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-Id: <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
In-Reply-To: <20141024195532.GF19377@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
	<1413913086-12730-1-git-send-email-johan@kernel.org>
	<20141024160845.GM26941@saruman>
	<20141024190251.GB19377@localhost>
	<20141024192540.GD11455@saruman>
	<20141024192948.GE11455@saruman>
	<20141024193655.GD19377@localhost>
	<20141024194442.GG11455@saruman>
	<20141024195532.GF19377@localhost>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014 21:55:32 +0200 Johan Hovold <johan@kernel.org> wrote:

> On Fri, Oct 24, 2014 at 02:44:42PM -0500, Felipe Balbi wrote:
> > On Fri, Oct 24, 2014 at 09:36:55PM +0200, Johan Hovold wrote:
> > > On Fri, Oct 24, 2014 at 02:29:48PM -0500, Felipe Balbi wrote:
> > > > Hi,
> > > > 
> > > > On Fri, Oct 24, 2014 at 02:25:40PM -0500, Felipe Balbi wrote:
> 
> > > > > with this I always get to "Power off failed -- system halted". If I
> > > > > switch to v3.18-rc1 vanilla, then it works. So it's definitely caused by
> > > > > your rtc-only patches.
> > > 
> > > That's expected (see below). It works with v3.18-rc1 vanilla because
> > > machine_halt is called instead of machine_power_off as there is no
> > > registered power-off handler.
> > 
> > yeah, that much I figured :-)
> > 
> > > > ok, so it seems like it takes more than 1 second for things to
> > > > propagate. If I increase that mdelay() to 3000, then everything works
> > > > fine on my end. I think we should get RMK's input on this 3000ms delay
> > > > to machine_power_off(). Should it be generic, or should we add it to our
> > > > rtc pm_power_off implementation ?
> > > 
> > > As I wrote above, we still need a 2-second mdelay in rtc-omap, which I
> > > intend to add to the pmic_power_en patch.
> > 
> > oh, alright then. If you can Cc me, I'll make sure to test that too ;-)
> 
> I will. :) Just wanted to see whether Andrew preferred I resend the
> whole series or just that one patch first.
> 
> The diff is minimal:
> 
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index e74750f00b18..e4f97ad9eb21 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -423,6 +423,8 @@ static void omap_rtc_power_off(void)
>         val = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
>         rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
>                         val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
> +
> +       mdelay(2000);
>  }

Yes, having read this threadlet: we need a very good comment in there
explaining what's going on, please.

Do we even need this delay on anything other than arm?  Or even on all arm?
