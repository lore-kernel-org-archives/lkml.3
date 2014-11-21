Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbaKUM0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:26:30 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:59186 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbaKUM02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:26:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Myron Stowe <myron.stowe@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        rjw@rjwysocki.net, lorenzo.pieralisi@arm.com,
        linaro-acpi@lists.linaro.org, linux-pci <linux-pci@vger.kernel.org>,
        catalin.marinas@arm.com, x86 <x86@kernel.org>, will.deacon@arm.com,
        LKML <linux-kernel@vger.kernel.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, hanjun.guo@linaro.org,
        "H. Peter Anvin" <hpa@zytor.com>, wangyijing@huawei.com,
        Liviu.Dudau@arm.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] pci, acpi: Share ACPI PCI config space accessors.
Date: Fri, 21 Nov 2014 13:24:52 +0100
Message-ID: <3957412.IooRKpIXjW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL-B5D3MqUa-=bzebo12DbZfczss2-MdGwQ8WKTbFH8H2AENXg@mail.gmail.com>
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org> <20141120222650.GC7987@google.com> <CAL-B5D3MqUa-=bzebo12DbZfczss2-MdGwQ8WKTbFH8H2AENXg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:RBeZYBrV61J36Gc/XrY+6mi+A76e84HKmuwcZ4iSk6k
 X/3PNBfksXE2Q6YiLC0wT58mEVQ4FR0sEm3F2JiByYCB6O69X3
 LvZWAero+5pXv4+e0WB63S5GHAvBxHZajWMgdwjEVwvXz4ytZm
 erN805XUIiHNLRVOq0vijPQTn544rktGSwbj4tg1W7WC0oBRks
 S8MV4vIQT8/6i9z+gZUZpBZ2JUVf9EjbmUMl8nRhkL2IytEPrM
 MUvL+2OvrzZ/3R3fO4eXOxPZoZs0KJjvpyIAZ4758s0PbPLCBY
 hrhl3l32eyLBj6rL/vjCfORUQusEPgC7uZYJe+FjkFPwDSYjAN
 0aOu6GAuOzE1IiwTVdLk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2014 21:00:17 Myron Stowe wrote:
> On Thu, Nov 20, 2014 at 3:26 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Wed, Nov 19, 2014 at 05:19:20PM +0100, Arnd Bergmann wrote:
> >> On Wednesday 19 November 2014 17:04:51 Tomasz Nowicki wrote:
> >> > +/*
> >> > + * raw_pci_read/write - ACPI PCI config space accessors.
> >> > + *
> >> > + * ACPI spec defines MMCFG as the way we can access PCI config space,
> >> > + * so let MMCFG be default (__weak).
> >> > + *
> >> > + * If platform needs more fancy stuff, should provides its own implementation.
> >> > + */
> >> > +int __weak raw_pci_read(unsigned int domain, unsigned int bus,
> >> > +                       unsigned int devfn, int reg, int len, u32 *val)
> >> > +{
> >> > +       return pci_mmcfg_read(domain, bus, devfn, reg, len, val);
> >> > +}
> >> > +
> >> > +int __weak raw_pci_write(unsigned int domain, unsigned int bus,
> >> > +                        unsigned int devfn, int reg, int len, u32 val)
> >> > +{
> >> > +       return pci_mmcfg_write(domain, bus, devfn, reg, len, val);
> >> > +}
> >> > +
> >> >
> >>
> >> I think it would be better to avoid __weak functions here, as they tend
> >> to be hard to follow when trying to understand the code.
> >
> > That's interesting.  I would have said exactly the opposite -- I think the
> > extra Kconfiggery is harder to follow than weak/strong functions 
> >
> > But consistency is better than my personal opinion.  Is there a consensus
> > that we should use the Kconfig strategy instead of __weak?
> 
> I too find weak/strong functions easier to follow than "Kconfiggery" (nice term
> invention there).

I don't think there is a universal consensus, but the majority of
maintainers seems to avoid them for the same reasons that I think
__weak is problematic.

We have some uses of __weak in the core kernel, but there is
basically none in drivers outside of PCI, and the most common
uses are all providing an empty __weak function that can be
overridden with a function that actually does something, unlike
the code above.

My pragmatic approach so far has been to advocate __weak for
drivers/pci patches but discourage it elsewhere when I review
patches, in order to maintain consistency. I also think it
would be nice to change the way that PCI handles architecture
specific overrides in the process of unifying the host bridge
handling.

I wouldn't use Kconfig symbols in most cases though. My preferred
choice would be to turn a lot of the __weak symbols into function
pointers within a per-hostbridge structure. As an example, we could
replace pcibios_add_device() with a pointer in pci_host_bridge->ops
that gets set by all the architectures and host drivers that currently
override it, and replace the one caller with

	if (pci_host_bridge->ops->add_device)
		pci_host_bridge->ops->add_device(dev);

	Arnd
