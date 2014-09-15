Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaIOPwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:52:39 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33019 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaIOPwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:52:38 -0400
Date: Mon, 15 Sep 2014 16:52:16 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jon Masters <jcm@redhat.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: "dma-coherent" property inheritance (arm vs arm64)
Message-ID: <20140915155216.GG5415@arm.com>
References: <5414FF8F.5040409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5414FF8F.5040409@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Sun, Sep 14, 2014 at 03:38:07AM +0100, Jon Masters wrote:
> commit 6ecba8eb51b7d23fda66388a5420be7d8688b186
> Author: Catalin Marinas <catalin.marinas@arm.com>
> Date:   Fri Apr 25 15:31:45 2014 +0100
> 
>     arm64: Use bus notifiers to set per-device coherent DMA ops
> 
> Thus at this point, on 32-bit systems, we have defined this function:
> 
> 	set_arch_dma_coherent_ops

It was a timing issue that they are not in sync. I would have used
set_arch_dma_coherent_ops() but it wasn't very clear when it gets merged
and changing the default on arm64 broke some other assumptions, so a
temporary fix.

> Thus when we see this "dma-coherent" entry, we will make the call to set
> the dma_ops over to the alternative. However, on AArch64 (or any
> non-32-bit ARM architecture using of_ probe for that matter), we do not
> define set_arch_dma_coherent_ops specifically, and thus the default
> (empty method) is called, resulting in no actual change. Instead, on
> AArch64, you rely upon a bus notifier callback that you register for
> several bus types (notably there is none for PCI yet, but we'll come
> back to that later once there's an upstream story there) that fires and
> only responds to the device addition to the bus event thus:
[...]
> This is used whenever an AMBA or Platform device is added to its
> respective bus through walking the devicetree at setup time. However,
> the logic here differs from that used in the case of the platform code
> call taking effect as in the case of 32-bit ARM (drivers/of/address.c):
[...]
> Notice in the latter case we will walk up the tree and inherit nodes
> from parents explicitly. Unless I am mistaken, this is a difference in
> logic between the 32-bit and 64-bit cases in terms of DMA inheritance.

There isn't any reason why arm64 shouldn't do the same.

I had a reason, however, for delaying this. My reading of the code is
that of_dma_configure() is only called from
of_platform_device_create_pdata() which is not called in case of AMBA
(arm,primcell compatible) devices.

> Further, I am trying to determine the best mechanism for handling the
> case in which the dma-coherent property must be defined for other bus
> types, for example the PCI bus (in which case there may not be an entry
> for a specific device but we want to inherit the behavior from the Root
> Complex bus device). I can just setup a notifier on device addition and
> register that against the PCI bus, in which case I would want the 32-bit
> ARM behavior of recursing up the tree and inheriting whatever I find
> there.

As I said, we should do this recursively for arm64 as well.

> I am worried to learn that some are instead reverting the patch
> from Ritesh because it makes everything seem all better again...sigh.

Like in faster? I don't like when people patch their private kernel
heavily and later complain that mainline doesn't work.

> Anyway. Perhaps I am wrong and miss-interpreting this. I'm going on code
> inspection not runtime since I'm on a long flight and had time to ponder
> a few things. I would appreciate your thoughts on whether:
> 
> 1). Is there a difference between 32-bit and 64-bit architectures?

There are many ;) but not with regards to DMA ops.

> 2). Should this be the case? If it's a bug, should it be changed? Which
> one should change? It seems to me that we should inherit from ancestors.

Add set_arch_dma_coherent_ops() for arm64 and drop the
platform_bus_notifier. Once we clear the DMA ops for AMBA devices, we
could drop this notifier as well (though not sure about ACPI, see
below).

> 3). How would you recommend to handle the PCI bus case later? As a
> notifier similar to that which you use for the other two bus types?

I would prefer something more generic but until sorted we could add
another notifier.

> P.S. Later, on ACPI based 64-bit ARM systems, we will specifically
> define the inheritance rules for _CCA (Cache Coherency Attribute) based
> entries according to the rules of ACPI5.1 section 6.2.17 (which
> specifies that these are recursive in nature and also defines when these
> properties should be defined for devices). So that is covered also. I am
> already requesting that _CCA be explicitly *required* in ARM server
> cases for *all* devices in future versions of various of ACPI-based
> specifications (without any possibility to not include it under the
> existing allowances of the specification). To remove ambiguity _CCA
> should IMO be provided for every single ACPI described device. I hope to
> see an updated set of specifications make this clarification soon.

In the meantime, as I understood, in ACPI it is assumed that devices are
coherent by default (like on x86) and only explicitly marked as
non-coherent. If that's the case, it means that we should still keep the
bus notifier hooks in the arm64 code and make the decision based on
acpi_disabled, DT and other properties.

-- 
Catalin
