Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbaICP51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:57:27 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41067 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743AbaICP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:57:26 -0400
Date: Wed, 3 Sep 2014 08:57:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] x86, lpc, Allow only one load of lpc_ich
Message-ID: <20140903155718.GA26776@roeck-us.net>
References: <1409695097-5831-1-git-send-email-prarit@redhat.com>
 <20140903074315.GB28985@lee--X1>
 <5406E9B0.101@redhat.com>
 <20140903113535.GE28985@lee--X1>
 <540701B5.3020409@redhat.com>
 <20140903121941.GF28985@lee--X1>
 <54070842.2000700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54070842.2000700@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 08:23:30AM -0400, Prarit Bhargava wrote:
> 
> 
> On 09/03/2014 08:19 AM, Lee Jones wrote:
> > On Wed, 03 Sep 2014, Prarit Bhargava wrote:
> >> On 09/03/2014 07:35 AM, Lee Jones wrote:
> >>>>>> This occurs because there are two LPC devices on the system:
> >>>>>>
> >>>>>> 00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface Controller
> >>>>>> 80:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface Controller
> >>>>>>
> >>>>>> which AFAICT is a hardware configuration error that can be resolved in
> >>>>>> firmware by hiding the second LPC device.  Having two of these results in
> >>>>>> two GPIO mappings and two Watchdog Timers which doesn't make much sense.
> >>>>>>
> >>>>>> An end user has no idea what the splats mean.  We should inform the user that
> >>>>>> the issue lies with the hardware and that they should contact their vendor
> >>>>>> for resolution.
> >>>>>
> >>>>> Why is it a problem for 2 of these devices to exist on a single system?
> >>>>>
> >>>>> Shouldn't the driver just be able to handle 2 devices?
> >>>>>
> >>
> >>>>
> >>>> You end up with two watchdogs on the same system (and more confusingly they use
> >>>> the same global interface).  Additionally you end up with two sets of GPIOs
> >>>> which also use the same global interface ... not good.
> >>>
> >>> I understand the problem with the _driver_, but why is it a problem
> >>> that two of these _devices_ exist on one system?  Bailing out of the
> >>> second .probe() sounds hacky to me.  The driver should know that this
> >>> is possible and act accordingly, or the second devices shouldn't be
> >>> registered.
> >>>
> >>> Can these devices be controlled seperately?  
> >>
> >> Let's just try and address this for now ... They can be controlled separately
> >> but that's not the issue here.
> >>
> >> Consider just the watchdog timer (because it is easier to explain).  The way the
> >> watchdog timer works is that we write to it every 30 seconds (or so ... it
> >> depends on your setup obviously).  If we don't write to it within 30 seconds the
> >> system will panic and reboot.
> >>
> >> Now ... suppose you have two on a system.  To what end? It doesn't make sense to
> >> have two.  Either you can write from userspace or you can't.  Now you have two
> >> running with different timeouts -- why?  That doesn't make sense either.  It
> > 
> > You only have 2 running if you start them both.
> > 
> >> isn't like the one with the longer timeout is ever going to cause a reboot.
> >>
> >> Does that explain things better?  It's a not a real-world scenario.
> > 
> > On the h/w I'm currently working on, we have 3 Watchdogs.
> 
> "3": what are they?  Are they all system-level watchdogs?  I can understand the
> BMC having a watchdog, the system HW having a watchdog (which is what we're
> talking about here), and I'm sure we can think of other watchdogs ... but two
> that are EXACTLY the same?
> 
> > 
> >> You also asked ...
> >>
> >>> Then why do they [have two devices specified]?
> >>
> >> Because the vendor didn't/forgot to hide one from the kernel in BIOS -- hence
> >> FW_BUG.
> > 
> > If only one is useful, why have the second one in the first place?
> 
> That's just it -- it shouldn't have been exposed (again, according to Intel).
> 
> > 
> > If the devices are present and we can see them, why not have 2?  Some
> > users might find a use for them.
> 
> No one will.
> 
Really ? I must be the "no one" then.

If available, I like using two watchdogs: One to be controlled by, say, systemd,
one to be controlled by the watchdog daemon. If I have three, I might find use
for it as well: One more to be controlled by whatever application is running
on the system.

Sure, that may be considered overkill, but declaring that "no one will use them"
if more than one watchdog is available is just not correct. After all, there was
a _reason_ for introducing the capability to support more than one watchdog into
the watchdog subsystem.

Similar, if there are multiple LPCs with separate GPIO pins on each in the
system, I don't entirely understand why the GPIO pins on the second chip
would or should be declared to be unusable. Why ?

Guenter
