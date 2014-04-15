Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaDOKtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:49:41 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:58654 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaDOKtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:49:39 -0400
MIME-Version: 1.0
In-Reply-To: <534c5757.VydWMxxcqkXGiwNa%akpm@linux-foundation.org>
References: <534c5757.VydWMxxcqkXGiwNa%akpm@linux-foundation.org>
Date: Tue, 15 Apr 2014 13:49:38 +0300
Message-ID: <CACVxJT-f+K_z-XxqjDVU_QK-VJPqnCEbWuMJF1fyTL0V0xiTgA@mail.gmail.com>
Subject: Re: + lib-stringc-strlcpy-might-read-too-far.patch added to -mm tree
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 12:47 AM,  <akpm@linux-foundation.org> wrote:
> Subject: lib/string.c: strlcpy() might read too far
>
> Imagine you have a user controlled variable at the end of a struct which
> is allocated at the end of a page.  The strlen() could read beyond the
> mapped memory and cause an oops.
>
> Probably there are two reasons why we have never hit this condition in
> real life.  First you would have to be really unlucky for all the
> variables to line up so the oops can happen.  Second we don't do a lot of
> fuzzing with invalid strings.
>
> The strnlen() call is obviously a little bit slower than strlen() but I
> have tested it and I think it's probably ok.

> --- a/lib/string.c~lib-stringc-strlcpy-might-read-too-far
> +++ a/lib/string.c
> @@ -148,10 +148,10 @@ EXPORT_SYMBOL(strncpy);
>   */
>  size_t strlcpy(char *dest, const char *src, size_t size)
>  {
> -       size_t ret = strlen(src);
> +       size_t ret = strnlen(src, size);
>
>         if (size) {
> -               size_t len = (ret >= size) ? size - 1 : ret;
> +               size_t len = (ret < size) ? ret : ret - 1;
>                 memcpy(dest, src, len);
>                 dest[len] = '\0';
>         }

Return value matters. It may not matter for kernel, because kernel is
not heavy string user.
But it is better to not diverge from master code:
http://www.openbsd.org/cgi-bin/cvsweb/src/lib/libc/string/strlcpy.c?rev=1.11

Counter-rationale:
* strlcpy() accepts strings, so if you're giving raw buffer you're
doing it wrong.
* last byte of last page argument is bogus because kernel copies data
from userspace first.
