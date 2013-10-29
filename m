Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3J2IX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:23:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3J2IXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:23:54 -0400
Date: Tue, 29 Oct 2013 01:22:33 -0700
From: tip-bot for Zhouyi Zhou <tipbot@zytor.com>
Message-ID: <tip-8e50d384cc1d5afd2989cf0f7093756ed7164eb2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, yizhouzhou@ict.ac.cn, dsahern@gmail.com,
        tglx@linutronix.de, zhouzhouyi@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, yizhouzhou@ict.ac.cn, dsahern@gmail.com,
        tglx@linutronix.de, zhouzhouyi@gmail.com
In-Reply-To: <1382600613-32177-1-git-send-email-zhouzhouyi@gmail.com>
References: <1382600613-32177-1-git-send-email-zhouzhouyi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fixup mmap event consumption
Git-Commit-ID: 8e50d384cc1d5afd2989cf0f7093756ed7164eb2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 01:22:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e50d384cc1d5afd2989cf0f7093756ed7164eb2
Gitweb:     http://git.kernel.org/tip/8e50d384cc1d5afd2989cf0f7093756ed7164eb2
Author:     Zhouyi Zhou <zhouzhouyi@gmail.com>
AuthorDate: Thu, 24 Oct 2013 15:43:33 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Oct 2013 16:06:00 -0300

perf tools: Fixup mmap event consumption

The tail position of the event buffer should only be modified after
actually use that event.

If not the event buffer could be invalid before use, and segment fault
occurs when invoking perf top -G.

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Cc: David Ahern <dsahern@gmail.com>
Cc: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Link: http://lkml.kernel.org/r/1382600613-32177-1-git-send-email-zhouzhouyi@gmail.com
[ Simplified the logic using exit gotos and renamed write_tail method to mmap_consume ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c                  |  7 +++++++
 tools/perf/builtin-top.c                  | 10 ++++++----
 tools/perf/builtin-trace.c                |  8 +++++---
 tools/perf/tests/code-reading.c           |  1 +
 tools/perf/tests/keep-tracking.c          |  1 +
 tools/perf/tests/mmap-basic.c             |  1 +
 tools/perf/tests/open-syscall-tp-fields.c |  4 +++-
 tools/perf/tests/perf-record.c            |  2 ++
 tools/perf/tests/perf-time-to-tsc.c       |  4 +++-
 tools/perf/tests/sw-clock.c               |  4 +++-
 tools/perf/tests/task-exit.c              |  6 +++---
 tools/perf/util/evlist.c                  | 13 ++++++++++---
 tools/perf/util/evlist.h                  |  2 ++
 tools/perf/util/python.c                  |  2 ++
 14 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 935d522..fbc2888 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -888,11 +888,18 @@ static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
 	while ((event = perf_evlist__mmap_read(kvm->evlist, idx)) != NULL) {
 		err = perf_evlist__parse_sample(kvm->evlist, event, &sample);
 		if (err) {
+			perf_evlist__mmap_consume(kvm->evlist, idx);
 			pr_err("Failed to parse sample\n");
 			return -1;
 		}
 
 		err = perf_session_queue_event(kvm->session, event, &sample, 0);
+		/*
+		 * FIXME: Here we can't consume the event, as perf_session_queue_event will
+		 *        point to it, and it'll get possibly overwritten by the kernel.
+		 */
+		perf_evlist__mmap_consume(kvm->evlist, idx);
+
 		if (err) {
 			pr_err("Failed to enqueue sample: %d\n", err);
 			return -1;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0df298a..5a11f13 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -810,7 +810,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 		ret = perf_evlist__parse_sample(top->evlist, event, &sample);
 		if (ret) {
 			pr_err("Can't parse sample, err = %d\n", ret);
-			continue;
+			goto next_event;
 		}
 
 		evsel = perf_evlist__id2evsel(session->evlist, sample.id);
@@ -825,13 +825,13 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 		case PERF_RECORD_MISC_USER:
 			++top->us_samples;
 			if (top->hide_user_symbols)
-				continue;
+				goto next_event;
 			machine = &session->machines.host;
 			break;
 		case PERF_RECORD_MISC_KERNEL:
 			++top->kernel_samples;
 			if (top->hide_kernel_symbols)
-				continue;
+				goto next_event;
 			machine = &session->machines.host;
 			break;
 		case PERF_RECORD_MISC_GUEST_KERNEL:
@@ -847,7 +847,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			 */
 			/* Fall thru */
 		default:
-			continue;
+			goto next_event;
 		}
 
 
@@ -859,6 +859,8 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			machine__process_event(machine, event);
 		} else
 			++session->stats.nr_unknown_events;
+next_event:
+		perf_evlist__mmap_consume(top->evlist, idx);
 	}
 }
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 71aa3e3..99c8d9a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -987,7 +987,7 @@ again:
 			err = perf_evlist__parse_sample(evlist, event, &sample);
 			if (err) {
 				fprintf(trace->output, "Can't parse sample, err = %d, skipping...\n", err);
-				continue;
+				goto next_event;
 			}
 
 			if (trace->base_time == 0)
@@ -1001,18 +1001,20 @@ again:
 			evsel = perf_evlist__id2evsel(evlist, sample.id);
 			if (evsel == NULL) {
 				fprintf(trace->output, "Unknown tp ID %" PRIu64 ", skipping...\n", sample.id);
-				continue;
+				goto next_event;
 			}
 
 			if (sample.raw_data == NULL) {
 				fprintf(trace->output, "%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
 				       perf_evsel__name(evsel), sample.tid,
 				       sample.cpu, sample.raw_size);
-				continue;
+				goto next_event;
 			}
 
 			handler = evsel->handler.func;
 			handler(trace, evsel, &sample);
+next_event:
+			perf_evlist__mmap_consume(evlist, i);
 
 			if (done)
 				goto out_unmap_evlist;
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 6fb781d..e3fedfa 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -290,6 +290,7 @@ static int process_events(struct machine *machine, struct perf_evlist *evlist,
 	for (i = 0; i < evlist->nr_mmaps; i++) {
 		while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
 			ret = process_event(machine, evlist, event, state);
+			perf_evlist__mmap_consume(evlist, i);
 			if (ret < 0)
 				return ret;
 		}
diff --git a/tools/perf/tests/keep-tracking.c b/tools/perf/tests/keep-tracking.c
index d444ea2..376c356 100644
--- a/tools/perf/tests/keep-tracking.c
+++ b/tools/perf/tests/keep-tracking.c
@@ -36,6 +36,7 @@ static int find_comm(struct perf_evlist *evlist, const char *comm)
 			    (pid_t)event->comm.tid == getpid() &&
 			    strcmp(event->comm.comm, comm) == 0)
 				found += 1;
+			perf_evlist__mmap_consume(evlist, i);
 		}
 	}
 	return found;
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index c4185b9..a7232c2 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -122,6 +122,7 @@ int test__basic_mmap(void)
 			goto out_munmap;
 		}
 		nr_events[evsel->idx]++;
+		perf_evlist__mmap_consume(evlist, 0);
 	}
 
 	err = 0;
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index fc5b9fc..524b221 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -77,8 +77,10 @@ int test__syscall_open_tp_fields(void)
 
 				++nr_events;
 
-				if (type != PERF_RECORD_SAMPLE)
+				if (type != PERF_RECORD_SAMPLE) {
+					perf_evlist__mmap_consume(evlist, i);
 					continue;
+				}
 
 				err = perf_evsel__parse_sample(evsel, event, &sample);
 				if (err) {
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index b8a7056..7923b06 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -263,6 +263,8 @@ int test__PERF_RECORD(void)
 						 type);
 					++errs;
 				}
+
+				perf_evlist__mmap_consume(evlist, i);
 			}
 		}
 
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 0ab61b1..4ca1b93 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -122,7 +122,7 @@ int test__perf_time_to_tsc(void)
 			if (event->header.type != PERF_RECORD_COMM ||
 			    (pid_t)event->comm.pid != getpid() ||
 			    (pid_t)event->comm.tid != getpid())
-				continue;
+				goto next_event;
 
 			if (strcmp(event->comm.comm, comm1) == 0) {
 				CHECK__(perf_evsel__parse_sample(evsel, event,
@@ -134,6 +134,8 @@ int test__perf_time_to_tsc(void)
 								 &sample));
 				comm2_time = sample.time;
 			}
+next_event:
+			perf_evlist__mmap_consume(evlist, i);
 		}
 	}
 
diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index 2e41e2d..6e2b44e 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -78,7 +78,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 		struct perf_sample sample;
 
 		if (event->header.type != PERF_RECORD_SAMPLE)
-			continue;
+			goto next_event;
 
 		err = perf_evlist__parse_sample(evlist, event, &sample);
 		if (err < 0) {
@@ -88,6 +88,8 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 
 		total_periods += sample.period;
 		nr_samples++;
+next_event:
+		perf_evlist__mmap_consume(evlist, 0);
 	}
 
 	if ((u64) nr_samples == total_periods) {
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index 28fe589..a3e6487 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -96,10 +96,10 @@ int test__task_exit(void)
 
 retry:
 	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
-		if (event->header.type != PERF_RECORD_EXIT)
-			continue;
+		if (event->header.type == PERF_RECORD_EXIT)
+			nr_exit++;
 
-		nr_exit++;
+		perf_evlist__mmap_consume(evlist, 0);
 	}
 
 	if (!exited || !nr_exit) {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f9f77be..e584cd3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -545,12 +545,19 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 
 	md->prev = old;
 
-	if (!evlist->overwrite)
-		perf_mmap__write_tail(md, old);
-
 	return event;
 }
 
+void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx)
+{
+	if (!evlist->overwrite) {
+		struct perf_mmap *md = &evlist->mmap[idx];
+		unsigned int old = md->prev;
+
+		perf_mmap__write_tail(md, old);
+	}
+}
+
 static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
 {
 	if (evlist->mmap[idx].base != NULL) {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 880d713..206d093 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -89,6 +89,8 @@ struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
+void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx);
+
 int perf_evlist__open(struct perf_evlist *evlist);
 void perf_evlist__close(struct perf_evlist *evlist);
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 71b5412..2ac4bc9 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -822,6 +822,8 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		PyObject *pyevent = pyrf_event__new(event);
 		struct pyrf_event *pevent = (struct pyrf_event *)pyevent;
 
+		perf_evlist__mmap_consume(evlist, cpu);
+
 		if (pyevent == NULL)
 			return PyErr_NoMemory();
 
