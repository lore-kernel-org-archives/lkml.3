Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3BWByu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 20:54:50 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41827 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab3BWByt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 20:54:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fabio Baltieri <fabio.baltieri@linaro.org>, Dave Jones <davej@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, tianyu.lan@intel.com,
        Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Date: Sat, 23 Feb 2013 03:01:26 +0100
Message-ID: <1462615.EzCDaXtu1F@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+55aFywBFO4F+gEmq5h05VBe4unEJLh4RckJwaWPsU67bw44w@mail.gmail.com>
References: <20130222085954.GA4352@redhat.com> <1451742.5dFcotgqBW@vostro.rjw.lan> <CA+55aFywBFO4F+gEmq5h05VBe4unEJLh4RckJwaWPsU67bw44w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 05:10:43 PM Linus Torvalds wrote:
> On Fri, Feb 22, 2013 at 4:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > The problem is, though, that even if bisection turns up something, it doesn't
> > automatically mean that this particular commit is the one that caused the
> > problem to happen in the first place.
> 
> No, I agree. I just react *very* strongly when somebody starts arguing
> against reverting.
> 
> The fact that the commit that was bisected fixes another bug in a
> previous commit does in fact just imply that that *previous* commit
> should perhaps be reverted. Of course, I see that that is the first in
> the whole series, so I understand the pain, but even so..
> 
> And looking at that commit that makes power resources be treated
> specially, that looks completely bogus. It's not what the old code did
> either, and it seems to be a total hack for the breakage that just
> happens to fix that one machine for purely random reasons, as far as I
> can tell. The ACPI_BUS_TYPE_POWER case always had match=1 before, no?

It had, when it was called from acpi_bus_add_power_resource(), but that
was not the only way power resources could be added.  That function was only
called when we found a device using power resources and we needed to add them
before adding that device (if they were not present already).

The second way we could add power resources was during the normal namespace
walk and that case was broken.

> The thing that looks to have been dropped somewhere is that
> 
>   .acpi_op_start = !!context,
> 
> which first became
> 
>   device->add_type = context ? ACPI_BUS_ADD_START : ACPI_BUS_ADD_MATCH;
> 
> and then somehow that wasn't needed any more, so it became just an unconditional
> 
>   device->add_type = ACPI_BUS_ADD_START;
> 
> for unexplained reasons (the commit message says that the argument
> "context" wasn't used, and renames it not_used to reinforce the point,
> but doesn't explain why it can remove the use that was there).
> 
> That unconditional "add_type = ACPI_BUS_ADD_START" then later becomes
> "flags.match_driver = true", which is where the whole match_driver
> thing comes in.
> 
> Anyway, I don't see how magically it became about ACPI_BUS_TYPE_POWER.

If we added a power resource with acpi_add_single_object(..., false) from
acpi_bus_check_add(), later acpi_bus_add_power_resource() saw that it
was already present and didn't add it either.  The power resource was there at
that point, but it didn't have a driver (which only would be probed in the
second pass, after all ACPI devices had been registered).  The driver was
needed, though, for the initialization of the power management of devices
depending on that power resource.

The fact that it was missing caused power management of devices depending on
that power resource not to be initialized correctly and changing their power
states didn't really work going forward.

That's why the Fabio's bisection turned up that commit, BTW (the changing
of USB controllers' power states didn't really work before it on his machine).

I put ACPI_BUS_TYPE_POWER in there, because power resources always needed
'true' in the last arg of acpi_add_single_object() and they were the only type
needing it.

> The code is not exactly obvious, though, so whatever. But that
> "context is suddenly not used" commit (e3863094c6f9: "ACPI: Drop the
> second argument of acpi_bus_scan()") looks odd.
> 
> Maybe "context" was effectively always non-NULL, but it *looks* like
> that series of commits is intended to have no semantic changes, and
> that's the one that looked very dubious to me.

While I might make a mistake in it, I seriously doubt that it is the root
cause of the problem at hand.

It surely is related to PCI power management and to the fact that PCI devices
can go into D3cold at run time now.  This isn't an old change and there were
problems with it.  The known problems were fixed, but there might be more to
uncover and it looks like we've just run into a new one. :-(

So I really need to know what's going on before deciding how to fix that.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
