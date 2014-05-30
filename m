Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbaE3LeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:34:13 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:63070 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaE3LeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:34:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: josh@joshtriplett.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit and 32-bit ports
Date: Fri, 30 May 2014 13:32:50 +0200
Message-ID: <4845518.edhUzAktsU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5387385B.1030203@zytor.com>
References: <20140509191914.GA7286@jtriplet-mobl1> <16228376.RHijyT1ZPk@wuerfel> <5387385B.1030203@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Bc/JxfOGp4C8/jzV+X2+peqdTzZN5nM8aMANNSJbZ0R
 3arAIIvPY7Bciivxtgu1GLvm5S+1xBmvOmVhal1avPqXUuFUst
 Oc0/LEjvmAbKYpJwfoBojiYSCMXpRsimPz/TW+hjdDQT+nw9Tr
 45xGPWnCeok5tzfZKoPHi5cpmWM2iOZy2vkVpsXp35kk3fdubp
 bnNlv5bzQhN8dqLMvQ3U5fTu+ME51lIUSbs1O/KagwEPUuqyb3
 8owJF+291X7rzlJW5b9WQ3h01A4NXQ80Cb8lUWZGU9U4p6fcBA
 juIr/o8ZGrHUNr/7KVNXccHeXTVvvhIYYStKCMg22Kd4xrQkGc
 ijOH9E9dQVyHSzlyvkSo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 May 2014 06:38:35 H. Peter Anvin wrote:
> On 05/29/2014 02:26 AM, Arnd Bergmann wrote:
> > On Wednesday 28 May 2014 14:41:52 H. Peter Anvin wrote:
> >> On 05/19/2014 05:36 AM, Arnd Bergmann wrote:
> >>>
> >>> My feeling is that all devices we can think of fall into at least one
> >>> of these categories:
> >>>
> >>> * legacy PC stuff that needs only byte access
> >>> * PCI devices that can be accessed through sysfs
> >>> * devices on x86 that can be accessed using iopl
> >>>
> >>
> >> I don't believe PCI I/O space devices can be accessed through sysfs, but
> >> perhaps I'm wrong?  (mmapping I/O space is not portable.)
> > 
> > The interface is there, both a read/write and mmap on the resource
> > bin_attribute. But it seems you're right, neither of them is implemented
> > on all architectures.
> > 
> > Only powerpc, microblaze, alpha, sparc and xtensa allow users to mmap
> > I/O space, even though a lot of others could. The read-write interface
> > is only defined for alpha, ia64, microblaze and powerpc.
> > 
> 
> And how is that read/write interface defined?  Does it have the same
> silly handling of data sizes?

In architecture specific code, e.g. for powerpc:

int pci_legacy_read(struct pci_bus *bus, loff_t port, u32 *val, size_t size)
{
        unsigned long offset;
        struct pci_controller *hose = pci_bus_to_host(bus);
        struct resource *rp = &hose->io_resource;
        void __iomem *addr;

        /* Check if port can be supported by that bus. We only check
         * the ranges of the PHB though, not the bus itself as the rules
         * for forwarding legacy cycles down bridges are not our problem
         * here. So if the host bridge supports it, we do it.
         */
        offset = (unsigned long)hose->io_base_virt - _IO_BASE;
        offset += port;

        if (!(rp->flags & IORESOURCE_IO))
                return -ENXIO;
        if (offset < rp->start || (offset + size) > rp->end)
                return -ENXIO;
        addr = hose->io_base_virt + port;

        switch(size) {
        case 1:
                *((u8 *)val) = in_8(addr);
                return 1;
        case 2:
                if (port & 1)
                        return -EINVAL;
                *((u16 *)val) = in_le16(addr);
                return 2;
        case 4:
                if (port & 3)
                        return -EINVAL;
                *((u32 *)val) = in_le32(addr);
                return 4;
        }
        return -EINVAL;
}

The common code already enforces size to be 1, 2 or 4.

	Arnd
