Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3K0Nvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:51:47 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:43186 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3K0Nvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:51:43 -0500
Date: Wed, 27 Nov 2013 14:51:37 +0100
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
Message-ID: <20131127135137.GA24403@gmail.com>
References: <528484CB.7@tu-dresden.de>
 <20131114083930.GC16543@gmail.com>
 <528490DE.4080204@tu-dresden.de>
 <20131114100552.GA5064@gmail.com>
 <528E1EE6.9040407@tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528E1EE6.9040407@tu-dresden.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joseph Schuchart <joseph.schuchart@tu-dresden.de> wrote:

> Sorry for my delayed reply, it's been a busy week and I really wanted to
> give Ingo's idea below some thought. Please find my comments below.
> 
> >>> If done that way then AFAICS we could even eliminate the 
> >>> ->max_timestamps[NR_CPUS] array.
> >>
> >> I can understand your performance concerns. However, I am not 
> >> sure how we can determine the minimal max_timestamp of all cpus 
> >> without storing the information on a per-cpu basis first. 
> >> Accumulating it on the fly would only lead to a global 
> >> max_timestamp. [...]
> > 
> > Ok. So this:
> > 
> > +static inline void set_next_flush(struct perf_session *session)
> > +{
> > +       int i;
> > +       u64 min_max_timestamp = session->ordered_samples.max_timestamps[0];
> > +       for (i = 1; i < MAX_NR_CPUS; i++) {
> > +               if (min_max_timestamp > session->ordered_samples.max_timestamps[i])
> > +                       min_max_timestamp = session->ordered_samples.max_timestamps[i];
> > +       }
> > +       session->ordered_samples.next_flush = min_max_timestamp;
> > +}
> > 
> > which should IMHO be written in a bit clearer form as:
> > 
> > static inline void set_next_flush(struct perf_session *session)
> > {
> > 	u64 *timestamps = session->ordered_samples.max_timestamps;
> > 	u64 min_timestamp = timestamps[0];
> >  	int i;
> > 
> > 	for (i = 1; i < MAX_NR_CPUS; i++) {
> > 		if (min_timestamp > timestamps[i])
> > 			min_timestamp = timestamps[i];
> > 	}
> > 
> > 	session->ordered_samples.next_flush = min_timestamp;
> > }
> 
> Agreed.
> 
> > 
> > calculates the minimum of the max_timestamps[] array, right?
> > 
> > Now, the max_timestamps[] array gets modified only in a single 
> > place, from the sample timestamps, via:
> > 
> > 	os->max_timestamps[sample->cpu] = timestamp;
> > 
> > My suggestion was an identity transformation: to calculate the 
> > minimum of the array when the max_timestamps[] array is modified. 
> > A new minimum happens if the freshly written value is smaller 
> > than the current minimum.
> 
> I am really not sure how this would work since I don't see where we 
> could make progress while flushing if the max_timestamp is only 
> replaced with a smaller one but is never increased. IMO, it is 
> necessary to distinguish between timestamps of different cpus to 
> determine the next_flush timestamp across all cpus in each pass. I 
> have tried to come up with a working implementation of your idea but 
> do not see a way to safely increase the value of max_timestamp 
> (without making assumptions about the order of timestamps between 
> cpus and passes).

Mine isn't really an 'idea' - I did to the code what I see an identity 
transformation, a change that does not change the principle or the 
working of the code.

And after the identity transformation your code seems to have 
simplified down significantly - at which point I was wondering.

If what I did is _not_ an identity transformation then please point 
out where I break your logic. (it might easily be some really simple 
misundestanding on my part.)

Thanks,

	Ingo
