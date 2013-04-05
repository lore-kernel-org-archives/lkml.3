Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161688Ab3DEJkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:40:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60138 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765545Ab3DEJkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:40:43 -0400
Message-ID: <515E9C0D.503@cip.cs.fau.de>
Date: Fri, 05 Apr 2013 11:40:29 +0200
From: Sebastian Wankerl <sisewank@cip.cs.fau.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Philip Kranz <philip.kranz@googlemail.com>, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, i4passt@lists.informatik.uni-erlangen.de
Subject: Re: [PATCH] Add non-zero module sections to sysfs
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de> <87mwtf3ya1.fsf@rustcorp.com.au> <515D4A7F.5070102@cip.cs.fau.de> <87vc81lj7x.fsf@rustcorp.com.au>
In-Reply-To: <87vc81lj7x.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:h/9w6NUd7mTL8pSM1wS80hTvqF6zsDXmFHwxJnhAjD5
 oVKYglyFxHAhWt2jd9N8LhMljTgmhvpBV56OfdjawcF4a96xWt
 7Ja/8+rQjm1e9hyOZMznIk9z8mkp+EqLvcORDnvl4e/G3nAWG2
 C3+CI9sS3gzaeX/Juzch6BkeQ4gRVkwszied/yxBI1AXOf0fgO
 Q4CrUtykeAsJJ+uWHXH/OqF38wR+7RW4dx8NzFkdiu9oWKLc0z
 UGF9Vd2nS7gJ3WUfrMm7k2YjWaDG3wabnMzcMzLTa4zKJQpysF
 C5ptf6WZy5hpSaXvWv1ps5iOtwrEeUxHIUqN2AbdeLfADczVR/
 QZ9QD+oLmk3dYJoLxvPc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/13 06:00, Rusty Russell wrote:
> Exactly.  Don't workaround it here, revert it and put the
> duplicate-section-name fixup in parisc where it belongs.
>
> Assuming parisc still produces these dup sections: that patch is 4 years
> old now.
>
> Untested:
>
> diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
> index 2a625fb..28d32a2 100644
> --- a/arch/parisc/kernel/module.c
> +++ b/arch/parisc/kernel/module.c
> @@ -341,6 +341,11 @@ int module_frob_arch_sections(CONST Elf_Ehdr *hdr,
>  			    ".PARISC.unwind", 14) == 0)
>  			me->arch.unwind_section = i;
>  
> +		/* we produce multiple, empty .text sections, and kallsyms
> +		 * gets upset.  make non-alloc so it doesn't see them. */
> +		if (sechdrs[i].sh_size == 0)
> +			sechdrs[i].sh_flags &= ~SHF_ALLOC;
> +
>  		if (sechdrs[i].sh_type != SHT_RELA)
>  			continue;
We just worked your suggested patch in.

> Why?  Does something refer to this empty section?  Why has noone noticed
> this since 2009?

GDB wants to know all section with attribute ALLOC, regardless whether
they are empty or not. Thus, it is useful if all of them appear in sysfs.
> A zero-length section doesn't change the binary's structure.  You don't
> see non-SHF_ALLOC sections either.

Yes, but they do occupy an index in the section headers of the binary.
GDB needs to know all of them in the right order.
