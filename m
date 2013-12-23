Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab3LWTiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 14:38:06 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:64313 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab3LWTiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 14:38:04 -0500
Date: Mon, 23 Dec 2013 16:37:57 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Do not show stats if workload fails
Message-ID: <20131223193757.GA1396@ghostprotocols.net>
References: <1387518748-25340-1-git-send-email-dsahern@gmail.com>
 <20131220075759.GA12937@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220075759.GA12937@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 20, 2013 at 08:57:59AM +0100, Ingo Molnar escreveu:
> * David Ahern <dsahern@gmail.com> wrote:
> 
> > Currently perf-stat attempts to show counter stats even if the workload
> > is bogus:
> > 
> > $ perf stat -- foo
> > foo: No such file or directory
> > 
> >  Performance counter stats for 'foo':
> > 
> >      <not counted>      task-clock
> >      <not counted>      context-switches
> >      <not counted>      cpu-migrations
> >      <not counted>      page-faults
> >      <not counted>      cycles
> >      <not counted>      stalled-cycles-frontend
> >      <not counted>      stalled-cycles-backend
> >      <not counted>      instructions
> >      <not counted>      branches
> >      <not counted>      branch-misses
> > 
> >        0.009769943 seconds time elapsed
> > 
> > It is impossible to differentiate all the failure modes, but it seems
> > reasonable that if the workload handling fails, perf-stat should not try
> > to print stats.
> > 
> > With this change:
> > 
> > $ perf stat  -v -- foo
> > Failed to start workload
> > 
> > Signed-off-by: David Ahern <dsahern@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Stephane Eranian <eranian@google.com>
> 
> Nice!
> 
> Acked-by: Ingo Molnar <mingo@kernel.org>

Good intent, but...

[acme@ssdandy linux]$ perf stat usleep 1
Failed to start workload
[acme@ssdandy linux]$

Your patch does:

if (perf_evlist__start_workload(evsel_list) != 0)

But:

int perf_evlist__start_workload(struct perf_evlist *evlist)
{
        if (evlist->workload.cork_fd > 0) {
                char bf = 0;
                int ret;
                /*
                 * Remove the cork, let it rip!
                 */
                ret = write(evlist->workload.cork_fd, &bf, 1);
                if (ret < 0)
                        perror("enable to write to pipe");

                close(evlist->workload.cork_fd);
                return ret;
        }

        return 0;
}

Ret there is 1, so we need to change it to:

		return ret != 1 ? -1 : 0;

Right?

- Arnaldo
