Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaESOrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:47:14 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:39417 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaESOrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:47:12 -0400
Date: Mon, 19 May 2014 14:46:59 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Arnd Bergmann <arnd@arndb.de>
CC: Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
In-Reply-To: <4254860.84WuxPQ4j9@wuerfel>
Message-ID: <Pine.LNX.4.64.1405191431210.25418@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
 <9236147.lyD24Zv5SZ@wuerfel> <Pine.LNX.4.64.1405152050230.911@digraph.polyomino.org.uk>
 <4254860.84WuxPQ4j9@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 19 May 2014 14:47:03.0916 (UTC) FILETIME=[32E152C0:01CF7371]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Arnd Bergmann wrote:

> I'm mostly worried about the embedded use case, which at least for time_t
> would have to build everything the new way as soon as possible. For
> desktop and server systems, doing a slow migration to catch the bugs
> and never introduce regressions in the field makes a lot of sense,
> but when someone today wants to build an embedded system, they already
> build everything from source, and it's more important to find all
> the bugs now (ideally at compile time) than to have a chance of hitting
> a subtle issue 24 years ago on today's build.
> 
> For that, it would be nice to even build a glibc that has no backwards
> compatibility interfaces for 32-bit time_t at all.

Building glibc without compatibility interfaces is --enable-oldest-abi (to 
disable ABIs obsoleted before a given point, so that if the 32-bit time_t 
interfaces are obsoleted and no longer available for new builds then it 
would disable them) - but that's been bitrotten for years 
<https://sourceware.org/bugzilla/show_bug.cgi?id=6652> and there is 
consensus to remove it if anyone sends a patch.  (Similarly, 
--disable-versioning support was removed.  The sort of really tiny 
embedded systems for which that sort of thing is relevant as space 
reduction no longer seem so relevant to glibc; there has been no interest 
in merging option group support from EGLIBC to glibc now EGLIBC 
development has been discontinued.)

Now, when the motivation is not space reduction but ensuring nothing is 
there that will break in 2038 (unless it's doing dubious things like 
storing a time_t value in an int or long in the application - something a 
reasonably stupid static analysis should be able to detect), you could 
always identify the (symbol, version) pairs for a given architecture that 
use 32-bit time_t and develop a tool that checks for binaries using 
problem symbols.  (Of course, that won't help with ioctls.)  Or put a 
small patch in the headers to force _TIME_BITS=64 and not allow an 
override with _TIME_BITS=32.  And if the kernel had a config option to 
disable all the old interfaces, that would make problem binaries break now 
rather than in 2038.

> > > I don't know why timespec on x32 uses 'long tv_nsec', it does seem
> > > problematic.
> > 
> > Yes, we have a glibc bug 
> > <https://sourceware.org/bugzilla/show_bug.cgi?id=16437> about the glibc 
> > definition (64-bit tv_nsec in x32 userspace to match the kernel's 64-bit 
> > "long") being nonconforming, but without the kernel treating upper bits as 
> > padding, fixing glibc requires wrappers that copy the value and clear the 
> > upper bits.
> 
> Ok. There is also work going on to have an x32-like ABI for ARM64, and
> that will likely have to support big-endian as well, so then it's not
> just about clearing the padding bits, but also having them in the right
> place.

Yes, I see no problem with putting the padding bits in the right place so 
that when the kernel is passing struct timespec values *to* userspace, it 
can just fill in the native 64-bit structure and have it automatically be 
correct when interpreted as a 32-bit structure with padding (which the 
kernel will have zeroed implicitly) on tv_nsec.

-- 
Joseph S. Myers
joseph@codesourcery.com
