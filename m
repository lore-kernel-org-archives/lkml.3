Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3BDBbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 20:31:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37140 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3BDBbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 20:31:19 -0500
Date: Mon, 4 Feb 2013 01:31:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
Message-ID: <20130204013111.GX4503@ZenIV.linux.org.uk>
References: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com>
 <20130127195714.GA11224@samfundet.no>
 <20130127203009.GG4503@ZenIV.linux.org.uk>
 <20130127203954.GA22063@samfundet.no>
 <20130204001055.GV4503@ZenIV.linux.org.uk>
 <20130204003047.GW4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204003047.GW4503@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 12:30:47AM +0000, Al Viro wrote:
> On Mon, Feb 04, 2013 at 12:10:55AM +0000, Al Viro wrote:
> > On Sun, Jan 27, 2013 at 09:39:54PM +0100, Hans-Christian Egtvedt wrote:
> > > > If you are OK with going that way, I could probably put together patches doing
> > > > just that.  Note that for rt_sigsuspend/rt_sigreturn/sigaltstack the wrappers
> > > > are not needed at all - they can just use current_pt_regs() in syscall body.
> > > > IOW, all of syscall-stubs.S could be killed.
> > > 
> > > Nice, could you put together the preprocessor stuff in a patch? It would be
> > > great to not having to write a re-occuring stub for each syscall that has 6+
> > > arguments.
> > > 
> > > Thanks for looking at this.
> > 
> > Apologies about the delay...  One question: what's the AVR32 C ABI for
> > passing 64bit arguments?  The tricky bugger is sys_sync_file_range();
> > it takes (s32, s64, s64, u32) as arguments and if not any pair of
> > registers can be used to pass 64bit value, we have more serious trouble
> > there...
> 
> BTW, it's worse: both fadivse64 and fadvise64_64 are wired, neither of them
> has a wrapper and arguments are (s32, s64, u32, s32) and (s32, s64, s64, s32)
> resp.  The former is OK unless you have restrictions on register pairs that
> can be used for 64bit; the latter is past the 5-register limit no matter what,
> so the wrapper is really needed.

Unless I'm misreading ocavr32.pdf, that should be (R12, R10:R11, R9, R8) and
(R12, R10:R11, R9:R8, stack) resp., so fadvise64 doesn't need a wrapper, but
fadvise64_64 does.  And something like (s32, s32, s64, s64) would turn into
(R12, R11, R9:R8, stack, stack); AFAICS, we don't have anything that ugly...

Automating *that* is going to be interesting...  I've not given up, but it's
not going to be fun ;-/
