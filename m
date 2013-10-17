Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab3JQOAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:00:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab3JQOAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:00:43 -0400
Date: Thu, 17 Oct 2013 15:53:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Hurley <peter@hurleysoftware.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: epoll oops.
Message-ID: <20131017135339.GA29182@redhat.com>
References: <20131014154627.GA9525@redhat.com> <CA+55aFw64xTR7LXjo5OfUvRwDb9UF8EcfjguAbF0C3VsUXCecg@mail.gmail.com> <CA+55aFxOpT9YLf7WLM+SOsp5U2R1-Px0LiEsdqV0Adr897dOqQ@mail.gmail.com> <20131015154838.GA32271@redhat.com> <20131016223922.GA18383@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016223922.GA18383@dcvr.yhbt.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Eric Wong wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
> > Yes. Before that 971316f0503a hack epoll can't even know if the task
> > which did signalfd_poll() exits and frees the active signalfd_wqh.
> > If for example that task forked a child before exit.
> >
> > And the whole RCU logic is only needed if exit/ep_remove_wait_queue
> > actually race with each other.
>
> Is there any chance this oops is caused by (or at least more easily
> exposed by) commit 91cf5ab60ff82ecf4550a596867787c1e360dd3f ?
> (epoll: add a reschedule point in ep_free())
>
> I thought 91cf5ab would be benign, except...
>
> > Yes, ugly, agreed. d80e731ecab4 even tries to docunent that this all
> > is the hack.
>
> .. the following sentence from d80e731ecab4 caught my eye:
>
>     It also assumes that nobody can take tasklist_lock under epoll
>     locks, this seems to be true.

This just reminds that with this patch __wake_up/ep_poll_callback can
be called under write_lock(tasklist).

> I haven't been able to trace if cond_resched() can take tasklist_lock.

No, it can't hold the non-sleepable rwlock_t. And the sentence above
doesn't mean the locks like epmutex, it is mostlt about ep->lock.

Oleg.

