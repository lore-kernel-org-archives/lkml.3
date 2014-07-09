Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaGILsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:48:46 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23773 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaGILso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:48:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ihmXUSp7y/z7b8Size1xZ
Date: Wed, 9 Jul 2014 04:48:38 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mika.westerberg@linux.intel.com
Subject: Re: [RFC PATCH 3/4] tty: serial: 8250 core: add runtime pm
Message-ID: <20140709114837.GU28884@atomide.com>
References: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de>
 <1404491651-1388-3-git-send-email-bigeasy@linutronix.de>
 <20140707142056.46f61cf9@alan.etchedpixels.co.uk>
 <20140709111705.GR28884@atomide.com>
 <53BD291D.3040307@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD291D.3040307@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140709 04:38]:
> On 07/09/2014 01:17 PM, Tony Lindgren wrote:
> > * One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> [140707 06:22]:
> >> On Fri,  4 Jul 2014 18:34:10 +0200
> >> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> >>
> >>> While comparing the OMAP-serial and the 8250 part of this I noticed that
> >>> the the latter does not use runtime-pm.
> >>
> >> Yes it does, but 8250 parts (generally - omap presumably is special
> >> here ?) need to be powered on to transmit/receive not just for register
> >> access. The core uart layer implements a "pm" operation for this.
> > 
> > At least for omaps the UARTs need to be idled for the SoC to
> > hit off-idle where the SoC is powered off and rebooted during
> > idle.
> >
> > So we can certainly enable this in a generic way, however, this
> > can only be done under the following conditions:

Sorry forgot to mention why I think this can now be done in a
generic way, that's because we have now runtime PM in Linux.

> > 1. We can save and restore the serial register context and detect
> >    when context was lost in the serial driver. The context loss
> >    can be detected by looking at some registers that are only
> >    initialized during init.
> 
> A register check on restore context? DLL+DLH might be a good hint here
> since its value should be >0 in the running case.

OK yeah that would be a generic way to do it potentially ;)

Note that all the context_loss_cnt stuff in omap-serial.c can
then be ignored, that's still only needed for the omap3 legacy
mode booting case and won't be needed much longer.

> > 2. There's a way for the serial RX pin to wake the SoC. On some
> >    omaps there's a separate pin specific wake-up interrupt that
> >    can be used for that.
> 
> That one would be handled by omap separately.

OK great.
 
> > 3. The serial PM features must be only enabled if requested by
> >    the user via sysfs. Typically extra latency and loss of the
> >    first RX character occur which is not acceptable to most
> >    applications.
> 
> Unless I'm mistaken the omap driver now initializes the timeout to -1.
> So nothing happens unless this is enabled separately.

Yes that's the only safe approach so the serial port behaves in
the standard Linux way unless specifically requested by the
user.

Regards,

Tony
