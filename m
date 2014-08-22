Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbaHVReo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:34:44 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54385 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932410AbaHVRel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:34:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] ACPI / scan: Allow ACPI drivers to bind to PNP device objects
Date: Fri, 22 Aug 2014 19:53:42 +0200
Message-ID: <3770704.uNPCcL4EDK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408672831.3315.35.camel@rzhang1-toshiba>
References: <5487060.QsgluucUH4@vostro.rjw.lan> <2188871.Tr0Kbz91aK@vostro.rjw.lan> <1408672831.3315.35.camel@rzhang1-toshiba>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 22, 2014 10:00:31 AM Zhang Rui wrote:
> On Thu, 2014-08-21 at 19:10 +0200, Rafael J. Wysocki wrote:
> > On Thursday, August 21, 2014 08:08:54 PM Zhang Rui wrote:
> > > Hi, Rafael,
> > > 
> > > On Thu, 2014-08-21 at 06:04 +0200, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > [cut]
> > 
> > > Note that I've just tested on my machine and it works well.
> > > I still need the bug reporter to check if the patch fixes bug 81511 or not.
> > 
> > The FUJ02B1 and FUJ02E3 devices in bug 81971 have the same problem and
> > they aren't motherboard devices.
> 
> Right, but IMO, the rootcause of that bug is that
> 1. the PNP id table in fujitsu-laptop driver was introduced for some
> reason, probably it is used as an indicator for module auto-loading, and
> nowadays, this is redundant because fujitsu-laptop driver probes ACPI
> device only, and the driver will be loaded if the ACPI device objects
> for FUJ02B1 and FUJ02E3 is created.

We may be able to drop the Fujitsu devices from the ACPI PNP list and all may
work.  Still, does that fix all of the potential problems?

> 2. This "redundant" PNP id table results in that those IDs are added to
> PNP ID list unnecessarily, and results in PNP device nodes for those
> devices are created unnecessarily.

Yes, that may be the case, but the way to deal with that is not to break
thing and then see what's broken and fix it, but to get rid of ACPI drivers
one by one in which case we can control what's been changed and why.

> >   Yes, we need to convert that driver
> > to use a PNP driver structure or a platform device, but (1) we need a
> > -stable fix *first*
> 
> I agree.
> 
> >  and (2) the cases we already know about may not be
> > the only broken ones.
> 
> Agree.
> But the issue addressed in your patch is that PNP scan handler blocks
> ACPI driver from being probed, right?

Yes.

> So my question would be,
> 1. If the id in PNP scan handler does not have a PNP driver, like the
>    FUJ02B1/FUJ02E3 issue, what do we need the id in PNP scan handler?
>    In fact, I think this is a good chance for us to cleanup the ACPI PNP
>    id list, as long as we can fix them in time.

No.

We need -stable to work and there's no way I will mark the motherboard
resource changes for -stable.  Second, if we deal with it as I said (that is,
get rid of ACPI drivers gradually), we will clean up that list in the process
without breaking things for people in random ways.

> 2. If the id in PNP scan handler has a PNP driver, should we allow both
>    PNP driver and ACPI driver loaded? I think PNP system driver is the
>    only case that makes us have to say yes, and what I'm trying to do
>    is to fix this in the following patch.
> 
> Plus, IMO, your patch only fixes the PNP bus vs. ACPI bus issue. We
> still may get bug report complaining some *PLATFORM* driver stops to
> functional if the ACPI node has _CID PNP0C01/PNP0C02, sooner or later.
> right?

No.

We never allowed ACPI drivers to bind to ACPI device objects having platform
device companions, wherease we *did* allow that for ACPI device objects having
PNP device companions.  We simply need to go back to what we were doing and fix
things *on* *top* of that.

Any other approach pretty much guarantees leaving breakage in random places.

So I'm fine with cleaning up the PNP list *if* you convert the drivers in
question from ACPI drivers to something else (platform drivers preferably)
at the same time.

Rafael

