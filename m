Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3JXOHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:07:39 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:50239 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab3JXOHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:07:37 -0400
Date: Thu, 24 Oct 2013 11:07:31 -0300
From: Arnaldo Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf session: Add option to copy events when queueing
Message-ID: <20131024140731.GD6539@ghostprotocols.net>
References: <1378496221-61525-1-git-send-email-dsahern@gmail.com>
 <20130914161626.GD1718@localhost.localdomain>
 <CAFTL4hx=ycrepky0P3DYwoFBgknYumW6+tpW7PygqGD2ZNDFqg@mail.gmail.com>
 <5268F524.20505@gmail.com>
 <20131024122748.GC6539@ghostprotocols.net>
 <52691CBD.7050606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52691CBD.7050606@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 24, 2013 at 02:12:29PM +0100, David Ahern escreveu:
> On 10/24/13 1:27 PM, Arnaldo Melo wrote:

> The driving use case is my perf-daemon:
> https://github.com/dsahern/linux/blob/perf-sched-timehist-3.11/tools/perf/schedmon.c,
> line 271.
> 
> Rather than have the perf infrastructure manage the allocation and
> copies I decided to have the daemon do it. The session
> infrastructure is only used for time sorting.
> 
> This works better because the event that pops out of the session
> ordering is put onto another list and it gives the daemon control of
> when memory is allocated and freed and the event only has to be
> copied once.

Ok, I see, but that could be useful for other tools, so at some point
what ends up being the best for your tool can be submitted upstream 8-)
 
> >
> >I had this feeling that perhaps we could defer copying the event till it
> >would be overwritten, something like making a range read only and then
> >when the event would be _really_ consumed the tooling would mark it as
> >so... Have to think about it more tho :-\
> 
> The above does not solve the problem for live tools where the event
> actually lies in the ring buffer and could be overwritten while it
> sits in the session ordered samples queue. The kvm-stat-live tool
> for nested virtualization is a stress test for this case. I need to
> come back to that problem, it just has not bubbled up to the top.

What I thought was since we have to allocate memory _somewhere_ we could
size the ring buffer in such a way that it would be big enough for us to
leave those referenced entries there, not consumed, till we actually
consume them when reordering the events, and if we run out of space, the
kernel would just use LOST records, and not overwrite anything.

- Arnaldo
