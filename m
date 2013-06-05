Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab3FEWF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:05:29 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:49213 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416Ab3FEWF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:05:26 -0400
MIME-Version: 1.0
In-Reply-To: <1370463236-2115-2-git-send-email-jacob.shin@amd.com>
References: <1370463236-2115-1-git-send-email-jacob.shin@amd.com>
	<1370463236-2115-2-git-send-email-jacob.shin@amd.com>
Date: Wed, 5 Jun 2013 15:05:25 -0700
X-Google-Sender-Auth: nORdA0TnNDlNAsdYwPjXSKRMzaM
Message-ID: <CAE9FiQUCv4EbY+vStiB3uSbt5xjTxLk-ZmP+DEVspMsXyWj2uQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86/microcode/amd: make find_ucode_in_initrd() __init
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 1:13 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> Change find_ucode_in_initrd() to __init and only let BSP call it
> during cold boot. This is the right thing to do because only BSP will
> see initrd loaded by the boot loader. APs will offset into
> initrd_start to find the microcode patch binary.
>
> Reported-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/kernel/microcode_amd_early.c |   98 +++++++++++++++++++++++----------
>  1 file changed, 68 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/kernel/microcode_amd_early.c b/arch/x86/kernel/microcode_amd_early.c
> index 9618805..7db1e16 100644
> --- a/arch/x86/kernel/microcode_amd_early.c
> +++ b/arch/x86/kernel/microcode_amd_early.c
> @@ -9,6 +9,7 @@
>   */
>
>  #include <linux/earlycpio.h>
> +#include <linux/initrd.h>
>
>  #include <asm/cpu.h>
>  #include <asm/setup.h>
> @@ -16,40 +17,59 @@
>
>  static bool ucode_loaded;
>  static u32 ucode_new_rev;
> +static unsigned long ucode_offset;
> +static size_t ucode_size;
>
>  /*
>   * Microcode patch container file is prepended to the initrd in cpio format.
>   * See Documentation/x86/early-microcode.txt
>   */
> -static __cpuinitdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
> +static __initdata char ucode_path[] = "kernel/x86/microcode/AuthenticAMD.bin";
>
> -static struct cpio_data __cpuinit find_ucode_in_initrd(void)
> +static struct cpio_data __init find_ucode_in_initrd(void)
>  {
>         long offset = 0;
> +       char *path;
> +       void *start;
> +       size_t size;
> +       unsigned long *uoffset;
> +       size_t *usize;
>         struct cpio_data cd;
>
>  #ifdef CONFIG_X86_32
> +       struct boot_params *p;
> +
>         /*
>          * On 32-bit, early load occurs before paging is turned on so we need
>          * to use physical addresses.
>          */
> -       if (!(read_cr0() & X86_CR0_PG)) {
> -               struct boot_params *p;
> -               p  = (struct boot_params *)__pa_nodebug(&boot_params);
> -               cd = find_cpio_data((char *)__pa_nodebug(ucode_path),
> -                       (void *)p->hdr.ramdisk_image, p->hdr.ramdisk_size,
> -                       &offset);
> -       } else
> +       p       = (struct boot_params *)__pa_nodebug(&boot_params);
> +       path    = (char *)__pa_nodebug(ucode_path);
> +       start   = (void *)p->hdr.ramdisk_image;
> +       size    = p->hdr.ramdisk_size;
> +       uoffset = (unsigned long *)__pa_nodebug(&ucode_offset);
> +       usize   = (size_t *)__pa_nodebug(&ucode_size);
> +#else
> +       path    = ucode_path;
> +       start   = (void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET);
> +       size    = boot_params.hdr.ramdisk_size;
> +       uoffset = &ucode_offset;
> +       usize   = &ucode_size;
>  #endif
> -               cd = find_cpio_data(ucode_path,
> -                       (void *)(boot_params.hdr.ramdisk_image + PAGE_OFFSET),
> -                       boot_params.hdr.ramdisk_size, &offset);
> +
> +       cd = find_cpio_data(path, start, size, &offset);
> +       if (!cd.data)
> +               return cd;
>
>         if (*(u32 *)cd.data != UCODE_MAGIC) {
>                 cd.data = NULL;
>                 cd.size = 0;
> +               return cd;
>         }
>
> +       *uoffset = (u8 *)cd.data - (u8 *)start;
> +       *usize   = cd.size;
> +
>         return cd;
>  }
>
> @@ -62,9 +82,8 @@ static struct cpio_data __cpuinit find_ucode_in_initrd(void)
>   * load_microcode_amd() to save equivalent cpu table and microcode patches in
>   * kernel heap memory.
>   */
> -static void __cpuinit apply_ucode_in_initrd(void)
> +static void __cpuinit apply_ucode_in_initrd(void *ucode, size_t size)
>  {
> -       struct cpio_data cd;
>         struct equiv_cpu_entry *eq;
>         u32 *header;
>         u8  *data;
> @@ -78,12 +97,9 @@ static void __cpuinit apply_ucode_in_initrd(void)
>  #else
>         new_rev = &ucode_new_rev;
>  #endif
> -       cd = find_ucode_in_initrd();
> -       if (!cd.data)
> -               return;
>
> -       data   = cd.data;
> -       left   = cd.size;
> +       data   = ucode;
> +       left   = size;
>         header = (u32 *)data;
>
>         /* find equiv cpu table */
> @@ -129,7 +145,11 @@ static void __cpuinit apply_ucode_in_initrd(void)
>
>  void __init load_ucode_amd_bsp(void)
>  {
> -       apply_ucode_in_initrd();
> +       struct cpio_data cd = find_ucode_in_initrd();
> +       if (!cd.data)
> +               return;
> +
> +       apply_ucode_in_initrd(cd.data, cd.size);
>  }
>
>  #ifdef CONFIG_X86_32
> @@ -145,12 +165,25 @@ u8 amd_bsp_mpb[MPB_MAX_SIZE];
>  void __cpuinit load_ucode_amd_ap(void)
>  {
>         struct microcode_amd *mc;
> +       unsigned long *initrd;
> +       unsigned long *uoffset;
> +       size_t *usize;
> +       void *ucode;
>
>         mc = (struct microcode_amd *)__pa_nodebug(amd_bsp_mpb);
> -       if (mc->hdr.patch_id && mc->hdr.processor_rev_id)
> +       if (mc->hdr.patch_id && mc->hdr.processor_rev_id) {
>                 __apply_microcode_amd(mc);
> -       else
> -               apply_ucode_in_initrd();
> +               return;
> +       }
> +

may need to check "if (!initrd_start)" here.

> +       initrd  = (unsigned long *)__pa_nodebug(&initrd_start);
> +       uoffset = (unsigned long *)__pa_nodebug(&ucode_offset);
> +       usize   = (size_t *)__pa_nodebug(&ucode_size);

could use __pa directly here.

> +       if (!*usize)
> +               return;
> +
> +       ucode = (void *)((unsigned long)__pa_nodebug(*initrd) + *uoffset);

same.

> +       apply_ucode_in_initrd(ucode, *usize);
>  }
>
>  static void __init collect_cpu_sig_on_bsp(void *arg)
> @@ -181,8 +214,13 @@ void __cpuinit load_ucode_amd_ap(void)
>         collect_cpu_info_amd_early(&cpu_data(cpu), ucode_cpu_info + cpu);
>
>         if (cpu && !ucode_loaded) {
> -               struct cpio_data cd = find_ucode_in_initrd();
> -               if (load_microcode_amd(0, cd.data, cd.size) != UCODE_OK)
> +               void *ucode;
> +
> +               if (!ucode_size)
> +                       return;
> +
> +               ucode = (void *)(initrd_start + ucode_offset);
> +               if (load_microcode_amd(0, ucode, ucode_size) != UCODE_OK)
>                         return;
>                 ucode_loaded = true;
>         }
> @@ -194,7 +232,7 @@ void __cpuinit load_ucode_amd_ap(void)
>  int __init save_microcode_in_initrd_amd(void)
>  {
>         enum ucode_state ret;
> -       struct cpio_data cd;
> +       void *ucode;
>  #ifdef CONFIG_X86_32
>         unsigned int bsp = boot_cpu_data.cpu_index;
>         struct ucode_cpu_info *uci = ucode_cpu_info + bsp;
> @@ -209,11 +247,11 @@ int __init save_microcode_in_initrd_amd(void)
>         if (ucode_loaded)
>                 return 0;
>
> -       cd = find_ucode_in_initrd();
> -       if (!cd.data)
> -               return -EINVAL;
> +       if (!ucode_size)
> +               return 0;
>
> -       ret = load_microcode_amd(0, cd.data, cd.size);
> +       ucode = (void *)(initrd_start + ucode_offset);
> +       ret = load_microcode_amd(0, ucode, ucode_size);
>         if (ret != UCODE_OK)
>                 return -EINVAL;
>
> --
> 1.7.9.5
>
>
