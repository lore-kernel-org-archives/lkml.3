Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbbAUGF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:05:28 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:62150 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbAUGF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:05:26 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 21 Jan 2015 01:06:30 -0500 (EST)
To: Jiri Olsa <jolsa@redhat.com>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: perf: behavior of poll() changed in 3.18
In-Reply-To: <20150120181316.GA12860@krava.brq.redhat.com>
Message-ID: <alpine.DEB.2.11.1501210058090.21805@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.11.1501201155380.18043@vincent-weaver-1.umelst.maine.edu> <20150120181316.GA12860@krava.brq.redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Jiri Olsa wrote:

> I made this change to get notification that monitored
> process exited.  We use it in 'perf record' to find out
> that we have nothing more to monitor and quit.
> 
> The logic is to return POLLHUP (via poll syscall) when
> the monitored process exits for the event.
> 
> Could you please share your test code?

My code does something like this to count the number of overflows
happening in a child:

	/* fds contains one fd, which is a harware event */
	/* attached to a child */

	while(1) {
                result=poll(fds,1,100);
                if (result==0) {
                        waitpid(child,&status,WNOHANG);
                        if (WIFEXITED(status)) break;
                        if (WIFSIGNALED(status)) {
                                printf("Signalled %d!\n",WTERMSIG(status));
                                break;
                        }
                }

                if (fds[0].revents&POLLIN) count.in++;
                if (fds[0].revents&POLLHUP) count.hup++;
                if (fds[0].revents&POLLERR) break;
	}

With the change you made this code hangs forever because poll no longer
returns "0" when the child exits, but instead returns "1" with
POLLHUP set.

I admit my code isn't the best out there, but it worked reliably up
until 3.18 when the change was made.

Part of why my code doesn't just exit on POLLHUP is because you can
get that result for reasons other than a process exit (for example,
if you are using ioctl(PERF_EVENT_IOC_REFRESH)

Vince
