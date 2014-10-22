Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbaJVKxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:53:17 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:54959 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458AbaJVKxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:53:14 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 22 Oct 2014 12:50:11 +0200
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
Subject: Re: [PATCH 08/12] rtc: omap: restore irq state after reading TC
 registers
Message-ID: <20141022105011.GN2113@localhost>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-9-git-send-email-johan@kernel.org>
 <20141010180225.GT31348@saruman>
 <20141011101201.GC18988@localhost>
 <20141012004758.GB21128@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012004758.GB21128@saruman>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 07:47:58PM -0500, Felipe Balbi wrote:
> On Sat, Oct 11, 2014 at 12:12:01PM +0200, Johan Hovold wrote:
> > On Fri, Oct 10, 2014 at 01:02:31PM -0500, Felipe Balbi wrote:
> > > Hi,
> > > 
> > > On Thu, Oct 09, 2014 at 09:06:30PM +0200, Johan Hovold wrote:
> > > > Make sure to restore local irq state when reading the timer/calendar
> > > > (TC) registers, so that omap_rtc_read_time() can be called with
> > > > interrupts disabled.
> > > > 
> > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > > ---
> > > >  drivers/rtc/rtc-omap.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> > > > index 0ef016553a97..62e2e9a9887a 100644
> > > > --- a/drivers/rtc/rtc-omap.c
> > > > +++ b/drivers/rtc/rtc-omap.c
> > > > @@ -239,8 +239,10 @@ static void bcd2tm(struct rtc_time *tm)
> > > >  
> > > >  static int omap_rtc_read_time(struct device *dev, struct rtc_time *tm)
> > > >  {
> > > > +	unsigned long flags;
> > > > +
> > > >  	/* we don't report wday/yday/isdst ... */
> > > > -	local_irq_disable();
> > > > +	local_irq_save(flags);
> > > 
> > > you should really convert these to a real spin_lock_irq*(), that's
> > > because local_irq* do not get re-written with RT patchset, so this
> > > pretty much "breaks" RT.
> > 
> > The driver uses local_irq* throughout to guarantee registers are not
> > read or written during an update event.
> > 
> > In fact, at least on AM33xx, this is not even necessary when reading (as
> > opposed to writing) the TC registers, but I did not dare change that
> > without knowing how the legacy platforms work in this respect.
> > 
> > Do you suggest doing this conversion as part of, or on top of, this
> > series?
> 
> probably on top of is. Safer that way.

I didn't include this conversion in v2 as you may have noticed. In fact,
I'm not even sure it should be done.

Using local_irq* "breaks" RT, but if we change it to spin_lock_irq* and
RT preempts us, we may miss the 15us access window which would break the
driver:

	"If the ARM accesses the TC registers outside of the access
	 period, then the access is not guaranteed."

On am33xx this only affects updating the TC (timer/calendar) or alarm
registers, but the driver currently disables interrupts also on reading
the time (possibly because the early IP revisions did not have the
shadow read registers).

Johan
