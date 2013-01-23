Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3AWTHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 14:07:08 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:52272 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3AWTG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 14:06:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Wu <lekensteyn@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI / ACPI: Rework ACPI device nodes lookup for the PCI bus type
Date: Wed, 23 Jan 2013 20:12:59 +0100
Message-ID: <3268331.1fmya6KvOh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <4892526.yENRuuZvDT@al>
References: <16168955.038G1kVfN2@vostro.rjw.lan> <3156987.mALXjkBy5R@vostro.rjw.lan> <4892526.yENRuuZvDT@al>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 23, 2013 08:00:31 PM Peter Wu wrote:
> Hi,
> 
> Any progress on this one? I guess it won't make into 3.8, perhaps 3.9?

No, that doesn't go anywhere for now.

In fact, I need to discuss that with Len.

Thanks,
Rafael


> On Friday 04 January 2013 00:44:16 Rafael J. Wysocki wrote:
> > On Thursday, January 03, 2013 04:00:55 PM Bjorn Helgaas wrote:
> > > On Thu, Jan 3, 2013 at 3:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Thursday, January 03, 2013 02:44:32 PM Bjorn Helgaas wrote:
> > > >> On Thu, Jan 3, 2013 at 1:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > >> > On Thursday, January 03, 2013 08:16:26 AM Bjorn Helgaas wrote:
> > > >> >> On Fri, Dec 28, 2012 at 2:29 PM, Rafael J. Wysocki <rjw@sisk.pl> 
> wrote:
> > > >> >> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > >> >> > 
> > > >> >> > As the kernel Bugzilla report #42696 indicates, it generally is
> > > >> >> > not
> > > >> >> > sufficient to use _ADR to get an ACPI device node corresponding to
> > > >> >> > the given PCI device, because there may be multiple objects with
> > > >> >> > matching _ADR in the ACPI namespace (this probably is against the
> > > >> >> > spec, but it evidently happens in practice).
> > > >> >> 
> > > >> >> I don't see anything in sec 6.1.1 (_ADR) that precludes having
> > > >> >> multiple objects that contain the same _ADR. Do you have any other
> > > >> >> pointers?
> > > >> > 
> > > >> > Section 6.1 implicitly means that.  It says that for PCI devices _ADR
> > > >> > must be present to identify which device is represented by the given
> > > >> > ACPI node.  Next, Section 6.1.1 says that the parent bus should be
> > > >> > inferred
> > > >> > from the location of the _ADR object's device package in the ACPI
> > > >> > namespace, so clearly, if that's under the PCI root bridge ACPI
> > > >> > node, the _ADR corresponds to a PCI device's bus address.
> > > >> 
> > > >> I agree that for namespace Devices below a PCI host bridge, the _ADR
> > > >> value and its position in the hierarchy is required to be sufficient
> > > >> to identify a PCI device and function (or the set of all functions on
> > > >> a device #).
> > > >> 
> > > >> > Then, Table 6-139 specifies the format of _ADR for PCI devices as
> > > >> > being
> > > >> > euqivalent to devfn, which means that if two nodes with the same _ADR
> > > >> > are
> > > >> > present in one scope (under one parent), then it is impossible to
> > > >> > distinguish between them and that's against Section 6.1.
> > > >> 
> > > >> This is the bit I don't understand.  Where's the requirement that we
> > > >> be able to distinguish between two namespace nodes with the same _ADR?
> > > > 
> > > > According to the spec we can't (if they are under the same parent) and
> > > > that's the whole problem.
> > > 
> > > It's only a problem if you make the assumptions Linux does.  I can
> > > imagine a system with different assumptions.  For example, an OS could
> > > start with PCI device X and ask "please run any _PS0 method that
> > > matches X."  In that case, you don't care how many objects have an
> > > _ADR that matches X; you merely find *any* matching object that
> > > contains _PS0.
> > 
> > Well, except when there are multiple matching objects having _PS0.
> > Which actually happens in the failing case in bug #42696.
> > 
> > Our assumptions work pretty well on other systems and I don't quite see the
> > reason to change them entirely.
> > 
> > Moreover, Section 19.5.30 of the spec says that "Device object [...]
> > represents either a bus or a device or any other similar hardware".  That
> > implies that if there are two objects with the same _ADR matching the same
> > single devfn of a PCI device, that will mean that there are _two_ different
> > PCI devices under the same parent that have the same devfn.  In that case
> > PCI config space accesses wouldn't work for those devices, though.
> > 
> > > >> Linux assumes we can start from a PCI device and identify a single
> > > >> related ACPI namespace node, e.g., in acpi_pci_find_device().  But all
> > > >> I see in the spec is a requirement that we can start from an ACPI
> > > >> namespace node and find a PCI device.  So I'm not sure
> > > >> acpi_pci_find_device() is based on a valid assumption.
> > > > 
> > > > I think it is.
> > > > 
> > > > Suppose that we have two namespace nodes with the same _ADR under one
> > > > parent (PCI bridge ACPI node) and they both contain things like _PS0
> > > > and _PS3.  Which one of these are we supposed to use for the power
> > > > management of the corresponding PCI device?  Because they both would
> > > > point to the same device, right?
> > > 
> > > That's a good question.  It's more complicated if two objects supply
> > > the same method.
> > 
> > Well it is and they do.
> > 
> > > >> Let's say we want to provide _SUN and _UID.  _SUN is a slot number
> > > >> that may apply to several PCI functions, while _UID probably refers to
> > > >> a single PCI function.  Is it legal to provide two namespace objects,
> > > >> one with _ADR 0x0003ffff and _SUN, and another with _ADR 0x00030000
> > > >> and _UID?
> > > > 
> > > > I don't think it is valid to do that.
> > > 
> > > Is there something in the spec that says you can't?  I can imagine a
> > > BIOS writer doing that, and I don't know how I could convince him that
> > > it's illegal.
> > 
> > Well, OK.
> > 
> > > It would be really interesting to try some of these scenarios on
> > > Windows with qemu.
> > 
> > That's interesting theoretically, but doesn't directly relate to the case at
> > hand.  The case at hand is that for a given PCI device we want to find the
> > ACPI namespace node that can be used for things like power management, if
> > one exists.  While it may be valid to specify _ADR of type 0x0003ffff for
> > some namespace nodes, I don't really think it is valid to specify two
> > objects with the same _ADR matching a specific devfn that both provide the
> > same methods (like _PSx or _CRS).
> > 
> > And the question we need to answer is not "I have a namespace node, so which
> > device it represents?", but "I have a device, so which namespace node
> > provides methods I'm supposed to use for it?"
> > 
> > So I think we make the right assumptions, but there are broken BIOSes that
> > don't follow them and I'm trying to find out how to handle them without
> > blacklisting etc.
> > 
> > Questioning the validity of everything we're doing doesn't really help, mind
> > you.
> > 
> > Thanks,
> > Rafael
> 
> Regards,
> Peter
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
