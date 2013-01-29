Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3A2MQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:16:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57618 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3A2MQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:16:46 -0500
Date: Tue, 29 Jan 2013 12:15:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Egon Alter <egon.alter@gmx.net>
Cc: linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, hyojun.im@lge.com,
        raphael.andy.lee@gmail.com, linux-kbuild@vger.kernel.org,
        gunho.lee@lge.com, namhyung.kim@lge.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Ingo Molnar <mingo@redhat.com>, Joe Millenbach <jmillenbach@gmail.com>,
        chan.jeong@lge.com, Kyungsik Lee <kyungsik.lee@lge.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        minchan.kim@lge.com
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
Message-ID: <20130129121530.GS23505@n2100.arm.linux.org.uk>
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com> <20130128142510.68092e10.akpm@linux-foundation.org> <20130129101549.GP23505@n2100.arm.linux.org.uk> <34874167.ghObrToI03@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34874167.ghObrToI03@fb07-iapwap2>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 12:43:20PM +0100, Egon Alter wrote:
> Am Dienstag, 29. Januar 2013, 10:15:49 schrieb Russell King - ARM Linux:
> > On Mon, Jan 28, 2013 at 02:25:10PM -0800, Andrew Morton wrote:
> > > What's this "with enabled unaligned memory access" thing?  You mean "if
> > > the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS"?  If so,
> > > that's only x86, which isn't really in the target market for this
> > > patch, yes?
> > > 
> > > It's a lot of code for a 50ms boot-time improvement.  Does anyone have
> > > any opinions on whether or not the benefits are worth the cost?
> > 
> > Well... when I saw this my immediate reaction was "oh no, yet another
> > decompressor for the kernel".  We have five of these things already.
> > Do we really need a sixth?
> > 
> > My feeling is that we should have:
> > - one decompressor which is the fastest
> > - one decompressor for the highest compression ratio
> > - one popular decompressor (eg conventional gzip)
> 
> the problem gets more complicated as the "fastest" decompressor usually 
> creates larger images which need more time to load from the storage, e.g. a 
> one MB larger image on a 10 MB/s storage (note: bootloaders often configure 
> the  storage controllers in slow modes) gives 100 ms more boot time, thus 
> eating the gain of a "fast decompressor".

Ok.

We already have:

- lzma: 33% smaller than gzip, decompression speed between gzip and bzip2
- xz: 30% smaller than gzip, decompression speed similar to lzma
- bzip2: 10% smaller than gzip, slowest decompression
- gzip: reference implementation
- lzo: 10% bigger than gzip, fastest

And now:

- lz4: 8% bigger than lzo, 16% faster than lzo?
  (I make that 16% bigger than gzip)

So, image size wise, on a 2MB compressed gzip image, we're looking at
the difference between LZO at 2.2MB and LZ4 at 2.38MB.

But let's not stop there - the figures given for a 13MB decompressed
image were:

lzo: 6.3MB, 301ms
lz4: 6.8MB, 251ms(167ms, with enabled unaligned memory access)

At 10MB/s (your figure), it takes .68s to read 6.8MB as opposed to .63s
for LZO.  So, totalling up these figures gives to give the overall figure:

lzo: 301ms + 630ms = 931ms
lz4: 167ms + 680ms = 797ms

Which gives the tradeoff at 10MB/s of 14% faster (but only with efficient
unaligned memory access.)  So... this faster decompressor is still the
fastest even with your media transfer rate factored in.

That gives an argument for replacing lzo with lz4...
