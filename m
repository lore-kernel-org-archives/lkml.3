Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaJRSWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 14:22:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51703 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaJRSWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 14:22:49 -0400
Date: Sat, 18 Oct 2014 19:22:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Anand Avati <avati@gluster.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
Message-ID: <20141018182241.GE7996@ZenIV.linux.org.uk>
References: <20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
 <542BE551.1010705@parallels.com>
 <CAJfpegs4Up_feUbqEGxfhq+rZneTmy0qcZy-k3so7VjufQY7-w@mail.gmail.com>
 <543F9E75.2090509@parallels.com>
 <CAJfpegvS+rmFqGgvHq183Z-MxLAwcgEB57LQxAwy3QAe5CaVwg@mail.gmail.com>
 <CA+55aFw68DMazGSu=YaOVVEWp=_LrD+2abah+5Tq3kpmH-r+Hg@mail.gmail.com>
 <20141017085509.GE5011@tucsk.piliscsaba.szeredi.hu>
 <CA+55aFyALiUbRVcxGGG79N-97pa997v9En64O9jLLBvBAO6vrA@mail.gmail.com>
 <CA+55aFyU2NgXYZSnNBwMR_ZyFuKzHna2NBBhwd6iev0uaEdqKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyU2NgXYZSnNBwMR_ZyFuKzHna2NBBhwd6iev0uaEdqKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 08:40:05AM -0700, Linus Torvalds wrote:
> On Sat, Oct 18, 2014 at 8:35 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Look around for AIO. Look around for the loop driver. Look around for
> > a number of things that do "fget()" and that you completely ignored.
> 
> .. actually, there are more instances of "get_file()" than of
> "fget()", the aio one just happened to be the latter form. Lots and
> lots of ways to get ahold of a file descriptor that keeps it open past
> the "last close".

FWIW, procfs patch touches a very annoying issue: ->show_fdinfo() being
blocking.  I would really like to get rid of that particular get_file()
and even more so - of get_files_struct() in there.

I certainly agree that anyone who expects that close() means the end of IO
is completely misguided.  Mappings don't disappear on close(), neither does
a descriptor returned by dup(), or one that child got over fork(),
or something sent over in SCM_RIGHTS datagram, or, as you suggested, made
backing store for /dev/loop, etc.

What's more, in the example given upthread, somebody might've spotted that
file in /proc/<pid>/fd/* and *opened* it.  At which point umount would
have to fail with EBUSY.  And the same lsof(8) might've done just that.

It's not a matter of correctness or security, especially since somebody who
could do that, could've stopped your process, PTRACE_POKEd a fairly short
series of syscalls that would connect to AF_UNIX socket, send the file
over to them and clean after itself, then single-stepped through all of that,
restored the original state and resumed your process.  

It is a QoI matter, though.  And get_files_struct() in there is a lot more
annoying than get_file()/fput().  Suppose you catch the process during
exit().  All of a sudden, read from /proc/<pid>/fdinfo/<n> ends up doing
shitloads of filp_close().  It would be nice to avoid that.

Folks, how much pain would it be to make ->show_fdinfo() non-blocking?
