Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaDVDQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:16:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaDVDQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:16:24 -0400
Date: Tue, 22 Apr 2014 11:16:10 +0800
From: WANG Chao <chaowang@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kaslr relocation incompitable with kernel loaded high
Message-ID: <20140422031610.GC4564@dhcp-17-89.nay.redhat.com>
References: <20140421105232.GB4564@dhcp-17-89.nay.redhat.com>
 <CAE9FiQWf+3hMZbt7Ac+vgL+8kqqQS4LKVGmWgrd5fJ4nkSgmPA@mail.gmail.com>
 <CAGXu5j+-Aqe3H04mK=3wRQ-rhpvNVPm1yOKgZrd=Yc3gqrGq0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+-Aqe3H04mK=3wRQ-rhpvNVPm1yOKgZrd=Yc3gqrGq0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/14 at 11:01am, Kees Cook wrote:
> On Mon, Apr 21, 2014 at 10:56 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Mon, Apr 21, 2014 at 3:52 AM, WANG Chao <chaowang@redhat.com> wrote:
> >> Hi, Kees
> >>
> >> When I'm testing kaslr with kdump, I find that when 2nd kernel is loaded
> >> high, it doesn't boot.
> >>
> >> I reserved 128M memory at high with kernel cmdline
> >> "crashkernel=128M,high crashkernel=0,low", and for which I got:
> >>
> >> [    0.000000] Reserving 128MB of memory at 6896MB for crashkernel (System RAM: 6013MB)
> >>
> >> Then I load kdump kernel into the reserved memory region, using a local
> >> modified kexec-tools which is passing e820 in boot_params.
> >>
> >> The e820 map of system RAM passed to 2nd kernel:
> >>
> >> E820 memmap (of RAM):
> >> 0000000000001000-000000000009e3ff (1)
> >> 00000001af000000-00000001b6f5dfff (1)
> >> 00000001b6fff400-00000001b6ffffff (1)
> >>
> >> In which, 2nd kernel is loaded at 0x1b5000000.
> >>
> >> After triggerred a system crash, 2nd kernel doesn't boot even with
> >> "nokaslr" cmdline:
> >>
> >> # echo c > /proc/sysrq-trigger
> >> [..]
> >>
> >> I'm in purgatory
> >> early console in decompress_kernel
> >> KASLR disabled...
> >>
> >> Decompressing Linux... Parsing ELF... Performing relocations...
> >>
> >> 32-bit relocation outside of kernel!
> >
> > Interesting, when kernel get at "early console in decompress_kernel"
> > kernel already in 64 bit...
> >
> > what does it mean "32-bit relocation outside of kernel" ?
> >
> > why 32-bit is involved ?
> 
> The 64-bit kernel has both 64 and 32 bit relocations (there are two
> tables at the end of the kernel image). The error means that the
> resulting relocation is believed to be outside the kernel image:
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/x86/boot/compressed/misc.c#n283
> 
> Which means there is likely something wrong with this calculation in
> your situation:
> 
> /*
>  * Calculate the delta between where vmlinux was linked to load
>  * and where it was actually loaded.
>  */
> delta = min_addr - LOAD_PHYSICAL_ADDR;
> 

Probably.

I'm wondering why such relocation is still needed when kaslr
is disabled in 64bit path. I think the relocation work is already
handled in head_64.S.

FWIW, I got these following relocation info:

# arch/x86/tools/relocs --text vmlinux
.section ".data.reloc","a"
.balign 4
	.long 0x00000000
	.long 0x81004687
	[..]
	.long 0x81e6b018
	.long 0x00000000
	.long 0x8100000a
	[..]
	.long 0x81e6c9fc


Thanks
WANG Chao
