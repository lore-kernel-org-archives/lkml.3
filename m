Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbaAWADr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:03:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:59583 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbaAWADp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:03:45 -0500
Date: Thu, 23 Jan 2014 01:03:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH v5 02/33] genirq: Add irq_alloc_reserved_desc()
In-Reply-To: <1388707565-16535-3-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1401222241100.24986@ionos.tec.linutronix.de>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org> <1388707565-16535-3-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai,

On Thu, 2 Jan 2014, Yinghai Lu wrote:

> For ioapic hot-add support, it would be easy if we have continuous
> irq numbers for hot added ioapic controller.

I really don't care about easy. Easy to solve problems are for
wimps.

What you really want to say is, that ioapic hot-add support requires a
contiguous irq number space for a hotplugged ioapic to avoid expensive
translations in the ioapic hotplug code.

That's a proper reason for making that change to the core code.
 
> We can reserve irq range at first, and later allocate desc for those
> pre-reserved irqs when they are needed.
> 
> The reasons for not allocating them during reserving:
> 1. only several pins of one ioapic are used, allocate for all pins, will
>    waste memory for not used pins.
> 2. allocate later when is needed could make sure irq_desc is allocated
>    on local node ram, as dev->node is set at that point.
> 
> -v2: update changelog by adding reasons, requested by Konrad.
> -v3: according to tglx:
>        separate core code change with arch code change.

Thanks for splitting the patches!

Now the scope of this change becomes more obvious and what I already
suspected before becomes crystal clear.

The initial intention of irq_reserve_irqs() was to cope with the
legacy interrupts to prevent the dynamic allocator from giving them
out, but it was at least a misnomer if not even a misconception.

Did you notice that? No!

Did you even think why irq_reserve_irqs() exists? No!

You just hacked it into submission for your purpose. As usual, sigh!

What prevents a user of __irq_alloc_reserved_desc() to request
something completely out of its range? Nothing as you happily return
an existing interrupt via:

+       if (irq_to_desc(irq))
+               return irq;

which is true for all already existing interrupts. So some random off
by one is going to cause a spurious and extremly hard to debug
issue. Brilliant.

No, we are not going to play the "it works for Yinghai" game again. I
wasted enough time with that already.

There is a clear step by step approach to get this done proper:

 1) Get rid of the existing misconception/misnomer of
    irq_reserve_irqs().
    
    Make it explicit that this is dealing with legacy irq spaces. It's
    not that hard as there are only two users in tree which are both
    trivial to fix. 

 2) Provide a proper reservation mechanism which does not piggypack
    blindly on the allocation bitmap.

    So what you want is a reservation which:

    A) Marks the irq range in the allocation bitmap

       This prevents other code pathes to stomp on that range.

    B) Stores a unique generated ID in a separate radix tree for that
       particular irq range.

       The generated ID is returned to the caller as it is required
       for actually allocating an interrupt from that range.

       We don't have to bother with making this conditional as the
       initial memory consumption of the radix tree is minimal and we
       only expand it when we actually use that hotplug feature.

  3) Provide a proper alloc_reserved_irqdesc() function

     This function verifies against the reservation ID which was
     handed out by the reservation function.

     It's questionable whether we want to allow the reuse of already
     allocated irq descriptors. I'm leaning to avoid that. See #4

  4) Provide a proper mechanism to free the registered irq descriptors
     and the reservation range when the physical device is removed
     from the system. So you don't have to preserve state in the
     ioapic code. Physical hotplug is not a high frequency hotpath
     operation.

  5) Modify the x86 ioapic code to always use the reserve first and
     allocate later mechanism to avoid ifdeffery and pointless
     conditional code pathes. That also ensures proper test coverage.

     TBH, I could not be bothered to look at your x86 related changes,
     but I expect they are from the "make it work for Yinghai"
     departement as well. I'll review them once the core code changes
     are in an acceptable shape.

Thanks,

	tglx
