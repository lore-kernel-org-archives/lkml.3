Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab3IJT7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:59:05 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:34738 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3IJT7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:59:03 -0400
Date: Tue, 10 Sep 2013 16:58:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130910195847.GA1866@ghostprotocols.net>
References: <1377079825-19057-3-git-send-email-eranian@google.com>
 <20130909192810.GA3825@infradead.org>
 <20130909194844.GB28428@ghostprotocols.net>
 <20130910130002.GD28428@ghostprotocols.net>
 <CABPqkBRgj71D8FkWtR-4K8g5ErWMt8YsV7FcmxQ3Uouj640Z0A@mail.gmail.com>
 <20130910131728.GE28428@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20130910131728.GE28428@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Tue, Sep 10, 2013 at 10:17:28AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Sep 10, 2013 at 03:05:03PM +0200, Stephane Eranian escreveu:
> > On Tue, Sep 10, 2013 at 3:00 PM, Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> > > Em Mon, Sep 09, 2013 at 04:48:44PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > +++ b/kernel/events/core.c
> > > @@ -5039,6 +5039,7 @@ static void perf_event_mmap_output(struct perf_event *event,
> > >                 mmap_event->event_id.header.size += sizeof(mmap_event->maj);
> > >                 mmap_event->event_id.header.size += sizeof(mmap_event->min);
> > >                 mmap_event->event_id.header.size += sizeof(mmap_event->ino);
> > > +               mmap_event->event_id.header.size += sizeof(mmap_event->ino_generation);
> > >         }
> > >         perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);

> > Arg, yes, this is missing.
> > Do you want to submit the patch?

> I will, in some jiffies, just rebooting with the patched kernel to
> re-run tperf test.
 
> > Thanks for tracking it down.
 
> np :-)

More fallout, this time the resulting tools fail to run on older
kernels, i.e. any kernel that doesn't have perf_event_attr.mmap2,
doesn't matter the event type:

[acme@zoo linux]$ perf record usleep 1
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (cycles).  
/bin/dmesg may provide additional information.
No CONFIG_PERF_EVENTS=y kernel support configured?

usleep: Terminated
[acme@zoo linux]$ perf record -e cpu-clock usleep 1
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (cpu-clock).  
/bin/dmesg may provide additional information.
No CONFIG_PERF_EVENTS=y kernel support configured?

usleep: Terminated
[acme@zoo linux]$

That is because kernel/events/core.c  perf_copy_attr() has this test:

        if (attr->__reserved_1)
                return -EINVAL;

So we must have the handling we have for other things that were added
in the past, like .sample_id_all, .exclude_guest, etc, like is done in
the attached patch, please ack.

Ingo, since you haven't merged my latest perf/urgent pull req, do you
want me to fold this into the patch that makes the tooling side use
PERF_RECORD_MMAP2?

- Arnaldo

--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="perf_mmap2_fallback.patch"

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ff2098b..404599d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -27,6 +27,7 @@
 static struct {
 	bool sample_id_all;
 	bool exclude_guest;
+	bool mmap2;
 } perf_missing_features;
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
@@ -677,7 +678,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
 
 	attr->mmap  = track;
-	attr->mmap2 = track;
+	attr->mmap2 = track && !perf_missing_features.mmap2;
 	attr->comm  = track;
 
 	/*
@@ -1017,6 +1018,8 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	}
 
 fallback_missing_features:
+	if (perf_missing_features.mmap2)
+		evsel->attr.mmap2 = 0;
 	if (perf_missing_features.exclude_guest)
 		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
 retry_sample_id:
@@ -1081,8 +1084,11 @@ try_fallback:
 	if (err != -EINVAL || cpu > 0 || thread > 0)
 		goto out_close;
 
-	if (!perf_missing_features.exclude_guest &&
-	    (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
+	if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
+		perf_missing_features.mmap2 = true;
+		goto fallback_missing_features;
+	} else if (!perf_missing_features.exclude_guest &&
+		   (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
 		perf_missing_features.exclude_guest = true;
 		goto fallback_missing_features;
 	} else if (!perf_missing_features.sample_id_all) {

--AhhlLboLdkugWU4S--
