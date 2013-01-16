Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab3APOAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:00:32 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:62063 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab3APOA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:00:28 -0500
MIME-Version: 1.0
In-Reply-To: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 16 Jan 2013 09:00:07 -0500
Message-ID: <CAOPLpQeHTCwr4tuHi0nORCn+LKJRzEGoCWhC-rj30nLe7bY5Nw@mail.gmail.com>
Subject: Re: [RFC 0/4] perf tool: Adding ratios support
To: Jiri Olsa <jolsa@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 8:39 AM, Jiri Olsa <jolsa@redhat.com> wrote:
>   $ perf stat -f formula.conf:cpi kill
>   usage: kill [ -s signal | -p ] [ -a ] pid ...
>          kill -l [ signal ]

I do like this proposal.  The only comment I have is that perhaps the
command line syntax isn't ideal.  What you use above is tied to the
ratios be defined in the config file.  I would imagine that at least
over time (for some ratios probably right away) they become available
by default and don't require a config file.  Also, users might want to
put individualized ratio definitions in a config file which is read by
default.

How about the formulas becoming available whenever the config file is
read.  Maybe this means a few more keywords in the config file (ratio,
ratio-set, ...).  E.g.:

ratio-set branch {
          events = {instructions,branch-instructions,branch-misses}:u

          ratio branch-rate {
                  formula = branch-instructions / instructions
                  desc = branch rate
          }

          ratio branch-miss-rate {
                  formula = branch-misses / instructions
                  desc = branch misprediction rate
          }

          ratio branch-miss-ratio{
                  formula = branch-misses / branch-instructions
                  desc = branch misprediction ratio
          }
  }

You get the idea.  Maybe substitute "ratio":with "formula". Then allow
such a ratio/formula to be used just like a normal event, perhaps with
a special suffix/prefix to designate it.  This should then also mark
the events as part of a group so that the underlying counters are
scheduled in together.
