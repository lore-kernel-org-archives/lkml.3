Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbaISIsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 04:48:35 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:55835 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaISIsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 04:48:31 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] perf session: Add option to copy events when queueing
References: <1411060059-23589-1-git-send-email-yarygin@linux.vnet.ibm.com>
	<1411060059-23589-2-git-send-email-yarygin@linux.vnet.ibm.com>
	<20140918185345.GJ2770@kernel.org> <541B3ECD.8000706@gmail.com>
	<541B40A8.8020406@gmail.com>
Date: Fri, 19 Sep 2014 12:48:21 +0400
In-Reply-To: <541B40A8.8020406@gmail.com> (David Ahern's message of "Thu, 18
	Sep 2014 14:29:28 -0600")
Message-ID: <87r3z86lnu.fsf@linux.vnet.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091908-0342-0000-0000-0000011F02D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 9/18/14, 2:21 PM, David Ahern wrote:
>> On 9/18/14, 12:53 PM, Arnaldo Carvalho de Melo wrote:
>>> If nobody objects I'll merge this patch, as it fixes problems, but I
>>> wonder if the best wouldn't be simply not calling
>>> perf_evlist__mmap_consume() till the last event there is in fact
>>> consumed... I.e. as we _really_ consume the events, we remove it from
>>> there.
>>>
>>> Instead of consuming the event at perf_tool->sample() time, we would
>>> do it at perf_tool->finished_round(), would that be feasible? Has anyone
>>> tried this?
>>
>> Hmmm... haven't tried this.  Conceptually it should work - at least
>> nothing comes to mind at the moment.
>
> Upon further review ...
>
> Alex you might want to try this first. Malloc and copy of all events
> is going to bring some serious overhead. Can avoid that if consuming
> the event in finished_round works.
>
> David

I've tried that:

--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -737,7 +737,6 @@ static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
                 * FIXME: Here we can't consume the event, as perf_session_queue_event will
                 *        point to it, and it'll get possibly overwritten by the kernel.
                 */
-               perf_evlist__mmap_consume(kvm->evlist, idx);
 
                if (err) {
                        pr_err("Failed to enqueue sample: %d\n", err);
@@ -787,6 +786,10 @@ static int perf_kvm__mmap_read(struct perf_kvm_stat *kvm)
        if (ntotal) {
                kvm->session->ordered_samples.next_flush = flush_time;
                err = kvm->tool.finished_round(&kvm->tool, NULL, kvm->session);
+
+               for (i = 0; i < kvm->evlist->nr_mmaps; i++)
+                       perf_evlist__mmap_consume(kvm->evlist, i);
+
                if (err) {
                        if (kvm->lost_events)
                                pr_info("\nLost events: %" PRIu64
                        "\n\n",

It did't work. Turned out that there is at least one event alive after
finished_round(), usually I get more - ~20. Not sure why, maybe it's
another problem which should be solved at first?


Also, I tried to follow 'perf-top' way:

  while (perf_evlist__mmap_read() != NULL) {
    perf_evlist__parse_sample();
    perf_event__process_sample();
    perf_evlist__mmap_consume();
  }

I.e. without session_queue. In this case perf won't crash, but it will
process significantly less events.

