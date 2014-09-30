Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaI3TTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:19:40 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57954 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaI3TTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:19:39 -0400
Date: Tue, 30 Sep 2014 21:19:33 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anand Avati <avati@gluster.org>, Maxim Patlasov <MPatlasov@parallels.com>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
Message-ID: <20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
 <CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>
 <CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
 <CA+55aFwqAOGbQ-LYmD-aSALTyA0p9=0vNdsJWd+uweUQyzsW8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwqAOGbQ-LYmD-aSALTyA0p9=0vNdsJWd+uweUQyzsW8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:04:08PM -0700, Linus Torvalds wrote:
> On Mon, Sep 29, 2014 at 10:33 PM, Anand Avati <avati@gluster.org> wrote:
> >
> > In general that sounds reasonable. The problem (as described in the original
> > thread, at http://sourceforge.net/p/fuse/mailman/message/29889055/)
> 
> From a quick look at that thread, the solution is clear: you *must*
> flush your write buffers in the "flush" function.
> 
> The fact that you must flush write buffers multiple times if people
> have done "dup()" is a complete non-issue. Just flush them each time.
> There is no "how do I differentiate the first flush and
> the second flush?" The answer is that you don't, and that you MUST
> NOT. You need to flush on both (or more). Trying to distinguish first
> vs second is broken, and would be wrogn *anyway*. There is no possible
> situation where it could validaly matter, and you simply cannot tell.
> 
> Don't do any data structure cleanups, that's for "release()". But yes,
> you do have to flush write buffers at flush time (and return IO errors
> if they happen). That's very much the point of flush.

What about flock(2), FL_SETLEASE, etc semantics (which are the sane ones,
compared to the POSIX locks shit which mandates release of lock on each close(2)
instead of "when all [duplicate] descriptors have been closed")?

You have to do that from ->release(), there's no question about that.  And while
I haven't looked at the wording of the standards, doing that synchronously with
the last close is a pretty decent thing to expect.

Thanks,
Miklos
