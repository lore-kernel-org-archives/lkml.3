Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab3KSX3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:29:53 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61087 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753448Ab3KSX3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:29:50 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] ACPI / hotplug: Fix PCI host bridge hot removal
Date: Wed, 20 Nov 2013 00:42:28 +0100
Message-ID: <3445730.IkUyvGUQQp@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1384898320.1791.48.camel@misato.fc.hp.com>
References: <2434673.zhjYZOTQ4A@vostro.rjw.lan> <4037930.5v7ysfShLb@vostro.rjw.lan> <1384898320.1791.48.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 19, 2013 02:58:40 PM Toshi Kani wrote:
> On Tue, 2013-11-19 at 22:10 +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, November 19, 2013 10:48:51 AM Toshi Kani wrote:
> > > > On Mon, 2013-11-18 at 22:39 +0100, Rafael J. Wysocki wrote:
> > > > > On Monday, November 18, 2013 11:10:05 AM Toshi Kani wrote:
> > > > > > On Thu, 2013-11-14 at 00:16 +0100, Rafael J. Wysocki wrote:
> > > > > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > > > 
> > > > > > > Since the PCI host bridge scan handler does not set hotplug.enabled,
> > > > > > > the check of it in acpi_bus_device_eject() effectively prevents the
> > > > > > > root bridge hot removal from working after commit a3b1b1ef78cd
> > > > > > > (ACPI / hotplug: Merge device hot-removal routines).  However, that
> > > > > > > check is not necessary, because the other acpi_bus_device_eject()
> > > > > > > users, acpi_hotplug_notify_cb and acpi_eject_store(), do the same
> > > > > > > check by themselves before executing that function.
> > > > > > > 
> > > > > > > For this reason, remove the scan handler check from
> > > > > > > acpi_bus_device_eject() to make PCI hot bridge hot removal work
> > > > > > > again.
> > > > > > 
> > > > > > I am curious why the PCI host bridge scan handler does not set
> > > > > > hotplug.enabled.  Is this how it disables hotplug via sysfs eject but
> > > > > > enables via ACPI notification?
> > > > > 
> > > > > It just doesn't register for hotplug at all.  I guess it could set that
> > > > > bit alone, but then it would be quite confusing and the check is not
> > > > > necessary anyway.
> > > > 
> > > > I see.  Given how the PCI host bridge scan handler is integrated today,
> > > > the change looks reasonable to me.
> > > 
> > > Looking further, I noticed that there is one more issue to address.  The
> > > patch below applies on top of your patchset.
> > >
> > > From: Toshi Kani <toshi.kani@hp.com>
> > > Subject: [PATCH] ACPI / hotplug: Fix conflicted PCI bridge notify
> > > handlers
> > > 
> > > The PCI host bridge scan handler installs its own notify handler,
> > > handle_hotplug_event_root(), by itself.  Nevertheless, the ACPI
> > > hotplug framework also installs the common notify handler,
> > > acpi_hotplug_notify_cb(), for PCI root bridges.  This causes
> > > acpi_hotplug_notify_cb() to call _OST method with unsupported
> > > error as hotplug.enabled is not set.
> > > 
> > > To address this issue, introduce hotplug.self_install flag, which
> > > indicates that the scan handler installs its own notify handler by
> > > itself.  The ACPI hotplug framework does not install the common
> > > notify handler when this flag is set.
> > 
> > Good catch!
> > 
> > Still, I don't think we need a new flag, because we know that that
> > scan handler doesn't support hotplug, because its hotplug profile
> > hasn't been registered (that actually applies to all scan handlers
> > without hotplug support, not only the root host bridge).  
> 
> When a scan handler does not support hotplug at all, the common notify
> handler should be installed so that it can call _OST with an appropriate
> response.

That creates an arbitrary difference between devices that have scan handlers
and devices that don't have them (PCI, USB, SATA etc).  So if we want _OST
to be called for all devices for which hotplug is not supported, that
should be implemented in a different way and not necessarily in 3.13.

> > Moreover,
> > if it does support hotplug, but the hotplug profile hasn't been
> > registered due to an error, we still should not install the notify
> > handler I think.  
> 
> This case, I think the common notify handler should be installed so that
> it can call _OST for error response as well.  The question is what to do
> when a scan handler has its own notify handler.

Well, to be precise, in the case of the PCI host bridge the notify handler is
installed via a separate init routine that doesn't belong to the scan handler.

Semantics aside, my original intention was not to install notify handlers for
all devices with scan handlers, but only for those whose scan handlers support
hotplug, because the default for all devices without hotplug support is to
avoid installing any notify handlers at all.

> > So, I prefer the patch below.
> >
> > And this fix will remain useful after my recent series at
> > http://marc.info/?l=linux-pci&m=138470560909690&w=4
> 
> I agree that the PCI host bridge scan handler should use the common
> notify handler, and your change is on the right direction.  But as I
> understand, this patchset is for 3.14.  For 3.13, I thought we have to
> live with the separate PCI root notify handler, and this patch avoids
> the conflict for the time being.  If necessary, the new flag can be
> removed in 3.14.

Well, it could, but then the current behavior is not intentional as I
said and obviously buggy for PCI host bridges.  So in my opinion we
should bring things back to the way they were *intended* to behave in the
first place.  If that causes problems to happen for someone, we can still
special case the PCI host bridge, but I'd prefer to avoid that if possible.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
