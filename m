Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3H1NFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:05:12 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49219 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3H1NFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:05:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130827234345.GA11187@neilslaptop.think-freely.org>
References: <1377278379-9054-1-git-send-email-nhorman@tuxdriver.com>
 <1377531553-17716-1-git-send-email-nhorman@tuxdriver.com> <CAErSpo7tne+NvO-idW8Dt-9FZaGOHjTEDcQ8mC6K1PG6M=ftvg@mail.gmail.com>
 <20130827234345.GA11187@neilslaptop.think-freely.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 28 Aug 2013 07:04:47 -0600
Message-ID: <CAErSpo4jq-GTGsgfDkfuRQz_8Vi6RmMC1fGCUcu_3tExUw=EFQ@mail.gmail.com>
Subject: Re: [PATCH v3] ACPI: Fix osc flag setup ordering to allow pcie
 hotplug use when available
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Stefan Seyfried <stefan.seyfried@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 5:43 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, Aug 27, 2013 at 03:34:11PM -0600, Bjorn Helgaas wrote:
>> [+cc Stefan]
>>
>> On Mon, Aug 26, 2013 at 9:39 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
>> > Somewhere between 3.9 and 3.10 it seems the order in which pcie and acpi probed
>> > slots for hotplug capabilites got reversed.  While this isn't a big deal, it did
>> > uncover a bug in the ACPI bus setup path.  Specifically, acpi_pci_root_add calls
>> > pci_acpi_scan_root before setting the osc flags for the device handle.
>> > pci_acpi_scan_root, among other things uses device_is_managed_by_native_pciehp()
>> > to determine if a given slot has pcie hotplug capabilties, whcih checks the
>> > devices OSC_PCI_EXPRESS_NATIVE_HP_CONTROL flag.  Since that flag is not set
>> > until after pci_acpi_scan_root_completes, the acpi code never sees that pcie
>> > slots are hotplug capable and configures them all to use acpi instead.
>>
>> I'd like to make it more explicit what we're fixing.  Apparently this
>> is a regression between v3.9 and v3.10.
>>
>> Is this a fix for problems like
>> https://bugzilla.kernel.org/show_bug.cgi?id=60736 ?  That bug is that
>> an ExpressCard slot doesn't work unless we boot with
>> "acpiphp.disable=1".  I think what happens there is that acpiphp
>> claims the slot before we run _OSC, so pciehp doesn't claim it, even
>> though _OSC did grant us control over native PCIe hotplug.
>>
> Yes, that bug is precisely what I am trying to fix (although your wording above is
> inverted from the problem in the bug).  What happens is that acpiphp claims the
> pcie ports, because acpiphp init runs first, and we haven't yet parsed _OSC,
> which would have told acpiphp to yield control to pciehp.  The initial fix I
> proposed fixed this by parsing _OSC prior to running the acpiphp bus scan, but
> that reintroduced the problem of not handling pcie 1.1 aspm properly.  That has
> been fixed in v2/v3 by deferring the setting of aspm_disable until after the bus
> scan.
>
> Shall I submit a v4 with an updated changelog?

No need, I'll update the changelog and include the bugzilla reference
and post it for your approval.  Thanks!

Bjorn
