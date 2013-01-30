Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3A3Byo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:54:44 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34465 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab3A3Bym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:54:42 -0500
MIME-Version: 1.0
In-Reply-To: <tip-8cf52eb755e5c5046d2a5d5d3b64d839677ed8ae@git.kernel.org>
References: <1359058816-7615-26-git-send-email-yinghai@kernel.org>
	<tip-8cf52eb755e5c5046d2a5d5d3b64d839677ed8ae@git.kernel.org>
Date: Tue, 29 Jan 2013 17:54:41 -0800
X-Google-Sender-Auth: 9UDcVHz7CL_XZ6pgmmU_3dIDqCA
Message-ID: <CAE9FiQWP-KRAppXUcYm7KYEJG_k5fMVCPgeZKoAEAUfdXuQXNA@mail.gmail.com>
Subject: Re: [tip:x86/mm2] x86, boot: enable support load bzImage and ramdisk
 above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, caushik1@gmail.com, matt.fleming@intel.com,
        jmillenbach@gmail.com, tglx@linutronix.de, josh@joshtriplett.org,
        hpa@linux.intel.com, rob@landley.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 5:45 PM, tip-bot for Yinghai Lu
<yinghai@kernel.org> wrote:
> Commit-ID:  8cf52eb755e5c5046d2a5d5d3b64d839677ed8ae
> Gitweb:     http://git.kernel.org/tip/8cf52eb755e5c5046d2a5d5d3b64d839677ed8ae
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Mon, 28 Jan 2013 20:16:44 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Tue, 29 Jan 2013 15:30:22 -0800
>
> x86, boot: enable support load bzImage and ramdisk above 4G
>
> xloadflags bit 1 indicates that we can load the kernel and all data
> structure above 4G; it is set if kernel is relocatable and 64bit.
>
> bootloader will check if xloadflags bit1 is set to decicde if
> it could load ramdisk and kernel high above 4G.
>
> bootloader will fill value to ext_ramdisk_image/size for high 32bits
> when it load ramdisk above 4G.
> kernel use get_ramdisk_image/size to use ext_ramdisk_image/size to get
> right positon for ramdisk.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Rob Landley <rob@landley.net>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Gokul Caushik <caushik1@gmail.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Joe Millenbach <jmillenbach@gmail.com>
> Link: http://lkml.kernel.org/r/1359058816-7615-26-git-send-email-yinghai@kernel.org
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/boot/compressed/cmdline.c |  2 ++
>  arch/x86/boot/compressed/misc.c    | 19 +++++++++++++++++++
>  arch/x86/boot/header.S             | 10 +++++++++-
>  arch/x86/kernel/head64.c           |  2 ++
>  arch/x86/kernel/setup.c            |  4 ++++
>  5 files changed, 36 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
> index b4c913c..bffd73b 100644
> --- a/arch/x86/boot/compressed/cmdline.c
> +++ b/arch/x86/boot/compressed/cmdline.c
> @@ -17,6 +17,8 @@ static unsigned long get_cmd_line_ptr(void)
>  {
>         unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
>
> +       cmd_line_ptr |= (u64)real_mode->ext_cmd_line_ptr << 32;
> +
>         return cmd_line_ptr;
>  }
>  int cmdline_find_option(const char *option, char *buffer, int bufsize)
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index 7cb56c6..5d8dc86 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -318,6 +318,23 @@ static void parse_elf(void *output)
>         free(phdrs);
>  }
>
> +static void sanitize_real_mode(struct boot_params *real_mode)
> +{
> +       if (real_mode->sentinel) {
> +               /*fields in boot_params are not valid, clear them */
> +               memset(&real_mode->olpc_ofw_header, 0,
> +                      (char *)&real_mode->alt_mem_k -
> +                       (char *)&real_mode->olpc_ofw_header);
> +               memset(&real_mode->_pad7[0], 0,
> +                      (char *)&real_mode->edd_mbr_sig_buffer[0] -
> +                       (char *)&real_mode->_pad7[0]);
> +               memset(&real_mode->_pad8[0], 0,
> +                      (char *)&real_mode->eddbuf[0] -
> +                       (char *)&real_mode->_pad8[0]);
> +               memset(&real_mode->_pad9[0], 0, sizeof(real_mode->_pad9));
> +       }
> +}
> +
>  asmlinkage void decompress_kernel(void *rmode, memptr heap,
>                                   unsigned char *input_data,
>                                   unsigned long input_len,
> @@ -327,6 +344,8 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
>
>         sanitize_boot_params(real_mode);
>
> +       sanitize_real_mode(real_mode);
> +

Hi, Peter,

sanitize_real_mode() need to be dropped from this patch.

You already have complete patch sanitize_boot_params() applied before.

Thanks

Yinghai
