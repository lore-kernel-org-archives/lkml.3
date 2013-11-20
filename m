Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3KTRPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:15:32 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:49628 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3KTRPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:15:30 -0500
Date: Wed, 20 Nov 2013 12:15:26 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*()
 family helpers
Message-ID: <20131120171526.GL28946@htj.dyndns.org>
References: <cover.1382103786.git.agordeev@redhat.com>
 <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 18, 2013 at 07:12:12PM +0200, Alexander Gordeev wrote:
> Currently many device drivers need contiguously call functions
> pci_enable_msix() for MSI-X or pci_enable_msi_block() for MSI
> in a loop until success or failure. This update generalizes
> this usage pattern and introduces pcim_enable_msi*() family
> helpers.
> 
> As result, device drivers do not have to deal with tri-state
> return values from pci_enable_msix() and pci_enable_msi_block()
> functions directly and expected to have more clearer and straight
> code.
> 
> So i.e. the request loop described in the documentation...
> 
> 	int foo_driver_enable_msix(struct foo_adapter *adapter,
> 				   int nvec)
> 	{
> 		while (nvec >= FOO_DRIVER_MINIMUM_NVEC) {
> 			rc = pci_enable_msix(adapter->pdev,
> 					     adapter->msix_entries,
> 					     nvec);
> 			if (rc > 0)
> 				nvec = rc;
> 			else
> 				return rc;
> 		}
> 
> 		return -ENOSPC;
> 	}
> 
> ...would turn into a single helper call....
> 
> 	rc = pcim_enable_msix_range(adapter->pdev,
> 				    adapter->msix_entries,
> 				    nvec,
> 				    FOO_DRIVER_MINIMUM_NVEC);
> 
> Device drivers with more specific requirements (i.e. a number of
> MSI-Xs which is a multiple of a certain number within a specified
> range) would still need to implement the loop using the two old
> functions.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Suggested-by: Ben Hutchings <bhutchings@solarflare.com>

The use of @nvec and @maxvec is a bit inconsistent.  Maybe it'd be
better to make them uniform?  Also, can you please add function
comments to the new public functions?  People are much more likely to
check them than the documentation.  Other than that,

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks a lot!

-- 
tejun
