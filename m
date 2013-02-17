Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3BQTec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:34:32 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:58229 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3BQTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:34:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130217191819.GA21778@redhat.com>
References: <20130217191819.GA21778@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 17 Feb 2013 11:34:10 -0800
X-Google-Sender-Auth: KGkr7Ok0tOVUFWnyjJ0nX2sbPzM
Message-ID: <CA+55aFx-9Ajb13JfxghNMzoHMJWDtH=a0DZfz2Q-eCBnHyVDPQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] coredump: fix the ancient signal problems
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 11:18 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Linus, et al, could you please ack/nack the intent? Of course I will
> appreciate if you can review the code, but what I am actually worried
> about is the user-visible change: the coredumping becomes killable but
> only by the _explicit_ SIGKILL, other fatal signals are "ignored".

That isn't a problem. In fact, we already have logic that makes the
act of writing a file be killable by SIGKILL (because you really
really want that for network filesystems, for example), so I suspect
that core-dumping was interruptible by SIGKILL even before you made it
explicitly so - simply because the IO itself was.

And even if it wasn't (because maybe the SIGKILL logic doesn't get
triggered due to all the special-case core-dumping code in signal
handling), SIGKILL really is very very special. Having it kill a
coredump in progress sounds fine to me. SIGKILL is used by
users/admins as a last-case thing to get rid of processes that are
problematic for the system, and we should really try to honor it over
just about anything else for that reason. It's the user saying "get
this thing away from me", we should honor it.

That said, I'm not convinced about your particular split of patches.
The first patch introduces that new SIGNAL_GROUP_COREDUMP, and then
the second patch modifies one of the new use cases:

-               tsk->signal->flags |= SIGNAL_GROUP_COREDUMP;
+               tsk->signal->flags = SIGNAL_GROUP_COREDUMP;


and that just smells to me like you tried too hard to split things
into two patches.

And obviously, it will need more testing and review. I wonder if Al
Viro hould be on the cc. He doesn't always get involved, but when it
comes to core-dumping and signal handling, he *sometimes* does, and so
just checking if he has any comments might be worth it.

                         Linus
