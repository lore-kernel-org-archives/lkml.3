Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab3JOPzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:55:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606Ab3JOPz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:55:28 -0400
Date: Tue, 15 Oct 2013 17:48:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Wong <normalperson@yhbt.net>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: epoll oops.
Message-ID: <20131015154838.GA32271@redhat.com>
References: <20131014154627.GA9525@redhat.com> <CA+55aFw64xTR7LXjo5OfUvRwDb9UF8EcfjguAbF0C3VsUXCecg@mail.gmail.com> <CA+55aFxOpT9YLf7WLM+SOsp5U2R1-Px0LiEsdqV0Adr897dOqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxOpT9YLf7WLM+SOsp5U2R1-Px0LiEsdqV0Adr897dOqQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm? There might be other cases..

Yes.

Dave, perhaps you have vmcore? I have no idea if this is possible or
not, but perhaps you can look at eventpoll_release_file's frame and
print file->f_op ?

On 10/14, Linus Torvalds wrote:
>
> [ Adding Pekka to verify the SLAB_DESTROY_BY_RCU semantics

Just in case, we depend on SLAB_DESTROY_BY_RCU anyway, and ->sighand
in particular. lock_task_sighand() equally depends on it.

> Ok, Oleg, going back to that whole thread, I think that old bug went like this:

Yes, yes, thanks, I do remember what this patch does and why. Just
I forgot everything about eventpoll.c, I tried to read it only once
to fix that bug.

>  (b) signalfd is special, and it does a
>
>         poll_wait(file, &current->sighand->signalfd_wqh);
>
>      which means that the wait-queue isn't associated with the file
> lifetime at all. It cleans it up with signalfd_cleanup() if the signal
> handlers are removed. Normal (non-epoll) handling is safe, because
> "current->sighand" obviously cannot go away as long as the current
> thread (doing the polling) is in its poll/select handling.

Yes. and, just in case, the main problem is that sighand has no any
connection with the file. Unlike, say, tty which uses ->private_data.

>  (c) as a result, epoll and exit() can race, since the normal epoll
> cleanup() is serialized by the file being closed, and we're missing
> that for the case of sighand going away.

Yes. Before that 971316f0503a hack epoll can't even know if the task
which did signalfd_poll() exits and frees the active signalfd_wqh.
If for example that task forked a child before exit.

And the whole RCU logic is only needed if exit/ep_remove_wait_queue
actually race with each other.

> Agreed so far? Ugly, ugly, ugly,

Yes, ugly, agreed. d80e731ecab4 even tries to docunent that this all
is the hack.

> And it looks like it should work.

Yes... I tried to read this all again, and so far I do not see
anything wrong... signalfd_cleanup()->waitqueue_active() looks fine
too, afaics. We do not need to clear ->whead unconditionally, the
only caller of ep_ptable_queue_proc() is signalfd_poll(), and we are
the last thread which can use this ->sighand.

> Peter? Does a tty hangup end up actually possibly freeing the tty
> struct? Looking at it, I'm starting to think that it only affects
> f_op, and the "struct tty" stays around, in which case this is all
> fine.

Of course I can't answer, but at first glance file_tty() should not go
away in this case... If nothing else, tty_release() expects tty != NULL,
and it seems that priv->tty is never changed.

Oleg.

