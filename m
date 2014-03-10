Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaCJP6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:58:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53283 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaCJP6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:58:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v5 1/7] pci: Introduce pci_register_io_range() helper function.
Date: Mon, 10 Mar 2014 16:57:42 +0100
Message-ID: <1852456.hNkOzqVe7y@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140310144519.GU6457@e106497-lin.cambridge.arm.com>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com> <201403070124.13139.arnd@arndb.de> <20140310144519.GU6457@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OWbyi0Ogp5acA7mSrALjQ11FXex9CqjVOGeucuguoZZ
 0VRTUj9i3g2dCn4teiT4FFHIh3dEFxhxqVGQG/sR8JuHYNBTUS
 hs2noM/4WrDTy5BU8bMfpyhWHWw8fxgzkflaeSbanOpiOGG5FN
 7TkKdpWXIVum+sWTGWdltIvUVkNIY5cINUTBnHvvXLG7Lt6FSO
 EoqthjhXY2ZWKpB7n96vGlvv1e0r4ehU8N2vvLCfI8gPB69QAv
 B75mn1RR7C5IldPQJSJwNNSwUP5/y7fNiPT0Y02vLwyA2lbJce
 Dv2C06xksvdPIeoxQS1rvQPJxZZW/qvhmPP8WRLHipVSa82wb7
 1NkRw8D4UoOAPDtx1FAk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2014 14:45:19 Liviu Dudau wrote:
> 
> So, if I understand you correctly, you would prefer to fail here and hence stop the
> parsing for the x86, rather than pretending everything is OK and going through the
> motions?

Yes, on x86 it is clearly a bug if we end up calling this function.

> That was not my original thinking when I've introduced this function here. The main
> purpose of the function is to help the correct translation of IO addresses in
> pci_address_to_pio(). As Jason has explained very nicely, we have 3 types of
> architectures here that we try to support:
>   - the ones that have separate IO address space (x86)
>   - the ones that have 1:1 mapping between physical IO addresses and logical ports

Still not convinced this second one actually exists.

>   - the architectures that memory map the IO addresses in virtual address space
>     and then translate the logical addresses into virtual based on a given offset.
> 
> For the first two types we don't want to do anything special. Architectures that
> fall in the last category will have to provide their own version of this function,
> with the arm64 version being generic enough to be used as de facto?

The page flags might be different across architectures: arm32 currently uses
MT_DEVICE, which only exists on arm32 and derived architectures (unicore32,
arm64).

> But I can see your point of view as well. I just don't know if that is good enough
> for powerpc and microblaze. With the way things are in my patch, they should be able
> to switch to of_create_pci_host_bridge() easily*, with your suggestion they will
> have to provide their implementation for pci_register_io_range().

I think there would still be a lot to do have powerpc switch over to
of_create_pci_host_bridge(), the more likely thing to happen is to have
that architecture implement its own copy that calls the same internal helpers
and does some more things that we may not want on other architectures.

Microblaze can probably be changed to use of_create_pci_host_bridge()
and need no custom code at all, it should need only a subset of what
we need for arm64.

> We really need to get another architecture converted. If there are no other takers I
> will make a stab once the current push towards upstreaming AArch64 hardware support
> slows down.

Moving over microblaze I think would be a good start. It has rather
specific requirements since there is only one host driver, but then again
that PCI host implementation might be shared with zynq (or synthesizable
there). I also wonder whether it's actually related to the X-gene PCI,
since I know some of the ppc4xx use Xilinx PCI and X-gene is also
based on those.

	Arnd
