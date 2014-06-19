Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaFSAvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 20:51:05 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54375 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaFSAvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 20:51:03 -0400
Message-ID: <53A233E9.6030006@ozlabs.ru>
Date: Thu, 19 Jun 2014 10:50:49 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Subject: Re: [PATCH] vfio: Fix endianness handling for emulated BARs
References: <1403091391-31780-1-git-send-email-aik@ozlabs.ru> <1403116512.3707.175.camel@ul30vt.home>
In-Reply-To: <1403116512.3707.175.camel@ul30vt.home>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 04:35 AM, Alex Williamson wrote:
> On Wed, 2014-06-18 at 21:36 +1000, Alexey Kardashevskiy wrote:
>> VFIO exposes BARs to user space as a byte stream so userspace can
>> read it using pread()/pwrite(). Since this is a byte stream, VFIO should
>> not do byte swapping and simply return values as it gets them from
>> PCI device.
>>
>> Instead, the existing code assumes that byte stream in read/write is
>> little-endian and it fixes endianness for values which it passes to
>> ioreadXX/iowriteXX helpers. This works for little-endian as PCI is
>> little endian and le32_to_cpu/... are stubs.
> 
> vfio read32:
> 
> val = cpu_to_le32(ioread32(io + off));
> 
> Where the typical x86 case, ioread32 is:
> 
> #define ioread32(addr)          readl(addr)
> 
> and readl is:
> 
> __le32_to_cpu(__raw_readl(addr));
> 
> So we do canceling byte swaps, which are both nops on x86, and end up
> returning device endian, which we assume is little endian.
> 
> vfio write32 is similar:
> 
> iowrite32(le32_to_cpu(val), io + off);
> 
> The implicit cpu_to_le32 of iowrite32() and our explicit swap cancel
> out, so input data is device endian, which is assumed little.
> 
>> This also works for big endian but rather by an accident: it reads 4 bytes
>> from the stream (@val is big endian), converts to CPU format (which should
>> be big endian) as it was little endian (@val becomes actually little
>> endian) and calls iowrite32() which does not do swapping on big endian
>> system.
> 
> Really?
> 
> In arch/powerpc/kernel/iomap.c iowrite32() is just a wrapper around
> writel(), which seems to use the generic implementation, which does
> include a cpu_to_le32.


Ouch, wrong comment. iowrite32() does swapping. My bad.


> 
> I also see other big endian archs like parisc doing cpu_to_le32 on
> iowrite32, so I don't think this statement is true.  I imagine it's
> probably working for you because the swap cancel.
> 
>> This removes byte swapping and makes use ioread32be/iowrite32be
>> (and 16bit versions) on big-endian systems. The "be" helpers take
>> native endian values and do swapping at the moment of writing to a PCI
>> register using one of "store byte-reversed" instructions.
> 
> So now you want iowrite32() on little endian and iowrite32be() on big
> endian, the former does a cpu_to_le32 (which is a nop on little endian)
> and the latter does a cpu_to_be32 (which is a nop on big endian)...
> should we just be using __raw_writel() on both?


We can do that too. The beauty of iowrite32be on ppc64 is that it does not
swap and write separately, it is implemented via the "Store Word
Byte-Reverse Indexed X-form" single instruction.

And some archs (do not know which ones) may add memory barriers in their
implementations of ioread/iowrite. __raw_writel is too raw :)

>  There doesn't actually
> seem to be any change in behavior here, it just eliminates back-to-back
> byte swaps, which are a nop on x86, but not power, right?

Exactly. No dependency for QEMU.


> 
>> Suggested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> ---
>>  drivers/vfio/pci/vfio_pci_rdwr.c | 20 ++++++++++++++++----
>>  1 file changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
>> index 210db24..f363b5a 100644
>> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
>> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
>> @@ -21,6 +21,18 @@
>>  
>>  #include "vfio_pci_private.h"
>>  
>> +#ifdef __BIG_ENDIAN__
>> +#define ioread16_native		ioread16be
>> +#define ioread32_native		ioread32be
>> +#define iowrite16_native	iowrite16be
>> +#define iowrite32_native	iowrite32be
>> +#else
>> +#define ioread16_native		ioread16
>> +#define ioread32_native		ioread32
>> +#define iowrite16_native	iowrite16
>> +#define iowrite32_native	iowrite32
>> +#endif
>> +
>>  /*
>>   * Read or write from an __iomem region (MMIO or I/O port) with an excluded
>>   * range which is inaccessible.  The excluded range drops writes and fills
>> @@ -50,9 +62,9 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
>>  				if (copy_from_user(&val, buf, 4))
>>  					return -EFAULT;
>>  
>> -				iowrite32(le32_to_cpu(val), io + off);
>> +				iowrite32_native(val, io + off);
>>  			} else {
>> -				val = cpu_to_le32(ioread32(io + off));
>> +				val = ioread32_native(io + off);
>>  
>>  				if (copy_to_user(buf, &val, 4))
>>  					return -EFAULT;
>> @@ -66,9 +78,9 @@ static ssize_t do_io_rw(void __iomem *io, char __user *buf,
>>  				if (copy_from_user(&val, buf, 2))
>>  					return -EFAULT;
>>  
>> -				iowrite16(le16_to_cpu(val), io + off);
>> +				iowrite16_native(val, io + off);
>>  			} else {
>> -				val = cpu_to_le16(ioread16(io + off));
>> +				val = ioread16_native(io + off);
>>  
>>  				if (copy_to_user(buf, &val, 2))
>>  					return -EFAULT;
> 
> 
> 


-- 
Alexey
