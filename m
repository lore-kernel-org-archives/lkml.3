Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaBNAJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:09:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49798 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaBNAJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:09:09 -0500
Date: Fri, 14 Feb 2014 00:09:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214000902.GA3078@ZenIV.linux.org.uk>
References: <20140212040358.GA25327@redhat.com>
 <20140212042215.GN18016@ZenIV.linux.org.uk>
 <20140212054043.GB13997@dastard>
 <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
 <20140212113928.GO18016@ZenIV.linux.org.uk>
 <CA+55aFywwx0Q8xK2GJiRJ+FV7PQEKoBRxDUxW4052FVyd5XOpg@mail.gmail.com>
 <20140212211421.GP18016@ZenIV.linux.org.uk>
 <CA+55aFyobyUNFo=3rpdbxTqgV7OQetCKbCfwEEbgxUcT-1+30w@mail.gmail.com>
 <20140212214411.GQ18016@ZenIV.linux.org.uk>
 <20140213205146.GS18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213205146.GS18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 08:51:46PM +0000, Al Viro wrote:
> On Wed, Feb 12, 2014 at 09:44:11PM +0000, Al Viro wrote:
> 
> > I'll try to put something along those lines together, if you or Oleg don't
> > do it first.
> 
> OK, having looked at that stuff...
> 
> 1) things become much more compact if we finish conversion to get_signal()
> first.  Callers of get_signal_to_deliver() have k_sigaction and siginfo in
> pair of local variables; switching to ksignal will be neutral wrt stack
> footprint (it just gathers those two in one struct) *and* we are getting
> rid of passing struct siginfo * around.  With that done, we can change
> struct ksignal ->info with zero impact on the code in arch/*, and conversion
> makes sense on its own.  In the mainline we have it done for alpha, arm,
> openrisc, sparc and x86.  I've just put together preliminary (and completely
> untested) patches for arm64, m68k and um; doing the rest won't take long, but
> they'll obviously need to be tested.  It's a fairly safe conversion;
> I'd expect the worst bugs to be typos.

OK, there's a couple of tricks that allow to reorder that.  First of all,
temporary config symbol (ARCH_USES_KSIGNAL) selecting that stuff; if it's
not selected, we just have #define small_siginfo siginfo and
#define assign_sigqueue(info, q) WARN_ON((q) != NULL)
and that's it - most of the changes in core kernel consist of s/siginfo/small_&/
and non-trivial ones are under ifdef CONFIG_ARCH_USES_KSIGNAL for the time
being.  Small ifdefs, at that...

Once all architectures get converted, we'll just kill that config symbol and
make ifdefs unconditional.

Another is that we don't need to bother with task_work_add() at all; on
converted architectures we have signal_setup_done(..., ksig, ...) called after
each successful get_signal() (the first argument of signal_setup_done() is
"has sigframe setup failed" flag; we get there regardless of success or
failure of setup_...frame()).  So we can just have that sucker do
assign_sigqueue(&ksig->info, NULL) and be done with that - all this delayed
freeing is explicit now (and we don't get locking overhead, etc. of
task_work_add()).

If what I've got survives the local beating, I'll put it into signal.git,
throw the arch conversions I could test in there and ask on linux-arch for
help with the missing ones.  With any luck we'll get the full set by the
next merge window, at which point we'll be able to kill ifdefs.
