Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbaDHUtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:49:13 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55070 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:49:11 -0400
Date: Tue, 8 Apr 2014 13:49:06 -0700
From: josh@joshtriplett.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, Andi Kleen <ak@linux.intel.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140408204906.GA3616@cloud>
References: <20140407201919.GA15838@sepie.suse.cz>
 <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 08:26:09AM -0700, Linus Torvalds wrote:
> On Mon, Apr 7, 2014 at 1:19 PM, Michal Marek <mmarek@suse.cz> wrote:
> > besides the kbuild branch, here is the LTO build support by Andi. It is
> > a separate branch, because it depends on other patches by Andi which
> > were merged through other trees. The link-time-optimization build is an
> > experimental feature, so there one kconfig option to enable it and
> > another kconfig option to disable it (behind a door with a sign "Beware
> > of the Leopard"...), so that it is not enabled by
> > allmodconfig/allyesconfig.
> 
> So right now, I see several reasons not to merge it ("It's so
> experimental that we don't even want to encourage people to test it"
> to "it's not fully fleshed out yet and makes compile times _much_
> longer").
> 
> And yet nobody has actually talked about why I *should* merge it.
> 
> Which - I think understandably - makes me less than enthusiastic.
> 
> So I think I'll let this wait a bit longer, _unless_ people start
> talking about the upsides. How much smaller is the end result? How
> much faster is it? How much more beautiful is it? Does it make new
> cool things possible? Are those cool things really close on the
> horizon and really want this merged even though it's not really quite
> ready yet?
> 
> So please: convince me.

I'd really like to see this feature go in to enable ongoing efforts to
make the kernel much smaller, so I'll give it a shot:

In addition to making the kernel smaller and such (I'll leave the
specific stats there to Andi), here's the key awesomeness of LTO that
you, personally, should find useful and compelling: LTO will eliminate
the need to add many lower-level Kconfig symbols to compile out bits of
the kernel.  Normally, compiling out a piece of kernel infrastructure
requires adding a kernel config symbol for that infrastructure, and
making all the other kernel bits that use that infrastructure depend on
it (which is an extra step beyond just "include the header and use it").
LTO will allow the compiler to automatically drop bits of infrastructure
(such as bits of lib/, kernel/, etc) that aren't used.

And with some additional GCC smarts (which exist today for C++ classes,
but would need adding for C structure-of-function-pointers objects), GCC
with LTO could even optimize away functions that are only used in the
function pointer of a data structure for which there are no callers.
So, it'd be possible to compile out high-level user-facing items like
syscalls, and have all the infrastructure go away all the way down.

So, with LTO merged, the next time you see a patch to add yet another
Kconfig symbol to compile out some low-level kernel infrastructure when
not needed, you can say "no, I don't want to add more configuration
complexity; compile out the high-level bits and use LTO to make the
compiler drop the infrastructure".  And we can potentially start ripping
out *existing* Kconfig infrastructure symbols like that, too.

- Josh Triplett
