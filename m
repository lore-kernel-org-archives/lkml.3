Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaBINWF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:22:05 -0500
Received: from know-smtprelay-omc-2.server.virginmedia.net ([80.0.253.66]:37465
	"EHLO know-smtprelay-omc-2.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaBINWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:22:01 -0500
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2014 08:22:00 EST
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.1 cv=L4GTQoj8 c=1 sm=1 tr=0 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
 a=rTb9Q+mClrhkGV9Ah9iRIA==:17 a=N1CowNylAAAA:8 a=fopZr8Ys9qIA:10
 a=IkcTkHD0fZMA:10 a=i-oMMPxEfaEA:10 a=VJyg0JVv8vjEN_qe9_UA:9 a=QEXdDO2ut3YA:10
Message-ID: <1391951759.6036.7.camel@artifact>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset
 flushing
From: Steven Newbury <steve@snewbury.org.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Paul Bolle <pebolle@tiscali.nl>, David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Sun, 09 Feb 2014 13:15:59 +0000
In-Reply-To: <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
References: <1391886379.2669.11.camel@x41>
	 <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
	 <1391890927.1882.5.camel@x41>
	 <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 01:02 +0100, Daniel Vetter wrote:
> On Sat, Feb 8, 2014 at 9:22 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > Daniel Vetter schreef op za 08-02-2014 om 20:59 [+0100]:
> >> Hm, if this is really a regression between 3.13 and 3.14-rc1 then I
> >> don't see any quick candidates - relevant functions in intel-gtt.c
> >> seem unchanged.
> >>
> >> So probably a bisect is what we need here. Note that this could also
> >> be due to resource handling changes in the driver/pci core, so you
> >> can't restrict the bisect really.
> >
> > The last bisect on this machine took over 20 builds to pinpoint the
> > offending commit. So that's bad news ...
> 
> Somehow we can't allocate the flush page resource any more, but I
> don't have any idea what. There's nothing occupying the old spot (the
> usual reason why resource management goes boom), so dunno why this
> doesn't work any more. I think bisecting is the most fruitful avenue
> here.
> -Daniel
> 
> 
> >
> >>  But before going down this route it
> >> would be worth to check out the resource allocations of both kernels.
> >> Can you please attach /proc/iomem for both 3.13 and 3.14-rc1
> >
> > The diff between /proc/iomem on v3.13.2 and v3.14-rc1 is:
> > --- iomem-3.13.2        2014-02-08 21:14:30.214030591 +0100
> > +++ iomem-3.14-rc1      2014-02-08 21:07:22.041189158 +0100
> > @@ -11,16 +11,13 @@
> >    000e0000-000effff : Extension ROM
> >    000f0000-000fffff : System ROM
> >  00100000-7f6dffff : System RAM
> > -  00400000-009af63a : Kernel code
> > -  009af63b-00c932ff : Kernel data
> > -  00d4f000-00e4dfff : Kernel bss
> > +  00400000-009c57bf : Kernel code
> > +  009c57c0-00cb6aff : Kernel data
> > +  00d78000-00e74fff : Kernel bss
> >  7f6e0000-7f6f4fff : ACPI Tables
> >  7f6f5000-7f6fffff : ACPI Non-volatile Storage
> >  7f700000-7fffffff : reserved
> >    7f800000-7fffffff : Graphics Stolen Memory
> > -80000000-801fffff : PCI Bus 0000:02
> > -80200000-8027ffff : 0000:00:02.1
> > -80280000-80280fff : Intel Flush Page
> >  a0000000-a003ffff : 0000:00:02.0
> >  a0040000-a00403ff : 0000:00:1d.7
> >    a0040000-a00403ff : ehci_hcd
> >
> > /proc/iomem for v3.13.2:
> > 00000000-00000fff : reserved
> > 00001000-0009efff : System RAM
> > 0009f000-0009ffff : reserved
> > 000a0000-000bffff : Video RAM area
> > 000c0000-000c7fff : Video ROM
> > 000c8000-000cbfff : pnp 00:00
> > 000cf800-000d3fff : reserved
> >   000cf800-000d0dff : Adapter ROM
> >   000d1000-000d1fff : Adapter ROM
> > 000dc000-000fffff : reserved
> >   000e0000-000effff : Extension ROM
> >   000f0000-000fffff : System ROM
> > 00100000-7f6dffff : System RAM
> >   00400000-009af63a : Kernel code
> >   009af63b-00c932ff : Kernel data
> >   00d4f000-00e4dfff : Kernel bss
> > 7f6e0000-7f6f4fff : ACPI Tables
> > 7f6f5000-7f6fffff : ACPI Non-volatile Storage
> > 7f700000-7fffffff : reserved
> >   7f800000-7fffffff : Graphics Stolen Memory
> > 80000000-801fffff : PCI Bus 0000:02
> > 80200000-8027ffff : 0000:00:02.1
> > 80280000-80280fff : Intel Flush Page
> > a0000000-a003ffff : 0000:00:02.0
> > a0040000-a00403ff : 0000:00:1d.7
> >   a0040000-a00403ff : ehci_hcd
> > a0040400-a00404ff : 0000:00:1e.2
> >   a0040400-a00404ff : Intel ICH6
> > a0040800-a00409ff : 0000:00:1e.2
> >   a0040800-a00409ff : Intel ICH6
> > a0080000-a00fffff : 0000:00:02.0
> > a0100000-a01fffff : PCI Bus 0000:02
> >   a0100000-a010ffff : 0000:02:00.0
> >     a0100000-a010ffff : tg3
> > a0200000-afffffff : PCI Bus 0000:04
> >   a0200000-a0200fff : 0000:04:00.0
> >     a0200000-a0200fff : yenta_socket
> >   a0201000-a02010ff : 0000:04:00.1
> >     a0201000-a02010ff : mmc0
> >   a0202000-a0202fff : 0000:04:02.0
> >     a0202000-a0202fff : ipw2200
> >   a4000000-a7ffffff : PCI CardBus 0000:05
> > c0000000-cfffffff : 0000:00:02.0
> > d0000000-d7ffffff : PCI Bus 0000:04
> >   d0000000-d3ffffff : PCI CardBus 0000:05
> > e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
> >   e0000000-efffffff : reserved
> >     e0000000-efffffff : pnp 00:01
> > f0008000-f000bfff : reserved
> >   f0008000-f000bfff : pnp 00:01
> >     f000b410-f000b414 : iTCO_wdt
> >       f000b410-f000b414 : iTCO_wdt
> > fec00000-fec0ffff : reserved
> >   fec00000-fec003ff : IOAPIC 0
> > fed14000-fed19fff : reserved
> >   fed14000-fed17fff : pnp 00:01
> >   fed18000-fed18fff : pnp 00:01
> >   fed19000-fed19fff : pnp 00:01
> > fed20000-fed8ffff : reserved
> > fee00000-fee00fff : Local APIC
> >   fee00000-fee00fff : reserved
> > ff000000-ffffffff : reserved
> >
> > /proc/iomem for v3.14-rc1:
> > 00000000-00000fff : reserved
> > 00001000-0009efff : System RAM
> > 0009f000-0009ffff : reserved
> > 000a0000-000bffff : Video RAM area
> > 000c0000-000c7fff : Video ROM
> > 000c8000-000cbfff : pnp 00:00
> > 000cf800-000d3fff : reserved
> >   000cf800-000d0dff : Adapter ROM
> >   000d1000-000d1fff : Adapter ROM
> > 000dc000-000fffff : reserved
> >   000e0000-000effff : Extension ROM
> >   000f0000-000fffff : System ROM
> > 00100000-7f6dffff : System RAM
> >   00400000-009c57bf : Kernel code
> >   009c57c0-00cb6aff : Kernel data
> >   00d78000-00e74fff : Kernel bss
> > 7f6e0000-7f6f4fff : ACPI Tables
> > 7f6f5000-7f6fffff : ACPI Non-volatile Storage
> > 7f700000-7fffffff : reserved
> >   7f800000-7fffffff : Graphics Stolen Memory
> > a0000000-a003ffff : 0000:00:02.0
> > a0040000-a00403ff : 0000:00:1d.7
> >   a0040000-a00403ff : ehci_hcd
> > a0040400-a00404ff : 0000:00:1e.2
> >   a0040400-a00404ff : Intel ICH6
> > a0040800-a00409ff : 0000:00:1e.2
> >   a0040800-a00409ff : Intel ICH6
> > a0080000-a00fffff : 0000:00:02.0
> > a0100000-a01fffff : PCI Bus 0000:02
> >   a0100000-a010ffff : 0000:02:00.0
> >     a0100000-a010ffff : tg3
> > a0200000-afffffff : PCI Bus 0000:04
> >   a0200000-a0200fff : 0000:04:00.0
> >     a0200000-a0200fff : yenta_socket
> >   a0201000-a02010ff : 0000:04:00.1
> >     a0201000-a02010ff : mmc0
> >   a0202000-a0202fff : 0000:04:02.0
> >     a0202000-a0202fff : ipw2200
> >   a4000000-a7ffffff : PCI CardBus 0000:05
> > c0000000-cfffffff : 0000:00:02.0
> > d0000000-d7ffffff : PCI Bus 0000:04
> >   d0000000-d3ffffff : PCI CardBus 0000:05
> > e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
> >   e0000000-efffffff : reserved
> >     e0000000-efffffff : pnp 00:01
> > f0008000-f000bfff : reserved
> >   f0008000-f000bfff : pnp 00:01
> >     f000b410-f000b414 : iTCO_wdt
> >       f000b410-f000b414 : iTCO_wdt
> > fec00000-fec0ffff : reserved
> >   fec00000-fec003ff : IOAPIC 0
> > fed14000-fed19fff : reserved
> >   fed14000-fed17fff : pnp 00:01
> >   fed18000-fed18fff : pnp 00:01
> >   fed19000-fed19fff : pnp 00:01
> > fed20000-fed8ffff : reserved
> > fee00000-fee00fff : Local APIC
> >   fee00000-fee00fff : reserved
> > ff000000-ffffffff : reserved
> >
> > Thanks,
> >
> >
> > Paul Bolle
> >
> 
> 
> 

PCI resource allocation is undergoing some changes at the moment, it's
definitely a bug if the Flush Page isn't getting allocated.  I'm looking
forward to hopefully getting pci_bus_alloc_resource_fit() behaviour in
mainline, it will provide much better resource allocation in the 32 bit
PCI address space, and prevent problems like this from cropping up.

See Yinghai Lu's for-pci-res-alloc branch.

I've been carrying the changes in my local tree, but right now the
upstream PCI changes are quite extensive.  He's planning on rebasing the
branch soon.



