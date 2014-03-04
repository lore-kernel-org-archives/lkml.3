Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaCDBFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:05:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37159 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbaCDBFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:05:20 -0500
Date: Tue, 4 Mar 2014 01:05:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Message-ID: <20140304010517.GT18016@ZenIV.linux.org.uk>
References: <20140303212642.GJ18016@ZenIV.linux.org.uk>
 <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
 <20140303220106.GL18016@ZenIV.linux.org.uk>
 <CA+55aFyRJqb1HkVESdZDOcQ+20t-s-JWxZa15SHJpGU+k=6www@mail.gmail.com>
 <20140303232858.GO18016@ZenIV.linux.org.uk>
 <CA+55aFyEXgMh61P3cmjZzw3RxitiL0oymWSyUsiMp96iJ+98Og@mail.gmail.com>
 <20140303234207.GQ18016@ZenIV.linux.org.uk>
 <CA+55aFyWorcX0qYAcD2bj=bOqa-X6Gmb_Ph4g25nqwSPxo4XSg@mail.gmail.com>
 <20140304002342.GS18016@ZenIV.linux.org.uk>
 <CA+55aFzzt+BK3YQf08KGXapL-sXjL=LkQcBvwTYBAZosNgsSgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzzt+BK3YQf08KGXapL-sXjL=LkQcBvwTYBAZosNgsSgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 04:42:36PM -0800, Linus Torvalds wrote:
> On Mon, Mar 3, 2014 at 4:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > I wonder if something like
> >
> > static inline struct fd fdget(int fd)
> > {
> >         unsigned long v = __fdget(fd);
> >         return (struct fd){(struct file *)(v & ~1), v & 1};
> > }
> 
> Make it use "&3" so that we have the two bits we need, and I'll
> happily take that approach, yes.

Hmm...  You want to have that second flag dealt with inside fs/file.c
as well?  OK, but that'll need one more thing - __attribute__((aligned(4)))
on struct file declaration.  We have at least one weird architecture that
is happy to align everything on 16bit boundaries.  Granted, it's half-dead,
but there might be something besides m68k with the same weirdness...

It's probably not worth replacing struct fd with typedef to unsigned long -
too easy to have it confused with a file descriptor itself and pass to
something that expects e.g. int.  In any case, since we leave fdget()
inlined, compiler will see the unsigned long it's been initialized with,
so if it decides that it's cheaper to replace f.file with v & ~3 through
the whole thing, keep v around and discard local struct fd completely,
it'll be able to do so just fine...

I'll play around with cross-builds a bit and see what falls out of all
that.
