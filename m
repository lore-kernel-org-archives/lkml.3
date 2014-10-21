Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaJUQLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:11:15 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:50002 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbaJUQLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:11:10 -0400
Date: Tue, 21 Oct 2014 09:11:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= 
	<philippe.retornaz@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call
 chain
Message-ID: <20141021161104.GB3453@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <41603148.RJg26vx0Wv@vostro.rjw.lan>
 <54465CD5.5070002@roeck-us.net>
 <2369971.tIcht5GPeB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2369971.tIcht5GPeB@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.5446859E.01B3,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:15:11PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, October 21, 2014 06:17:09 AM Guenter Roeck wrote:
> > On 10/21/2014 05:26 AM, Rafael J. Wysocki wrote:
> > > On Monday, October 20, 2014 09:12:17 PM Guenter Roeck wrote:
> > >> Various drivers implement architecture and/or device specific means to
> > >> remove power from the system.  For the most part, those drivers set the
> > >> global variable pm_power_off to point to a function within the driver.
> > >>
> > >> This mechanism has a number of drawbacks.  Typically only one scheme
> > >> to remove power is supported (at least if pm_power_off is used).
> > >> At least in theory there can be multiple means remove power, some of
> > >> which may be less desirable. For example, some mechanisms may only
> > >> power off the CPU or the CPU card, while another may power off the
> > >> entire system.  Others may really just execute a restart sequence
> > >> or drop into the ROM monitor. Using pm_power_off can also be racy
> > >> if the function pointer is set from a driver built as module, as the
> > >> driver may be in the process of being unloaded when pm_power_off is
> > >> called. If there are multiple poweroff handlers in the system, removing
> > >> a module with such a handler may inadvertently reset the pointer to
> > >> pm_power_off to NULL, leaving the system with no means to remove power.
> > >>
> > >> Introduce a system poweroff handler call chain to solve the described
> > >> problems.  This call chain is expected to be executed from the
> > >> architecture specific machine_power_off() function.  Drivers providing
> > >> system poweroff functionality are expected to register with this call chain.
> > >> By using the priority field in the notifier block, callers can control
> > >> poweroff handler execution sequence and thus ensure that the poweroff
> > >> handler with the optimal capabilities to remove power for a given system
> > >> is called first.
> > >
> > > Well, I must admit to having second thoughts regarding this particular
> > > mechanism.  Namely, notifiers don't seem to be the best way of expressing
> > > what's needed from the design standpoint.
> > >
> > > It looks like we need a list of power off methods and a way to select one
> > > of them, so it seems that using a plist would be a natural choice here?
> > >
> > Isn't a notifier call chain nothing but a list of methods, with its priority
> > the means to select which one to use (first) ?
> 
> Traditionally, the idea behind notifier call chains has been to call all of the
> supplied methods (meaning whoever supplied them wants to be notified of events)
> where the higher-priority ones are called first.
> 
> In this particular case, though, we call them until one succeeds to power
> off the system it seems.
> 
> > The only difference I can see is that you would only select one of them,
> > meaning the one with the highest priority, and not try the others.
> 
> Yes, this was my thought.
> 
> But if you want a fallback mechanism, then I agree that using notifiers makes
> sense, although it is not exactly about notifications this time.
> 
It is the same machanism we are using for the newly introduced restart handler,
with the same logic. Notifiers come handy, because the infrastructure is already
there, but I consider that to be more of an implementation detail. It is useful
in many cases, though, since the notifier_block can be part of a local data
structure which can be referenced from the callback using container_of.

If I don't use notifiers, and the callback function doesn't get a reference to
its control block, I don't get that reference, and another means to pass context
data into the notifier function would be necessary - either a static variable,
as widely used so far, or another parameter. While the current code of course
permits the use of a static variable, I very much like that it is possible to
avoid that by using notifiers.

> I would probably use something along the lines of syscore_ops, but with added
> execution priority.

But wouldn't that mean to, for all practical purposes, re-implement a notifier
call chain in syscore just for the purpose of naming it differently ?

>From a practical side, it would also be a bit awkward since syscore_ops are
typically not installed from the same file as the poweroff handler. So I would
either have to rearrange code significantly, or install two sysore_ops handlers
for the same architecture / platform. Hope it would be ok to do the latter; if
the first approach is asked for, I'd rather only implement the core code and not
do the full conversion, as it would add more risk than I think it adds value.

Guenter
