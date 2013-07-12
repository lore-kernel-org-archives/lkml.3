Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab3GLLyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:54:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36250 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab3GLLyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:54:02 -0400
Date: Fri, 12 Jul 2013 12:54:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs.git part 2
Message-ID: <20130712115400.GZ4165@ZenIV.linux.org.uk>
References: <20130703122918.GK4165@ZenIV.linux.org.uk>
 <CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
 <20130712054817.GY4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712054817.GY4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 06:48:17AM +0100, Al Viro wrote:
> It's slightly less painful than that - if dirname exists, the old kernels
> will fail; O_CREAT for existing directory means an error.  So in practice
> you can use it safely.  I'm not too happy about that situation, but I
> hadn't been able to come up with anything better, short of a new syscall
> that would duplicate openat(2), but reject unknown values in flags argument
> from the very beginning ;-/  Which is what we probably should've done with
> openat(2) itself, but it's too late for that now...

FWIW, it might make sense to do sys_openat2() that would really validate
the 'flags' argument.  The question is, what checks do we want to do?
The situation for open(2) is complicated by OSF, HPUX and Solaris compat.
AFAICS, we have the following picture:

* two bits are used to encode O_RDONLY/O_WRONLY/O_RDWR/open-for-ioctl
Any combination is allowed.  Ignored with O_PATH.

* O_CLOEXEC - orthogonal to everything else

* O_NOATIME, O_APPEND, O_DIRECT, O_NONBLOCK, O_NDELAY - more or less
arch-independent (O_NDELAY may or may not coincide with O_NONBLOCK,
on parisc O_NOATIME is the same value as O_INVISIBLE, whatever that is).
Can be changed by fcntl(), probably shouldn't be allowed with O_PATH
(right now we just ignore those in that case).  For that matter, F_SETFL
makes no sense for O_PATH descriptors.  O_APPEND makes no sense for O_RDONLY
opens; might be better to leave that as-is, though.

* O_DIRECTORY - shouldn't be allowed with O_TMPFILE.  Requires either O_RDONLY
or O_PATH (in which case both lower bits are ignored anyway).

* O_NOFOLLOW - orthogonal to everything else

* O_NOCTTY, O_LARGEFILE - probably shouldn't be allowed with O_PATH (currently
ignored in that case).

* O_CREAT - makes no sense with O_PATH.  O_TMPFILE currently demands it, but
that's just an attempt to get it fail on old kernels more reliably.

* O_TRUNC - makes no sense with O_PATH.  Pointless with O_TMPFILE.

* O_EXCL - $DEITY-awful mess.  Combination with O_CREAT is probably the
most regular part; however, it is usable without O_CREAT for some
devices, with varying semantics.  I'd mapped "can't link tmpfile in place"
semantics on that one (with O_CREAT | O_TMPFILE).

* O_SYNC and things around it - arch-dependent mess.

* O_BLKSEEK, etc. - weird flags from HPUX et.al.; ignored by the kernel,
OSF fortunately has only O_SYNC/O_DSYNC near that pile and that's the only
one we might realistically care about - Solaris compat is gone and HPUX
one is not much better off.

IMO we should fail on any unknown bits if we go that way, and probably
tighten O_PATH side of things as well.  It's still not too late - we can
just add sys_openat2() and make sys_openat() ignore O_TMPFILE completely.
Do you want to go that way?  If so, let's decide what validation will be
done and spell it out explicitly...
