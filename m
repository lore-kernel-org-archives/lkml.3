Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3JWJIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:08:34 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61836 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3JWJIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:08:31 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxOpT9YLf7WLM+SOsp5U2R1-Px0LiEsdqV0Adr897dOqQ@mail.gmail.com>
References: <20131014154627.GA9525@redhat.com>
	<CA+55aFw64xTR7LXjo5OfUvRwDb9UF8EcfjguAbF0C3VsUXCecg@mail.gmail.com>
	<CA+55aFxOpT9YLf7WLM+SOsp5U2R1-Px0LiEsdqV0Adr897dOqQ@mail.gmail.com>
Date: Wed, 23 Oct 2013 11:08:30 +0200
X-Google-Sender-Auth: AeA0yaVmX8TUmNsm-N2Uc2bFWP0
Message-ID: <CAOJsxLEbMqreniixFkPtsp1ftNaiyTmZTfUoK-DOT_5ZQm1RiQ@mail.gmail.com>
Subject: Re: epoll oops.
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Wong <normalperson@yhbt.net>, Oleg Nesterov <oleg@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Oct 14, 2013 at 10:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> [ Adding Pekka to verify the SLAB_DESTROY_BY_RCU semantics, and Peter
> Hurley due to the possible tty association ]
>
> On Mon, Oct 14, 2013 at 10:31 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Oleg, does this trigger any memory for you? Commit 971316f0503a
>> ("epoll: ep_unregister_pollwait() can use the freed pwq->whead") just
>> makes me go "Hmm, this is *exactly* that that commit is talking
>> about.."
>
> Ok, Oleg, going back to that whole thread, I think that old bug went like this:
>
>  (a) normally all the wait-queues that epoll accesses are associated
> with files, and as such they cannot go away for any normal file
> activity. If the file exists, the waitqueue used for poll() on that
> file must exist.
>
>  (b) signalfd is special, and it does a
>
>         poll_wait(file, &current->sighand->signalfd_wqh);
>
>      which means that the wait-queue isn't associated with the file
> lifetime at all. It cleans it up with signalfd_cleanup() if the signal
> handlers are removed. Normal (non-epoll) handling is safe, because
> "current->sighand" obviously cannot go away as long as the current
> thread (doing the polling) is in its poll/select handling.
>
>  (c) as a result, epoll and exit() can race, since the normal epoll
> cleanup() is serialized by the file being closed, and we're missing
> that for the case of sighand going away.
>
>  (d) we have this magic POLLFREE protocol to make signal handling
> cleanup inform the epoll logic that "oops, this is going away", and we
> depend on the underlying sighand data not going away thanks to the
> eventual destruction of the slab being delayed by RCU.
>
>  (e) we are also very careful to only ever initialize the signalfd_wqh
> entry in the SLAB *constructor*, because we cannot do it at every
> allocation: it might still be in reused as long as it exists in the
> slab cache: the SLAB_DESTROY_BY_RCU flag does *not* delay individual
> slab entries, it only delays the final free of the underlying memory
> allocation.
>
>  (f) to make things even more exciting, the SLAB_DESTROY_BY_RCU depend
> on the slab implementation: slub and slob seem to delay each
> individual allocation (and do ctor/dtor on every allocation), while
> slab does that "delay only the underlying big page allocator" thing.

So I'm not completely sure what you wanted me to verify Linus but yes
SLAB_DESTROY_BY_RCU only guarantees that the underlying page doesn't
go away for RCU but we're free to reuse the object. Anyone using the
object passed to kmem_cache_free() with SLAB_DESTROY_BY_RCU must check
that it's in fact the object we're interested in.

There's example code in a SLAB_DESTROY_BY_RCU comment in
<linux/slab.h> added by PeterZ.

                                Pekka
