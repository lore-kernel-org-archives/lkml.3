Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3CNRJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:09:27 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42802 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab3CNRJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:09:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [Update 4][PATCH 2/7] ACPI / scan: Introduce common code for ACPI-based device hotplug
Date: Thu, 14 Mar 2013 18:16:30 +0100
Message-ID: <3390139.KZuRkSrE4e@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130304131023.GA4561@dhcp-192-168-178-175.profitbricks.localdomain>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <18666371.hyHAvqrdQ6@vostro.rjw.lan> <20130304131023.GA4561@dhcp-192-168-178-175.profitbricks.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the sluggish response, I've been travelling recently. ->

On Monday, March 04, 2013 02:10:23 PM Vasilis Liaskovitis wrote:
> Hi,
> 
> On Tue, Feb 26, 2013 at 12:39:50AM +0100, Rafael J. Wysocki wrote:
> > On Monday, February 25, 2013 11:07:52 AM Toshi Kani wrote:
> > > On Sat, 2013-02-23 at 22:38 +0000, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > Multiple drivers handling hotplug-capable ACPI device nodes install
> > > > notify handlers covering the same types of events in a very similar
> > > > way.  Moreover, those handlers are installed in separate namespace
> > > > walks, although that really should be done during namespace scans
> > > > carried out by acpi_bus_scan().  This leads to substantial code
> > > > duplication, unnecessary overhead and behavior that is hard to
> > > > follow.
> > > > 
> > > > For this reason, introduce common code in drivers/acpi/scan.c for
> > > > handling hotplug-related notification and carrying out device
> > > > insertion and eject operations in a generic fashion, such that it
> > > > may be used by all of the relevant drivers in the future.  To cover
> > > > the existing differences between those drivers introduce struct
> > > > acpi_hotplug_profile for representing collections of hotplug
> > > > settings associated with different ACPI scan handlers that can be
> > > > used by the drivers to make the common code reflect their current
> > > > behavior.
> [...]
> > That's correct, but I don't know what the user space expectations are
> > currently.
> > 
> > > So, I'd suggest the following changes.
> > >  - Remove the "uevents" attribute.  KOBJ_ONLINE/OFFLINE are not used for
> > > ACPI device objects.
> > >  - Make the !autoeject case as an exception for now, and emit
> > > KOBJ_OFFLINE as a way to request off-lining to user.  This uevent is
> > > tied with the !autoeject case.  We can then revisit if this use-case
> > > needs to be supported going forward.  If so, we may want to consider a
> > > different event type.
> > 
> > Well, what about avoiding to expose uevents and autoeject for now and
> > exposing enabled only?  Drivers would still be able to set the other flags on
> > init on init to enforce the backwards-compatible behavior.
> 
> Now that we don't define uevents and autoeject in v2 of this series, could you
> explain how we get safe ejection from userspace e.g. for memory hot-remove? What
> are the other flags drivers can use (on init?) to avoid autoeject and only issue
> KOBJ_OFFLINE?
> 
> > 
> > I agree that it would be sufficient to use one additional flag then, to start
> > with, but its meaning would be something like "keep backwards compatibility
> > with the old container driver", so perhaps "autoeject" is not a good name.
> > 
> > What about "user_eject" (that won't be exposed to user space) instead?  Where,
> > if set, it would meand "do not autoeject and emit KOBJ_OFFLINE/ONLINE uevents
> > like the old container driver did"?
> 
> I don't see user_eject in v2. Is it unnecessary for userspace ejection control
> or planned for later? Also why shouldn't it be exposed to userpace?

-> At this point we are not sure if it is necessary to have an attribute for
direct ejection control.  Since the plan is to have a separate offline/online
attribute anyway (and a check preventing us from ejecting things that haven't
been put offline), it is not clear how useful it is going to be to control
ejection directly from user space.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
