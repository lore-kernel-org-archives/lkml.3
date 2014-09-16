Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaIPVQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:16:31 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:53896 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaIPVQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:16:28 -0400
MIME-Version: 1.0
In-Reply-To: <541824CE020000780003550B@mail.emea.novell.com>
References: <541824CE020000780003550B@mail.emea.novell.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 16 Sep 2014 14:16:07 -0700
Message-ID: <CALCETrWU6xiZB51MGENTqYSFEi2UFchkHtRFkot0mrkycd2RmA@mail.gmail.com>
Subject: Re: suspicious compiler warning in vdso2c.h
To: Jan Beulich <JBeulich@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 16, 2014 2:53 AM, "Jan Beulich" <JBeulich@suse.com> wrote:
>
> Andy
>
> following e6577a7ce9 ("x86, vdso: Move the vvar area before the
> vdso text") gcc 4.3.4 tells me
>
> .../arch/x86/vdso/vdso2c.c: In function ‘main’:
> .../arch/x86/vdso/vdso2c.h:118: warning: assuming signed overflow does not occur when assuming that (X + c) < X is
> always false
> .../arch/x86/vdso/vdso2c.h:118: warning: assuming signed overflow does not occur when assuming that (X + c) < X is
> always false

Yes.  There's a more or less equivalent fix sitting in -mm.

--Andy

>
> apparently because it unrolls the containing loop and finds i ==
> sym_vvar_start on the first iteration. I think there was a hidden
> dependency before your change on required_syms[] first two
> entries matching up with special_pages[]. If that's correct, all
> syms[i] within said loop would seem to need replacing by
> syms[special_pages[i]] (similarly for required_syms[i] afaict, see
> below draft patch), which also is in line with the loop iterating
> over the array elements of special_pages[].
>
> Question then of course is - are there any further hidden
> dependencies that already got or may eventually get broken?
>
> Jan
>
> --- a/arch/x86/vdso/vdso2c.h
> +++ b/arch/x86/vdso/vdso2c.h
> @@ -109,18 +109,18 @@ static void BITSFUNC(go)(void *raw_addr,
>
>         /* Validate mapping addresses. */
>         for (i = 0; i < sizeof(special_pages) / sizeof(special_pages[0]); i++) {
> -               if (!syms[i])
> +               if (!syms[special_pages[i]])
>                         continue;  /* The mapping isn't used; ignore it. */
>
> -               if (syms[i] % 4096)
> +               if (syms[special_pages[i]] % 4096)
>                         fail("%s must be a multiple of 4096\n",
> -                            required_syms[i].name);
> -               if (syms[sym_vvar_start] > syms[i] + 4096)
> +                            required_syms[special_pages[i]].name);
> +               if (syms[sym_vvar_start] > syms[special_pages[i]] + 4096)
>                         fail("%s underruns begin_vvar\n",
> -                            required_syms[i].name);
> -               if (syms[i] + 4096 > 0)
> +                            required_syms[special_pages[i]].name);
> +               if (syms[special_pages[i]] + 4096 > 0)
>                         fail("%s is on the wrong side of the vdso text\n",
> -                            required_syms[i].name);
> +                            required_syms[special_pages[i]].name);
>         }
>         if (syms[sym_vvar_start] % 4096)
>                 fail("vvar_begin must be a multiple of 4096\n");
>
