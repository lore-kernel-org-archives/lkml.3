Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaAIVje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:39:34 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:49183 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827AbaAIVjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:39:21 -0500
MIME-Version: 1.0
In-Reply-To: <1389291911.3209.234.camel@bling.home>
References: <20140109153513.21446.31778.stgit@bling.home> <CAErSpo4Asnx4JiZvppZLUzxmVymz0t-fHXRFMr81-Qz31XyR+g@mail.gmail.com>
 <1389291911.3209.234.camel@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 9 Jan 2014 14:39:00 -0700
Message-ID: <CAErSpo6vA=f1RSnpkWumYxs3tQ8uM8NKuWqck4GRb6gL5HvqiA@mail.gmail.com>
Subject: Re: [PATCH] pci/iov: VFs are never multifunction
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        sathya.perla@emulex.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ajit.khaparde@emulex.com, Don Dutile <ddutile@redhat.com>,
        subbu.seetharaman@emulex.com, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 11:25 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Thu, 2014-01-09 at 11:08 -0700, Bjorn Helgaas wrote:
>> On Thu, Jan 9, 2014 at 8:36 AM, Alex Williamson
>> <alex.williamson@redhat.com> wrote:
>> > Per the SR-IOV spec rev 1.1:
>> >
>> > 3.4.1.9 Header Type (Offset 0Eh)
>> >
>> > "... For VFs, this register must be RO Zero."
>> >
>> > Unfortunately some devices get this wrong, ex. Emulex OneConnect 10Gb
>> > NIC.  When they do it makes us handle ACS testing and therefore IOMMU
>> > groups as if they were actual multifunction devices and require ACS
>> > capabilities to make sure there's no peer-to-peer between functions.
>> > VFs are never traditional multifunction devices, so simply clear this
>> > bit before we get any further into setup.
>>
>> This seems reasonable.  Do you have "lspci -vvxxxx" output for this
>> device?  I'd like to save it for future reference.
>
> Sure, here's a VF:
>
> 09:04.0 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (be3) (rev 01)
>         Subsystem: Emulex Corporation Device e722

Thanks!  I put this in
https://bugzilla.kernel.org/show_bug.cgi?id=68431, and I'll add a
reference to the changelog.

But I wonder if we can make this slightly more generic by doing
something like this in pci_setup_device():

  dev->multifunction = (PCI_FUNC(dev->devfn) == 0) && (hdr_type & 0x80);

That's basically what lspci does in pci_generic_scan_bus(), and
section 3.2.2.3.4 of the PCI 3.0 spec sort of implies that we should
only look at the bit 7 of the header type for function 0:

  If a single function device is detected (i.e., bit 7 in the Header
  Type register of function 0 is 0), no more functions for that
  Device Number will be checked. If a multi-function device is
  detected (i.e., bit 7 in the Header Type register of function 0
  is 1), then all remaining Function Numbers will be checked.

Bjorn
