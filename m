Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab3KSRkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:40:35 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:41717 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3KSRkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:40:31 -0500
MIME-Version: 1.0
In-Reply-To: <20131119055714.GA3451@adam-laptop>
References: <1384767652-20567-1-git-send-email-adam.lee@canonical.com>
 <CAErSpo7bERHRbBNOzb6g+666jMmFXQvv2T2U6dv82fVh1dU5kA@mail.gmail.com> <20131119055714.GA3451@adam-laptop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 19 Nov 2013 10:40:09 -0700
Message-ID: <CAErSpo45HV27k-ULgj4JFzEWqDC+o9dH11qVwO21YfYBFGP9Mw@mail.gmail.com>
Subject: Re: [PATCH] pci: check PCI_EXP_FLAGS_SLOT before setting hotplug bridge
To: Adam Lee <adam.lee@canonical.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Amos Kong <kongjianjun@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>, Thomas Renninger <trenn@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:57 PM, Adam Lee <adam.lee@canonical.com> wrote:
> On Mon, Nov 18, 2013 at 10:38:17AM -0700, Bjorn Helgaas wrote:
>> [+cc Myron, Amos, Thomas, Ben]
>>
>> On Mon, Nov 18, 2013 at 2:40 AM, Adam Lee <adam.lee@canonical.com> wrote:
>> > This patch adds the PCI_EXP_FLAGS_SLOT check back before setting
>> > hotplug bridge, which is omitted by an API switching commit,
>> > 59875ae489609b2267548dc85160c5f0f0c6f9d4 "PCI/core: Use PCI Express
>> > Capability accessors".
>> >
>> > Some Lenovo laptops hang in booting without this fix.
>>
>> What kernel version hangs?  I suspect you might be missing 6d3a1741f1
>> ("PCI: Support PCIe Capability Slot registers only for ports with
>> slots"), because it *looks* like the current kernel should work
>> correctly even without your patch.
>
> No, patching 6d3a1741f1 and d3694d4fa3 doesn't fix the hang.
>
> It hangs in acpi_evaluate_integer() from
> 59875ae489609b2267548dc85160c5f0f0c6f9d4 "PCI/core: Use PCI Express
> Capability accessors" and before
> ac212b6980d8d5eda705864fc5a8ecddc6d6eacc "ACPI / processor: Use common
> hotplug infrastructure", 3.4~3.11. (double confirmed)

I don't understand what you're saying here.  We're talking about this path:

    set_pcie_hotplug_bridge
      pcie_capability_read_dword(dev, PCI_EXP_SLTCAP, ...)
        pcie_capability_reg_implemented(dev, PCI_EXP_SLTCAP)
          pcie_cap_has_sltctl(dev)

This path doesn't invoke acpi_evaluate_integer().  How does a hang
there relate to the patch you posted?  Are you saying you bisected the
hang to one of the commits you mentioned?

Your patch appears to be functionally equivalent to 6d3a1741f1 -- they
both check the PCI_EXP_FLAGS_SLOT bit in the PCI_EXP_FLAGS word.  But
6d3a1741f1 uses a cached copy of PCI_EXP_FLAGS, so it could be that
you found a path where the cached copy hasn't been updated yet.

I don't want to apply a patch that is logically unnecessary, because
then it's likely that somebody in the future will think "there's no
need to check PCI_EXP_FLAGS_SLOT twice, so I'll remove the second
one," which will break things again.  Your patch appears unnecessary,
so obviously I'm missing something.  I'm just trying to understand
what I'm missing.

Bjorn
