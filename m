Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaI3Uoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:44:44 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:33616 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaI3Uom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:44:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
	<CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>
	<CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
	<CA+55aFwqAOGbQ-LYmD-aSALTyA0p9=0vNdsJWd+uweUQyzsW8w@mail.gmail.com>
	<20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu>
Date: Tue, 30 Sep 2014 13:44:42 -0700
X-Google-Sender-Auth: 2LpqbN8fLWNpy45Rm1hZY4enp8o
Message-ID: <CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Anand Avati <avati@gluster.org>, Maxim Patlasov <MPatlasov@parallels.com>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> What about flock(2), FL_SETLEASE, etc semantics (which are the sane ones,
> compared to the POSIX locks shit which mandates release of lock on each close(2)
> instead of "when all [duplicate] descriptors have been closed")?
>
> You have to do that from ->release(), there's no question about that.

We do locks_remove_file() independently on ->release, but yes, it's
basically done just before the last release.

But it has the *exact* same semantics as release, including very much
having nothing what-so-ever to do with "last close()".

If the file descriptor is opened for other reasons (ie mmap, /proc
accesses, whatever), then that delays locks_remove_file() the same way
it delays release.

None of that has *anothing* to do with "synchronous". Thinking it does is wrong.

And none of this has *anything* to do with the issue that Maxim
pointed to in the mailing list web page, which was about write caches,
and how you cannot (and MUST NOT) delay them until release time.

            Linus
