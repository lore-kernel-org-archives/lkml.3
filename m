Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3KUOzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:55:47 -0500
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:47849 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753177Ab3KUOzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:55:46 -0500
Message-ID: <528E1EE6.9040407@tu-dresden.de>
Date: Thu, 21 Nov 2013 15:55:34 +0100
From: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
References: <528484CB.7@tu-dresden.de> <20131114083930.GC16543@gmail.com> <528490DE.4080204@tu-dresden.de> <20131114100552.GA5064@gmail.com>
In-Reply-To: <20131114100552.GA5064@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for my delayed reply, it's been a busy week and I really wanted to
give Ingo's idea below some thought. Please find my comments below.

>>> If done that way then AFAICS we could even eliminate the 
>>> ->max_timestamps[NR_CPUS] array.
>>
>> I can understand your performance concerns. However, I am not 
>> sure how we can determine the minimal max_timestamp of all cpus 
>> without storing the information on a per-cpu basis first. 
>> Accumulating it on the fly would only lead to a global 
>> max_timestamp. [...]
> 
> Ok. So this:
> 
> +static inline void set_next_flush(struct perf_session *session)
> +{
> +       int i;
> +       u64 min_max_timestamp = session->ordered_samples.max_timestamps[0];
> +       for (i = 1; i < MAX_NR_CPUS; i++) {
> +               if (min_max_timestamp > session->ordered_samples.max_timestamps[i])
> +                       min_max_timestamp = session->ordered_samples.max_timestamps[i];
> +       }
> +       session->ordered_samples.next_flush = min_max_timestamp;
> +}
> 
> which should IMHO be written in a bit clearer form as:
> 
> static inline void set_next_flush(struct perf_session *session)
> {
> 	u64 *timestamps = session->ordered_samples.max_timestamps;
> 	u64 min_timestamp = timestamps[0];
>  	int i;
> 
> 	for (i = 1; i < MAX_NR_CPUS; i++) {
> 		if (min_timestamp > timestamps[i])
> 			min_timestamp = timestamps[i];
> 	}
> 
> 	session->ordered_samples.next_flush = min_timestamp;
> }

Agreed.

> 
> calculates the minimum of the max_timestamps[] array, right?
> 
> Now, the max_timestamps[] array gets modified only in a single 
> place, from the sample timestamps, via:
> 
> 	os->max_timestamps[sample->cpu] = timestamp;
> 
> My suggestion was an identity transformation: to calculate the 
> minimum of the array when the max_timestamps[] array is modified. 
> A new minimum happens if the freshly written value is smaller 
> than the current minimum.

I am really not sure how this would work since I don't see where we
could make progress while flushing if the max_timestamp is only replaced
with a smaller one but is never increased. IMO, it is necessary to
distinguish between timestamps of different cpus to determine the
next_flush timestamp across all cpus in each pass. I have tried to come
up with a working implementation of your idea but do not see a way to
safely increase the value of max_timestamp (without making assumptions
about the order of timestamps between cpus and passes).

Thinking about it a little more I see two catches in my solution:
(1) a cpu is only considered in determining the next_flush timestamp if
at least one event of this cpu has been processed already. Otherwise the
cpu is unknown and its first timestamp could be below the already
flushed timeslice timestamp. This can also happen in the current
implementation.
(2) Flush progress is only guaranteed while events from all cpus are
read. As soon as there are no events left for a cpu which already had
events in this session, the next_flush will remain at the timestamp of
the last pass which had events from all cpus until the final flush. I am
not sure how likely this is. This does not happen in the current
implementation.

As for David's suggestion to read perf_clock() at the start of every
round as a flush timestamp: from looking at the comments in
kernel/sched/clock.c, local_clock() (which is called by perf_clock) is
not guaranteed to be monotonic across cpus so there could still be
earlier timestamps coming late. Or am I missing something there?

Simply increasing the window to more than two passes in the current
implementation might lower the chance of hitting this problem but does
not guarantee success since passes can be very short (only a few events
from a few cpus) or even be empty.

Cheers
Joseph
