Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaIFVVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 17:21:45 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:41421 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaIFVVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 17:21:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy63sEs2zvr0LzKSjxSRuH5paLG378qQ6_QyLmmJw=D3w@mail.gmail.com>
References: <53FFA54D.9000907@gmail.com> <CAErSpo5_WMUmnTHpPZt+j04VZoiW1pthQoGV90A5BDQpQgjwOQ@mail.gmail.com>
 <CA+55aFy63sEs2zvr0LzKSjxSRuH5paLG378qQ6_QyLmmJw=D3w@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 6 Sep 2014 15:21:21 -0600
Message-ID: <CAErSpo57EyJj1uc+oqvmy+_10AwwhrOQEO=EQbB2zs-7gd9tFA@mail.gmail.com>
Subject: Re: [PATCH] pci/probe: Enable CRS for Intel Haswell root ports
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>,
        Richard Yang <weiyang@linux.vnet.ibm.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Josh Logan <joshtlogan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Josh]

On Tue, Sep 2, 2014 at 1:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Sep 1, 2014 at 9:14 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>> I'm not a fan of adding a whitelist for devices that work correctly.
>> I don't think that's a maintainable solution.  Since we haven't had
>> many systems yet that care about CRS, some kind of "enable CRS on
>> machines newer than X" might work.
>
> I'd suggest trying to just enable CRS unconditionally (ie revert my
> old commit ad7edfe04908). We've done other changes in this area since,
> and in particular, it's entirely possible that the original problem we
> had doesn't even trigger any more.
>
> In particular, looking at one of the old reports, I don't see that
> "Device %04x:%02x:%02x.%d not responding" warning that we *should*
> have triggered in pci_scan_device(). So I wonder if we had some case
> that read the vendor ID without that whole loop, and that _that_ was
> our fundamental problem.
>
> It would be great if somebody could test with the old hardware that
> triggered the problem originally, but those reports are from 2007, so
> it might be hard to find anything relevant today. But trying to just
> go back to unconditionally enabling CRS (say, in 3.18-rc1) and seeing
> if anybody hollers, might just be the right approach.

Josh actually does still have the hardware, so he *might* be able to test it.

My original theory was that the device didn't advertise CRS SV
capability, and something went wrong when we enabled it anyway.  But
lspci incorrectly decoded CRS SV from the RootCap, so we don't know
whether it was advertised, and I didn't have an explanation for what
could be going wrong if we enabled it.

But as you point out, we don't see the "not responding" message.  We
only print that if we read 0xffff0001 (device/vendor ID).  But lspci
claims the vendor:device ID is 0001:8168.  So my new theory is:

  - Root Port issues Configuration Request to read four bytes at 0x0.
  - Device generates Completion with Config Request Retry Status,
returning data of 10ec:8168.
  - Root Port (with SV disabled) retries the Config Request until it
succeeds, then returns 0x816810ec.  In this configuration, these
boards work correctly today.
  - Root Port (with SV enabled) replaces Vendor ID with 0001 but fails
to replace Device ID with ffff, so it returns 0x81680001.  This is a
hardware defect per PCIe r3.0, sec 2.3.2.
  - Linux sees 0x81680001, but we're looking for 0xffff0001, so we
think everything's fine and we don't retry or warn about it.

So I think we should try two patches:

  1) Enable CRS SV if support is advertised, i.e., Rajat's current patch
  2) Change pci_bus_read_dev_vendor_id() to test only the two bytes of
the vendor ID and ignore the device ID

I suspect that if Josh tested patch 1) alone, he would see the same
problem he originally reported, and that if he tested both together,
it would work correctly.  Obviously, if it works out this way, I would
apply them in the reverse order to avoid a bisection problem.

Bjorn
