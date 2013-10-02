Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3JBMxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 08:53:21 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63970 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3JBMxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 08:53:17 -0400
Message-ID: <524C1729.4010904@gmail.com>
Date: Wed, 02 Oct 2013 06:52:57 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf session: Add option to copy events when queueing
References: <1378496221-61525-1-git-send-email-dsahern@gmail.com> <20131002121821.GE10099@krava.brq.redhat.com> <20131002123808.GA20396@krava.brq.redhat.com>
In-Reply-To: <20131002123808.GA20396@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/13 6:38 AM, Jiri Olsa wrote:
>>> Examples hitting this problem are 'perf kvm stat live', especially with nested
>>> VMs which generate 100,000+ traces per second, and a command processing
>>> scheduling events with a high rate of context switching -- e.g., running
>>> 'perf bench sched pipe'.
>>>
>>> This patch offers live commands an option to copy the event when it is
>>> placed in
>>> the ordered samples queue.
>
> So I guess you have some other patch that actually sets
> session::copy_on_queue?

Yes, with this patch commands have to set session->copy_on_queue to true.

My latest perf-sched-daemon code actually solves this another way: 
rather than asking perf-session to copy the events, the command itself 
does and passes the copied event to the perf-session processing code.

I like this design better because the command itself controls the 
allocation and free which the daemon needs because the events are added 
to another queue so the flow is:

    read from mmmap --> copy event --> pass to session code for time 
ordering --> process time ordered events

The daemon puts the time ordered events into a time-limited queue and 
only processes the event when requested.

If that is too confusing take a look at:

https://github.com/dsahern/linux/blob/perf-sched-timehist-3.11/tools/perf/schedmon.c

process_event is the handler for sample events coming out of the mmaps. 
It allocates memory, copies the event and then calls 
perf_session_queue_event on the copy.

David

