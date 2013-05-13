Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3EMTgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:36:55 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:8467 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3EMTgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:36:53 -0400
Message-ID: <1368473808.3305.47.camel@bwh-desktop.uk.solarflarecom.com>
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
Date: Mon, 13 May 2013 20:36:48 +0100
In-Reply-To: <CAMuHMdVs+gcuGKdW82g+rkrzo53UGn0zqU8KwsThCY8STwCd0Q@mail.gmail.com>
References: <1368467297.3305.28.camel@bwh-desktop.uk.solarflarecom.com>
	 <CAMuHMdXnp0z-Tn6KBkPzpbmu1jFpZZaSWRGSggysX5QHNx52ng@mail.gmail.com>
	 <1368472300.3305.39.camel@bwh-desktop.uk.solarflarecom.com>
	 <CAMuHMdVs+gcuGKdW82g+rkrzo53UGn0zqU8KwsThCY8STwCd0Q@mail.gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19862.005
X-TM-AS-Result: No--21.189900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 21:16 +0200, Geert Uytterhoeven wrote:
> On Mon, May 13, 2013 at 9:11 PM, Ben Hutchings
> <bhutchings@solarflare.com> wrote:
> >> error: BUILD_BUG_ON failed: sizeof(struct efx_rx_page_state) +
> >> EFX_PAGE_IP_ALIGN + EFX_RX_USR_BUF_SIZE > PAGE_SIZE / 2
> >> make[4]: *** [drivers/net/ethernet/sfc/efx.o] Error 1
> >
> > OK, this doesn't work because on s390 EFX_PAGE_IP_ALIGN == 2 (this macro
> 
> Yeah, that's what I just discovered, too.
> 
> #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> #define EFX_PAGE_IP_ALIGN 0
> #else
> #define EFX_PAGE_IP_ALIGN NET_IP_ALIGN
> #endif
> 
> > is equivalent to NET_IP_ALIGN, though that wasn't always true).  So DMA
> > is going to be misaligned on s390 anyway.
> 
> Hmm, so it's making the choice between misaligned CPU and misaligned
> DMA? Sounds fishy...

When writing headers into an skb, we need to ensure that the IP header
is aligned as required by the CPU.  I'm not sure whether this is true
for page buffers; it will depend on whether GRO pulls the IP header into
an skb header area before looking at it.

For RX DMA, our controller doesn't care about alignment but there is a
performance concern.  So where possible we prefer to align the start of
the DMA buffer with a cache line.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

