Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaGIXah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:30:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaGIXag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:30:36 -0400
Date: Wed, 9 Jul 2014 16:30:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ix86: fix vDSO build
Message-Id: <20140709163034.2d93541a7af85fa71fddd17b@linux-foundation.org>
In-Reply-To: <53B5863B02000078000204D5@mail.emea.novell.com>
References: <53B5863B02000078000204D5@mail.emea.novell.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jul 2014 15:35:07 +0100 "Jan Beulich" <JBeulich@suse.com> wrote:

> Relying on static functions used just once to get inlined (and
> subsequently have dead code paths eliminated) is wrong: Compilers are
> free to decide whether they do this, regardless of optimization level.
> With this not happening for vdso_addr() (observed with gcc 4.1.x), an
> unresolved reference to align_vdso_addr() causes the build to fail.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/vdso/vma.c    |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- 3.16-rc3/arch/x86/vdso/vma.c
> +++ 3.16-rc3-x86-vdso-build/arch/x86/vdso/vma.c
> @@ -62,6 +62,9 @@ struct linux_binprm;
>     Only used for the 64-bit and x32 vdsos. */
>  static unsigned long vdso_addr(unsigned long start, unsigned len)
>  {
> +#ifdef CONFIG_X86_32
> +	return 0;
> +#else
>  	unsigned long addr, end;
>  	unsigned offset;
>  	end = (start + PMD_SIZE - 1) & PMD_MASK;
> @@ -83,6 +86,7 @@ static unsigned long vdso_addr(unsigned
>  	addr = align_vdso_addr(addr);
>  
>  	return addr;
> +#endif
>  }
>  
>  static int map_vdso(const struct vdso_image *image, bool calculate_addr)

Tested-by: Andrew Morton <akpm@linux-foundation.org>
