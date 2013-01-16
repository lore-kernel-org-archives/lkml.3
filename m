Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3APSJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:09:22 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55376 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3APSJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:09:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130116105757.GB26569@linux-mips.org>
References: <1358200025-15994-1-git-send-email-dinggnu@gmail.com>
	<20130116105757.GB26569@linux-mips.org>
Date: Wed, 16 Jan 2013 19:09:18 +0100
X-Google-Sender-Auth: TymiDhQJkbc45H2Muq9g2Nngzto
Message-ID: <CAMuHMdUiJN_1anMHiEAvtjGTTREKdds361bqppu=7uJK4nxJyw@mail.gmail.com>
Subject: Re: [PATCH] mpis: cavium-octeon/executive/cvmx-l2c.c: fix
 uninitialized variable
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Cong Ding <dinggnu@gmail.com>, Jim Quinlan <jim2101024@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <ddaney@caviumnetworks.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 11:57 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Mon, Jan 14, 2013 at 10:47:03PM +0100, Cong Ding wrote:
>
>> the variable dummy is used without initialization.
>
> Interesting - I wonder how you found this one.  My compiler (gcc 4.7)
> doesn't warn about this one.

Probably older gcc does.

> Nor does gcc notice that the whole summing up business is wasted efford.
>
> So here's my counter proposal.  It works because ptr is a volatile pointer
> so the compiler will always dereference it even if the returned value is
> not being used.  The resulting code is a bit smaller.
>
>   Ralf
>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
>
>  arch/mips/cavium-octeon/executive/cvmx-l2c.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/cavium-octeon/executive/cvmx-l2c.c b/arch/mips/cavium-octeon/executive/cvmx-l2c.c
> index 9f883bf..ec3e059 100644
> --- a/arch/mips/cavium-octeon/executive/cvmx-l2c.c
> +++ b/arch/mips/cavium-octeon/executive/cvmx-l2c.c
> @@ -286,7 +286,7 @@ uint64_t cvmx_l2c_read_perf(uint32_t counter)
>  static void fault_in(uint64_t addr, int len)
>  {
>         volatile char *ptr;
> -       volatile char dummy;
> +
>         /*
>          * Adjust addr and length so we get all cache lines even for
>          * small ranges spanning two cache lines.
> @@ -300,7 +300,7 @@ static void fault_in(uint64_t addr, int len)
>          */
>         CVMX_DCACHE_INVALIDATE;
>         while (len > 0) {
> -               dummy += *ptr;
> +               *ptr;

Alternatively, to make clearer what's intended:
  - drop the "volatile" from "ptr" and from the cast when assigning to it,
  - use "ACCESS_ONCE(*ptr)" instead of "*ptr".

>                 len -= CVMX_CACHE_LINE_SIZE;
>                 ptr += CVMX_CACHE_LINE_SIZE;
>         }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
