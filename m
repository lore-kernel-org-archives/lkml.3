Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288Ab3EGAvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:51:33 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:56286 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab3EGAvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:51:31 -0400
MIME-Version: 1.0
In-Reply-To: <51884263.4020608@zytor.com>
References: <51884263.4020608@zytor.com>
Date: Mon, 6 May 2013 17:51:30 -0700
X-Google-Sender-Auth: YD66qDS1hpY_cB6F2BnZ3gbT23Y
Message-ID: <CA+55aFzwjQ03ZA71rgKMhCqh_+1fcMbPJUK3upcOacX2F8+Z9A@mail.gmail.com>
Subject: Re: The type of bitops
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 4:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> The type of bitops is currently "int" on most, if not all, architectures
> except sparc64 where it is "unsigned long".

By "type of bitops" I assume you mean the actual bit offset.

> It seems pretty clear to me at least that x86-64 really should use
> "long".  However, before blindly making that change I wanted to feel
> people out for what this should look like across architectures.
>
> Moving this forward, I see a couple of possibilities:
>
> 1. We simply change the type to "long" on x86, and let this be a fully
>    architecture-specific option.  This is easy, obviously.

Just do this. There's no reason to overthink it, I think

> 2. Same as above, except we also define a typedef for whatever type is
>    the bitops argument type (bitops_t?  bitpos_t?)

Who would ever use it? In particular, a lot of users will use bitops
for small arrays and will have fundamentally smaller indexes. For
them, "int" or "u32" or whatever may well make sense, and the fact
that that bitops _can_ take larger bit indexes is immaterial.

> 3. Change the type to "long" Linux-wide, on the logic that it should be
>    the same as the general machine width across all platforms.

I don't think it's worth it, but I don't think anybody will care/notice.

> 4. Do some macro hacks so the bitops are dependent on the size of the
>    argument.

That sounds insane. Just *how* could the size of the argument even
matter? Seriously, there's no *difference* between a 32-bit or a
64-bit index. The code is the same, there's no possible reason to make
it be different.

The only place where the actual size of the data matters is in the
underlying bitop bitmap itse;f, and that has always been defined to be
an array of "unsigned long", and we long logn since made sure people
aren't confused about that. But the index? It's just a number, there's
no structure associated with it. Somebody might use an "unsigned char"
as the index into a bitmap, and the operations fundamentally wouldn't
care - casting the bit index it to an "int" (or a "long") doesn't
change the operation.

               Linus
