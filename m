Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3AWCAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 21:00:53 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:36180 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3AWCAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 21:00:51 -0500
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <jeff.dagenais@gmail.com>
In-Reply-To: <EDE518F3-0E59-49A4-A5B1-A013A91C319F@gmail.com>
Date: Tue, 22 Jan 2013 21:00:45 -0500
Cc: hjk@hansjkoch.de, tglx@linutronix.de,
        open list <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6537CEC1-06CF-4169-883A-60B2B4DC0AAB@gmail.com>
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com> <20111118220849.GA25205@suse.de> <EDE518F3-0E59-49A4-A5B1-A013A91C319F@gmail.com>
To: Lokesh M <lokesh.m84@gmail.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's to free software! (and good karma?)

A M Lokesh mailed me directly for a follow up question about this old thread, I
thought it would be interesting to post my reply to the list.

On 2013-01-22, at 10:23, Lokesh M wrote:
> 
> After reading through your below thread, I was wondering if you could please
> give me some feedback
>  
> https://lkml.org/lkml/2011/11/18/462
>  
> I am in a similar situation, where I need to write a driver to pass the Data
> from PCIe(FPGA) to my Linux machine (4MB would be enough - streaming).  I
> havn't checked if my Server supports Vt-d,  But was interested in the way
> your implementation was(UIO mapping).

I've sort of abandonned the vt-d way of doing it because I also need to support
an Atom architecture. Was a bit glad to do it like this since I know the IOMMU
translation tables and what not aren't free and the code to map and support this
was kind of hard to follow. Giving it up also means loosing FPGA stray memory
access protection though, but it's not like I had the choice (Atom).

>  
> I was looking to know more about the 2 buffer mapping you have for streaming
> data and how it is achieved,  We have mapping for BAR0 for register access and
> I would like to implement similar buffer for Data as well.  So Please let me
> know any details and point me to few documentation to implement the same.
> We have a bounce buffer mechanism (device ->Kernel ->User) but the speed is
> around 100MB which I need to improve.

On Nov 18, 2011, at 17:08, Greg KH wrote:

> On Fri, Nov 18, 2011 at 04:16:23PM -0500, Jean-Francois Dagenais wrote:
>> 
>> 
>> I had thought about cutting out a chunk of ram from the kernel's boot
>> args, but had always feared cache/snooping errors. Not to mention I
>> had no idea how to "claim" or setup this memory once my driver's probe
>> function. Maybe I would still be lucky and it would just work? mmmh...
> 
> Yeah, don't do that, it might not work out well.
> 
> greg k-h


Turns out, for me, this works very well!!

So, here the jist of what I do... remember, I only need to support pure Core2 +
Intel CPU/Chipset architectures on very specific COM modules. This means the
architecture takes care of invalidating the CPU cachelines when the PCI-E device
(an FPGA) bus masters reads and writes to RAM (bus snooping). The area I
describe here is 128M (on the other system, I used 256M successfully) and is
strictly used for FPGA write - CPU read. As a note, the other area I use (only
1M) for CPU write - FPGA read is still allocated using pci_alloc_consistent. The
DMA address is collected through the 3rd argument of pci_alloc_consistent and is
handed to UIO as UIO_MEM_PHYS type of memory. FYI, I had previously succeeded in
allocating 4M using pci_alloc_consistent, but only if done quite soon after
boot. This was on a Core2 duo arch.

I do hook into the kernel boot parameter "memmap" to reserve a chunk of
contiguous memory which I know falls inside a range which the BIOS declares
(through E820) as available. This makes the kernel's memory management ignore
this area. I compile-in a kernel module which looks like this:

void* uio_hud_memblock_addr; EXPORT_SYMBOL(uio_hud_memblock_addr); unsigned long
long uio_hud_memblock_size; EXPORT_SYMBOL(uio_hud_memblock_size);

/* taken from parse_memmap_opt in e820.c and modified */ static int __init
uio_hud_memblock_setup(char *str) {
	char *cur_p = str; u64 mem_size;

	if (!str)
		return -EINVAL;

	mem_size = memparse(str, &cur_p); if (cur_p == str)
		return -EINVAL;

	if (*cur_p == '$') {
		uio_hud_memblock_addr = (void*)(ulong)memparse(cur_p+1, &cur_p);
		uio_hud_memblock_size = mem_size;
	} else {
		return -EINVAL;
	}

	return *cur_p == '\0' ? 0 : -EINVAL;
} __setup("memmap=", uio_hud_memblock_setup);


static int __init uio_hud_memblock_init(void) {
	if(uio_hud_memblock_addr) {
		PDEBUG("ram memblock at %p (size:%llu)\n",
		       uio_hud_memblock_addr, uio_hud_memblock_size);
	} else {
		PDEBUG("no memmap=nn$ss kernel parameter found\n");
	}

	return 0;
} early_initcall(uio_hud_memblock_init);


MODULE_AUTHOR("Jean-Francois Dagenais"); MODULE_DESCRIPTION("Built-in module to
parse the memmap memblock reservation"); MODULE_LICENSE("GPL");

The parsed address and size (uio_hud_memblock_addr/size) are exported for my
other non-compiled in module to discover. That module is the real PCI "driver"
which simply takes this address and size, and hands it to UIO as a memory map of
type UIO_MEM_PHYS.

That's pretty much it for the kernel stuff (aside for the trivial interrupt
handling). In userspace, I also have a UIO map for the FPGA's BAR0 registers
where I instruct the device where the other two physical memory ranges (begin
and end addresses and one for it's read ops (1M), one for it's write ops(128M),
so 4 physical addresses). The device autonomously updates where it's going to
write next (it's "data write addr" register), rolls around when reaching the end
and sends me an interrupt for each "data unit" it finishes. The interrupt is
forwarded to userspace as described in UIO docs because of a small ISR in my
kernel driver. Userspace instructs the device through a "software read addr"
register which indicates to FPGA the lowest address which the software still
needs (hasn't consumed yet). This is so the autonomous FPGA doesn't overwrite
busy memory. As soon as I update the soft read addr, the FPGA can fill that spot
again.

This way you squeeze out as much as you can out of the architecture as the CPU
is only burdonned with consuming the data and updating a pointer.

Cheers!  /jfd