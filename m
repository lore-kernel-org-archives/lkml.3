Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbbA0XLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:11:35 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:52585 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbA0XLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:11:33 -0500
Date: Wed, 28 Jan 2015 00:13:14 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
        Mike Frysinger <vapier@gentoo.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] lib/checksum.c: fix carry in csum_tcpudp_nofold
Message-ID: <20150127231314.GA21679@gobelin>
References: <1422372316-25287-1-git-send-email-karl.beldan@rivierawaves.com>
 <20150127220332.GZ29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150127220332.GZ29656@ZenIV.linux.org.uk>
X-Location: France
User-Agent: Mutt (3.18.0-rc7-00059-g56c67ce)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 10:03:32PM +0000, Al Viro wrote:
> On Tue, Jan 27, 2015 at 04:25:16PM +0100, Karl Beldan wrote:
> > The carry from the 64->32bits folding was dropped, e.g with:
> > saddr=0xFFFFFFFF daddr=0xFF0000FF len=0xFFFF proto=0 sum=1
> > 
> > Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> > Cc: Mike Frysinger <vapier@gentoo.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: Stable <stable@vger.kernel.org>
> > ---
> >  lib/checksum.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/checksum.c b/lib/checksum.c
> > index 129775e..4b5adf2 100644
> > --- a/lib/checksum.c
> > +++ b/lib/checksum.c
> > @@ -195,8 +195,8 @@ __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
> >  #else
> >  	s += (proto + len) << 8;
> >  #endif
> > -	s += (s >> 32);
> > -	return (__force __wsum)s;
> > +	s += (s << 32) + (s >> 32);
> > +	return (__force __wsum)(s >> 32);
> 
> Umm...  I _think_ it's correct, but it needs a better commit message.  AFAICS,
> what we have is that s is guaranteed to be (a << 32) + b, with a being small.
> What we want is something congruent to a + b modulo 0xffff.  And yes, in case
> when a + b >= 2^32, the original variant fails - it yields a + b - 2^32, which
> is one less than what's needed.  New one results first in
> (a + b)(2^32+1)mod 2^64, then that divided by 2^32.  If a + b <= 2^32 - 1,
> the first product is less than 2^64 and dividing it by 2^32 yields a + b.
> If a + b = 2^32 + c, c is guaranteed to be small and we first get
> 2^32 * c + 2^32 + 1, then c + 1, i.e. a + b - 0xffffffff, i.e.
> a + b - 0x10001 * 0xffff, so the congruence holds in all cases.
> 
> IOW, I think the fix is correct, but it really needs analysis in the commit
> message.

My take on this was "somewhat" simpler:

s = a31..0b31..b0 = a << 32 + b, as you put it

Here however I don't assume that a is "small", however I assume it has
never overflowed, which is trivial to verify since we only add 3 32bits
values and 2 16 bits values to a 64bits.
Now we just want (a + b + carry(a + b)) % 2^32, and here I assume
(a + b + carry(a + b)) % 2^32 == (a + b) % 2^32 + carry(a + b), I
guess this is the trick, and this is easy to convince oneself with:
0xffffffff + 0xffffffff == 0x1fffffffe ==>
((u32)-1 + (u32)-1 + 1) % 2^32 == 0xfffffffe % 2^32 + 1
We get this carry pushed out from the MSbs side by the s+= addition
pushed back in to the LSbs side of the upper 32bits and this carry
doesn't make the upper side overflow.

If this explanation is acceptable, I can reword the commit message with
it. Sorry if my initial commit log lacked details, and thanks for your
detailed input.

 
Karl
