Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3EMTCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:02:45 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:35252 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3EMTCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:02:43 -0400
MIME-Version: 1.0
In-Reply-To: <1368467297.3305.28.camel@bwh-desktop.uk.solarflarecom.com>
References: <1368467297.3305.28.camel@bwh-desktop.uk.solarflarecom.com>
Date: Mon, 13 May 2013 21:02:42 +0200
X-Google-Sender-Auth: XvNo4rrg6ZvrnaCj9D5n227V4Tk
Message-ID: <CAMuHMdXnp0z-Tn6KBkPzpbmu1jFpZZaSWRGSggysX5QHNx52ng@mail.gmail.com>
Subject: Re: [PATCH net] sfc: Reduce RX scatter buffer size to multiple of 256
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, May 13, 2013 at 7:48 PM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> efx_start_datapath() asserts that we can fit 2 RX scatter buffers plus
> a software structure, each cache-aligned, into a single page.  Where
> L1_CACHE_BYTES == 256 and PAGE_SIZE == 4096, which is the case on
> s390, this assertion fails.  Reduce EFX_RX_USR_BUF_SIZE to make this
> work.
>
> This should also be good for performance, as it ensures that each RX
> scatter buffer covers whole cache lines and slightly reduces the use
> of DMA writes that can require a read-modify-write on inter-processor
> links.
>
> (We could use 2048 - L1_CACHE_BYTES, but EFX_RX_USR_BUF_SIZE also
> affects user-level networking where a larger amount of housekeeping
> data may be needed.  Although this version of the driver does not
> support user-level networking, I prefer to keep scattering behaviour
> consistent with the out-of-tree version.)
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> ---
> Heiko or Geert, please confirm that this really does fix the build

Thanks! But unfortunately I still get the same error:

  CC [M]  drivers/net/ethernet/sfc/efx.o
/scratch/geert/linux/linux-m68k/drivers/net/ethernet/sfc/efx.c: In
function 'efx_start_datapath':
/scratch/geert/linux/linux-m68k/drivers/net/ethernet/sfc/efx.c:646:3:
error: call to '__compiletime_assert_648' declared with attribute
error: BUILD_BUG_ON failed: sizeof(struct efx_rx_page_state) +
EFX_PAGE_IP_ALIGN + EFX_RX_USR_BUF_SIZE > PAGE_SIZE / 2
make[4]: *** [drivers/net/ethernet/sfc/efx.o] Error 1

> failure - I don't have an s390 toolchain.

http://kernel.org/pub/tools/crosstool/files/bin/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
