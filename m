Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbaLJUQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:16:22 -0500
Received: from www.linutronix.de ([62.245.132.108]:55447 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaLJUQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:16:19 -0500
Date: Wed, 10 Dec 2014 21:15:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Jiang Liu <jiang.liu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/apic] x86, PCI, ACPI: Kill private function resource_to_addr()
 in arch/x86/pci/acpi.c
In-Reply-To: <CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412101820510.13233@nanos>
References: <1414387308-27148-5-git-send-email-jiang.liu@linux.intel.com> <tip-e22ce93870deae0e9a54e1539f0088538f187780@git.kernel.org> <CAE9FiQWaL1Qu1eP-fQV784ucy+r-65AZ95VyiUrefn0dNtfLDw@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014, Yinghai Lu wrote:

Can you please

1) Cut out the completely irrelevant information from your replies?
   It's just annoying to scroll through hundreds of quoted lines to
   find the guts of the mail.

2) Send patches inline. It's a pain to review and reply and I can't
   use my normal tooling.
 
> This one cause one system with Nehalem and one with Westmere failing.
> 
> [   32.353347] acpi PNP0A08:00: host bridge window expanded to [mem
> 0x00000000-0xffffffff]; [mem 0x000a0000-0x000bffff] ignored
> [   32.362897] acpi PNP0A08:00: host bridge window expanded to [mem
> 0x00000000-0xffffffff]; [mem 0x000d0000-0x000dffff] ignored
> [   32.382862] acpi PNP0A08:00: host bridge window expanded to [mem
> 0x00000000-0xffffffff]; [mem 0x00000000-0xffffffff] ignored
> [   32.402889] acpi PNP0A08:00: host bridge window expanded to [mem
> 0x00000000-0xffffffff]; [??? 0x00000000-0xffffffff flags 0x0] ignored
> [   32.423000] acpi PNP0A08:00: host bridge window expanded to [mem
> 0x00000000-0xffffffff]; [mem 0x00000000-0xffffffff] ignored
> [   32.602921] PCI host bridge to bus 0000:00
> [   32.603158] pci_bus 0000:00: root bus resource [bus 00-3f]
> [   32.622782] pci_bus 0000:00: root bus resource [io  0x0000-0x5fff]
> [   32.642569] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
> [   32.642893] pci_bus 0000:00: root bus resource [mem
> 0xfc000000000-0xfc07fffffff pref]
> 
> Looks like the commit have several problems.
> 
> Attached patch should address them.

> -       struct resource r = {
> -               .flags = 0
> -       };
> +       struct resource r;
>  
> +       memset(&r, 0, sizeof(r));

What's the point of this change? Both initialize r to 0. memset()
generates better code, but that's irrelevant for the problem at hand.

And the "fix" is also missing that the address range check happens for
IORESOURCE_IO as well. Which is silly because
acpi_dev_resource_address_space() has that already for the IO
case. But sure, that does not help, because it does not return false,
it sets the IORESOURCE_DISABLED flag and returns true.

Now the code in setup_resource() clears that flag along with all other
flags which does not make any sense, at least not without a comment.

But clearing and therefor ignoring IORESOURCE_DISABLED does not make
any sense at all and is outright wrong.

So there is another interesting flag: IORESOURCE_WINDOW. That's
cleared as well and of course the rest of that setup code does not
handle it either. If IORESOURCE_WINDOW is not set, then this is
address space which is consumed by the bridge itself. So its just
wrong to treat it as window and try coalescing it with the real window
spaces.

Also why is this x86 bridge specific?

     if (addr.resource_type == ACPI_MEMORY_RANGE &&
     	 addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
	    r.flags |= IORESOURCE_PREFETCH;

and not happening in the acpi code? Just because struct resource does
not have a field for it? Sigh.

This needs more than a hacked together fixup, really. It was wrong
before Jiangs change already.

> Please fix it before it get into linus tree.

You can be sure that I'm going to fix the whole mess there proper and
not by applying a cobbled together bandaid.

Thanks,

	tglx






