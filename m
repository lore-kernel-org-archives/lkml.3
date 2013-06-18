Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3FRGwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:52:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47621 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3FRGwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:52:34 -0400
Date: Tue, 18 Jun 2013 07:52:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC] should read(2) update the position if it returns an error?
Message-ID: <20130618065231.GT4165@ZenIV.linux.org.uk>
References: <20130614080528.GM4165@ZenIV.linux.org.uk>
 <CA+55aFyEuDsLtKXDCd1w_dUfOg-4_7b2WBO3P+5VMFXB4XS=YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyEuDsLtKXDCd1w_dUfOg-4_7b2WBO3P+5VMFXB4XS=YQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 08:38:19AM -0700, Linus Torvalds wrote:
> On Fri, Jun 14, 2013 at 1:05 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> >         Comments?  I'd obviously prefer to solve it that way (i.e. leave
> > ->f_pos untouched if vfs_read() returns an error), but I might be missing
> > some case where we want position updated even though read() returns an
> > error.  I can't come up with one, but then I hadn't RTFS through every
> > ->read() instance in drivers in search of weird cases like that - we've
> > too many instances ;-/
> 
> Not updating f_pos on errors sounds like the right thing to do to me,
> and if it also ends up fixing some nasty issues with hpfs and
> potentially other cases, I'd say "go for it".
> 
> Not for 3.10, though. It's not like this is a new - or acute - problem.

Grr...  I've just crawled through ->llseek() instances and I really wonder
what to do with that crap.  Debugfs idiocies had been obvious, but there
are much stranger turds floating there.

Some random examples:
drivers/sbus/char/flash.c:
	SEEK_CUR beyond the EOF silently trims position to EOF
	SEEK_SET to the same position just sets it
	SEEK_END sets position to EOF, period - offset is simply ignored

cris eeprom:
	SEEK_END inverts the sign of offset
	any seek to negative returns EOVERFLOW (instead of usual EINVAL)
*and* sets position to 0
	any seek to or beyond the EOF (there's an off-by-one) also
returns EOVERFLOW *and* sets position to EOF - 1.  Yes, that includes
lseek(fd, SEEK_END, 0)

carma-fpga-program.c:
	SEEK_END inverts sign of offset
	seeks past EOF give EINVAL
	seeks to negative offsets pass on 32bit and give EINVAL on 64bit

drivers/s390/char/vmur.c:
	fails when offset is not a multiple of 4Kb; the trouble
being, read() can bloody well leave you with position not being such
a multiple, so that check buys us nothing - SEEK_CUR for 12Kb might
be an equivalent of SEEK_SET to 13Kb; the former is allowed, the
latter isn't.

drivers/staging/vme/devices/vme_user.c:
	apparent off-by-one - SEEK_END:-1 succeeds, SEEK_END:0 gives
EINVAL.

Then there's a bunch of drivers that either don't allow SEEK_END while
having an upper limit to seekable positions acting as EOF would or
allow seeks past what SEEK_END:0 yields.

All that mess is a user-visible ABI and at least for the weird eeprom
devices I would be very cautious with fixing it - the userland code
dealing with those animals is rather obscure, can easily turn out
to rely on the idiotic behaviour and brick the boxen if things go
wrong.

I'm switching everything I can to use of generic_file_llseek_size();
quite a few can be switched, often along with dropping the locking
that served only to serialize lseek vs. lseek.  The rest is going to
be unpleasant.

There's another pile of fun around f_pos manipulations - try to run
ecryptfs on top of tmpfs or ceph and do seeks on directories.
ecryptfs ->readdir() assigns ->f_pos of underlying file and calls
underlying ->readdir(); the trouble is, underlying fs has things it
wants done on ->f_pos changes (cursor needs to be moved, etc.).
ecryptfs on top of hpfs is also a lot of fun, not that anybody had been
using that combination.

Sigh...
