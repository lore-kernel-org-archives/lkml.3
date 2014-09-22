Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaIVHFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:05:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbaIVHFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:05:44 -0400
Date: Mon, 22 Sep 2014 09:04:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf session: Add option to copy events when queueing
Message-ID: <20140922070417.GB1191@krava.brq.redhat.com>
References: <1411060059-23589-1-git-send-email-yarygin@linux.vnet.ibm.com>
 <1411060059-23589-2-git-send-email-yarygin@linux.vnet.ibm.com>
 <20140918185345.GJ2770@kernel.org>
 <541B3ECD.8000706@gmail.com>
 <541B40A8.8020406@gmail.com>
 <87r3z86lnu.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r3z86lnu.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 12:48:21PM +0400, Alexander Yarygin wrote:
> David Ahern <dsahern@gmail.com> writes:
> 
> > On 9/18/14, 2:21 PM, David Ahern wrote:
> >> On 9/18/14, 12:53 PM, Arnaldo Carvalho de Melo wrote:
> >>> If nobody objects I'll merge this patch, as it fixes problems, but I
> >>> wonder if the best wouldn't be simply not calling
> >>> perf_evlist__mmap_consume() till the last event there is in fact
> >>> consumed... I.e. as we _really_ consume the events, we remove it from
> >>> there.
> >>>
> >>> Instead of consuming the event at perf_tool->sample() time, we would
> >>> do it at perf_tool->finished_round(), would that be feasible? Has anyone
> >>> tried this?
> >>
> >> Hmmm... haven't tried this.  Conceptually it should work - at least
> >> nothing comes to mind at the moment.
> >
> > Upon further review ...
> >
> > Alex you might want to try this first. Malloc and copy of all events
> > is going to bring some serious overhead. Can avoid that if consuming
> > the event in finished_round works.
> >
> > David
> 
> I've tried that:
> 
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -737,7 +737,6 @@ static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
>                  * FIXME: Here we can't consume the event, as perf_session_queue_event will
>                  *        point to it, and it'll get possibly overwritten by the kernel.
>                  */
> -               perf_evlist__mmap_consume(kvm->evlist, idx);
>  
>                 if (err) {
>                         pr_err("Failed to enqueue sample: %d\n", err);
> @@ -787,6 +786,10 @@ static int perf_kvm__mmap_read(struct perf_kvm_stat *kvm)
>         if (ntotal) {
>                 kvm->session->ordered_samples.next_flush = flush_time;
>                 err = kvm->tool.finished_round(&kvm->tool, NULL, kvm->session);
> +
> +               for (i = 0; i < kvm->evlist->nr_mmaps; i++)
> +                       perf_evlist__mmap_consume(kvm->evlist, i);
> +
>                 if (err) {
>                         if (kvm->lost_events)
>                                 pr_info("\nLost events: %" PRIu64
>                         "\n\n",
> 
> It did't work. Turned out that there is at least one event alive after
> finished_round(), usually I get more - ~20. Not sure why, maybe it's
> another problem which should be solved at first?

The flush timestamp at the moment of the ROUND event is not
the max timestamp of the queue. It's set as max queue timestamp
by the previous flush as explained in util/session.c
process_finished_round function comment

> 
> 
> Also, I tried to follow 'perf-top' way:
> 
>   while (perf_evlist__mmap_read() != NULL) {
>     perf_evlist__parse_sample();
>     perf_event__process_sample();
>     perf_evlist__mmap_consume();
>   }
> 
> I.e. without session_queue. In this case perf won't crash, but it will
> process significantly less events.

right, I guess they are dropped in kernel due to the
userspace processing being slow

I'm ok with this solution.. with some comments in my other email

jirka
