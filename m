Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaCJQdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:33:50 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39789 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbaCJQdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:33:47 -0400
Date: Mon, 10 Mar 2014 16:33:44 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v6 6/6] pci: Add support for creating a generic
 host_bridge from device tree
Message-ID: <20140310163343.GY6457@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Bjorn Helgaas <bhelgaas@google.com>
References: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com>
 <201403081815.08829.arnd@arndb.de>
 <20140310144414.GT6457@e106497-lin.cambridge.arm.com>
 <2115856.ZTdgp5fkma@wuerfel>
MIME-Version: 1.0
In-Reply-To: <2115856.ZTdgp5fkma@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 10 Mar 2014 16:33:44.0908 (UTC) FILETIME=[8140B0C0:01CF3C7E]
X-MC-Unique: 114031016334506801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 03:21:01PM +0000, Arnd Bergmann wrote:
> On Monday 10 March 2014 14:44:14 Liviu Dudau wrote:
> > I will try to improve the error handling in the next patchset version.
> > However I am still confused about the earlier discussion on
> > pci_register_io_range(). Your suggestion initially was to return an
> > error in the default weak implementation, but in your last email you
> > are talking about returning 'port'.
> 
> You can do either one: 'port' should be positive or zero, while the
> error would always be negative. We do the same thing in many interfaces
> in the kernel.
> 
> > My idea when I've introduced the
> > helper function was that it would return an error if it fails to
> > register the IO range and zero otherwise. I agree that we can treat
> > the default 'do nothing with the IO range' case as an error, with
> > the caveat that will force architectures that use this code to
> > provide their own implementation of pci_register_io_range() in order
> > to avoid failure, even for the cases where the architecture has a 1:1
> > mapping between IO and CPU addresses.
> 
> Which architectures are you thinking of? The only one I know that
> does this is ia64, and we won't ever have to support this helper
> on that architecture.

I was thinking about architectures that have IO_SPACE_LIMIT >= 0xffffffff.
While not an absolute indicator, with the default pci_address_to_pio()
that means that they can use the CPU MMIO address as IO address directly.

$ git grep IO_SPACE_LIMIT | grep -i ffffffff
arch/arm/include/asm/io.h:#define IO_SPACE_LIMIT ((resource_size_t)0xffffffff)
arch/arm/mach-at91/include/mach/io.h:#define IO_SPACE_LIMIT		0xFFFFFFFF
arch/arm/mach-omap1/include/mach/io.h:#define IO_SPACE_LIMIT 0xffffffff
arch/arm/mach-pxa/include/mach/io.h:#define IO_SPACE_LIMIT 0xffffffff
arch/arm/mach-s3c24xx/include/mach/io.h:#define IO_SPACE_LIMIT 0xffffffff
arch/avr32/include/asm/io.h:#define IO_SPACE_LIMIT	0xffffffff
arch/frv/include/asm/io.h:#define IO_SPACE_LIMIT	0xffffffff
arch/ia64/include/asm/io.h:#define IO_SPACE_LIMIT		0xffffffffffffffffUL
arch/m32r/include/asm/io.h:#define IO_SPACE_LIMIT  0xFFFFFFFF
arch/m68k/include/asm/io_no.h:#define IO_SPACE_LIMIT 0xffffffff
arch/microblaze/include/asm/io.h:#define IO_SPACE_LIMIT (0xFFFFFFFF)
arch/mn10300/include/asm/io.h:#define IO_SPACE_LIMIT 0xffffffff
arch/sh/include/asm/io.h:#define IO_SPACE_LIMIT 0xffffffff
arch/sparc/include/asm/io_32.h:#define IO_SPACE_LIMIT 0xffffffff
arch/sparc/include/asm/io_64.h:#define IO_SPACE_LIMIT 0xffffffffffffffffUL
arch/tile/include/asm/io.h:#define IO_SPACE_LIMIT 0xffffffff


> 
> I did not ask to treat 'do nothing with the IO range' as an error,
> what I meant is that we should treat 'architecture cannot translate
> from I/O space to memory space but DT lists a translation anyway'
> as an error. On x86, you should never see an entry for the I/O space
> in "ranges", so we will not call this function unless there is a
> bug in DT.

Ok, it's just that there is no "architecture cannot translate from I/O
space to memory space" indicator anywhere and I don't want to make x86
a special case.

So, my proposal is this: default weak implementation of pci_register_io_range()
returns an error (meaning I have no idea how to translate IO addresses
to memory space) and anyone that wants this function to return success will
have to provide their implementation.

I will send an updated series.

Best regards,
Liviu

> 
> 	Arnd
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

