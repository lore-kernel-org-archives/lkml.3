Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab3KNKGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:06:01 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58894 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3KNKF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:05:58 -0500
Date: Thu, 14 Nov 2013 11:05:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
Message-ID: <20131114100552.GA5064@gmail.com>
References: <528484CB.7@tu-dresden.de>
 <20131114083930.GC16543@gmail.com>
 <528490DE.4080204@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528490DE.4080204@tu-dresden.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joseph Schuchart <joseph.schuchart@tu-dresden.de> wrote:


> > Just a quick side note, while I realize that you are 
> > (rightfully!) concerned about correctness primarily, if that loop 
> > over MAX_NR_CPUS executes often enough then this might hurt 
> > performance:
> > 
> >    perf.h:#define MAX_NR_CPUS                      256
> > 
> > So it might be better to maintain a rolling min_max_timestamp in 
> > this place:
> > 
> > +       os->max_timestamps[sample->cpu] = timestamp;
> > 
> > ?
> > 
> > If done that way then AFAICS we could even eliminate the 
> > ->max_timestamps[NR_CPUS] array.
> 
> I can understand your performance concerns. However, I am not 
> sure how we can determine the minimal max_timestamp of all cpus 
> without storing the information on a per-cpu basis first. 
> Accumulating it on the fly would only lead to a global 
> max_timestamp. [...]

Ok. So this:

+static inline void set_next_flush(struct perf_session *session)
+{
+       int i;
+       u64 min_max_timestamp = session->ordered_samples.max_timestamps[0];
+       for (i = 1; i < MAX_NR_CPUS; i++) {
+               if (min_max_timestamp > session->ordered_samples.max_timestamps[i])
+                       min_max_timestamp = session->ordered_samples.max_timestamps[i];
+       }
+       session->ordered_samples.next_flush = min_max_timestamp;
+}

which should IMHO be written in a bit clearer form as:

static inline void set_next_flush(struct perf_session *session)
{
	u64 *timestamps = session->ordered_samples.max_timestamps;
	u64 min_timestamp = timestamps[0];
 	int i;

	for (i = 1; i < MAX_NR_CPUS; i++) {
		if (min_timestamp > timestamps[i])
			min_timestamp = timestamps[i];
	}

	session->ordered_samples.next_flush = min_timestamp;
}

calculates the minimum of the max_timestamps[] array, right?

Now, the max_timestamps[] array gets modified only in a single 
place, from the sample timestamps, via:

	os->max_timestamps[sample->cpu] = timestamp;

My suggestion was an identity transformation: to calculate the 
minimum of the array when the max_timestamps[] array is modified. 
A new minimum happens if the freshly written value is smaller 
than the current minimum.

I.e. the max_timestamps[] array itself is redundant, and we just 
have to update a rolling minimum - which is a (session-) global 
minimum - which is equivalent to the more complex minimum 
calculation in your patch.

What am I missing?

Thanks,

	Ingo
