Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbaGCXIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 19:08:25 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:61133 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbaGCXIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 19:08:24 -0400
Message-ID: <53B5E2E1.5010102@gmail.com>
Date: Thu, 03 Jul 2014 19:10:25 -0400
From: Boris Ostrovsky <ostr.lkml@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] ix86: fix vDSO build
References: <53B5863B02000078000204D5@mail.emea.novell.com>
In-Reply-To: <53B5863B02000078000204D5@mail.emea.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 10:35 AM, Jan Beulich wrote:
> Relying on static functions used just once to get inlined (and
> subsequently have dead code paths eliminated) is wrong: Compilers are
> free to decide whether they do this, regardless of optimization level.
> With this not happening for vdso_addr() (observed with gcc 4.1.x), an
> unresolved reference to align_vdso_addr() causes the build to fail.

Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> ---
>   arch/x86/vdso/vma.c    |    4 ++++
>   1 file changed, 4 insertions(+)
>
> --- 3.16-rc3/arch/x86/vdso/vma.c
> +++ 3.16-rc3-x86-vdso-build/arch/x86/vdso/vma.c
> @@ -62,6 +62,9 @@ struct linux_binprm;
>      Only used for the 64-bit and x32 vdsos. */
>   static unsigned long vdso_addr(unsigned long start, unsigned len)
>   {
> +#ifdef CONFIG_X86_32
> +	return 0;
> +#else
>   	unsigned long addr, end;
>   	unsigned offset;
>   	end = (start + PMD_SIZE - 1) & PMD_MASK;
> @@ -83,6 +86,7 @@ static unsigned long vdso_addr(unsigned
>   	addr = align_vdso_addr(addr);
>   
>   	return addr;
> +#endif
>   }
>   
>   static int map_vdso(const struct vdso_image *image, bool calculate_addr)
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

