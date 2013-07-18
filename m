Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab3GRP5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:57:15 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:38758 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab3GRP5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:57:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUNQOiaia=j-+Cf7fW33ZfGi-kYAO0Y4qpCa5HBkKN8mQ@mail.gmail.com>
References: <cover.1372515621.git.yann.morin.1998@free.fr>
	<b57caaaed2bd127fe656e6c145970ed6a05c0125.1372515621.git.yann.morin.1998@free.fr>
	<CAMuHMdUNQOiaia=j-+Cf7fW33ZfGi-kYAO0Y4qpCa5HBkKN8mQ@mail.gmail.com>
Date: Thu, 18 Jul 2013 08:57:12 -0700
X-Google-Sender-Auth: 3dfXgs4IAoLTnueD4wgVNqaFbX4
Message-ID: <CAGXu5j+wYmD9H96dY738ALS2OVyeaCj-xjWm95LgGxnZ_ZcViw@mail.gmail.com>
Subject: Re: [PATCH 1/1] kconfig: allow "hex" and "range" to support longs
From: Kees Cook <keescook@chromium.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 3:08 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Sat, Jun 29, 2013 at 4:21 PM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
>> From: Kees Cook <keescook@chromium.org>
>>
>> The parsing routines for Kconfig files use strtol(), but store and
>> render values as int. Switch types and formating to long to support a
>> wider range of values. For example, 0x80000000 wasn't representable.
>
> 0x80000000 does fit in an int. If it's printed as hex, it's treated as unsigned.
> Is there a "0" missing, or am I missing something?

0x80000000 is 1 more than INT_MAX, but you're right about the hex
printing. Regardless, it was still being truncated in kconfig
(probably due to signed comparisons). I had to switch the formatting
since the type changed, though.

>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
>> Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
>> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
>> ---
>>  scripts/kconfig/symbol.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
>> index 387d554..d550300 100644
>> --- a/scripts/kconfig/symbol.c
>> +++ b/scripts/kconfig/symbol.c
>> @@ -136,7 +136,7 @@ static struct property *sym_get_range_prop(struct symbol *sym)
>>         return NULL;
>>  }
>>
>> -static int sym_get_range_val(struct symbol *sym, int base)
>> +static long sym_get_range_val(struct symbol *sym, int base)
>>  {
>>         sym_calc_value(sym);
>>         switch (sym->type) {
>
> Changing all these "int" to "long" only matters on 64-bit platforms.
> As kconfig is built on the host, this will cause different behavior when
> cross-compiling 64-bit (I assume that's where you need it most) kernels
> on a 32-bit or a 64-bit host.
>
> Probably you wanted to use "long long" instead of "long", and switch
> to "strtoll()", to make them always 64-bit?

That's an excellent point; I hadn't considered the cross-compiling
from a 32-bit host.

> Still, beware using 64-bit config symbols with arithmetic shell operations from
> a Makefile, cfr. https://lkml.org/lkml/2013/6/13/200.

Yeah, noted. I don't have plans to pass kconfig items through the shell.

> Sorry for only noticing now, after it went into 3.11-rc1.

Thanks for pointing it out! I don't think there is huge urgency since
nothing is (yet) using > INT_MAX values in kconfig. Regardless, I'll
send a new patch that switches to long long.

-Kees

--
Kees Cook
Chrome OS Security
