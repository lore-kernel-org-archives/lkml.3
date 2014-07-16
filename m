Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaGPWWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:22:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61029 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752085AbaGPWWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:22:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Allen Yu <alleny@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add "rpm_not_supported" flag
Date: Thu, 17 Jul 2014 00:40:23 +0200
Message-ID: <1908592.0t6juNfLFj@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1407021002380.874-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1407021002380.874-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That took me much more time than I had hoped, sorry about that.

On Wednesday, July 02, 2014 10:27:06 AM Alan Stern wrote:
> On Wed, 2 Jul 2014, Rafael J. Wysocki wrote:
> 
> > > Then you have no other objections to the patch?
> > 
> > My concern still is that it will be confusing, because people won't read the
> > documentation carefully enough and will confuse "runtime PM never used" with
> > "hardware can't do PM".  I'm not sure how to make that more clear, though.
> 
> I could emphasize that distinction a little more strongly in the 
> documentation.

So it looks like we'd like to cover the "enabled but always active" case for
runtime PM of a device?

> > Also we have the no_callbacks flag and I wonder if/how it is related to the
> > new one.  Do we still need both?
> 
> They mean different things.  The no_callbacks flag is used when we want 
> the PM core to think the device can be in RPM_SUSPENDED at times (it is 
> "logically suspended").  rpm_not_supported is used when we want the PM 
> core to think the device must always be in RPM_ACTIVE.
> 
> > In addition to that, I think that "hardware can't do PM" should apply to the
> > handling of system suspend resume too.
> 
> Maybe.  For the use case Dan Williams and I are working on, it doesn't 
> matter; for other cases it might matter.  That's why I named the flag 
> "rpm_not_supported" -- it applies specifically to runtime PM, not 
> system PM.

Maybe it'd be better to call the flag always_active and make rpm_suspend()
and rpm_resume() react to it accordingly?

So before enabling runtime PM the driver will set always_active and that will
mean the device cannot be suspended.  And we could add a separate sysfs
attribute for that instead of re-purposing the status thing, if needed
(I'm not sure about that, however).

> Here's a brief summary of the story behind this patch...
> 
> At one point, I suggested to Dan that instead of doing something
> special for these devices, we could simply have the runtime_suspend()
> routine always return -EBUSY.  He didn't like that idea because then
> the user would see the device was never powering down but would have no
> idea why.  The rpm_not_supported flag provides this information to the
> user by causing the power/runtime_status attribute to say "not
> supported".  (Although to be entirely fair, we could just put a message
> in the kernel log during probe if the hardware doesn't support runtime
> suspend.)
> 
> Instead, Dan introduced a messy PM QoS mechanism in commit
> e3d105055525.  I didn't like that approach, but Greg merged it before I
> objected.

That really looks a bit like a hack to me to be honest.

Greg, what's your plan toward this?

> Do you have any suggestions?

We could use an "always_active" type of flag for that, but I'm not sure how
much value to the user that will bring.

Rafael

