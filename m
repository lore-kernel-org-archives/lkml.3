Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3JXNMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 09:12:33 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:64415 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3JXNMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 09:12:32 -0400
Message-ID: <52691CBD.7050606@gmail.com>
Date: Thu, 24 Oct 2013 14:12:29 +0100
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnaldo Melo <acme@ghostprotocols.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf session: Add option to copy events when queueing
References: <1378496221-61525-1-git-send-email-dsahern@gmail.com> <20130914161626.GD1718@localhost.localdomain> <CAFTL4hx=ycrepky0P3DYwoFBgknYumW6+tpW7PygqGD2ZNDFqg@mail.gmail.com> <5268F524.20505@gmail.com> <20131024122748.GC6539@ghostprotocols.net>
In-Reply-To: <20131024122748.GC6539@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/13 1:27 PM, Arnaldo Melo wrote:
> Em Thu, Oct 24, 2013 at 11:23:32AM +0100, David Ahern escreveu:
>> On 10/24/13 10:30 AM, Frederic Weisbecker wrote:
>>> Bah, checking that again, there don't seem to be a bug there. Actually
>>> the sample buffer is reset after we pick the last entry. So it looks
>>> all fine. I got confused as usual. Nevermind.
>>
>> Ok. I had not come back to this thread since I decided on a
>> different route for the event copying. I'll take it out of my to-do
>> list.
>
> Can you elaborate on that?

The driving use case is my perf-daemon:
https://github.com/dsahern/linux/blob/perf-sched-timehist-3.11/tools/perf/schedmon.c, 
line 271.

Rather than have the perf infrastructure manage the allocation and 
copies I decided to have the daemon do it. The session infrastructure is 
only used for time sorting.

This works better because the event that pops out of the session 
ordering is put onto another list and it gives the daemon control of 
when memory is allocated and freed and the event only has to be copied once.

>
> I had this feeling that perhaps we could defer copying the event till it
> would be overwritten, something like making a range read only and then
> when the event would be _really_ consumed the tooling would mark it as
> so... Have to think about it more tho :-\

The above does not solve the problem for live tools where the event 
actually lies in the ring buffer and could be overwritten while it sits 
in the session ordered samples queue. The kvm-stat-live tool for nested 
virtualization is a stress test for this case. I need to come back to 
that problem, it just has not bubbled up to the top.

David
