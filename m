Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3HTEGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 00:06:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52629 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab3HTEGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 00:06:53 -0400
Date: Tue, 20 Aug 2013 05:06:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, Simon Kirby <sim@hostway.ca>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
Message-ID: <20130820040648.GG27005@ZenIV.linux.org.uk>
References: <20130706000949.GD16853@hostway.ca>
 <CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
 <20130819201717.GA23608@hostway.ca>
 <0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
 <CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 02:16:36PM -0700, Linus Torvalds wrote:
> On Mon, Aug 19, 2013 at 1:29 PM, Christoph Lameter <cl@gentwo.org> wrote:
> > On Mon, 19 Aug 2013, Simon Kirby wrote:
> >
> >>    [... ]  The
> >> alloc/free traces are always the same -- always alloc_pipe_info and
> >> free_pipe_info. This is seen on 3.10 and (now) 3.11-rc4:
> >>
> >> Object ffff880090f19e78: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkklkkkkkkkkkkk
> >
> > This looks like an increment after free in the second 32 bit value of the
> > structure. First 32 bit value's poison is unchanged.
> 
> Ugh. If that is "struct pipe_inode_info" and I read it right, that's
> the "wait_lock" spinlock that is part of the mutex.
> 
> Doing a "spin_lock()" could indeed cause an increment operation. But
> it still sounds like a very odd case. And even for some wild pointer
> I'd then expect the spin_unlock to also happen, and to then increment
> the next byte (or word) too. More importantly, for a mutex, I'd expect
> the *other* fields to be corrupted too (the "waiter" field etc). That
> is, unless we're still spinning waiting for the mutex, but with that
> value we shouldn't, as far as I can see.

Point...  I would probably start with CONFIG_DEBUG_MUTEXES and see if
it screams about mutex magic, etc. having been buggered.  FWIW, pipe is
neither a FIFO nor an internal per-task one - it's a usual pipe(2) one,
which should've excluded most of the weird codepaths...
