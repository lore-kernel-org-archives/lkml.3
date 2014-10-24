Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaJXTkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:40:00 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:51825 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaJXTj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:39:58 -0400
Date: Fri, 24 Oct 2014 21:36:55 +0200
From: Johan Hovold <johan@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Johan Hovold <johan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        nsekhar@ti.com, t-kristo@ti.com, j-keerthy@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141024193655.GD19377@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
 <20141024160845.GM26941@saruman>
 <20141024190251.GB19377@localhost>
 <20141024192540.GD11455@saruman>
 <20141024192948.GE11455@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024192948.GE11455@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 02:29:48PM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Oct 24, 2014 at 02:25:40PM -0500, Felipe Balbi wrote:
> > On Fri, Oct 24, 2014 at 09:02:51PM +0200, Johan Hovold wrote:
> > > [ +CC: Russell ]
> > > 
> > > On Fri, Oct 24, 2014 at 11:08:45AM -0500, Felipe Balbi wrote:
> > > 
> > > > I tested this entire series with my BBB and it still works fine. However
> > > > I still get below panic. This time without any DRM errors:
> > > > 
> > > > [   63.087832] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000000
> > > > [   63.087832] 
> > > > [   63.097399] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 3.18.0-rc1-00095-g8524e69 #556
> > > > [   63.106060] [<c00175a4>] (unwind_backtrace) from [<c00132f0>] (show_stack+0x20/0x24)
> > > > [   63.114160] [<c00132f0>] (show_stack) from [<c0657404>] (dump_stack+0x8c/0xa4)
> > > > [   63.121706] [<c0657404>] (dump_stack) from [<c0654f70>] (panic+0xa0/0x220)
> > > > [   63.128895] [<c0654f70>] (panic) from [<c0049e64>] (do_exit+0x974/0x9d0)
> > > > [   63.135900] [<c0049e64>] (do_exit) from [<c006775c>] (SyS_reboot+0x14c/0x1e8)
> > > > [   63.143361] [<c006775c>] (SyS_reboot) from [<c000f080>] (ret_fast_syscall+0x0/0x48)
> > > > [   63.151596] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000000
> > > > 
> > > > Then again, this also happens by simply calling poweroff without
> > > > enabling wakealarm.
> > > 
> > > Bah, I forgot to look into that. I haven't seen this myself as I don't
> > > use systemd (which does the syscall from process 0).
> > > 
> > > Some driver power-off implementations and some arch machine_power_off
> > > spin indefinitely (or use an mdelay and WARN) after trying to power off.
> > > 
> > > I think this is really a bug in arch/arm that should be fixed
> > > analogously to how failed reboot is handled in machine_restart().
> > > 
> > > Care to try the patch below?
> > > 
> > > I should still add a two-second delay to rtc-omap to avoid the arch
> > > error message.
> > > 
> > > Andrew, can you update one patch in the series or should I just resend
> > > them all (with proper Tested-by tags)?
> > > 
> > > > In any case, for the whole series:
> > > > 
> > > > Tested-by: Felipe Balbi <balbi@ti.com>
> > > 
> > > Thanks for testing!
> > > 
> > > Johan
> > > 
> > > 
> > > >From aaa1d1d6171c895b6966ba5b738ac7946ada97c7 Mon Sep 17 00:00:00 2001
> > > From: Johan Hovold <johan@kernel.org>
> > > Date: Fri, 24 Oct 2014 18:53:09 +0200
> > > Subject: [PATCH] ARM: fix failed power-off handling
> > > 
> > > Make sure to handle failed power off by printing an error message and
> > > halting (analogously to how failed reboot is handled).
> > > 
> > > Power off can fail for example if the hardware has not been wired up
> > > correctly.
> > > 
> > > This avoids a kernel panic when called from process 0:
> > > 
> > > [   63.087832] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000000
> > > [   63.087832]
> > > [   63.097399] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 3.18.0-rc1-00095-g8524e69 #556
> > > [   63.106060] [<c00175a4>] (unwind_backtrace) from [<c00132f0>] (show_stack+0x20/0x24)
> > > [   63.114160] [<c00132f0>] (show_stack) from [<c0657404>] (dump_stack+0x8c/0xa4)
> > > [   63.121706] [<c0657404>] (dump_stack) from [<c0654f70>] (panic+0xa0/0x220)
> > > [   63.128895] [<c0654f70>] (panic) from [<c0049e64>] (do_exit+0x974/0x9d0)
> > > [   63.135900] [<c0049e64>] (do_exit) from [<c006775c>] (SyS_reboot+0x14c/0x1e8)
> > > [   63.143361] [<c006775c>] (SyS_reboot) from [<c000f080>] (ret_fast_syscall+0x0/0x48)
> > > [   63.151596] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000000
> > > 
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > ---
> > >  arch/arm/kernel/process.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> > > index a35f6ebbd2c2..68c38af5687c 100644
> > > --- a/arch/arm/kernel/process.c
> > > +++ b/arch/arm/kernel/process.c
> > > @@ -212,6 +212,12 @@ void machine_power_off(void)
> > >  
> > >  	if (pm_power_off)
> > >  		pm_power_off();
> > > +
> > > +	/* Give a grace period for failure to power off */
> > > +	mdelay(1000);
> > > +
> > > +	pr_err("Power off failed -- system halted\n");
> > > +	while (1);
> > >  }
> > 
> > with this I always get to "Power off failed -- system halted". If I
> > switch to v3.18-rc1 vanilla, then it works. So it's definitely caused by
> > your rtc-only patches.

That's expected (see below). It works with v3.18-rc1 vanilla because
machine_halt is called instead of machine_power_off as there is no
registered power-off handler.

> ok, so it seems like it takes more than 1 second for things to
> propagate. If I increase that mdelay() to 3000, then everything works
> fine on my end. I think we should get RMK's input on this 3000ms delay
> to machine_power_off(). Should it be generic, or should we add it to our
> rtc pm_power_off implementation ?

As I wrote above, we still need a 2-second mdelay in rtc-omap, which I
intend to add to the pmic_power_en patch.

The one-second delay is there in machine_power_off to catch most cases
which wouldn't take nearly as long as rtc-omap and hence wouldn't be
adding an explicit delay in the driver power-off handler.

Johan
