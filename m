Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaB0Oso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:48:44 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:58854 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbaB0Osm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:48:42 -0500
Date: Thu, 27 Feb 2014 15:48:27 +0100
From: Guillaume Morin <guillaume@morinfr.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        matt.helsley@gmail.com, davem@davemloft.net, guillaume@morinfr.org
Subject: Re: + exitc-call-proc_exit_connector-after-exit_state-is-set.patch
 added to -mm tree
Message-ID: <20140227144826.GA13313@bender.morinfr.org>
Mail-Followup-To: Oleg Nesterov <oleg@redhat.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	matt.helsley@gmail.com, davem@davemloft.net, guillaume@morinfr.org
References: <530bbf59.78aTdR6Ql6kCpXnE%akpm@linux-foundation.org>
 <20140225151043.GA24546@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225151043.GA24546@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 Feb 16:10, Oleg Nesterov wrote:
> > pid_t pid = fork();
> > if (pid > 0) {
> > 	register_interest_for_pid(pid);
> > 	if (waitpid(pid, NULL, WNOHANG) > 0)
> > 	{
> > 	  /* We might have raced with exit() */
> > 	}
> 
> Just in case... Even with this patch the code above is still "racy" if the
> child is multi-threaded. Plus it should obviously filter-out subthreads.
> And afaics there is no way to make it reliable, even if you change the
> code above so that waitpid() is called only after the last thread exits
> WNOHANG still can fail.
> Not that I am not arguing with this change. Although I hope that someone
> can confirm that netlink_broadcast() is safe even if release_task(current)
> was already called, so that the caller has no pids, sighand, is not visible
> via /proc/, etc.

I was too succinct, I think.  What I am trying to do is to close a race
when a short-lived *process* dies before register_interest_for_pid()
interprets the connector message correctly, (i.e realizes this is an
exit message for a pid that the parent created).

For example, let's say that the parent has an independent thread that
just reads from the netlink socket or uses a BPF filter to see only the
events it cares about.  In that case, it's possible that the exit
connector message will be discarded (either by a reader thread or the
BPF filter) before the parent realizes it should care about messages
about a new pid (the child pid)

You clarified for me that a ptraced process is a case where this race
could still happen.  That's a good point.  Fortunately, in the case of a
short-lived process, this is not a common scenario.

If we ignore the ptrace() case, I am not sure I see the problem with
multithreaded processes.  Even if the main thread exits right away, what is
important is that:
- *either* the exit connector message of the last thread that dies is be
  seen after register_interest_for_pid completes
- *or* that waitpid(WNOHANG) succeeds right after
  register_interest_for_pid()

You seem to say it's possible for all threads to have completed
exit_notify() and sent their exit message to the connector before
register_interest_for_pid() does its job and still have waitpid(WNOHANG)
fails.  Is it correct?  If so, could you give a bit more details on how
this could happen?

My understanding is that if all threads exited before waitpid() is
called, exit->state will be set to EXIT_ZOMBIE for the pid and that
delay_group_leader() will be false (because all sub-threads have
exited), so that waitpid(WNOHANG) will successfully reap the process.
What am I missing?

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>
