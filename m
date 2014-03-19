Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaCSSgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:36:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaCSSgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:36:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Rob Herring <robherring2@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
Date: Wed, 19 Mar 2014 19:36:10 +0100
Message-ID: <14992874.y2jPSm88bi@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqJCa6kz8H_W7vz4YW5eOrOZ43kwxQq9Uh-M0qpCtW_pQQ@mail.gmail.com>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com> <20140319172140.GA16328@e106497-lin.cambridge.arm.com> <CAL_JsqJCa6kz8H_W7vz4YW5eOrOZ43kwxQq9Uh-M0qpCtW_pQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:T2lzcBobWT9dfpYQmwcfpDD5GlUccbjNP4B5toBslOz
 m7EjJdrfXwGVQCSNuh65BkXFXjSHQCi+dtozKYRQN9r7STRPZL
 BuIlNZyoRIAZrJZuJREwmWjnMWyZBTdy4VmdeABcd5CxFxzs7E
 EQMcm0JUzYf2AAaWjshzVQKB6NnbBaGN5Omg2BmCjLQA8jfnNS
 Zbiewxg3au42ez0BREErTQkKMg+tCXNnYOw1YBjuCr/XV9K1uy
 xeBCgiRxHjHaUNhovZe9v/d2Dc5wKIMYyputot5ZJYwUFezc9o
 GvieLHk/RpnM+ei0HEukZcW3R+2rCT4Pwk2j8yWbW18CkunnWy
 sLXPN1FVJMO4JRmDmBHo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 March 2014 12:53:11 Rob Herring wrote:
> I've successfully used the preceeding series on ARM converting the
> Versatile PCI support to use it. The main part of the process was just
> copying this arm64 code to arm which tells me the code is in the wrong
> place. There are still some differences in pcibios_fixup_bus, and it
> is not clear to me whether the arm version should be doing all the
> things the arm64 version does and vice-versa. Certainly that should be
> sorted out. The other issues I see is pci_ioremap_io still has to be
> called by the driver and is not aligned at least for the prototype as
> I pointed out. Seems all these issues could be fixed with a simple
> CONFIG_ARCH_HAS_MMIO_IOSPACE kconfig option.

I don't even think we need a CONFIG option: Any architecture that wants
to provide pci_ioremap_io (or whatever we end up calling the new version)
needs to pass the virtual base address to the common code, and the
easiest way to do that is using a macro  (e.g. PCI_IO_VIRT_BASE).

What I think we should end up with is a generic implementation like

/* 
 * architectures with special needs may provide their own version,
 * but most should be able to use this one.
 */
unsigned long __weak pci_ioremap_iospace(struct resource *bus, unsigned long cpu)
{
#ifdef PCI_IO_VIRT_BASE
	/* find free space, ioremap the bus address, return the offset */
	...
#endif

	/* this architecture doesn't have memory mapped I/O space,
	   so this function should never be called */
	WARN_ON(1);
	return -ENODEV;
}

	Arnd
