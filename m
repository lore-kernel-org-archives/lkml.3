Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaAIXj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:39:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbaAIXj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:39:56 -0500
Message-ID: <1389310776.3209.277.camel@bling.home>
Subject: Re: [PATCH] pci/iov: VFs are never multifunction
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Nishank Trivedi <nistrive@cisco.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        sathya.perla@emulex.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ajit.khaparde@emulex.com, Don Dutile <ddutile@redhat.com>,
        subbu.seetharaman@emulex.com, Myron Stowe <myron.stowe@redhat.com>
Date: Thu, 09 Jan 2014 16:39:36 -0700
In-Reply-To: <CAErSpo7xEKzWF8oetskQAcLcwJUw4VPByXgbMUkurVcK2caRgA@mail.gmail.com>
References: <20140109153513.21446.31778.stgit@bling.home>
	 <CAErSpo4Asnx4JiZvppZLUzxmVymz0t-fHXRFMr81-Qz31XyR+g@mail.gmail.com>
	 <1389291911.3209.234.camel@bling.home>
	 <CAErSpo6vA=f1RSnpkWumYxs3tQ8uM8NKuWqck4GRb6gL5HvqiA@mail.gmail.com>
	 <1389304708.3209.257.camel@bling.home>
	 <CAErSpo7xEKzWF8oetskQAcLcwJUw4VPByXgbMUkurVcK2caRgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 16:20 -0700, Bjorn Helgaas wrote:
> [+to Nishank]
> 
> On Thu, Jan 9, 2014 at 2:58 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Thu, 2014-01-09 at 14:39 -0700, Bjorn Helgaas wrote:
> >> On Thu, Jan 9, 2014 at 11:25 AM, Alex Williamson
> >> <alex.williamson@redhat.com> wrote:
> >> > On Thu, 2014-01-09 at 11:08 -0700, Bjorn Helgaas wrote:
> >> >> On Thu, Jan 9, 2014 at 8:36 AM, Alex Williamson
> >> >> <alex.williamson@redhat.com> wrote:
> >> >> > Per the SR-IOV spec rev 1.1:
> >> >> >
> >> >> > 3.4.1.9 Header Type (Offset 0Eh)
> >> >> >
> >> >> > "... For VFs, this register must be RO Zero."
> >> >> >
> >> >> > Unfortunately some devices get this wrong, ex. Emulex OneConnect 10Gb
> >> >> > NIC.  When they do it makes us handle ACS testing and therefore IOMMU
> >> >> > groups as if they were actual multifunction devices and require ACS
> >> >> > capabilities to make sure there's no peer-to-peer between functions.
> >> >> > VFs are never traditional multifunction devices, so simply clear this
> >> >> > bit before we get any further into setup.
> >> >>
> >> >> This seems reasonable.  Do you have "lspci -vvxxxx" output for this
> >> >> device?  I'd like to save it for future reference.
> >> >
> >> > Sure, here's a VF:
> >> >
> >> > 09:04.0 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (be3) (rev 01)
> >> >         Subsystem: Emulex Corporation Device e722
> >>
> >> Thanks!  I put this in
> >> https://bugzilla.kernel.org/show_bug.cgi?id=68431, and I'll add a
> >> reference to the changelog.
> >>
> >> But I wonder if we can make this slightly more generic by doing
> >> something like this in pci_setup_device():
> >>
> >>   dev->multifunction = (PCI_FUNC(dev->devfn) == 0) && (hdr_type & 0x80);
> >>
> >> That's basically what lspci does in pci_generic_scan_bus(), and
> >> section 3.2.2.3.4 of the PCI 3.0 spec sort of implies that we should
> >> only look at the bit 7 of the header type for function 0:
> >>
> >>   If a single function device is detected (i.e., bit 7 in the Header
> >>   Type register of function 0 is 0), no more functions for that
> >>   Device Number will be checked. If a multi-function device is
> >>   detected (i.e., bit 7 in the Header Type register of function 0
> >>   is 1), then all remaining Function Numbers will be checked.
> >
> > We could do that and rely only on pci_scan_slot() to set multifunction=1
> > for the other functions, but that doesn't completely solve this problem.
> > VFs can occupy function zero and the example device would still set
> > multifunction with that test.  Thanks,
> 
> Duh, it would help if I actually paid attention to your lspci output...
> 
> The reason I'm thinking about this is that virtfn_add() is only used
> when we enable SR-IOV.  If we clear dev->multifunction there, we only
> end up with the correct value if we start with SR-IOV disabled, and
> then enable it.
> 
> If SR-IOV were enabled by the firmware before Linux boots, we wouldn't
> go through the virtfn_add() path, and dev->multifunction might still
> be wrong.
> 
> I'm pretty sure Nishank said there were Cisco boxes that enable SR-IOV
> in the firmware, but I don't know how that works.  It looks like we
> would disable SR-IOV during enumeration in the path below:
> 
>   pci_scan_slot
>     pci_scan_single_device
>       pci_device_add
>         pci_init_capabilities
>           pci_iov_init
>             sriov_init
>               pci_read_config_word(dev, pos + PCI_SRIOV_CTRL, &ctrl)
>               if (ctrl & PCI_SRIOV_CTRL_VFE)
>                 pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, 0)
> 
> From that path, it *looks* like it doesn't really matter whether
> SR-IOV is enabled at handoff, because we disable it anyway.
> 
> So I'm not sure if I misunderstood Nishank or what.  I think it would
> be cool if we could enumerate previously-enabled VFs, but maybe there
> are other issues that would make that impossible.

VFs don't have vendor/device IDs, that's provided by the PF SR-IOV
capability.  We'd need to go reverse engineer which PF they came from to
set that up, so it doesn't really seem worthwhile.  I have seen devices
with various modes of operation, SR-IOV or multifunction.  Depending on
how the device firmware is configured they can pretend to be something
that looks more like a traditional multifunction device or generate VFs.
Those typically exist to work around system firmware that doesn't
support SR-IOV and doesn't leave properly sized apertures.  Thanks,

Alex

