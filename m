Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3FFCaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:30:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35473 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab3FFCaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:30:02 -0400
Date: Thu, 6 Jun 2013 03:29:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] corner cases of open() on procfs symlinks
Message-ID: <20130606022959.GF13110@ZenIV.linux.org.uk>
References: <20130606012010.GE13110@ZenIV.linux.org.uk>
 <CA+55aFxB9GRfxhCg+s3xMCUQ5Sjt+nViRHQA-DPJ_5DB+v57Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxB9GRfxhCg+s3xMCUQ5Sjt+nViRHQA-DPJ_5DB+v57Uw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 10:38:31AM +0900, Linus Torvalds wrote:
> On Thu, Jun 6, 2013 at 10:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >         I'm not sure whether to treat that as a bug or as a weird misfeature
> > enshrined in userland ABI:
> >         open("/tmp", O_CREAT, 0) => -EISDIR     // LAST_NORM case
> >         open("/", O_CREAT, 0) => -EISDIR        // LAST_ROOT
> >         open(".", O_CREAT, 0) => -EISDIR        // LAST_DOT
> >         open("..", O_CREAT, 0) => -EISDIR       // LAST_DOTDOT
> >         open("/proc/self/cwd", O_CREAT, 0) => success   // LAST_BIND
> >         open("/proc/self/cwd/", O_CREAT, 0) => -EISDIR  // trailing slashes
> 
> Ok, that looks buggy. O_CREAT should definitely return EISDIR for
> /proc/self/cwd too, since it's a directory. I don't think the
> O_RDWR/O_WRONLY thing should matter.
> 
> >        I would obviously
> > like to do that - do_last() is far too convoluted as it is; the only
> > question is whether we can change the first weirdness...  Comments?
> 
> Exactly which cases does that change? I have no objections if it's
> only the "LAST_BIND" case that now starts returning EISDIR. Is there
> anything else it affects?

LAST_BIND gets to go through the EISDIR and ENOTDIR checks that way, which
fixes these two bugs.

LAST_DOT/LAST_DOTDOT/LAST_ROOT end up checking whether we are at the
directory or not; sure, we know that we are, so these tests are
redundant, but I really don't think it's worth optimizing for.  We are
not generating any data misses and arguably we reduce instruction cache
footprint a bit, not that it would be noticable with the I$ horror
do_last() still is...

What really happens in that switch is that do_last() tries to be too smart
and ends up skipping a few things too many.

> That said, obviously if something breaks, we'd have to revert it, and
> as a cleanup rather than some serious bug (ie this doesn't cause
> crashes or security issues), I suspect this should wait until 3.11
> regardless. No?

Probably...  procfs symlinks neutering O_DIRECTORY might, in theory, be usable
to cook something nasty, but I don't see any obvious ways to exploit that.
FWIW, resulting kernel seems to survive the minimal beating, but obviously
more is needed.
