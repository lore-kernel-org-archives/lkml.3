Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbaAaTZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:25:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532AbaAaTZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:25:29 -0500
Message-ID: <1391196326.6959.111.camel@bling.home>
Subject: Re: [PATCH 0/2] Quirk Intel PCH root ports for ACS-like features
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 31 Jan 2014 12:25:26 -0700
In-Reply-To: <20140131184918.GA8834@google.com>
References: <20140120215502.29567.11291.stgit@bling.home>
	 <20140131184918.GA8834@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-31 at 11:49 -0700, Bjorn Helgaas wrote:
> On Mon, Jan 20, 2014 at 03:01:40PM -0700, Alex Williamson wrote:
> > As described in 2/2 many Intel root ports lack PCIe ACS capabilities
> > which results in excessively large IOMMU groups.  Many of these root
> > ports do provide isolation capabilities, we just need to use device
> > specific mechanisms to enable and verify.  Long term, I hope we can
> > round out this list (particularly to include X79 root ports) and
> > more importantly, encourage proper PCIe ACS support in future
> > products.  I'm really hoping we can get this in during the 3.14 cycle.
> 
> v3.13 was released Jan 19, so this came during the v3.14 merge window.  I
> like to have things in -next for a while before asking Linus to pull them,
> and I try to keep it to regression fixes after the merge window, i.e.,
> things that used to work, but don't work any more.  But that's all standard
> procedure that you already know, and maybe you can make a case for
> accelerating this.

Sorry, I sent it out as early as I was able to.  It's my understanding
that fixes are always allowed after the merge window and we can
generally assume that 3.14 won't be released for at least 6-8 weeks
after rc1, which gives us plenty of time to let this cook in -next and
still make 3.14.  Obviously it's your prerogative as maintainer where
you feel comfortable.

So what does this fix and how close is it to a regression?  The fix is a
quirk for hardware that lacks proper ACS support, but still provides
device isolation when properly configured.  What that means to a user is
that if they attempt to use vfio to expose a device to a userspace
driver such as QEMU, the device may be artificially tied to other
devices behind the root port and devices behind root ports that are part
of the same multifunction PCH package.  In effect, there are devices
that are isolated or isolate-able that users should be able to use
independently of other devices, but they can't.  I fully acknowledge
that this use case is a small, but important to me, subset of users.

As to a regression, the only remote software regression is that legacy
KVM device assignment takes a much more lax (non-existent) approach to
kernel-base isolation and allows such assignments.  That's a weak
regression, but if you're a downstream trying to switch users over to
vfio-based device assignment, it's an important one.  In some respects
there's also a hardware regression.  Intel root ports used to support
ACS and for whatever reasons they forgot how critical ACS is in
determining isolation sets for exposing devices to VMs.  We obviously
can't go back and fix the existing hardware, but we can fix this
regression for many of those chipsets in software (and beat Intel to
include it in next generation hardware).

I hope you'll consider it for 3.14, I know a number of users who
continue to patch their kernel with the old ACS override patch who would
appreciate it sooner than later, but I fully understand wanting some
soak time in -next first.  Thanks,

Alex

