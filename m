Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaINDyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 23:54:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbaINDyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 23:54:23 -0400
Message-ID: <5414FF8F.5040409@redhat.com>
Date: Sat, 13 Sep 2014 22:38:07 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: "dma-coherent" property inheritance (arm vs arm64)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Sitting here on a flight, I decided to go over a number of patches and
pondering a few things through inspection (my 64-bit ARM servers are in
the overhead bin, I guess I /could/ power them on with the in-seat power
to poke at this...but people around me would probably be even more
weirded out than they are already...so I haven't tested this). Anyway. I
think I have noticed a difference in the inheritance of dma-coherent
properties between 32-and-64-bit ARM systems:.

The behavioral default for dma_ops selection on the 64-bit ARM
architecture was changed by Ritest Harjani upstream on Apr 23 2014:

commit c7a4a7658d689f664050c45493d79adf053f226e
Author: Ritesh Harjani <ritesh.harjani@gmail.com>
Date:   Wed Apr 23 06:29:46 2014 +0100

    arm64: Make default dma_ops to be noncoherent

This prompted you to later send the following patch, adding two bus
notifiers (for AMBA and Platform devices, this is prior to PCI being
upstreamed), intending to allow coherent devices to be marked such:

commit 6ecba8eb51b7d23fda66388a5420be7d8688b186
Author: Catalin Marinas <catalin.marinas@arm.com>
Date:   Fri Apr 25 15:31:45 2014 +0100

    arm64: Use bus notifiers to set per-device coherent DMA ops

Thus at this point, on 32-bit systems, we have defined this function:

	set_arch_dma_coherent_ops

Which is used to switch the dma_ops for a device to the coherent
methods. For example, and regardless of the architecture, this occurs in
Linux's platform code (platform.c) during device setup:

        /*
         * if dma-coherent property exist, call arch hook to setup
         * dma coherent operations.
         */
        if (of_dma_is_coherent(dev->of_node)) {
                set_arch_dma_coherent_ops(dev);
                dev_dbg(dev, "device is dma coherent\n");
        }

Thus when we see this "dma-coherent" entry, we will make the call to set
the dma_ops over to the alternative. However, on AArch64 (or any
non-32-bit ARM architecture using of_ probe for that matter), we do not
define set_arch_dma_coherent_ops specifically, and thus the default
(empty method) is called, resulting in no actual change. Instead, on
AArch64, you rely upon a bus notifier callback that you register for
several bus types (notably there is none for PCI yet, but we'll come
back to that later once there's an upstream story there) that fires and
only responds to the device addition to the bus event thus:

static int dma_bus_notifier(struct notifier_block *nb,
                            unsigned long event, void *_dev)
{
        struct device *dev = _dev;

        if (event != BUS_NOTIFY_ADD_DEVICE)
                return NOTIFY_DONE;

        if (of_property_read_bool(dev->of_node, "dma-coherent"))
                set_dma_ops(dev, &coherent_swiotlb_dma_ops);

        return NOTIFY_OK;
}

This is used whenever an AMBA or Platform device is added to its
respective bus through walking the devicetree at setup time. However,
the logic here differs from that used in the case of the platform code
call taking effect as in the case of 32-bit ARM (drivers/of/address.c):

bool of_dma_is_coherent(struct device_node *np)
{
        struct device_node *node = of_node_get(np);

        while (node) {
                if (of_property_read_bool(node, "dma-coherent")) {
                        of_node_put(node);
                        return true;
                }
                node = of_get_next_parent(node);
        }
        of_node_put(node);
        return false;
}

Notice in the latter case we will walk up the tree and inherit nodes
from parents explicitly. Unless I am mistaken, this is a difference in
logic between the 32-bit and 64-bit cases in terms of DMA inheritance.

Further, I am trying to determine the best mechanism for handling the
case in which the dma-coherent property must be defined for other bus
types, for example the PCI bus (in which case there may not be an entry
for a specific device but we want to inherit the behavior from the Root
Complex bus device). I can just setup a notifier on device addition and
register that against the PCI bus, in which case I would want the 32-bit
ARM behavior of recursing up the tree and inheriting whatever I find
there. I am worried to learn that some are instead reverting the patch
from Ritesh because it makes everything seem all better again...sigh.

Anyway. Perhaps I am wrong and miss-interpreting this. I'm going on code
inspection not runtime since I'm on a long flight and had time to ponder
a few things. I would appreciate your thoughts on whether:

1). Is there a difference between 32-bit and 64-bit architectures?
2). Should this be the case? If it's a bug, should it be changed? Which
one should change? It seems to me that we should inherit from ancestors.
3). How would you recommend to handle the PCI bus case later? As a
notifier similar to that which you use for the other two bus types?

Thanks very much,

Jon.

P.S. Later, on ACPI based 64-bit ARM systems, we will specifically
define the inheritance rules for _CCA (Cache Coherency Attribute) based
entries according to the rules of ACPI5.1 section 6.2.17 (which
specifies that these are recursive in nature and also defines when these
properties should be defined for devices). So that is covered also. I am
already requesting that _CCA be explicitly *required* in ARM server
cases for *all* devices in future versions of various of ACPI-based
specifications (without any possibility to not include it under the
existing allowances of the specification). To remove ambiguity _CCA
should IMO be provided for every single ACPI described device. I hope to
see an updated set of specifications make this clarification soon.
