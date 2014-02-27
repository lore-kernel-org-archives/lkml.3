Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaB0TsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:48:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:59996 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaB0TsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:48:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Thu, 27 Feb 2014 20:48:08 +0100
Message-ID: <5379319.g8IPYmY2Zo@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140227193627.GA7773@obsidianresearch.com>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com> <20140227191259.GA31753@bart.dudau.co.uk> <20140227193627.GA7773@obsidianresearch.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:x9pvmFmbA72JIofL4MHv4SFRvND3QAuFiDdTrwo07FG
 DqZO/L7cIt46qarhxb/lrUpPfmAixvYBKHJ0umJlXg4CDFT8zc
 jhLb1HeaggTUxnyFvfmluaVM5KKuU7Rv9xdd5xmCYW+mBFDwyZ
 gb7Xkp0/BBsG2AaAMPOng2pWgKvNtIAjm3KsO2TgcPFxGbVurX
 KHm65qqpKdMDmofZTXJnx7tEk5SiosXwQqDmIQEYg4kjPbvIu6
 x2zrvH1gU1H0MzAgv0xN9oj3/L+4SomHjESEG0M34SjbmlNy9d
 TWgEXhqqrySSiNItvVeNle9bFASm2nCbBv2qHzaqsUm4kcr77C
 aTaBYasyL/iSDKDwtDIc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 12:36:27 Jason Gunthorpe wrote:
> On Thu, Feb 27, 2014 at 07:12:59PM +0000, Liviu Dudau wrote:
> > The outstanding issue is how to fix pci_address_to_pio() as it will not
> > for for range->cpu_addr > IO_SPACE_LIMIT (16MB in my case).
> 
> The default actually looks fine to me, it is the correct behavior for
> systems that actually have a dedicated IO space (like x86) where the
> 'CPU' value for IO is the exact value used in the IO accessor
> instructions. In this case the IO_SPACE_LIMIT test is appropriate.

Right.

> It also looks correct for architectures that use the CPU MMIO address
> as the IO address directly (where IO_SPACE_LIMIT would be 4G)

Are you aware of any that still do? I thought we had stopped doing
that.

> Architectures that use the virtual IO window technique will always
> require a custom pci_address_to_pio implementation.

Hmm, at the moment we only call it from of_address_to_resource(),
which in turn does not get called on PCI devices, and does not
call pci_address_to_pio for 'simple' platform devices. The only
case I can think of where it actually matters is when we have
ISA devices in DT that use an I/O port address in the reg property,
and that case hopefully won't happen on ARM32 or ARM64.

> BTW, something that occured to me after reading the patches:
> 
> For ARM64 you might want to think about doing away with the fixed
> virtual IO window like we see in ARM32. Just use the CPU MMIO address
> directly within the kernel, and implement a ioport_map to setup the MM
> on demand.
> 
> I think the legacy reasons for having all those layers of translation
> are probably not applicable to ARM64, and it is much simpler without
> the extra translation step....
> 
> Arnd, what do you think?

Either I don't like it or I misunderstand you ;-)

Most PCI drivers normally don't call ioport_map or pci_iomap, so
we can't just do it there. If you are thinking of calling ioport_map
for every PCI device that has an I/O BAR and storing the virtual
address in the pci_dev resource, I don't see what that gains us
in terms of complexity, and it will also break /dev/port.

	Arnd
