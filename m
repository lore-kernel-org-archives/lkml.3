Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab3LTK0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:26:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838Ab3LTK0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:26:22 -0500
Date: Fri, 20 Dec 2013 11:28:12 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v4 9/9] PCI/MSI: Introduce pci_auto_enable_msi*() family
 helpers
Message-ID: <20131220102812.GB28367@dhcp-26-207.brq.redhat.com>
References: <cover.1387140921.git.agordeev@redhat.com>
 <bbf6f73ef3e16e5dfd7d41fc1e4412f641acb0f3.1387140921.git.agordeev@redhat.com>
 <20131218003002.GA15119@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218003002.GA15119@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 05:30:02PM -0700, Bjorn Helgaas wrote:
> After this patch, we would have:
> 
>     pci_enable_msi()				# existing (1 vector)
>     pci_enable_msi_block(nvec)			# existing
>     pci_enable_msi_block_auto(maxvec)		# existing (removed)
> 
>     pci_auto_enable_msi(maxvec)			# new	(1-maxvec)
>     pci_auto_enable_msi_range(minvec, maxvec)	# new
>     pci_auto_enable_msi_exact(nvec)		# new	(nvec-nvec)
> 
>     pci_enable_msix(nvec)			# existing
> 
>     pci_auto_enable_msix(maxvec)		# new	(1-maxvec)
>     pci_auto_enable_msix_range(minvec, maxvec)	# new
>     pci_auto_enable_msix_exact(nvec)		# new	(nvec-nvec)
> 
> That seems like a lot of interfaces to document and understand, especially
> since most of them are built on each other.  I'd prefer just these:
> 
>     pci_enable_msi()				# existing (1 vector)
>     pci_enable_msi_range(minvec, maxvec)	# new
> 
>     pci_enable_msix(nvec)			# existing
>     pci_enable_msix_range(minvec, maxvec)	# new
> 
> with examples in the documentation about how to call them with ranges like
> (1, maxvec), (nvec, nvec), etc.  I think that will be easier than
> understanding several interfaces.

I agree pci_auto_enable_msix() and pci_auto_enable_msix_exact() are worth
sacrificing for the sake of clarity. My only concern is people will start
defining their own helpers for (1, maxvec) and (nvec, nvec) cases here and
there...

> I don't think the "auto" in the names really adds anything, does it?  The
> whole point of supplying a range is that the core has the flexibility to
> choose any number of vectors within the range.

"Auto" indicates auto-retry, but I see no problem in skipping it, especially
if we deprecate or phase out the existing interfaces.

> I only see five users of pci_enable_msi_block() (nvme, ath10k, wil6210,
> ipr, vfio); we can easily convert those to use pci_enable_msi_range() and
> then remove pci_enable_msi_block().
> 
> pci_enable_msi() itself can simply be pci_enable_msi_range(1, 1).
> 
> There are nearly 80 callers of pci_enable_msix(), so that's a bit harder.
> Can we deprecate that somehow, and incrementally convert callers to use
> pci_enable_msix_range() instead?  Maybe you're already planning that; I
> know you dropped some driver patches from the series for now, and I didn't
> look to see exactly what they did.

Right, the plan is first to introduce pci_auto_* (or whatever) family into
the tree and then gradually convert all drivers to the new interfaces.

> It would be good if pci_enable_msix() could be implemented in terms of
> pci_enable_msix_range(nvec, nvec), with a little extra glue to handle the
> positive return values.

[...]

> I think it would be better to make pci_enable_msix_range() the fundamental
> implementation, with pci_enable_msix() built on top of it.  That way we
> could deprecate and eventually remove pci_enable_msix() and its tri-state
> return values.

We can reuse pci_enable_msix() name, but not before all drivers converted.

But considering the other thread you want to have only pci_enable_msi_range()
and pci_enable_msix_range() interfaces - am I getting it right?

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
