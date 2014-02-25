Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaBYPK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:10:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbaBYPK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:10:57 -0500
Date: Tue, 25 Feb 2014 16:10:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, matt.helsley@gmail.com, davem@davemloft.net,
        guillaume@morinfr.org
Subject: Re: + exitc-call-proc_exit_connector-after-exit_state-is-set.patch
	added to -mm tree
Message-ID: <20140225151043.GA24546@redhat.com>
References: <530bbf59.78aTdR6Ql6kCpXnE%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530bbf59.78aTdR6Ql6kCpXnE%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The process events connector delivers a notification when a process exits.
>  This is really convenient for a process that spawns and wants to monitor
> its children through an epoll-able() interface.
>
> Unfortunately, there is a small window between when the event is delivered
> and the child become wait()-able.
>
> This is creates a race if the parent wants to make sure that it knows
> about the exit, e.g
>
> pid_t pid = fork();
> if (pid > 0) {
> 	register_interest_for_pid(pid);
> 	if (waitpid(pid, NULL, WNOHANG) > 0)
> 	{
> 	  /* We might have raced with exit() */
> 	}

Just in case... Even with this patch the code above is still "racy" if the
child is multi-threaded. Plus it should obviously filter-out subthreads.
And afaics there is no way to make it reliable, even if you change the
code above so that waitpid() is called only after the last thread exits
WNOHANG still can fail.

Not that I am not arguing with this change. Although I hope that someone
can confirm that netlink_broadcast() is safe even if release_task(current)
was already called, so that the caller has no pids, sighand, is not visible
via /proc/, etc.

Oleg.

