Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaBCTMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:12:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45590 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaBCTMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:12:41 -0500
Message-ID: <52EFEA57.4000709@oracle.com>
Date: Mon, 03 Feb 2014 14:13:27 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -v2] x86, microcode, AMD: Sanity-check initrd image
References: <52E8168D.9060805@oracle.com> <20140128205246.GL815@pd.tnic> <52E81B90.8040604@oracle.com> <20140128213030.GM815@pd.tnic> <52E8230F.7080300@oracle.com> <52E83903.5040908@oracle.com> <20140128232219.GO815@pd.tnic> <20140130151321.GC23342@pd.tnic> <52EAAAD5.2010301@oracle.com> <20140130195413.GH23342@pd.tnic> <20140203175526.GB4281@pd.tnic>
In-Reply-To: <20140203175526.GB4281@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 12:55 PM, Borislav Petkov wrote:
> On Thu, Jan 30, 2014 at 08:54:13PM +0100, Borislav Petkov wrote:
>> Yeah, it is simpler. Ok, will change.
> Ok, let's have another run at it. This one takes care of the relocated
> ramdisk on 64-bit too, as we do it there also, not only on 32-bit. It
> boots fine here on the 32/64-bit guests.
>
> ---
> From: Borislav Petkov <bp@suse.de>
> Subject: [PATCH] x86, microcode, AMD: Sanity-check initrd image
>
> For additional coverage, BorisO and friends did swap AMD microcode with
> Intel microcode blobs in order to see what happens. What did happen on
> 32-bit was
>
> [    5.722656] BUG: unable to handle kernel paging request at be3a6008
> [    5.722693] IP: [<c106d6b4>] load_microcode_amd+0x24/0x3f0
> [    5.722716] *pdpt = 0000000000000000 *pde = 0000000000000000
>
> because there was a valid initrd there but without valid microcode in
> it. In order to fix that, we need to check the container signature from
> the initrd before we continue loading it.


I thought that it may be sufficient to check for !container in 
save_microcode_in_initrd_amd() before performing relocation. If the 
signature was wrong, we would have found out about it in 
load_ucode_bsp() -> apply_ucode_in_initrd() and returned right away, from

         /* find equiv cpu table */
         if (header[0] != UCODE_MAGIC ||
             header[1] != UCODE_EQUIV_CPU_TABLE_TYPE || /* type */
             header[2] == 0)             /* size */
                 return;

and container would have stayed zero (which I think it is. And if not, 
you can set it to zero, just like you do below if you couldn't find 
equivalence ID and eq_id is zero).

You only need the additional signature verification that the patch below 
is adding if you check for !container after relocation, the way it was 
in the original patch.

In other words, the whole fix would be moving !container check up. 
(64-bit relocation is a separate issue).

No?

-boris


>
> Also, take care of the ramdisk relocation on both bitness.
>
> Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>   arch/x86/kernel/cpu/microcode/amd_early.c | 60 +++++++++++++++++++++++--------
>   1 file changed, 45 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
> index 8384c0fa206f..41537ae7c31d 100644
> --- a/arch/x86/kernel/cpu/microcode/amd_early.c
> +++ b/arch/x86/kernel/cpu/microcode/amd_early.c
> @@ -37,10 +37,12 @@ static __initdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
>   
>   static struct cpio_data __init find_ucode_in_initrd(void)
>   {
> +	struct cpio_data ret;
>   	long offset = 0;
>   	char *path;
>   	void *start;
>   	size_t size;
> +	u32 *hdr;
>   
>   #ifdef CONFIG_X86_32
>   	struct boot_params *p;
> @@ -59,7 +61,20 @@ static struct cpio_data __init find_ucode_in_initrd(void)
>   	size    = boot_params.hdr.ramdisk_size;
>   #endif
>   
> -	return find_cpio_data(path, start, size, &offset);
> +	ret = find_cpio_data(path, start, size, &offset);
> +	if (!ret.data)
> +		return ret;
> +
> +	/* Verify we didn't get some garbage from the initrd. */
> +	hdr = (u32 *)ret.data;
> +
> +	if (hdr[0] != UCODE_MAGIC ||
> +	    hdr[1] != UCODE_EQUIV_CPU_TABLE_TYPE ||
> +	    hdr[2] == 0) {
> +		ret.data = NULL;
> +		ret.size = 0;
> +	}
> +	return ret;
>   }
>   
>   static size_t compute_container_size(u8 *data, u32 total_size)
> @@ -285,6 +300,15 @@ static void __init collect_cpu_sig_on_bsp(void *arg)
>   
>   	uci->cpu_sig.sig = cpuid_eax(0x00000001);
>   }
> +
> +static void __init get_bsp_sig(void)
> +{
> +	unsigned int bsp = boot_cpu_data.cpu_index;
> +	struct ucode_cpu_info *uci = ucode_cpu_info + bsp;
> +
> +	if (!uci->cpu_sig.sig)
> +		smp_call_function_single(bsp, collect_cpu_sig_on_bsp, NULL, 1);
> +}
>   #else
>   void load_ucode_amd_ap(void)
>   {
> @@ -337,31 +361,37 @@ void load_ucode_amd_ap(void)
>   
>   int __init save_microcode_in_initrd_amd(void)
>   {
> +	unsigned long cont;
>   	enum ucode_state ret;
>   	u32 eax;
>   
> -#ifdef CONFIG_X86_32
> -	unsigned int bsp = boot_cpu_data.cpu_index;
> -	struct ucode_cpu_info *uci = ucode_cpu_info + bsp;
> -
> -	if (!uci->cpu_sig.sig)
> -		smp_call_function_single(bsp, collect_cpu_sig_on_bsp, NULL, 1);
> +	if (!container)
> +		return -EINVAL;
>   
> +#ifdef CONFIG_X86_32
> +	get_bsp_sig();
> +	cont = (unsigned long)container;
> +#else
>   	/*
> -	 * Take into account the fact that the ramdisk might get relocated
> -	 * and therefore we need to recompute the container's position in
> -	 * virtual memory space.
> +	 * We need the physical address of the container for both bitness since
> +	 * boot_params.hdr.ramdisk_image is a physical address.
>   	 */
> -	container = (u8 *)(__va((u32)relocated_ramdisk) +
> -			   ((u32)container - boot_params.hdr.ramdisk_image));
> +	cont = __pa(container);
>   #endif
> +
> +	/*
> +	 * Take into account the fact that the ramdisk might get relocated and
> +	 * therefore we need to recompute the container's position in virtual
> +	 * memory space.
> +	 */
> +	if (relocated_ramdisk)
> +		container = (u8 *)(__va(relocated_ramdisk) +
> +			     (cont - boot_params.hdr.ramdisk_image));
> +
>   	if (ucode_new_rev)
>   		pr_info("microcode: updated early to new patch_level=0x%08x\n",
>   			ucode_new_rev);
>   
> -	if (!container)
> -		return -EINVAL;
> -
>   	eax   = cpuid_eax(0x00000001);
>   	eax   = ((eax >> 8) & 0xf) + ((eax >> 20) & 0xff);
>   

