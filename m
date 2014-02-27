Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaB0QsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:48:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbaB0QsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:48:05 -0500
Date: Thu, 27 Feb 2014 17:47:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        matt.helsley@gmail.com, davem@davemloft.net, guillaume@morinfr.org
Subject: Re: + exitc-call-proc_exit_connector-after-exit_state-is-set.patch
	added to -mm tree
Message-ID: <20140227164750.GC909@redhat.com>
References: <530bbf59.78aTdR6Ql6kCpXnE%akpm@linux-foundation.org> <20140225151043.GA24546@redhat.com> <20140227144826.GA13313@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227144826.GA13313@bender.morinfr.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27, Guillaume Morin wrote:
>
> On 25 Feb 16:10, Oleg Nesterov wrote:
> > > pid_t pid = fork();
> > > if (pid > 0) {
> > > 	register_interest_for_pid(pid);
> > > 	if (waitpid(pid, NULL, WNOHANG) > 0)
> > > 	{
> > > 	  /* We might have raced with exit() */
> > > 	}
> >
> > Just in case... Even with this patch the code above is still "racy" if the
> > child is multi-threaded. Plus it should obviously filter-out subthreads.
> > And afaics there is no way to make it reliable, even if you change the
> > code above so that waitpid() is called only after the last thread exits
> > WNOHANG still can fail.
> > Not that I am not arguing with this change. Although I hope that someone
> > can confirm that netlink_broadcast() is safe even if release_task(current)
> > was already called, so that the caller has no pids, sighand, is not visible
> > via /proc/, etc.
>
> I was too succinct, I think.  What I am trying to do is to close a race
> when a short-lived *process* dies before register_interest_for_pid()
> interprets the connector message correctly, (i.e realizes this is an
> exit message for a pid that the parent created).

Yes, I misunderstood the changelog, thanks.

Anyway, I only tried to say that "a small window between when the event
is delivered and the child become wait()-able." is not closed by this
patch. Sorry for not being clear enough.

> You clarified for me that a ptraced process is a case where this race
> could still happen.  That's a good point.  Fortunately, in the case of a
> short-lived process, this is not a common scenario.

OK.

> You seem to say it's possible for all threads to have completed
> exit_notify() and sent their exit message to the connector before
> register_interest_for_pid() does its job and still have waitpid(WNOHANG)
> fails.  Is it correct?

And I indeed said this, but I was wrong ;) Sorry. somehow I forgot
that with this patch release_task(sub_thread) is always called before
proc_exit_connector() (and I even asked if this is safe above).

However, I still do not see how you can ensure that all threads have
already exited to rely on WNOHANG.

Nevermind. Please consider this trivial example:

	tfunc(void *)
	{
		for (;;)
			pause();
	}

	int main(void)
	{
		pthread_create(tfunc);
		pthread_exit();
	}

The main thread can exit and call proc_exit_connector() before
register_interest_for_pid(), but WNOHANG obviously can't succeed.

So I am still not sure this patch can solve the problem you described.
But let me repeat just in case: I am not arguing with this change.

Oleg.

