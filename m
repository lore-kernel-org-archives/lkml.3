Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaJJPnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 11:43:10 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60017 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751273AbaJJPnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 11:43:08 -0400
Date: Fri, 10 Oct 2014 16:42:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: keystone: add bus notifier to set dma_pfn_offset
	for pci devices
Message-ID: <20141010154258.GN5182@n2100.arm.linux.org.uk>
References: <1412954137-4567-1-git-send-email-m-karicheri2@ti.com> <5437FB3F.4010906@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5437FB3F.4010906@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 11:29:03AM -0400, Santosh Shilimkar wrote:
>
>
> On 10/10/14 11:15 AM, Murali Karicheri wrote:
>> When PCI device driver such as that for e1000e tries to set dma mask
>> using dma_set_mask_and_coherent(), it fails because the dma_pfn_offset
>> is incorrect on a Keystone SoC. This patch fix this by adding a bus
>> notifier to set this correctly for PCI devices.
>>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> ---
> Looks good. I will pick this up after the merge window.

No it doesn't, this patch is crap.  Really.  Let's look again at what the
patch is doing:

        if (platform_nb.notifier_call)
                bus_register_notifier(&platform_bus_type, &platform_nb);
+       if (platform_nb.notifier_call)
+               bus_register_notifier(&pci_bus_type, &platform_nb);

Notice that both calls are using the same platform_nb structure, which is:

static struct notifier_block platform_nb;

and in turn this is:

struct notifier_block {
        notifier_fn_t notifier_call;
        struct notifier_block __rcu *next;
        int priority;
};

Notice that "next" pointer - these blocks are used as a single-linked list.
So, this block gets registered for the platform bus, and is inserted into
that bus notifier chain.  That means "next" may be set to a non-NULL
next notifier block.

Then it gets registered against the PCI bus, which *will* overwrite the
next pointer in platform_nb.

There are several side effects from this:

1. Any subsequent notifiers on the platform bus which come after _this_
   notifier are now orphaned, and will never be called.

2. Any subsequent notifiers on the PCI bus list which come after _this_
   notifier will now also be called for the platform bus.

3. Subsequent notifiers registered against either list which are sorted
   after _this_ notifier will be attached to _both_ lists.

In other words, this patch totally screws up the notifier lists for both
buses, and while it may not be immediately obvious, if any of the above
three scenarios occur, it will probably be very confusing to debug.

So, one hell of a big NAK on this patch.

Moreover, I have to ask why there wasn't some research done first into
how notifiers work *before* writing this code, specifically to find out
whether it is safe to register the same notifier block simultaneously
onto two lists.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
