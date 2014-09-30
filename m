Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaI3Hnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:43:52 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:60329 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaI3Hnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:43:50 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
	<CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>
	<CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
Date: Tue, 30 Sep 2014 09:43:49 +0200
Message-ID: <CAJfpegv=aeOyz0osw9PD0abYHbJ+RjKkY3_mos+Cz1DbgTR-ww@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
From: Miklos Szeredi <miklos@szeredi.hu>
To: Anand Avati <avati@gluster.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Maxim Patlasov <MPatlasov@parallels.com>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 7:33 AM, Anand Avati <avati@gluster.org> wrote:

> In general that sounds reasonable. The problem (as described in the original
> thread, at http://sourceforge.net/p/fuse/mailman/message/29889055/) happens
> in the presence of dup(). Tools like dd (and others) call dup(), and a
> second file descriptor is created for the same filp. Every descriptor's
> close() results in a ->flush(). The final close() of course results in
> ->release() as well.
>
> Because dup() is silently handled in VFS (and a FUSE filesystem is
> completely unaware), from a FUSE filesystem's point of view this is how
> operations look:
>
> - OPEN
> - ... <I/O ops>
> - FLUSH
> - ... <I/O ops>
> - FLUSH
> - ... <many more FLUSHes and I/O>
> - FLUSH
> - RELEASE
>
> So, for a given open(), one release() is guaranteed. There can be one or
> more (arbitrary number) of flush()es. If one wants to implement semantics
> where a second concurrent open()er gets EBUSY, they have to pick between one
> of the two evils:
>
> - Assume the first FLUSH is the last FLUSH and release internal locks/leases
> and therefore break semantics
> - Wait for RELEASE and asynchronously release internal locks/leases and
> therefore result in spurious EBUSY (between last close() and ->release())

As I wrote, we may identify the last FLUSH, if there aren't any more
references to the file.  This is by far the most common case.   Most
obvious exceptions:

 - mmaped file: there won't be a FLUSH after the file is closed, but
there might well be I/O.

 - file is sent over UNIX domain socket.  There might or might not be
a FLUSH depending on whether the file was received by the other end or
not.  There's no I/O while the file is being sent.

 - close() racing with read()/write() in multithreaded app.  FLUSH
might get there first before the actual I/O.

In these cases the "last flush" flag will *not* be set.

So we can have several cases:

 - "last flush" is set: this is indeed the last flush
 - "last flush" is not set and this is not the last flush
 - "last flush" is not set and this is the last flush, but there are
still I/O coming before the release
 - "last flush" is not set and this is the last flush and no I/O
happens before the release

Would this work for you?

Thanks,
Miklos
