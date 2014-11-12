Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaKLQ04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:26:56 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61970 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbaKLQ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:26:54 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18mC9Q0FOAb7I+0pRdmTuE7
Date: Wed, 12 Nov 2014 08:26:07 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH] mfd: twl4030-power: Fix poweroff with PM configuration
 enabled
Message-ID: <20141112162607.GI26481@atomide.com>
References: <20141102180756.GH31454@atomide.com>
 <5458D29E.50908@compulab.co.il>
 <20141104154231.GP31454@atomide.com>
 <CANOLnOP8JmROaCruC8NEwh+Nzq_-fFit-+5d_W9vU9KtNTphoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANOLnOP8JmROaCruC8NEwh+Nzq_-fFit-+5d_W9vU9KtNTphoA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grazvydas Ignotas <notasas@gmail.com> [141112 07:46]:
> On Tue, Nov 4, 2014 at 5:42 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Igor Grinberg <grinberg@compulab.co.il> [141104 05:22]:
> >> Hi Tony,
> >>
> >> On 11/02/14 20:07, Tony Lindgren wrote:
> >> > Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
> >> > configuration") enabled configuring the PM features for twl4030.
> >> >
> >> > This caused poweroff command to fail on devices that have the
> >> > BCI charger on twl4030 wired, or have power wired for VBUS.
> >> > Instead of powering off, the device reboots. This is because
> >> > voltage is detected on charger or VBUS with the default bits
> >> > enabled for the power transition registers.
> >> >
> >> > To fix the issue, let's just clear VBUS and CHG bits as we want
> >> > poweroff command to keep the system powered off.
> >>
> >> What about devices that really need to start once VBUS or CHG is connected?
> >
> > More handling can be added for some cases. With this patch the
> > poweron bits will clear to defaults if power is completely removed.
> > So start-up with VBUS and CHG works in that case.
> >
> > However, if you have a battery connected, and you poweroff, with
> > this patch the device won't power up with VBUS or CHG connected.
> >
> > Note that most battery operated devices are not using the charger
> > on twl4030 because it has issues charging a completely empty
> > battery AFAIK. So most battery powered devices have been using an
> > external USB charger chip that's not affected by this patch.
> 
> Pandora does, as well as GTA04 AFAIK, but that's not "most devices" I
> guess.. At least pandora was booting up on charger connect up until
> now. I don't know why shutdown used to work for Russell in legacy boot
> and it changed for DT, the device would always start up when there was
> AC power here.

I think Pandora should still start up fine on charger connect except
after you do a poweroff first?

And my guess is Pandora would not stay powered off earlier after you
did poweroff but would start up again immediately instead.

If something has changed with the default start up events, then
it must be some separate issue. This is because we configure the start
up events only in twl4030_power_off() when poweroff is called, so those
are not touched during the init time.

BTW, the reason why things changed for device tree based booting is
because we're now configuring the PMIC for PM features while for
legacy booting that was only done for n900.

Regards,

Tony
