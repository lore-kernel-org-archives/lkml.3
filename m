Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3BQTwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:52:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab3BQTwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:52:15 -0500
Date: Sun, 17 Feb 2013 20:50:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] coredump: fix the ancient signal problems
Message-ID: <20130217195044.GA22544@redhat.com>
References: <20130217191819.GA21778@redhat.com> <CA+55aFx-9Ajb13JfxghNMzoHMJWDtH=a0DZfz2Q-eCBnHyVDPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx-9Ajb13JfxghNMzoHMJWDtH=a0DZfz2Q-eCBnHyVDPQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Linus Torvalds wrote:
>
> On Sun, Feb 17, 2013 at 11:18 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Linus, et al, could you please ack/nack the intent? Of course I will
> > appreciate if you can review the code, but what I am actually worried
> > about is the user-visible change: the coredumping becomes killable but
> > only by the _explicit_ SIGKILL, other fatal signals are "ignored".
>
> That isn't a problem. In fact, we already have logic that makes the
> act of writing a file be killable by SIGKILL (because you really
> really want that for network filesystems, for example), so I suspect
> that core-dumping was interruptible by SIGKILL even before you made it
> explicitly so - simply because the IO itself was.

Yes, and even pipe_write() can fail if signal_pending() == T.

> And even if it wasn't (because maybe the SIGKILL logic doesn't get
> triggered due to all the special-case core-dumping code in signal
> handling),

Yes, SIGKILL can wakeup (or can miss) the dumping thread sleeping in
->write() but this is not enough. See 2/3.

> SIGKILL really is very very special. Having it kill a
> coredump in progress sounds fine to me.

Great.

> That said, I'm not convinced about your particular split of patches.
> The first patch introduces that new SIGNAL_GROUP_COREDUMP, and then
> the second patch modifies one of the new use cases:
>
> -               tsk->signal->flags |= SIGNAL_GROUP_COREDUMP;
> +               tsk->signal->flags = SIGNAL_GROUP_COREDUMP;
>
>
> and that just smells to me like you tried too hard to split things
> into two patches.

Oh, I disagree, but I wouldn't mind to join these changes assuming
they pass the review (including my self-review tomorrow).

To me, the splitting is "natural". 1/3 protects the dumping thread
from !SIGKILL signals, 2/3 makes makes the dumping thread killable.

Another reason for 1/3 in a separate patch is the documentation,
I think we need more changes in prepare_signal(SIGNAL_GROUP_EXIT)
case.

But I won't insist.

> I wonder if Al
> Viro hould be on the cc.

Hello Al.

I'll send you mbox with this series privately.

Oleg.

