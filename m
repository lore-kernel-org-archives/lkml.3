Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab3HMOub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:50:31 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60175 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619Ab3HMOu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:50:28 -0400
MIME-Version: 1.0
In-Reply-To: <871u633t27.fsf@igel.home>
References: <871u633t27.fsf@igel.home>
Date: Tue, 13 Aug 2013 16:50:26 +0200
X-Google-Sender-Auth: WepefXTa3oNGA7nL89LjmSYBoj8
Message-ID: <CAMuHMdV-cWUgsjHkuSMwrTE8jeq8U8Xr13ZT0Vji2utfQJHhLg@mail.gmail.com>
Subject: Re: [PATCH] m68k: truncate base in do_div
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Debian m68k <debian-68k@lists.debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 9, 2013 at 3:14 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Explicitly truncate the second operand of do_div to 32 bits to guard
> against bogus code calling it with a 64bit divisor.
>
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>

I added

    [Thorsten]

    After upgrading from 3.2 to 3.10, mounting a btrfs volume fails with:

    btrfs: setting nodatacow, compression disabled
    btrfs: enabling auto recovery
    btrfs: disk space caching is enabled
    *** ZERO DIVIDE ***   FORMAT=2
    Current process id is 722
    BAD KERNEL TRAP: 00000000
    Modules linked in: evdev mac_hid ext4 crc16 jbd2 mbcache btrfs xor lzo_compr
    PC: [<319535b2>] __btrfs_map_block+0x11c/0x119a [btrfs]
    SR: 2000  SP: 30c1fab4  a2: 30f0faf0
    d0: 00000000    d1: 00001000    d2: 00000000    d3: 00000000
    d4: 00010000    d5: 00000000    a0: 3085c72c    a1: 3085c72c
    Process mount (pid: 722, task=30f0faf0)
    Frame format=2 instr addr=319535ae
    Stack from 30c1faec:
            00000000 00000020 00000000 00001000 00000000 01401000 30253928 300ff
            00a843ac 3026f640 00000000 00010000 0009e250 00d106c0 00011220 00000
            00001000 301c6830 0009e32a 000000ff 00000009 3085c72c 00000000 00000
            30c1fd14 00000000 00000020 00000000 30c1fd14 0009e26c 00000020 00000
            00000000 0009dd8a 300b0b6c 30253928 00a843ac 00001000 00000000 00000
            0000a008 3194e76a 30253928 00a843ac 00001000 00000000 00000000 00000
    Call Trace: [<00001000>] kernel_pg_dir+0x0/0x1000

        [...]

    Code: 222e ff74 2a2e ff5c 2c2e ff60 4c45 1402 <2d40> ff64 2d41 ff68 2205 4c2

    [Geert]

    As diagnosed by Andreas, fs/btrfs/volumes.c:__btrfs_map_block()
    calls

        do_div(stripe_nr, stripe_len);

    with stripe_len u64, while do_div() assumes the divisor is a 32-bit number.

    Due to the lack of truncation in the m68k-specific implementation of
    do_div(), the division is performed using the upper 32-bit word of
    stripe_len, which is zero.

    This was introduced by commit 53b381b3abeb86f12787a6c40fee9b2f71edc23b
    ("Btrfs: RAID5 and RAID6"), which changed the divisor from
    map->stripe_len (struct map_lookup.stripe_len is int) to a 64-bit temporary.

    Reported-by: Thorsten Glaser <tg@debian.org>
    Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
    Tested-by: Thorsten Glaser <tg@debian.org>
    Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
    Cc: stable@vger.kernel.org

> ---
>  arch/m68k/include/asm/div64.h | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/m68k/include/asm/div64.h b/arch/m68k/include/asm/div64.h
> index 444ea8a..ef881cf 100644
> --- a/arch/m68k/include/asm/div64.h
> +++ b/arch/m68k/include/asm/div64.h
> @@ -15,16 +15,17 @@
>                 unsigned long long n64;                         \
>         } __n;                                                  \
>         unsigned long __rem, __upper;                           \
> +       unsigned long __base = (base);                          \
>                                                                 \
>         __n.n64 = (n);                                          \
>         if ((__upper = __n.n32[0])) {                           \
>                 asm ("divul.l %2,%1:%0"                         \
> -                       : "=d" (__n.n32[0]), "=d" (__upper)     \
> -                       : "d" (base), "0" (__n.n32[0]));        \
> +                    : "=d" (__n.n32[0]), "=d" (__upper)        \
> +                    : "d" (__base), "0" (__n.n32[0]));         \
>         }                                                       \
>         asm ("divu.l %2,%1:%0"                                  \
> -               : "=d" (__n.n32[1]), "=d" (__rem)               \
> -               : "d" (base), "1" (__upper), "0" (__n.n32[1])); \
> +            : "=d" (__n.n32[1]), "=d" (__rem)                  \
> +            : "d" (__base), "1" (__upper), "0" (__n.n32[1]));  \
>         (n) = __n.n64;                                          \
>         __rem;                                                  \
>  })
> --
> 1.8.3.4

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
