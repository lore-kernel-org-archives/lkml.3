Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbaFSFbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:31:04 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:2705
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750919AbaFSFbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:31:02 -0400
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH] vfio: Fix endianness handling for emulated BARs
Thread-Topic: [PATCH] vfio: Fix endianness handling for emulated BARs
Thread-Index: AQHPi3FfKKoPa5JbGE+Tvq+WWWMh2pt35cXw
Date: Thu, 19 Jun 2014 05:30:39 +0000
Message-ID: <0df01f652acd446fa6db39f7049d6e72@BLUPR03MB566.namprd03.prod.outlook.com>
References: <1403091391-31780-1-git-send-email-aik@ozlabs.ru>
 <1403116512.3707.175.camel@ul30vt.home> <53A233E9.6030006@ozlabs.ru>
 <53A241F6.9010307@ozlabs.ru> <53A25D74.5000804@ozlabs.ru>
In-Reply-To: <53A25D74.5000804@ozlabs.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(199002)(189002)(24454002)(377424004)(377454003)(51704005)(13464003)(479174003)(83322001)(4477795004)(81342001)(19580395003)(74662001)(19580405001)(74502001)(80022001)(105586002)(95666004)(15975445006)(99286002)(101416001)(93886003)(20776003)(46102001)(66066001)(31966008)(64706001)(99396002)(77982001)(86362001)(21056001)(83072002)(85852003)(50986999)(87936001)(54356999)(33646001)(4396001)(76176999)(79102001)(2656002)(92566001)(76482001)(74316001)(85306003)(81542001)(106116001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB568;H:BLUPR03MB566.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Bharat.Bhushan@freescale.com; 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5J5VApl024039



> -----Original Message-----
> From: Linuxppc-dev [mailto:linuxppc-dev-
> bounces+bharat.bhushan=freescale.com@lists.ozlabs.org] On Behalf Of Alexey
> Kardashevskiy
> Sent: Thursday, June 19, 2014 9:18 AM
> To: Alex Williamson
> Cc: kvm@vger.kernel.org; Nikunj A Dadhania; linux-kernel@vger.kernel.org;
> Alexander Graf; linuxppc-dev@lists.ozlabs.org
> Subject: Re: [PATCH] vfio: Fix endianness handling for emulated BARs
> 
> On 06/19/2014 11:50 AM, Alexey Kardashevskiy wrote:
> > On 06/19/2014 10:50 AM, Alexey Kardashevskiy wrote:
> >> On 06/19/2014 04:35 AM, Alex Williamson wrote:
> >>> On Wed, 2014-06-18 at 21:36 +1000, Alexey Kardashevskiy wrote:
> >>>> VFIO exposes BARs to user space as a byte stream so userspace can
> >>>> read it using pread()/pwrite(). Since this is a byte stream, VFIO
> >>>> should not do byte swapping and simply return values as it gets
> >>>> them from PCI device.
> >>>>
> >>>> Instead, the existing code assumes that byte stream in read/write
> >>>> is little-endian and it fixes endianness for values which it passes
> >>>> to ioreadXX/iowriteXX helpers. This works for little-endian as PCI
> >>>> is little endian and le32_to_cpu/... are stubs.
> >>>
> >>> vfio read32:
> >>>
> >>> val = cpu_to_le32(ioread32(io + off));
> >>>
> >>> Where the typical x86 case, ioread32 is:
> >>>
> >>> #define ioread32(addr)          readl(addr)
> >>>
> >>> and readl is:
> >>>
> >>> __le32_to_cpu(__raw_readl(addr));
> >>>
> >>> So we do canceling byte swaps, which are both nops on x86, and end
> >>> up returning device endian, which we assume is little endian.
> >>>
> >>> vfio write32 is similar:
> >>>
> >>> iowrite32(le32_to_cpu(val), io + off);
> >>>
> >>> The implicit cpu_to_le32 of iowrite32() and our explicit swap cancel
> >>> out, so input data is device endian, which is assumed little.
> >>>
> >>>> This also works for big endian but rather by an accident: it reads
> >>>> 4 bytes from the stream (@val is big endian), converts to CPU
> >>>> format (which should be big endian) as it was little endian (@val
> >>>> becomes actually little
> >>>> endian) and calls iowrite32() which does not do swapping on big
> >>>> endian system.
> >>>
> >>> Really?
> >>>
> >>> In arch/powerpc/kernel/iomap.c iowrite32() is just a wrapper around
> >>> writel(), which seems to use the generic implementation, which does
> >>> include a cpu_to_le32.
> >>
> >>
> >> Ouch, wrong comment. iowrite32() does swapping. My bad.
> >>
> >>
> >>>
> >>> I also see other big endian archs like parisc doing cpu_to_le32 on
> >>> iowrite32, so I don't think this statement is true.  I imagine it's
> >>> probably working for you because the swap cancel.
> >>>
> >>>> This removes byte swapping and makes use ioread32be/iowrite32be
> >>>> (and 16bit versions) on big-endian systems. The "be" helpers take
> >>>> native endian values and do swapping at the moment of writing to a
> >>>> PCI register using one of "store byte-reversed" instructions.
> >>>
> >>> So now you want iowrite32() on little endian and iowrite32be() on
> >>> big endian, the former does a cpu_to_le32 (which is a nop on little
> >>> endian) and the latter does a cpu_to_be32 (which is a nop on big endian)...
> >>> should we just be using __raw_writel() on both?
> >>
> >>
> >> We can do that too. The beauty of iowrite32be on ppc64 is that it
> >> does not swap and write separately, it is implemented via the "Store
> >> Word Byte-Reverse Indexed X-form" single instruction.
> >>
> >> And some archs (do not know which ones) may add memory barriers in
> >> their implementations of ioread/iowrite. __raw_writel is too raw :)
> >>
> >>>  There doesn't actually
> >>> seem to be any change in behavior here, it just eliminates
> >>> back-to-back byte swaps, which are a nop on x86, but not power, right?
> >>
> >> Exactly. No dependency for QEMU.
> >
> > How about that:
> > ===
> >
> > VFIO exposes BARs to user space as a byte stream so userspace can read
> > it using pread()/pwrite(). Since this is a byte stream, VFIO should
> > not do byte swapping and simply return values as it gets them from PCI
> > device.
> >
> > Instead, the existing code assumes that byte stream in read/write is
> > little-endian and it fixes endianness for values which it passes to
> > ioreadXX/iowriteXX helpers in native format. The IO helpers do
> > swapping again. Since both byte swaps are nops on little-endian host, this
> works.
> >
> > This also works for big endian but rather by an accident: it reads 4
> > bytes from the stream (@val is big endian), converts to CPU format
> > (which should be big endian) as it was little endian (and @val becomes
> > actually little
> > endian) and calls iowrite32() which does swapping on big endian system
> > again. So byte swap gets cancelled, __raw_writel() receives a native
> > value and then *(volatile unsigned int __force *)PCI_FIX_ADDR(addr) =
> > v; just does the right thing.
> 
> I am wrong here, sorry. This is what happens when you watch soccer between 2am
> and 4am :)
> 
> 
> >
> > This removes byte swaps and makes use of ioread32be/iowrite32be (and
> > 16bit versions) which do explicit byte swapping at the moment of write
> > to a PCI register. PPC64 uses a special "Store Word Byte-Reverse
> > Indexed X-form" instruction which does swap and store.
> 
> No swapping is done here if we use ioread32be as it calls in_be32 and that
> animal does "lwz" which is simple load from memory.
> 
> So @val (16/32 bit variable on stack) will have different values on LE and BE
> but since we do not handle it the host and just memcpy it to the buffer, nothing
> breaks here.
> 
> 
> So it should be like this:
> ===
> VFIO exposes BARs to user space as a byte stream so userspace can read it using
> pread()/pwrite(). Since this is a byte stream, VFIO should not do byte swapping
> and simply return values as it gets them from PCI device and copy_to_user will
> save bytes in the correct same true for writes.

" copy_to_user will save bytes in the correct" ---? --- "same true for writes".

Thanks
-Bharat

> 
> Instead, the existing code assumes that byte stream in read/write is little-
> endian and it fixes endianness for values which it passes to ioreadXX/iowriteXX
> helpers in native format. The IO helpers do swapping again. Since both byte
> swaps are nops on little-endian host, this works.

> 
> This also works for big endian but rather by an accident: it reads 4 bytes from
> the stream (@val is big endian), converts to CPU format (which should be big
> endian) as it was little endian (and @val becomes actually little
> endian) and calls iowrite32() which does swapping on big endian system again. So
> byte swap in the host gets cancelled and __raw_writel() writes the value which
> was swapped originally by the guest.
> 
> This removes byte swaps and makes use of ioread32be/iowrite32be (and 16bit
> versions) which do not do byte swap on BE hosts.
> For LE hosts, ioread32/iowrite32 are still used.
> 
> ===
> 
> 
> > ===
> >
> > any better?
> >
> >
> >
> >
> >>>> Suggested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> >>>> ---
> >>>>  drivers/vfio/pci/vfio_pci_rdwr.c | 20 ++++++++++++++++----
> >>>>  1 file changed, 16 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c
> >>>> b/drivers/vfio/pci/vfio_pci_rdwr.c
> >>>> index 210db24..f363b5a 100644
> >>>> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> >>>> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> >>>> @@ -21,6 +21,18 @@
> >>>>
> >>>>  #include "vfio_pci_private.h"
> >>>>
> >>>> +#ifdef __BIG_ENDIAN__
> >>>> +#define ioread16_native		ioread16be
> >>>> +#define ioread32_native		ioread32be
> >>>> +#define iowrite16_native	iowrite16be
> >>>> +#define iowrite32_native	iowrite32be
> >>>> +#else
> >>>> +#define ioread16_native		ioread16
> >>>> +#define ioread32_native		ioread32
> >>>> +#define iowrite16_native	iowrite16
> >>>> +#define iowrite32_native	iowrite32
> >>>> +#endif
> >>>> +
> >>>>  /*
> >>>>   * Read or write from an __iomem region (MMIO or I/O port) with an
> excluded
> >>>>   * range which is inaccessible.  The excluded range drops writes
> >>>> and fills @@ -50,9 +62,9 @@ static ssize_t do_io_rw(void __iomem *io, char
> __user *buf,
> >>>>  				if (copy_from_user(&val, buf, 4))
> >>>>  					return -EFAULT;
> >>>>
> >>>> -				iowrite32(le32_to_cpu(val), io + off);
> >>>> +				iowrite32_native(val, io + off);
> >>>>  			} else {
> >>>> -				val = cpu_to_le32(ioread32(io + off));
> >>>> +				val = ioread32_native(io + off);
> >>>>
> >>>>  				if (copy_to_user(buf, &val, 4))
> >>>>  					return -EFAULT;
> >>>> @@ -66,9 +78,9 @@ static ssize_t do_io_rw(void __iomem *io, char __user
> *buf,
> >>>>  				if (copy_from_user(&val, buf, 2))
> >>>>  					return -EFAULT;
> >>>>
> >>>> -				iowrite16(le16_to_cpu(val), io + off);
> >>>> +				iowrite16_native(val, io + off);
> >>>>  			} else {
> >>>> -				val = cpu_to_le16(ioread16(io + off));
> >>>> +				val = ioread16_native(io + off);
> >>>>
> >>>>  				if (copy_to_user(buf, &val, 2))
> >>>>  					return -EFAULT;
> >>>
> >>>
> >>>
> >>
> >>
> >
> >
> 
> 
> --
> Alexey
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
