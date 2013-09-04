Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761818Ab3IDXYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:24:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57921 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761378Ab3IDXYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:24:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 25/30] ACPI / hotplug / PCI: Check for new devices on enabled slots
Date: Thu, 05 Sep 2013 01:35:05 +0200
Message-ID: <16239518.dJxs4RVK1M@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378336334.3246.158.camel@ul30vt.home>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <2449715.ReJj2CQeDS@vostro.rjw.lan> <1378336334.3246.158.camel@ul30vt.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 04, 2013 05:12:14 PM Alex Williamson wrote:
> On Thu, 2013-09-05 at 00:54 +0200, Rafael J. Wysocki wrote:
> > On Wednesday, September 04, 2013 02:36:34 PM Alex Williamson wrote:
> > > On Thu, 2013-07-18 at 01:32 +0200, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > 
> > > > The current implementation of acpiphp_check_bridge() is pretty dumb:
> > > >  - It enables a slot if it's not enabled and the slot status is
> > > >    ACPI_STA_ALL.
> > > >  - It disables a slot if it's enabled and the slot status is not
> > > >    ACPI_STA_ALL.
> > > > 
> > > > This behavior is not sufficient to handle the Thunderbolt daisy
> > > > chaining case properly, however, because in that case the bus
> > > > behind the already enabled slot needs to be rescanned for new
> > > > devices.
> > > > 
> > > > For this reason, modify acpiphp_check_bridge() so that slots are
> > > > disabled and stopped if they are not in the ACPI_STA_ALL state.
> > > > 
> > > > For slots in the ACPI_STA_ALL state, devices behind them that don't
> > > > respond are trimmed using a new function, trim_stale_devices(),
> > > > introduced specifically for this purpose.  That function walks
> > > > the given bus and checks each device on it.  If the device doesn't
> > > > respond, it is assumed to be gone and is removed.
> > > > 
> > > > Once all of the stale devices directy behind the slot have been
> > > > removed, acpiphp_check_bridge() will start looking for new devices
> > > > that might have appeared on the given bus.  It will do that even if
> > > > the slot is already enabled (SLOT_ENABLED is set for it).
> > > > 
> > > > In addition to that, make the bus check notification ignore
> > > > SLOT_ENABLED and go for enable_device() directly if bridge is NULL,
> > > > so that devices behind the slot are re-enumerated in that case too.
> > > > 
> > > > This change is based on earlier patches from Kirill A Shutemov
> > > > and Mika Westerberg.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > ---
> > > 
> > > FYI, git bisect landed on this patch as the cause of my serial console
> > > dying on current upstream.  Further debugging to come...  Thanks,
> > 
> > Well, sorry about that.
> > 
> > What exactly do you mean by "dying"?
> 
> Sorry, I was hoping to have more details quickly, but it's been a pain
> to debug.  By dying I mean serial console output suddenly stops during
> kernel boot and nothing more comes out of it until after the system is
> rebooted.  The problem happens when acpiphp_check_bridge() calls
> enable_slot().  The serial console dies somewhere down in
> acpiphp_bus_trim().  I think this is happening on the 00:1f ISA bridge,
> so there's a good chance the serial ports are described as somewhere
> under there.

Can you please check if that is the acpiphp_bus_trim() called by
acpiphp_bus_add() or the other one called from trim_stale_devices()?

Just add a dump_stack() or WARN_ON(1) to trim_stale_devices() next to
the acpiphp_bus_trim() call and see if that triggers.  I *think* it's the one
in acpiphp_bus_add(), but it won't hurt to verify that.

Thanks,
Rafael

