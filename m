Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbbA1U7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:59:00 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49470 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbbA1U65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:58:57 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Fabian Frederick <fabf@skynet.be>, Bjorn Helgaas <bhelgaas@google.com>,
        Ryan Mallon <rmallon@gmail.com>, Masanari Iida <standby24x7@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib/vsprintf.c: Fix potential NULL deref in hex_string
Organization: D03
References: <1422451543-12401-1-git-send-email-linux@rasmusvillemoes.dk>
	<1422451543-12401-2-git-send-email-linux@rasmusvillemoes.dk>
	<1422456824.31903.298.camel@linux.intel.com>
X-Hashcash: 1:20:150128:linux-kernel@vger.kernel.org::oNhwplpoEzcwOUG/:0000000000000000000000000000000001qai
X-Hashcash: 1:20:150128:andriy.shevchenko@linux.intel.com::hUbfr9fUm4vRPJTQ:00000000000000000000000000001Rdm
X-Hashcash: 1:20:150128:akpm@linux-foundation.org::Uv+IHtiNHoo9wnDA:0000000000000000000000000000000000001hmp
X-Hashcash: 1:20:150128:rmallon@gmail.com::B7KmcbQaCgXGgfmD:000000000000000000000000000000000000000000002EGU
X-Hashcash: 1:20:150128:jkosina@suse.cz::ZLWkCJbPcxwEdcW+:001zsj
X-Hashcash: 1:20:150128:rdunlap@infradead.org::g0aIZ1aapNRZX1Ay:00000000000000000000000000000000000000002DJW
X-Hashcash: 1:20:150128:standby24x7@gmail.com::dWgq640l9miShAdc:00000000000000000000000000000000000000002WV6
X-Hashcash: 1:20:150128:fabf@skynet.be::/h5THHfBaqyx5qr3:0007Xgm
X-Hashcash: 1:20:150128:bhelgaas@google.com::TmpQpw+4GEaGGqFV:0000000000000000000000000000000000000000007bQR
Date: Wed, 28 Jan 2015 16:49:05 +0100
In-Reply-To: <1422456824.31903.298.camel@linux.intel.com> (Andy Shevchenko's
	message of "Wed, 28 Jan 2015 16:53:44 +0200")
Message-ID: <87y4omzz0u.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28 2015, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Wed, 2015-01-28 at 14:25 +0100, Rasmus Villemoes wrote:
>> The helper hex_string() is broken in two ways. First, it doesn't
>> increment buf regardless of whether there is room to print, so callers
>> such as kasprintf() that try to probe the correct storage to allocate
>> will get a too small return value. But even worse, kasprintf() (and
>> likely anyone else trying to find the size of the result) pass NULL
>> for buf and 0 for size, so we also have end == NULL. But this means
>> that the end-1 in hex_string() is (char*)-1, so buf < end-1 is true
>> and we get a NULL pointer deref. I double-checked this with a trivial
>> kernel module that just did a kasprintf(GFP_KERNEL, "%14ph",
>> "CrashBoomBang").
>
> Good catch, though I don't like the implementation of fix.
>
> What about the following?
>
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 8690798..47b36ddd 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -783,11 +783,20 @@ char *hex_string(char *buf, char *end, u8 *addr,
> struct printf_spec spec,
>         if (spec.field_width > 0)
>                 len = min_t(int, spec.field_width, 64);
>  
> -       for (i = 0; i < len && buf < end - 1; i++) {
> -               buf = hex_byte_pack(buf, addr[i]);
> +       for (i = 0; i < len; i++) {
> +               if (buf < end)
> +                       *buf = hex_asc_hi(addr[i]);
> +               ++buf;
> +
> +               if (buf < end)
> +                       *buf = hex_asc_lo(addr[i]);
> +               ++buf;
>  
> -               if (buf < end && separator && i != len - 1)
> -                       *buf++ = separator;
> +               if (separator && i != len - 1) {
> +                       if (buf < end)
> +                               *buf = separator;
> +                       ++buf;
> +               }
>         }
>  
>         return buf;

I had exactly that at one point. I think the only reason I ended up
doing it the other way was that I wanted to introduce the write_bytes
helper, and then use that to do some simplifications and optimizations
for other %p helpers. Many of those write their output to a temporary
buffer, knowing exactly how much there is, then delegate to string(),
which then recomputes the string length before printing. But all that
can be done another time, so I'm fine with this also.

Rasmus
