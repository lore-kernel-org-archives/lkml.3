Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaDVF25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbaDVF2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:28:50 -0400
Date: Tue, 22 Apr 2014 13:28:34 +0800
From: WANG Chao <chaowang@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kaslr relocation incompitable with kernel loaded high
Message-ID: <20140422052834.GE4564@dhcp-17-89.nay.redhat.com>
References: <20140421105232.GB4564@dhcp-17-89.nay.redhat.com>
 <CAE9FiQWf+3hMZbt7Ac+vgL+8kqqQS4LKVGmWgrd5fJ4nkSgmPA@mail.gmail.com>
 <CAGXu5j+-Aqe3H04mK=3wRQ-rhpvNVPm1yOKgZrd=Yc3gqrGq0w@mail.gmail.com>
 <20140422031610.GC4564@dhcp-17-89.nay.redhat.com>
 <CAE9FiQWMUAdzpNV02rhvpBm8m8FJQXmaiuT+HwFWQKVkJQkYsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWMUAdzpNV02rhvpBm8m8FJQXmaiuT+HwFWQKVkJQkYsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/14 at 09:58pm, Yinghai Lu wrote:
> On Mon, Apr 21, 2014 at 8:16 PM, WANG Chao <chaowang@redhat.com> wrote:
> > On 04/21/14 at 11:01am, Kees Cook wrote:
> >> On Mon, Apr 21, 2014 at 10:56 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> > On Mon, Apr 21, 2014 at 3:52 AM, WANG Chao <chaowang@redhat.com> wrote:
> >> >> Hi, Kees
> >> >>
> >> >> When I'm testing kaslr with kdump, I find that when 2nd kernel is loaded
> >> >> high, it doesn't boot.
> >> >>
> >> >> I reserved 128M memory at high with kernel cmdline
> >> >> "crashkernel=128M,high crashkernel=0,low", and for which I got:
> >> >>
> >> >> [    0.000000] Reserving 128MB of memory at 6896MB for crashkernel (System RAM: 6013MB)
> >> >>
> >> >> Then I load kdump kernel into the reserved memory region, using a local
> >> >> modified kexec-tools which is passing e820 in boot_params.
> >> >>
> >> >> The e820 map of system RAM passed to 2nd kernel:
> >> >>
> >> >> E820 memmap (of RAM):
> >> >> 0000000000001000-000000000009e3ff (1)
> >> >> 00000001af000000-00000001b6f5dfff (1)
> >> >> 00000001b6fff400-00000001b6ffffff (1)
> >> >>
> >> >> In which, 2nd kernel is loaded at 0x1b5000000.
> >> >>
> >> >> After triggerred a system crash, 2nd kernel doesn't boot even with
> >> >> "nokaslr" cmdline:
> >> >>
> >> >> # echo c > /proc/sysrq-trigger
> >> >> [..]
> >> >>
> >> >> I'm in purgatory
> >> >> early console in decompress_kernel
> >> >> KASLR disabled...
> >> >>
> >> >> Decompressing Linux... Parsing ELF... Performing relocations...
> >> >>
> >> >> 32-bit relocation outside of kernel!
> >> >
> >> > Interesting, when kernel get at "early console in decompress_kernel"
> >> > kernel already in 64 bit...
> >> >
> >> > what does it mean "32-bit relocation outside of kernel" ?
> >> >
> >> > why 32-bit is involved ?
> >>
> >> The 64-bit kernel has both 64 and 32 bit relocations (there are two
> >> tables at the end of the kernel image). The error means that the
> >> resulting relocation is believed to be outside the kernel image:
> >>
> >> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/x86/boot/compressed/misc.c#n283
> >>
> >> Which means there is likely something wrong with this calculation in
> >> your situation:
> >>
> >> /*
> >>  * Calculate the delta between where vmlinux was linked to load
> >>  * and where it was actually loaded.
> >>  */
> >> delta = min_addr - LOAD_PHYSICAL_ADDR;
> >>
> >
> > Probably.
> 
> Please check attached that patch that will solve nokaslr.
> 
> Somehow I got "KASLR could not find suitable E820 region..."
> so i only have "No relocation needed"

I think it makes sense. If output from choose_kernel_location() doesn't
change (output == output_orig), we shouldn't call relocation code.

There are two situations that makes output == output_orig:
- "nokaslr" case
- "KASLR could not find suitable E820 region" case.

> 
> will check that later.

> ---
>  arch/x86/boot/compressed/misc.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/arch/x86/boot/compressed/misc.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/compressed/misc.c
> +++ linux-2.6/arch/x86/boot/compressed/misc.c
> @@ -235,8 +235,9 @@ static void error(char *x)
>  		asm("hlt");
>  }
>  
> -#if CONFIG_X86_NEED_RELOCS
> -static void handle_relocations(void *output, unsigned long output_len)
> +#ifdef CONFIG_X86_NEED_RELOCS
> +static void handle_relocations(void *output_orig, void *output,
> +			       unsigned long output_len)
>  {
>  	int *reloc;
>  	unsigned long delta, map, ptr;
> @@ -247,7 +248,7 @@ static void handle_relocations(void *out
>  	 * Calculate the delta between where vmlinux was linked to load
>  	 * and where it was actually loaded.
>  	 */
> -	delta = min_addr - LOAD_PHYSICAL_ADDR;
> +	delta = min_addr - (unsigned long)output_orig;
>  	if (!delta) {
>  		debug_putstr("No relocation needed... ");
>  		return;
> @@ -304,7 +305,8 @@ static void handle_relocations(void *out
>  #endif
>  }
>  #else
> -static inline void handle_relocations(void *output, unsigned long output_len)
> +static inline void handle_relocations(void *output_orig, void *output,
> +				      unsigned long output_len)
>  { }
>  #endif
>  
> @@ -365,6 +367,8 @@ asmlinkage void *decompress_kernel(void
>  				  unsigned char *output,
>  				  unsigned long output_len)
>  {
> +	unsigned char *output_orig = output;
> +
>  	real_mode = rmode;
>  
>  	sanitize_boot_params(real_mode);
> @@ -417,7 +421,7 @@ asmlinkage void *decompress_kernel(void
>  	debug_putstr("... ");
>  	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
>  	parse_elf(output);
> -	handle_relocations(output, output_len);
> +	handle_relocations(output_orig, output, output_len);
>  	debug_putstr("done.\nBooting the kernel.\n");
>  	return output;
>  }

Thanks for the patch, it works for me :)

I also have a draft patch with the same idea as Yinghai. But I take a
slightly different approach:

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 1768461..7f392a8 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -360,6 +360,8 @@ asmlinkage void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *output,
 				  unsigned long output_len)
 {
+	char *output_orig;
+
 	real_mode = rmode;
 
 	sanitize_boot_params(real_mode);
@@ -381,6 +383,7 @@ asmlinkage void *decompress_kernel(void *rmode, memptr heap,
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
+	output_orig = output;
 	output = choose_kernel_location(input_data, input_len,
 					output, output_len);
 
@@ -402,7 +405,10 @@ asmlinkage void *decompress_kernel(void *rmode, memptr heap,
 	debug_putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
-	handle_relocations(output, output_len);
+
+	if (output != output_orig)
+		handle_relocations(output, output_len);
+
 	debug_putstr("done.\nBooting the kernel.\n");
 	return output;
 }

 Thanks
 WANG Chao
