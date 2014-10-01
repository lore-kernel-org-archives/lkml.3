Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaJADrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 23:47:25 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:47608 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaJADrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 23:47:24 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
	<CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>
	<CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
	<CA+55aFwqAOGbQ-LYmD-aSALTyA0p9=0vNdsJWd+uweUQyzsW8w@mail.gmail.com>
	<20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
Date: Wed, 1 Oct 2014 05:47:23 +0200
Message-ID: <CAJfpegsaL6zRS-EaB3cd-Uk7nDsZnb0vO07-0W6xfYvAuuB6mA@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anand Avati <avati@gluster.org>, Maxim Patlasov <MPatlasov@parallels.com>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 10:44 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Sep 30, 2014 at 12:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> What about flock(2), FL_SETLEASE, etc semantics (which are the sane ones,
>> compared to the POSIX locks shit which mandates release of lock on each close(2)
>> instead of "when all [duplicate] descriptors have been closed")?
>>
>> You have to do that from ->release(), there's no question about that.
>
> We do locks_remove_file() independently on ->release, but yes, it's
> basically done just before the last release.
>
> But it has the *exact* same semantics as release, including very much
> having nothing what-so-ever to do with "last close()".
>
> If the file descriptor is opened for other reasons (ie mmap, /proc
> accesses, whatever), then that delays locks_remove_file() the same way
> it delays release.
>
> None of that has *anothing* to do with "synchronous". Thinking it does is wrong.

Oh, and btw. nfsv4 has a synchronous ->release implementation.
Probably for exactly the same reason Anand and Maxim wants it in their
server.  Note: locks_remove_file() works for local locking, but
distributed filesystems need to release locks and leases in their
->release.

And yes, /proc does temporary ref of file.  But it's an implementation
detail, and should be fixable.  As to mmap, it's almost like dup(2)
regarding the file, we could actually handle it that way and have a
flush at munmap time too.

Thanks,
Miklos
