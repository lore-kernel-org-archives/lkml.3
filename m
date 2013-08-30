Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3H3LU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:20:26 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60316 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab3H3LUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:20:23 -0400
Date: Fri, 30 Aug 2013 07:20:13 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v4] ACPI: Fix osc flag setup ordering to allow pcie
 hotplug use when available
Message-ID: <20130830112013.GA1142@hmsreliant.think-freely.org>
References: <1377278379-9054-1-git-send-email-nhorman@tuxdriver.com>
 <1377807425-27423-1-git-send-email-nhorman@tuxdriver.com>
 <20130829234052.GA22252@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130829234052.GA22252@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 05:40:52PM -0600, Bjorn Helgaas wrote:
> On Thu, Aug 29, 2013 at 04:17:05PM -0400, Neil Horman wrote:
> > This is a fix for:
> > https://bugzilla.kernel.org/show_bug.cgi?id=60736
> > 
> > During the 3.8 devel cycle:
> > 
> > commit 8c33f51df406e1a1f7fa4e9b244845b7ebd61fa6
> > Author: Taku Izumi <izumi.taku@jp.fujitsu.com>
> > Date:   Tue Oct 30 15:27:13 2012 +0900
> > 
> >     PCI/ACPI: Request _OSC control before scanning PCI root bus
> > 
> > went in to allow us to query the pcie hotplug flags during the acpi bus scan.
> > It however caused problems with the disabling of pcie aspm, and so:
> > commit b8178f130e25c1bdac1c33e0996f1ff6e20ec08e
> > Author: Bjorn Helgaas <bhelgaas@google.com>
> > Date:   Mon Apr 1 15:47:39 2013 -0600
> > 
> >     Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"
> > 
> > Backed it out.  This of course brought back the problem in which acpi took over
> > hotplug ports that were meant to be controlled by pcie.
> > 
> > This patch gives us both items.  It lets us request _OSC control before scanning
> > the pci root bus, but defers any disabling of aspm until after the scan is
> > complete, allowing us to properly handle old pcie 1.1 devices aspm settings
> > properly, as b8178f130e documents.
> > 
> > Tested successfully by myself.
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Len Brown <lenb@kernel.org>
> > CC: "Rafael J. Wysocki" <rjw@sisk.pl>
> > CC: linux-acpi@vger.kernel.org
> > CC: linux-pci@vger.kernel.org
> 
> I added Yinghai's ack and a stable tag and put this in pci/misc
> for v3.12.  Thanks!
> 
> I reworked the changelog because I think the actual cause of the
> regression was 3b63aaa70e, not the _OSC commits you mentioned:
> 
> 8c33f51df4 ("PCI/ACPI: Request _OSC control before scanning PCI root bus")
> appeared in v3.8 and broke ASPM but not acpiphp.
> 
> b8178f130e ('Revert "PCI/ACPI: Request _OSC control before scanning PCI
> root bus"') appeared in v3.9 and fixed ASPM, leaving acpiphp working.
> 
> 3b63aaa70e ("PCI: acpiphp: Do not use ACPI PCI subdriver mechanism")
> appeared in v3.10, and I believe this is what actually broke acpiphp
> because it moved the acpiphp initialization earlier, into the bus scan.
> 
> in v3.8:
>     acpi_pci_root_add
>       acpi_pci_osc_control_set          # request OS control
>       pci_acpi_scan_root                # scan bus
>     acpi_pci_root_start
>       add_bridge                        # acpi_pci_driver .add method
>         ...
>           device_is_managed_by_native_pciehp	# OK
> 
> in v3.9:
>     acpi_pci_root_add
>       pci_acpi_scan_root                # scan bus
>       acpi_pci_osc_control_set          # request OS control
>       add_bridge                        # acpi_pci_driver .add method
>         ...
>           device_is_managed_by_native_pciehp	# OK
> 
> in v3.10:
>     acpi_pci_root_add
>       pci_acpi_scan_root                # scan bus
>         ...
>           acpiphp_enumerate_slots
>             ...
>               device_is_managed_by_native_pciehp	# PROBLEM
>       acpi_pci_osc_control_set          # request OS control
> 
> So I added a stable tag for v3.10+ only.  I'll ask Linus to merge it
> directly during the merge window for v3.12, and hopefully it will be
> backported to the v3.10 and v3.11 stable trees soon after that.
> 
> Bjorn
> 
Copy that, thanks!
Neil

