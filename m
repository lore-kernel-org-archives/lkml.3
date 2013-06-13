Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab3FMWD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:03:56 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36608 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798Ab3FMWDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:03:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 0/5] ACPI / scan: Make it possible to use the container hotplug with other scan handlers
Date: Fri, 14 Jun 2013 00:13:06 +0200
Message-ID: <1461809.TyKCjmiDDv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371158939.21540.39.camel@misato.fc.hp.com>
References: <1417592.vuSG0cUIGo@vostro.rjw.lan> <1371158939.21540.39.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 13, 2013 03:28:59 PM Toshi Kani wrote:
> On Thu, 2013-06-13 at 01:23 +0200, Rafael J. Wysocki wrote:
> > Hi All,
> > 
> > It turns out that some BIOSes add container device IDs as _CIDs to device
> > object that in principle may be matched against the other scan handlers (or
> > ACPI drivers, but that's not a problem, because the container scan handler
> > can co-exist with an ACPI driver).  That's why our recent fix for an issue
> > related to the ACPI video driver had to be reverted right before -rc5.
> 
> I am familiar with this firmware, although I no longer have access to
> the systems.  An SBA device object has _HID with an HP-specific PNPID
> and _CID with a generic container PNPID.  The _HID allows an OS with the
> HP SBA driver (which recognizes the _HID) to enable the SBA's I/O TLB
> functionality, while the _CID allows an OS without the HP SBA driver to
> boot-up by treating this SBA as a container.  The _CID is needed because
> some OS skips scanning underneath when it finds an unrecognized object.

How cute.

> > Although I submitted an alternative fix for that bug, I think the problem
> > with the container scan handler possibly matching devices already having
> > some other scan handlers attached needs addressing, because we may need to
> > use the container hotplug profile for those devices.  The following patch
> > series is supposed to address it.
> 
> When the HP SBA driver is bound to the SBA object, this driver needs to
> handle a hotplug request when it is supported.  This is because the I/O
> TLB functionality requires its hot-delete operation as well.  The
> container scan handler can be used only when this driver is bound to the
> SBA object as a container and therefore its I/O TLB functionality is not
> used. 

Ah, so in fact those device IDs are kind of mutually exclusive?  That is,
we only should use the _CID if we don't use the _HID, right?

We have a bug there, then, but it probably is bening enough for 3.10 to be left
as is.

> > [1/5] ACPI / scan: Do not bind ACPI drivers to objects with scan handlers
> >    (this version shouldn't break the Tony's IA64 HP box the previous one broke)
> > [2/5] ACPI / scan: Separate hotplug profiles from scan handlers
> > [3/5] ACPI / scan: Add hotplug profile pointer to struct acpi_device
> > [4/5] ACPI / scan: Use container hotplug profile for matching device objects
> > [5/5] ACPI / ia64 / sba_iommu: Use ACPI scan handler for discovery
> > 
> > Patches [1-4/5] were run on my Toshiba test box and didn't break it, but it
> > really doesn't do any ACPI hotplug notifications.
> > 
> > Patch [5/5] is kind of additional, but it wouldn't work correctly without the
> > previous ones (to be honest, I haven't tried to compile it yet, but here it
> > goes for completness).
> 
> I think we only need patch [5/5] to address the problem.  We have
> enhanced the match function of scan handlers to match a proper driver
> with respect to their priority order, i.e. matching with _HID first and
> then with _CIDs.  Patch [5/5] should assure that the HP SBA driver is
> bound to an SBA object when this driver is configured to the kernel.

OK, but then I'd like to apply a modified version of [1/5] that won't
check if the scan handler is the container handler, but will just return
-EINVAL if any scan handler has been set already.  And the changelog of
[5/5] needs to be modified slightly.

Tony promised me to test those patches on his box, so we'll know for sure
in a while.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
