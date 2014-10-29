Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbaJ2Nih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:38:37 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:38274 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759AbaJ2Nif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:38:35 -0400
Date: Wed, 29 Oct 2014 14:35:26 +0100
From: Johan Hovold <johan@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Johan Hovold <johan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141029133526.GE2265@localhost>
References: <20141024194442.GG11455@saruman>
 <20141024195532.GF19377@localhost>
 <20141027162251.d7ff2a5f31917c638d4e47f7@linux-foundation.org>
 <20141028002552.GX12379@n2100.arm.linux.org.uk>
 <20141028081616.GL2006@localhost>
 <20141028084745.GY12379@n2100.arm.linux.org.uk>
 <20141028131257.GS2006@localhost>
 <20141028151610.GA12379@n2100.arm.linux.org.uk>
 <20141029123418.GB2265@localhost>
 <5450E9A8.1060506@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5450E9A8.1060506@roeck-us.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 06:20:40AM -0700, Guenter Roeck wrote:
> On 10/29/2014 05:34 AM, Johan Hovold wrote:
> > On Tue, Oct 28, 2014 at 03:16:10PM +0000, Russell King - ARM Linux wrote:
> >> On Tue, Oct 28, 2014 at 02:12:57PM +0100, Johan Hovold wrote:
> >>> That's not what I was trying to refer to. But the patch set explicitly
> >>> allows for multiple, prioritised power-off handlers, which can power
> >>> off a board in different ways and with various degrees of success.
> >>> Specifically, it allows for fallback handlers in case one or more
> >>> power-off handlers fail.
> >>>
> >>> So if we allow for that, what is to prevent the final power-off handler
> >>> from failing? And should this not be logged by arch code in the same way
> >>> as failure to restart is?
> >>
> >> And how is that different from having a set of power-off handlers, and
> >> reporting when each individual one fails?  Don't you want to know if
> >> your primary high priority reboot handler fails, just as much as you
> >> want to know if your final last-resort power-off handler fails?
> >
> > Good point. Failed power-off should probably be logged by the power-off
> > call chain implementation (which seems to makes notifier chains a bad
> > fit).
>
> Good that I just replaced notifier chain with an open coded implementation.

Good to hear.

> Sure, that is possible, but I would prefer to do that as a follow-up commit,
> and it should be discussed in the context of the power-off handler patch set.

Fine with me.

> > And what about any power-off latencies? Should this always be dealt with
> > in the power-off handler?
> >
> > Again, if it's predictable and high, as in the OMAP RTC case, it should
> > go in the handler. But what if it's just normal bus latencies
> > (peripheral busses, i2c, or whatever people may come up with)?
> >
> > Should there always be a short delay before calling the next handler?
> 
> That delay would depend on the individual power-off handler, so I think
> the current implementation works just fine (where power-off handlers
> implement the delay).

Some don't, and could possibly unknowingly have been relying on the fact
that they could return to user space and be powered off at some later
time. With systemd that would have caused a panic.

Also consider generic power-off handlers such as gpio-poweroff. It
currently hard-codes a three-second delay but the actual delay would
really be board specific.

> We could move the delay into the infrastructure, but it would have
> to be configurable. I would prefer to consider that as a follow-up patch
> to not overload the power-off handler patch set with too many changes
> at the same time.

Sure.

Johan
