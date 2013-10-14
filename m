Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab3JNU5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:57:48 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:61944 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab3JNU5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:57:46 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw64xTR7LXjo5OfUvRwDb9UF8EcfjguAbF0C3VsUXCecg@mail.gmail.com>
References: <20131014154627.GA9525@redhat.com>
	<CA+55aFw64xTR7LXjo5OfUvRwDb9UF8EcfjguAbF0C3VsUXCecg@mail.gmail.com>
Date: Mon, 14 Oct 2013 13:57:45 -0700
X-Google-Sender-Auth: nHtt2Il2pPOsQbSnVVYq69_IlP0
Message-ID: <CA+55aFxOpT9YLf7WLM+SOsp5U2R1-Px0LiEsdqV0Adr897dOqQ@mail.gmail.com>
Subject: Re: epoll oops.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Wong <normalperson@yhbt.net>, Oleg Nesterov <oleg@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Adding Pekka to verify the SLAB_DESTROY_BY_RCU semantics, and Peter
Hurley due to the possible tty association ]

On Mon, Oct 14, 2013 at 10:31 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Oleg, does this trigger any memory for you? Commit 971316f0503a
> ("epoll: ep_unregister_pollwait() can use the freed pwq->whead") just
> makes me go "Hmm, this is *exactly* that that commit is talking
> about.."

Ok, Oleg, going back to that whole thread, I think that old bug went like this:

 (a) normally all the wait-queues that epoll accesses are associated
with files, and as such they cannot go away for any normal file
activity. If the file exists, the waitqueue used for poll() on that
file must exist.

 (b) signalfd is special, and it does a

        poll_wait(file, &current->sighand->signalfd_wqh);

     which means that the wait-queue isn't associated with the file
lifetime at all. It cleans it up with signalfd_cleanup() if the signal
handlers are removed. Normal (non-epoll) handling is safe, because
"current->sighand" obviously cannot go away as long as the current
thread (doing the polling) is in its poll/select handling.

 (c) as a result, epoll and exit() can race, since the normal epoll
cleanup() is serialized by the file being closed, and we're missing
that for the case of sighand going away.

 (d) we have this magic POLLFREE protocol to make signal handling
cleanup inform the epoll logic that "oops, this is going away", and we
depend on the underlying sighand data not going away thanks to the
eventual destruction of the slab being delayed by RCU.

 (e) we are also very careful to only ever initialize the signalfd_wqh
entry in the SLAB *constructor*, because we cannot do it at every
allocation: it might still be in reused as long as it exists in the
slab cache: the SLAB_DESTROY_BY_RCU flag does *not* delay individual
slab entries, it only delays the final free of the underlying memory
allocation.

 (f) to make things even more exciting, the SLAB_DESTROY_BY_RCU depend
on the slab implementation: slub and slob seem to delay each
individual allocation (and do ctor/dtor on every allocation), while
slab does that "delay only the underlying big page allocator" thing.

Agreed so far? Ugly, ugly, ugly, and I think there's exactly one
person who understands all of this. Namely you.

Anyway, so we protect the magic wait_queue_head_t from going away from
under us. We even make sure that we are very careful about only
initializing the sighand spinlock and this magic signalfd_wqh only
once per RCU lifetime. We're going to a lot of trouble to make this
all work. And it looks like it should work.

BUT.

It's enough that *one* other user of "poll_wait()" does something
similar to signalfd, and *doesn't* go through all this effort to make
it ok.

And I see a few worrisome cases. For example, look at "tty_poll()". It
ends up doing something very similar, except it uses the tty instead
of sighand. And exactly like the sighand struct, the tty allocation
lifespan can - thanks to hangup() - be shorter than the file
allocation lifespan.

Peter? Does a tty hangup end up actually possibly freeing the tty
struct? Looking at it, I'm starting to think that it only affects
f_op, and the "struct tty" stays around, in which case this is all
fine.

Hmm? There might be other cases..

                    Linus
