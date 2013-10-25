Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3JYNTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:19:19 -0400
Received: from mail-gg0-f173.google.com ([209.85.161.173]:52199 "EHLO
	mail-gg0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3JYNTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:19:17 -0400
Date: Fri, 25 Oct 2013 10:19:10 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH 1/1] PERF: The tail position of the event buffer should
 only be modified after actually use that event.
Message-ID: <20131025131910.GD20423@ghostprotocols.net>
References: <1382600613-32177-1-git-send-email-zhouzhouyi@gmail.com>
 <20131024182333.GD4998@ghostprotocols.net>
 <CAABZP2z+dPKNBkxnxcoJu68pEgymOkz+Hry0WSYUdPA2yYyRzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAABZP2z+dPKNBkxnxcoJu68pEgymOkz+Hry0WSYUdPA2yYyRzA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 25, 2013 at 09:46:34AM +0800, Zhouyi Zhou escreveu:
> Thanks Arnaldo For Reviewing and Nice simplication.
> The next headache should be how to quick copy out the digest
> of event.
> From my own engineering experience, it is unsafe to keep the pointer
> to shared ring buffer for too long.

Right, that it is, that is why I left a blinking FIXME in the only place
were we leave pointers to consumed records, and David Ahern spent some
time already on this problem, will get to that at some point.

But with your fix at least we're sure that it won't happen for the event
being processed, i.e. in non overwrite mode the kernel will not mess
with its contents, generating PERF_RECORD_LOST records instead.

Ok, applying the simplified version to perf/core.

- Arnaldo
 
> On Fri, Oct 25, 2013 at 2:23 AM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > Em Thu, Oct 24, 2013 at 03:43:33PM +0800, Zhouyi Zhou escreveu:
> >>
> >> The tail position of the event buffer should only be
> >> modified after actually use that event. If not the event
> >> buffer could be invalid before use, and segment fault occurs when invoking
> >> perf top -G.
> >
> > Good catch!
> >
> > Long standing problem, but please take a look at the patch below, which
> > should be a simpler version of your fix, main points:
> >
> > . Rename perf_evlist__write_tail to perf_evlist__mmap_consume:
> >
> >      So it should be a transaction end counterpart to
> >      perf_evlist__mmap_read, the "writing the tail" detail gets nicely
> >      abstracted away.
> >
> > . The error exit path for 'perf test' entries don't need to consume the
> >   event, since it will be all shutdown anyway
> >
> > . In other cases avoid multiple calls to the consume method by just
> >   goto'ing to the end of the loop, where we would consume the event
> >   anyway when everything is all right.
> >
> > Please take a look, if you're ok with it, I'll keep your patch
> > authorship and just add a quick note about the simplifications I made.
> >
> > After that I think we should, a-la skb_free/skb_consume have a another
> > method, namely perf_evlist__mmap_discard, so that we can keep a tab on
> > how many events were successfully consumed and how many were not
> > processed due to some problem.
> >
> > WRT the simplifications:
> >
> > Your patch:
> >
> >  14 files changed, 65 insertions(+), 9 deletions(-)
> >
> > Your patch + my changes:
> >
> >  14 files changed, 49 insertions(+), 16 deletions(-)
> >
> > :-)
> >
> > - Arnaldo
> >
> >> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> >> ---
> >>  tools/perf/builtin-kvm.c                  |    4 ++++
> >>  tools/perf/builtin-top.c                  |   11 +++++++++--
> >>  tools/perf/builtin-trace.c                |    4 ++++
> >>  tools/perf/tests/code-reading.c           |    1 +
> >>  tools/perf/tests/keep-tracking.c          |    1 +
> >>  tools/perf/tests/mmap-basic.c             |    4 ++++
> >>  tools/perf/tests/open-syscall-tp-fields.c |    7 ++++++-
> >>  tools/perf/tests/perf-record.c            |    3 +++
> >>  tools/perf/tests/perf-time-to-tsc.c       |    5 ++++-
> >>  tools/perf/tests/sw-clock.c               |    7 ++++++-
> >>  tools/perf/tests/task-exit.c              |    5 ++++-
> >>  tools/perf/util/evlist.c                |   13 +++++++++++--
> >>  tools/perf/util/evlist.h                |    2 ++
> >>  tools/perf/util/python.c                  |    7 ++++++-
> >>  14 files changed, 64 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> >> index 935d522..e240846 100644
> >> --- a/tools/perf/builtin-kvm.c
> >> +++ b/tools/perf/builtin-kvm.c
> >> @@ -888,16 +888,20 @@ static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
> >>       while ((event = perf_evlist__mmap_read(kvm->evlist, idx)) != NULL) {
> >>               err = perf_evlist__parse_sample(kvm->evlist, event, &sample);
> >>               if (err) {
> >> +                     perf_evlist__mmap_write_tail(kvm->evlist, idx);
> >>                       pr_err("Failed to parse sample\n");
> >>                       return -1;
> >>               }
> >>
> >>               err = perf_session_queue_event(kvm->session, event, &sample, 0);
> >>               if (err) {
> >> +                     perf_evlist__mmap_write_tail(kvm->evlist, idx);
> >>                       pr_err("Failed to enqueue sample: %d\n", err);
> >>                       return -1;
> >>               }
> >>
> >> +             perf_evlist__mmap_write_tail(kvm->evlist, idx);
> >> +
> >>               /* save time stamp of our first sample for this mmap */
> >>               if (n == 0)
> >>                       *mmap_time = sample.time;
> >> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> >> index 2122141..5e03cf5 100644
> >> --- a/tools/perf/builtin-top.c
> >> +++ b/tools/perf/builtin-top.c
> >> @@ -809,6 +809,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
> >>       while ((event = perf_evlist__mmap_read(top->evlist, idx)) != NULL) {
> >>               ret = perf_evlist__parse_sample(top->evlist, event, &sample);
> >>               if (ret) {
> >> +                     perf_evlist__mmap_write_tail(top->evlist, idx);
> >>                       pr_err("Can't parse sample, err = %d\n", ret);
> >>                       continue;
> >>               }
> >> @@ -824,14 +825,18 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
> >>               switch (origin) {
> >>               case PERF_RECORD_MISC_USER:
> >>                       ++top->us_samples;
> >> -                     if (top->hide_user_symbols)
> >> +                     if (top->hide_user_symbols) {
> >> +                             perf_evlist__mmap_write_tail(top->evlist, idx);
> >>                               continue;
> >> +                     }
> >>                       machine = &session->machines.host;
> >>                       break;
> >>               case PERF_RECORD_MISC_KERNEL:
> >>                       ++top->kernel_samples;
> >> -                     if (top->hide_kernel_symbols)
> >> +                     if (top->hide_kernel_symbols) {
> >> +                             perf_evlist__mmap_write_tail(top->evlist, idx);
> >>                               continue;
> >> +                     }
> >>                       machine = &session->machines.host;
> >>                       break;
> >>               case PERF_RECORD_MISC_GUEST_KERNEL:
> >> @@ -847,6 +852,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
> >>                        */
> >>                       /* Fall thru */
> >>               default:
> >> +                     perf_evlist__mmap_write_tail(top->evlist, idx);
> >>                       continue;
> >>               }
> >>
> >> @@ -859,6 +865,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
> >>                       machine__process_event(machine, event);
> >>               } else
> >>                       ++session->stats.nr_unknown_events;
> >> +             perf_evlist__mmap_write_tail(top->evlist, idx);
> >>       }
> >>  }
> >>
> >> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> >> index 71aa3e3..7afb6cd 100644
> >> --- a/tools/perf/builtin-trace.c
> >> +++ b/tools/perf/builtin-trace.c
> >> @@ -986,6 +986,7 @@ again:
> >>
> >>                       err = perf_evlist__parse_sample(evlist, event, &sample);
> >>                       if (err) {
> >> +                             perf_evlist__mmap_write_tail(evlist, i);
> >>                               fprintf(trace->output, "Can't parse sample, err = %d, skipping...\n", err);
> >>                               continue;
> >>                       }
> >> @@ -1000,11 +1001,13 @@ again:
> >>
> >>                       evsel = perf_evlist__id2evsel(evlist, sample.id);
> >>                       if (evsel == NULL) {
> >> +                             perf_evlist__mmap_write_tail(evlist, i);
> >>                               fprintf(trace->output, "Unknown tp ID %" PRIu64 ", skipping...\n", sample.id);
> >>                               continue;
> >>                       }
> >>
> >>                       if (sample.raw_data == NULL) {
> >> +                             perf_evlist__mmap_write_tail(evlist, i);
> >>                               fprintf(trace->output, "%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
> >>                                      perf_evsel__name(evsel), sample.tid,
> >>                                      sample.cpu, sample.raw_size);
> >> @@ -1014,6 +1017,7 @@ again:
> >>                       handler = evsel->handler.func;
> >>                       handler(trace, evsel, &sample);
> >>
> >> +                     perf_evlist__mmap_write_tail(evlist, i);
> >>                       if (done)
> >>                               goto out_unmap_evlist;
> >>               }
> >> diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
> >> index 6fb781d..2e5c20d 100644
> >> --- a/tools/perf/tests/code-reading.c
> >> +++ b/tools/perf/tests/code-reading.c
> >> @@ -290,6 +290,7 @@ static int process_events(struct machine *machine, struct perf_evlist *evlist,
> >>       for (i = 0; i < evlist->nr_mmaps; i++) {
> >>               while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
> >>                       ret = process_event(machine, evlist, event, state);
> >> +                     perf_evlist__mmap_write_tail(evlist, i);
> >>                       if (ret < 0)
> >>                               return ret;
> >>               }
> >> diff --git a/tools/perf/tests/keep-tracking.c b/tools/perf/tests/keep-tracking.c
> >> index d444ea2..ffa5836 100644
> >> --- a/tools/perf/tests/keep-tracking.c
> >> +++ b/tools/perf/tests/keep-tracking.c
> >> @@ -36,6 +36,7 @@ static int find_comm(struct perf_evlist *evlist, const char *comm)
> >>                           (pid_t)event->comm.tid == getpid() &&
> >>                           strcmp(event->comm.comm, comm) == 0)
> >>                               found += 1;
> >> +                     perf_evlist__mmap_write_tail(evlist, i);
> >>               }
> >>       }
> >>       return found;
> >> diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
> >> index c4185b9..bbca5f4 100644
> >> --- a/tools/perf/tests/mmap-basic.c
> >> +++ b/tools/perf/tests/mmap-basic.c
> >> @@ -103,6 +103,7 @@ int test__basic_mmap(void)
> >>               struct perf_sample sample;
> >>
> >>               if (event->header.type != PERF_RECORD_SAMPLE) {
> >> +                     perf_evlist__mmap_write_tail(evlist, 0);
> >>                       pr_debug("unexpected %s event\n",
> >>                                perf_event__name(event->header.type));
> >>                       goto out_munmap;
> >> @@ -110,6 +111,7 @@ int test__basic_mmap(void)
> >>
> >>               err = perf_evlist__parse_sample(evlist, event, &sample);
> >>               if (err) {
> >> +                     perf_evlist__mmap_write_tail(evlist, 0);
> >>                       pr_err("Can't parse sample, err = %d\n", err);
> >>                       goto out_munmap;
> >>               }
> >> @@ -117,11 +119,13 @@ int test__basic_mmap(void)
> >>               err = -1;
> >>               evsel = perf_evlist__id2evsel(evlist, sample.id);
> >>               if (evsel == NULL) {
> >> +                     perf_evlist__mmap_write_tail(evlist, 0);
> >>                       pr_debug("event with id %" PRIu64
> >>                                " doesn't map to an evsel\n", sample.id);
> >>                       goto out_munmap;
> >>               }
> >>               nr_events[evsel->idx]++;
> >> +             perf_evlist__mmap_write_tail(evlist, 0);
> >>       }
> >>
> >>       err = 0;
> >> diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
> >> index fc5b9fc..38e180c 100644
> >> --- a/tools/perf/tests/open-syscall-tp-fields.c
> >> +++ b/tools/perf/tests/open-syscall-tp-fields.c
> >> @@ -77,11 +77,14 @@ int test__syscall_open_tp_fields(void)
> >>
> >>                               ++nr_events;
> >>
> >> -                             if (type != PERF_RECORD_SAMPLE)
> >> +                             if (type != PERF_RECORD_SAMPLE) {
> >> +                                     perf_evlist__mmap_write_tail(evlist, i);
> >>                                       continue;
> >> +                             }
> >>
> >>                               err = perf_evsel__parse_sample(evsel, event, &sample);
> >>                               if (err) {
> >> +                                     perf_evlist__mmap_write_tail(evlist, i);
> >>                                       pr_err("Can't parse sample, err = %d\n", err);
> >>                                       goto out_munmap;
> >>                               }
> >> @@ -89,11 +92,13 @@ int test__syscall_open_tp_fields(void)
> >>                               tp_flags = perf_evsel__intval(evsel, &sample, "flags");
> >>
> >>                               if (flags != tp_flags) {
> >> +                                     perf_evlist__mmap_write_tail(evlist, i);
> >>                                       pr_debug("%s: Expected flags=%#x, got %#x\n",
> >>                                                __func__, flags, tp_flags);
> >>                                       goto out_munmap;
> >>                               }
> >>
> >> +                             perf_evlist__mmap_write_tail(evlist, i);
> >>                               goto out_ok;
> >>                       }
> >>               }
> >> diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
> >> index b8a7056..87a2b0c 100644
> >> --- a/tools/perf/tests/perf-record.c
> >> +++ b/tools/perf/tests/perf-record.c
> >> @@ -173,6 +173,7 @@ int test__PERF_RECORD(void)
> >>
> >>                               err = perf_evlist__parse_sample(evlist, event, &sample);
> >>                               if (err < 0) {
> >> +                                     perf_evlist__mmap_write_tail(evlist, i);
> >>                                       if (verbose)
> >>                                               perf_event__fprintf(event, stderr);
> >>                                       pr_debug("Couldn't parse sample\n");
> >> @@ -236,6 +237,7 @@ int test__PERF_RECORD(void)
> >>                                       }
> >>                                       break;
> >>                               case PERF_RECORD_EXIT:
> >> +                                     perf_evlist__mmap_write_tail(evlist, i);
> >>                                       goto found_exit;
> >>                               case PERF_RECORD_MMAP:
> >>                                       mmap_filename = event->mmap.filename;
> >> @@ -263,6 +265,7 @@ int test__PERF_RECORD(void)
> >>                                                type);
> >>                                       ++errs;
> >>                               }
> >> +                             perf_evlist__mmap_write_tail(evlist, i);
> >>                       }
> >>               }
> >>
> >> diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
> >> index 0ab61b1..d911316 100644
> >> --- a/tools/perf/tests/perf-time-to-tsc.c
> >> +++ b/tools/perf/tests/perf-time-to-tsc.c
> >> @@ -121,8 +121,10 @@ int test__perf_time_to_tsc(void)
> >>
> >>                       if (event->header.type != PERF_RECORD_COMM ||
> >>                           (pid_t)event->comm.pid != getpid() ||
> >> -                         (pid_t)event->comm.tid != getpid())
> >> +                         (pid_t)event->comm.tid != getpid()) {
> >> +                             perf_evlist__mmap_write_tail(evlist, i);
> >>                               continue;
> >> +                     }
> >>
> >>                       if (strcmp(event->comm.comm, comm1) == 0) {
> >>                               CHECK__(perf_evsel__parse_sample(evsel, event,
> >> @@ -134,6 +136,7 @@ int test__perf_time_to_tsc(void)
> >>                                                                &sample));
> >>                               comm2_time = sample.time;
> >>                       }
> >> +                     perf_evlist__mmap_write_tail(evlist, i);
> >>               }
> >>       }
> >>
> >> diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
> >> index 2e41e2d..af7f2626 100644
> >> --- a/tools/perf/tests/sw-clock.c
> >> +++ b/tools/perf/tests/sw-clock.c
> >> @@ -77,15 +77,20 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
> >>       while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
> >>               struct perf_sample sample;
> >>
> >> -             if (event->header.type != PERF_RECORD_SAMPLE)
> >> +             if (event->header.type != PERF_RECORD_SAMPLE) {
> >> +                     perf_evlist__mmap_write_tail(evlist, 0);
> >>                       continue;
> >> +             }
> >>
> >>               err = perf_evlist__parse_sample(evlist, event, &sample);
> >>               if (err < 0) {
> >> +                     perf_evlist__mmap_write_tail(evlist, 0);
> >>                       pr_debug("Error during parse sample\n");
> >>                       goto out_unmap_evlist;
> >>               }
> >>
> >> +             perf_evlist__mmap_write_tail(evlist, 0);
> >> +
> >>               total_periods += sample.period;
> >>               nr_samples++;
> >>       }
> >> diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
> >> index 28fe589..3ef1dbd 100644
> >> --- a/tools/perf/tests/task-exit.c
> >> +++ b/tools/perf/tests/task-exit.c
> >> @@ -96,9 +96,12 @@ int test__task_exit(void)
> >>
> >>  retry:
> >>       while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
> >> -             if (event->header.type != PERF_RECORD_EXIT)
> >> +             if (event->header.type != PERF_RECORD_EXIT) {
> >> +                     perf_evlist__mmap_write_tail(evlist, 0);
> >>                       continue;
> >> +             }
> >>
> >> +             perf_evlist__mmap_write_tail(evlist, 0);
> >>               nr_exit++;
> >>       }
> >>
> >> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> >> index f9f77be..accb9b7 100644
> >> --- a/tools/perf/util/evlist.c
> >> +++ b/tools/perf/util/evlist.c
> >> @@ -545,12 +545,21 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
> >>
> >>       md->prev = old;
> >>
> >> -     if (!evlist->overwrite)
> >> -             perf_mmap__write_tail(md, old);
> >>
> >>       return event;
> >>  }
> >>
> >> +void perf_evlist__mmap_write_tail(struct perf_evlist *evlist, int idx)
> >> +{
> >> +     struct perf_mmap *md = &evlist->mmap[idx];
> >> +     unsigned int old = md->prev;
> >> +
> >> +     if (!evlist->overwrite)
> >> +             perf_mmap__write_tail(md, old);
> >> +
> >> +     return;
> >> +}
> >> +
> >>  static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
> >>  {
> >>       if (evlist->mmap[idx].base != NULL) {
> >> diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
> >> index 880d713..a973e36 100644
> >> --- a/tools/perf/util/evlist.h
> >> +++ b/tools/perf/util/evlist.h
> >> @@ -89,6 +89,8 @@ struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
> >>
> >>  union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
> >>
> >> +void perf_evlist__mmap_write_tail(struct perf_evlist *evlist, int idx);
> >> +
> >>  int perf_evlist__open(struct perf_evlist *evlist);
> >>  void perf_evlist__close(struct perf_evlist *evlist);
> >>
> >> diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
> >> index 71b5412..5ed90d0 100644
> >> --- a/tools/perf/util/python.c
> >> +++ b/tools/perf/util/python.c
> >> @@ -822,10 +822,15 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
> >>               PyObject *pyevent = pyrf_event__new(event);
> >>               struct pyrf_event *pevent = (struct pyrf_event *)pyevent;
> >>
> >> -             if (pyevent == NULL)
> >> +             if (pyevent == NULL) {
> >> +                     perf_evlist__mmap_write_tail(evlist, cpu);
> >>                       return PyErr_NoMemory();
> >> +             }
> >>
> >>               err = perf_evlist__parse_sample(evlist, event, &pevent->sample);
> >> +
> >> +             perf_evlist__mmap_write_tail(evlist, cpu);
> >> +
> >>               if (err)
> >>                       return PyErr_Format(PyExc_OSError,
> >>                                           "perf: can't parse sample, err=%d", err);
> >> --
> >> 1.7.10.4
