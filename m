Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab3IDXMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:12:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab3IDXMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:12:23 -0400
Message-ID: <1378336334.3246.158.camel@ul30vt.home>
Subject: Re: [PATCH 25/30] ACPI / hotplug / PCI: Check for new devices on
 enabled slots
From: Alex Williamson <alex.williamson@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Wed, 04 Sep 2013 17:12:14 -0600
In-Reply-To: <2449715.ReJj2CQeDS@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
	 <1818424.8fNkf5pBy3@vostro.rjw.lan> <1378326994.3246.152.camel@ul30vt.home>
	 <2449715.ReJj2CQeDS@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-05 at 00:54 +0200, Rafael J. Wysocki wrote:
> On Wednesday, September 04, 2013 02:36:34 PM Alex Williamson wrote:
> > On Thu, 2013-07-18 at 01:32 +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > The current implementation of acpiphp_check_bridge() is pretty dumb:
> > >  - It enables a slot if it's not enabled and the slot status is
> > >    ACPI_STA_ALL.
> > >  - It disables a slot if it's enabled and the slot status is not
> > >    ACPI_STA_ALL.
> > > 
> > > This behavior is not sufficient to handle the Thunderbolt daisy
> > > chaining case properly, however, because in that case the bus
> > > behind the already enabled slot needs to be rescanned for new
> > > devices.
> > > 
> > > For this reason, modify acpiphp_check_bridge() so that slots are
> > > disabled and stopped if they are not in the ACPI_STA_ALL state.
> > > 
> > > For slots in the ACPI_STA_ALL state, devices behind them that don't
> > > respond are trimmed using a new function, trim_stale_devices(),
> > > introduced specifically for this purpose.  That function walks
> > > the given bus and checks each device on it.  If the device doesn't
> > > respond, it is assumed to be gone and is removed.
> > > 
> > > Once all of the stale devices directy behind the slot have been
> > > removed, acpiphp_check_bridge() will start looking for new devices
> > > that might have appeared on the given bus.  It will do that even if
> > > the slot is already enabled (SLOT_ENABLED is set for it).
> > > 
> > > In addition to that, make the bus check notification ignore
> > > SLOT_ENABLED and go for enable_device() directly if bridge is NULL,
> > > so that devices behind the slot are re-enumerated in that case too.
> > > 
> > > This change is based on earlier patches from Kirill A Shutemov
> > > and Mika Westerberg.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > ---
> > 
> > FYI, git bisect landed on this patch as the cause of my serial console
> > dying on current upstream.  Further debugging to come...  Thanks,
> 
> Well, sorry about that.
> 
> What exactly do you mean by "dying"?

Sorry, I was hoping to have more details quickly, but it's been a pain
to debug.  By dying I mean serial console output suddenly stops during
kernel boot and nothing more comes out of it until after the system is
rebooted.  The problem happens when acpiphp_check_bridge() calls
enable_slot().  The serial console dies somewhere down in
acpiphp_bus_trim().  I think this is happening on the 00:1f ISA bridge,
so there's a good chance the serial ports are described as somewhere
under there.  Thanks,

Alex

