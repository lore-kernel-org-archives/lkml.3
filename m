Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab3KTHJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:09:59 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64277 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3KTHJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:09:41 -0500
Date: Wed, 20 Nov 2013 15:09:30 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Myron Stowe <myron.stowe@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Amos Kong <kongjianjun@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>, Thomas Renninger <trenn@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] pci: check PCI_EXP_FLAGS_SLOT before setting hotplug
 bridge
Message-ID: <20131120070930.GD3821@adam-laptop>
References: <1384767652-20567-1-git-send-email-adam.lee@canonical.com>
 <CAErSpo7bERHRbBNOzb6g+666jMmFXQvv2T2U6dv82fVh1dU5kA@mail.gmail.com>
 <20131119055714.GA3451@adam-laptop>
 <CAL-B5D2WtALi5RMX9JQQmVUShLEN947cdvr7jjnpfCXS3zmPVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL-B5D2WtALi5RMX9JQQmVUShLEN947cdvr7jjnpfCXS3zmPVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 11:08:06AM -0700, Myron Stowe wrote:
> On Mon, Nov 18, 2013 at 10:57 PM, Adam Lee <adam.lee@canonical.com> wrote:
> > On Mon, Nov 18, 2013 at 10:38:17AM -0700, Bjorn Helgaas wrote:
> >> [+cc Myron, Amos, Thomas, Ben]
> >>
> >> On Mon, Nov 18, 2013 at 2:40 AM, Adam Lee <adam.lee@canonical.com> wrote:
> >> > This patch adds the PCI_EXP_FLAGS_SLOT check back before setting
> >> > hotplug bridge, which is omitted by an API switching commit,
> >> > 59875ae489609b2267548dc85160c5f0f0c6f9d4 "PCI/core: Use PCI Express
> >> > Capability accessors".
> >> >
> >> > Some Lenovo laptops hang in booting without this fix.
> >>
> >> What kernel version hangs?  I suspect you might be missing 6d3a1741f1
> >> ("PCI: Support PCIe Capability Slot registers only for ports with
> >> slots"), because it *looks* like the current kernel should work
> >> correctly even without your patch.
> >
> > No, patching 6d3a1741f1 and d3694d4fa3 doesn't fix the hang.
> 
> Did you actually try it?  This patch did solve a problem that I
> encountered (see below).

On Tue, Nov 19, 2013 at 10:40:09AM -0700, Bjorn Helgaas wrote:
> >
> > It hangs in acpi_evaluate_integer() from
> > 59875ae489609b2267548dc85160c5f0f0c6f9d4 "PCI/core: Use PCI Express
> > Capability accessors" and before
> > ac212b6980d8d5eda705864fc5a8ecddc6d6eacc "ACPI / processor: Use common
> > hotplug infrastructure", 3.4~3.11. (double confirmed)
                             ^^^^^^^^ should be 3.7~3.10

> I don't understand what you're saying here.  We're talking about this path:
>
>     set_pcie_hotplug_bridge
>       pcie_capability_read_dword(dev, PCI_EXP_SLTCAP, ...)
>         pcie_capability_reg_implemented(dev, PCI_EXP_SLTCAP)
>           pcie_cap_has_sltctl(dev)
>
> This path doesn't invoke acpi_evaluate_integer().  How does a hang
> there relate to the patch you posted?  Are you saying you bisected the
> hang to one of the commits you mentioned?

Bjorn and Myron,

Yes, I did try, and those two commits are both coming from bisect, it is weird.
But good news, I tried the new series containing three patches, it fixed that
hang.(backported to 3.8, pcie_flags_reg is fine)

Great thanks.

-- 
Adam Lee
