Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbbAUQVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:21:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbbAUQV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:21:28 -0500
Date: Wed, 21 Jan 2015 17:21:08 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: perf: behavior of poll() changed in 3.18
Message-ID: <20150121162108.GD6835@krava.brq.redhat.com>
References: <alpine.DEB.2.11.1501201155380.18043@vincent-weaver-1.umelst.maine.edu>
 <20150120181316.GA12860@krava.brq.redhat.com>
 <alpine.DEB.2.11.1501210058090.21805@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501210058090.21805@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 01:06:30AM -0500, Vince Weaver wrote:
> On Tue, 20 Jan 2015, Jiri Olsa wrote:
> 
> > I made this change to get notification that monitored
> > process exited.  We use it in 'perf record' to find out
> > that we have nothing more to monitor and quit.
> > 
> > The logic is to return POLLHUP (via poll syscall) when
> > the monitored process exits for the event.
> > 
> > Could you please share your test code?
> 
> My code does something like this to count the number of overflows
> happening in a child:
> 
> 	/* fds contains one fd, which is a harware event */
> 	/* attached to a child */
> 
> 	while(1) {
>                 result=poll(fds,1,100);
>                 if (result==0) {
>                         waitpid(child,&status,WNOHANG);

		unrelated, but I noticed, that this seems broken.. you shouldn't check
		WIFEXITED(status) without waitpid(... WNOHANG) returning > 0

>                         if (WIFEXITED(status)) break;
>                         if (WIFSIGNALED(status)) {
>                                 printf("Signalled %d!\n",WTERMSIG(status));
>                                 break;
>                         }
>                 }
> 
>                 if (fds[0].revents&POLLIN) count.in++;
>                 if (fds[0].revents&POLLHUP) count.hup++;
>                 if (fds[0].revents&POLLERR) break;
> 	}
> 
> With the change you made this code hangs forever because poll no longer
> returns "0" when the child exits, but instead returns "1" with
> POLLHUP set.

right, once event is HUPed the poll will return POLLHUP in revents

> 
> I admit my code isn't the best out there, but it worked reliably up
> until 3.18 when the change was made.

I think that poll returning POLLHUP for an event which cease to work
due to its process died is correct.

On the other side we broke your code, which is against the policy.

However if we revert this code, we'll loose nice (and standard) way
to check if the event is still valid.. not sure how to handle this.

thoughts?

> 
> Part of why my code doesn't just exit on POLLHUP is because you can
> get that result for reasons other than a process exit (for example,
> if you are using ioctl(PERF_EVENT_IOC_REFRESH)

Nope, this is related to POOL_HUP (notice the '_') which you'll get
accompanied with SIGIO if you setup this.

Before you could get POLLHUP (through poll) only if you'd called
poll on unmapped event.

Now (after commit 179033b3e064) you'll get it also if the process
that the event monitored has died.


jirka
