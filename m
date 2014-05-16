Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaEPHso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 03:48:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbaEPHsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 03:48:42 -0400
Date: Fri, 16 May 2014 00:48:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Message-ID: <20140516074826.GB8555@infradead.org>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
 <8468354.y2kUZdOz9e@wuerfel>
 <1400168823.7862.9.camel@dabdike>
 <9176609.NChAu49t7f@wuerfel>
 <20140515220717.1ced0f1a@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515220717.1ced0f1a@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:07:17PM +0100, One Thousand Gnomes wrote:
> True sort of for the kernel (except you've got problems with file system
> compatibility and I believe stuff like NFS and that fact some file
> systems just break).

modern filesystems including NFS don't use anything that corresponds to
a time_t on disk or on the wire, so we'd just need to adjust the few
places the conert time representations.

> > The main advantage that I see with 64-bit time_t is that a lot of user
> > space already works with it, because NetBSD and OpenBSD use this, and
> > all 64-bit Linux systems already work with this without changing the ABI.
> > If we want a POSIX extension to cover a new ABI, this would be the most
> > likely candidate.
> 
> The main advantage IMHO of just using 64bit on 32bit boxes is getting it
> right. I'd go so far as to consider changing userspace time_t to be a
> struct. Yes it'll break lots of code but at least you'll know about it.

I think we're attacking that from the wrong angle.  We'll need to work
with the glibc and other libc folks to what can be implemented as the
library API/ABI and then ensure the kernel provides proper support for
it.

Chaning the size of time_t in the library seems like the only feasible
approach that keeps existing programs compatible.  If we support this
with a time64_, a shifted epoch or structures at the kernel ABI is a
question of balaning what libc needs and what we can use efficiently
internally.

> > As mentioned earlier, between kernel and user space it's probably best
> > to avoid time_t and timeval completely and just use timespec64 or some
> > other safe type, but there has to be a way to port user space that relies
> > on time_t or timespec.
> 
> This I think is bang on. We've already got lots of cases where we can't
> shoehorn useful info into syscalls due to time_t, including stuff like
> exposing accurate stamps in stat(). On an 8MHz 68000 not much happened in
> the same second, on a 32 core x86 it's a bit different.

The stat(64) syscall already has stopped time_t for a long time:

struct stat64 {
	...
	int             st_atime;       /* Time of last access.  */
	unsigned int    st_atime_nsec;
	int             st_mtime;       /* Time of last modification.  */
	unsigned int    st_mtime_nsec;
	int             st_ctime;	/* Time of last status change. */
	unsigned int	st_ctime_nsec;
};

