Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3LXMxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 07:53:55 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:58862 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3LXMxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 07:53:54 -0500
Date: Tue, 24 Dec 2013 09:53:42 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Do not show stats if workload fails
Message-ID: <20131224125342.GC17780@ghostprotocols.net>
References: <1387518748-25340-1-git-send-email-dsahern@gmail.com>
 <20131220075759.GA12937@gmail.com>
 <20131223193757.GA1396@ghostprotocols.net>
 <52B8D582.9090009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B8D582.9090009@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 23, 2013 at 07:29:54PM -0500, David Ahern escreveu:
> On 12/23/13, 2:37 PM, Arnaldo Carvalho de Melo wrote:
> >int perf_evlist__start_workload(struct perf_evlist *evlist)
> >{
> >         if (evlist->workload.cork_fd > 0) {
> >                 char bf = 0;
> >                 /* Remove the cork, let it rip! */
> >                 int ret = write(evlist->workload.cork_fd, &bf, 1);
> >                 if (ret < 0)
> >                         perror("enable to write to pipe");
> >
> >                 close(evlist->workload.cork_fd);
> >                 return ret;
> >         }
> >         return 0;
> >}

> >Ret there is 1, so we need to change it to:

> >		return ret != 1 ? -1 : 0;

> >Right?
 
> Yes, nice catch.

But this doesn't really matters, if one uses the more usual:

	if (function() < 0)

pattern for error checking, there would be no problem, and we would only
be checking that we told perf_evlist__prepare_workload()'s fork branch
to call execvp, not to check what happens then, i.e. if it finds the
specified workload in the system's PATH, if there are no permission of
file format problems, etc.

The thing to check is perf_evlist__{prepare,start}_workload notification
errors using SIGUSR1, that we need to check for in the caller, and emit
the message, no?

- Arnaldo
