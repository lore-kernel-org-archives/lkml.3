Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaCOTNB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 15:13:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbaCOTNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 15:13:00 -0400
Date: Sat, 15 Mar 2014 20:12:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: matt.helsley@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] exit.c: call proc_exit_connector() after exit_state is
	set
Message-ID: <20140315191222.GA32499@redhat.com>
References: <20140224192734.GA15573@bender.morinfr.org> <CA+55aFyXCh8ETJH2XODzWM_Hj8_eTe4fjHt6v630YJB8OzS-Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyXCh8ETJH2XODzWM_Hj8_eTe4fjHt6v630YJB8OzS-Ew@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, Linus Torvalds wrote:
>
> [ Going through old emails, adding relevant people, ie Oleg for
> kernel/exit.c and David because he seems to be the go-to person for
> connector issues judging by commits ]
>
> Patch looks sane to me, and logically that exit_connector thing would
> pair with exit_notify(), but I'd like some comments on it.

Please see the (confusing, my fault) discussion

	http://marc.info/?t=139327886600003

But in short, personally I agree with this change too. Just it was not
clear from the changelog (to me ;) which problem this change actually
tries to solve, because in general the task is not waitable after it
reports PROC_EVENT_EXIT.

So I think the patch is fine, but let me repeat:

	I hope that someone
	can confirm that netlink_broadcast() is safe even if release_task(current)
	was already called, so that the caller has no pids, sighand, is not visible
	via /proc/, etc.

not that I expect this should not work, but still.

> That
> usability issue/race has been there since forever afaik. We probably
> should never have added that process events connector thing, but since
> we did and people apparently use it..

Yes... BTW, Guillaume, I forgot to mention that perhaps you can use
signalfd(SIGCHLD) instead of connector, this is epoll-able too. SIGCHLD
doesn't queue, so it can't tell you which child has exited, but WNOHANG
should work.

Oleg.

