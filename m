Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502Ab3JPWjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:39:25 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:53519 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761394Ab3JPWjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:39:23 -0400
Date: Wed, 16 Oct 2013 22:39:22 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Hurley <peter@hurleysoftware.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: epoll oops.
Message-ID: <20131016223922.GA18383@dcvr.yhbt.net>
References: <20131014154627.GA9525@redhat.com>
 <CA+55aFw64xTR7LXjo5OfUvRwDb9UF8EcfjguAbF0C3VsUXCecg@mail.gmail.com>
 <CA+55aFxOpT9YLf7WLM+SOsp5U2R1-Px0LiEsdqV0Adr897dOqQ@mail.gmail.com>
 <20131015154838.GA32271@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015154838.GA32271@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:
> Yes. Before that 971316f0503a hack epoll can't even know if the task
> which did signalfd_poll() exits and frees the active signalfd_wqh.
> If for example that task forked a child before exit.
> 
> And the whole RCU logic is only needed if exit/ep_remove_wait_queue
> actually race with each other.

Is there any chance this oops is caused by (or at least more easily
exposed by) commit 91cf5ab60ff82ecf4550a596867787c1e360dd3f ?
(epoll: add a reschedule point in ep_free())

I thought 91cf5ab would be benign, except...

> Yes, ugly, agreed. d80e731ecab4 even tries to docunent that this all
> is the hack.

.. the following sentence from d80e731ecab4 caught my eye:

    It also assumes that nobody can take tasklist_lock under epoll
    locks, this seems to be true.

I haven't been able to trace if cond_resched() can take tasklist_lock.
