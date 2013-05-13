Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab3EMTLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:11:47 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:60235 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3EMTLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:11:45 -0400
Message-ID: <1368472300.3305.39.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH net] sfc: Reduce RX scatter buffer size to multiple of
 256
From: Ben Hutchings <bhutchings@solarflare.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: David Miller <davem@davemloft.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 13 May 2013 20:11:40 +0100
In-Reply-To: <CAMuHMdXnp0z-Tn6KBkPzpbmu1jFpZZaSWRGSggysX5QHNx52ng@mail.gmail.com>
References: <1368467297.3305.28.camel@bwh-desktop.uk.solarflarecom.com>
	 <CAMuHMdXnp0z-Tn6KBkPzpbmu1jFpZZaSWRGSggysX5QHNx52ng@mail.gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19862.005
X-TM-AS-Result: No--24.656000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 21:02 +0200, Geert Uytterhoeven wrote:
> Hi Ben,
> 
> On Mon, May 13, 2013 at 7:48 PM, Ben Hutchings
> <bhutchings@solarflare.com> wrote:
> > efx_start_datapath() asserts that we can fit 2 RX scatter buffers plus
> > a software structure, each cache-aligned, into a single page.  Where
> > L1_CACHE_BYTES == 256 and PAGE_SIZE == 4096, which is the case on
> > s390, this assertion fails.  Reduce EFX_RX_USR_BUF_SIZE to make this
> > work.
> >
> > This should also be good for performance, as it ensures that each RX
> > scatter buffer covers whole cache lines and slightly reduces the use
> > of DMA writes that can require a read-modify-write on inter-processor
> > links.
> >
> > (We could use 2048 - L1_CACHE_BYTES, but EFX_RX_USR_BUF_SIZE also
> > affects user-level networking where a larger amount of housekeeping
> > data may be needed.  Although this version of the driver does not
> > support user-level networking, I prefer to keep scattering behaviour
> > consistent with the out-of-tree version.)
> >
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
> > ---
> > Heiko or Geert, please confirm that this really does fix the build
> 
> Thanks! But unfortunately I still get the same error:
> 
>   CC [M]  drivers/net/ethernet/sfc/efx.o
> /scratch/geert/linux/linux-m68k/drivers/net/ethernet/sfc/efx.c: In
> function 'efx_start_datapath':
> /scratch/geert/linux/linux-m68k/drivers/net/ethernet/sfc/efx.c:646:3:
> error: call to '__compiletime_assert_648' declared with attribute
> error: BUILD_BUG_ON failed: sizeof(struct efx_rx_page_state) +
> EFX_PAGE_IP_ALIGN + EFX_RX_USR_BUF_SIZE > PAGE_SIZE / 2
> make[4]: *** [drivers/net/ethernet/sfc/efx.o] Error 1

OK, this doesn't work because on s390 EFX_PAGE_IP_ALIGN == 2 (this macro
is equivalent to NET_IP_ALIGN, though that wasn't always true).  So DMA
is going to be misaligned on s390 anyway.

I'll see if I can work out a sensible definition that works for s390
while still being good for x86 and powerpc (which are the two we mostly
care about).

> > failure - I don't have an s390 toolchain.
> 
> http://kernel.org/pub/tools/crosstool/files/bin/

I know, but this still takes time to set up.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

