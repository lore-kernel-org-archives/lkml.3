Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3HGPnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:43:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51137 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab3HGPnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:43:09 -0400
Message-ID: <52026AB5.80009@zytor.com>
Date: Wed, 07 Aug 2013 08:41:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: Re: [PATCH 00/26] STA2X11 devicetree support for amba/pci
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 03:16 AM, Alessandro Rubini wrote:
> 
> Some of the problems he found are:
> 
>      * Passing a dtb to the kernel: we use a modified kexec at present
>        because x86 boot loaders can't pass the DT blob, to our knowledge.
> 
>      * Passing correct irq numbers to the AMBA drivers, because PCI MSI
>        irq numbers are dynamically allocated (we solved this by using
>        of_update_property() at runtime). We also had to register a new
>        irq domain for msi irqs, otherwise of_irq_map_one() would complain
>        about irqs lacking a corresponding domain.
> 
>      * Switching to a new gpio driver with devicetree support (we took the
>        Nomadik gpio/pinctrl because our device apparently has more or less
>        the same gpio cell as the Nomadik chip). This requires implementation
>        of writel_relaxed() and IRQF_VALID on x86: we hacked them internally
>        but the patches are not part of this set. We're willing to solve
>        these incompatibilities first, if there's interest.
> 
>      * Writing a suitable dts: at present, a dts only exists for one
>        of the STA2X11 based boards (Intel Northville). This includes a
>        copy of all the physical addresses for the devices, as dts requires
>        that, even if such addresses are automatically assigned by PCI.
>        Clearly, with this approach we kill PCI autodetect: if you plug
>        to a different slot you need a different dts.
> 
> This got us a more or less working kernel on the Northville board
> (where the device is soldered on the motherboard and acts as main chipset).
> The plug-in PCIe board cannot be supported by device tree, as far as
> we know, which in our opinion is a strong downside of device tree in favor
> of the platform data "shit".
> 

OK, so we have a real corner case here... which is a plugin board beyond
which sits a bus normally used by fixed devices.  You are definitely
correct that this is something that stresses current means of
description to the breaking point.

*Note there are some questions below that I would perfectly understand
if you can't talk about publicly, if so, please contact me privately at
my corporate address.*

However, the plugin board is very different from it being the main
chipset, in no small part because you can boot without it.  I think this
is the first time I have ever heard of a chip which can act both as a
system chipset and a plugin card.

The mainboard case is relatively straightforward -- we should use ACPI 5
(preferred for x86) or device tree to describe it.  My understanding
from what you describe so far is that the only existing case is the
Northville which is a mainboard.

For the plugin case, my thinking is that we probably do need a driver of
some kind which at least contains the description of the board, as I
assume one is not present in any kind of firmware on the board itself
(*do any such boards or plans for them actually exist at this point?*)
Ideally that driver should be (primarily?) a data object (an ACPI 5 SSDT
or a DTB file) rather than open coded C.

I believe ACPI 5 unlike device tree should be able to specify the
dynamic properties that you are rightfully concerned with.

Sorry if this feels like a wild goose chase to you.  Some of this
problem domain is not very well handled by the current code, but we
really have to draw a hard line to make sure it doesn't descend into
unmaintainable chaos.

We have similar issues with MinnowBoard and are trying to use that as a
platform to figure out how a lot of these things need to be handled.

	-hpa

