Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3HYTLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 15:11:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43608 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab3HYTLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 15:11:50 -0400
Date: Sun, 25 Aug 2013 20:11:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: /proc/pid/fd && anon_inode_fops
Message-ID: <20130825191140.GB27005@ZenIV.linux.org.uk>
References: <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com>
 <20130822185317.GI31117@1wt.eu>
 <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
 <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
 <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
 <20130822201530.GL31117@1wt.eu>
 <20130824182939.GA23630@redhat.com>
 <20130824212432.GA9299@1wt.eu>
 <20130825052317.GZ27005@ZenIV.linux.org.uk>
 <CA+55aFy_W_rEeCyrTWMx55WNDh4HaOs5O-krQMqLUjOc=MxA3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy_W_rEeCyrTWMx55WNDh4HaOs5O-krQMqLUjOc=MxA3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 11:32:45AM -0700, Linus Torvalds wrote:
> On Sat, Aug 24, 2013 at 10:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > We are really stuck with the current semantics here - switching to
> > *BSD one would not only mean serious surgery on descriptor handling
> > (it's one of the wartier areas in *BSD VFS, in large part because
> > of magic-open-really-a-dup kludges they have to do), it would change
> > a long-standing userland API that had been there for nearly 20 years
> > _and_ one that tends to be used in corner cases of hell knows how many
> > scripts.
> 
> Actually, I'm pretty sure we did have the "dup" semantics at one point
> (long ago), and they were really nice (because you could use them to
> see where in the stream the fd was etc). It just fit so horribly badly
> into the VFS semantics that it got changed into the current "new file
> descriptor" one. Afaik, nothing broke.
> 
> So I'm not really sure about the "we're stuck with it" for semantic
> reasons, and it turns out that very few programs/scripts actually use
> /proc/<pid>/fd/<nr> at all (random use of /dev/stdin is likely the
> most common case). But I agree about the "serious surgery on
> descriptor handling" part.

Well...  We are actually in better position for that these days;
right now we have very few instances of ->atomic_open(), so we could
change the calling conventions for it.  It returns 0 or -error and we
could turn that into NULL, ERR_PTR(-error) or a reference to already
opened struct file.  It's not _that_ far to propagate from that point -
atomic_open() <- lookup_open() <- do_last() <- path_openat().  So the amount
of surgery is nowhere near the horrors we used to need (and *BSD actually
does).

We could try that, but I'm really afraid that semantics changes will break
stuff; worse yet, that it'll happen to stuff in dusty corners of random admin
scripts nobody able to debug anymore ;-/
