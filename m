Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3IJNAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:00:12 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:50744 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab3IJNAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:00:09 -0400
Date: Tue, 10 Sep 2013 10:00:02 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, namhyung.kim@lge.com,
        dsahern@gmail.com
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130910130002.GD28428@ghostprotocols.net>
References: <1377079825-19057-3-git-send-email-eranian@google.com>
 <20130909192810.GA3825@infradead.org>
 <20130909194844.GB28428@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909194844.GB28428@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Em Mon, Sep 09, 2013 at 04:48:44PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Sep 09, 2013 at 04:47:45PM -0300, Arnaldo Carvalho de Melo escreveu:
> > I noticed the kernel part is in, and I'm going to use MMAP2 on that new
> > tool, so tried merging it, but:
> > 
> > I fixed it up wrt another patch that makes machine__find_thread receive pid/tid
> > but then 'perf test' complains about it, see below, trying to fix...
> 
> Following patch makes it progress a bit, still checking why it is not
> enough...

Without your patch:

[root@sandy ~]# perf test -v 7
 7: Validate PERF_RECORD_* events & perf_sample fields     :
--- start ---
61118374953766 0 PERF_RECORD_SAMPLE
61118374958840 0 PERF_RECORD_SAMPLE
61118374961420 0 PERF_RECORD_SAMPLE
61118374964293 0 PERF_RECORD_SAMPLE
61118376117716 0 PERF_RECORD_COMM: sleep:5096
61118376153724 0 PERF_RECORD_MMAP 5096/5096: [0x400000(0x7000) @ 0]: /usr/bin/sleep
61118376190304 0 PERF_RECORD_MMAP 5096/5096: [0x3b7e000000(0x223000) @ 0]: /usr/lib64/ld-2.16.so
61118376229562 0 PERF_RECORD_MMAP 5096/5096: [0x7fff2f9ff000(0x1000) @ 0x7fff2f9ff000]: [vdso]
61118376526654 0 PERF_RECORD_MMAP 5096/5096: [0x3b7e400000(0x3b8000) @ 0]: /usr/lib64/libc-2.16.so
61119377689687 0 PERF_RECORD_EXIT(5096:5096):(5096:5096)
---- end ----
Validate PERF_RECORD_* events & perf_sample fields: Ok
[root@sandy ~]#

So the tstamp grows monotonically, then, after your patch + the patch at the
end of this message:

[root@sandy ~]# perf test -v 7
 7: Validate PERF_RECORD_* events & perf_sample fields     :
--- start ---
61315294449606 0 PERF_RECORD_SAMPLE
61315294453161 0 PERF_RECORD_SAMPLE
61315294454441 0 PERF_RECORD_SAMPLE
61315294455709 0 PERF_RECORD_SAMPLE
61315295600899 0 PERF_RECORD_COMM: sleep:6500
27917287430500 342521613 PERF_RECORD_MMAP2 6500/6500: [0x400000(0x7000) @ 0 00:1d 311442 9016]: /usr/bin/sleep
MMAP2 going backwards in time, prev=61315295600899, curr=27917287430500
MMAP2 with unexpected cpu, expected 0, got 342521613
MMAP2 with unexpected pid, expected 6500, got 1701606191
MMAP2 with unexpected tid, expected 6500, got 28773
27917287430500 342561333 PERF_RECORD_MMAP2 6500/6500: [0x3b7e000000(0x223000) @ 0 00:1d 309186 9016]: /usr/lib64/ld-2.16.so
MMAP2 with unexpected cpu, expected 0, got 342561333
MMAP2 with unexpected pid, expected 6500, got 1932408369
MMAP2 with unexpected tid, expected 6500, got 111
27917287430500 342600095 PERF_RECORD_MMAP2 6500/6500: [0x7fffbd7dc000(0x1000) @ 0x7fffbd7dc000 00:00 0 0]: [vdso]
MMAP2 with unexpected cpu, expected 0, got 342600095
MMAP2 with unexpected pid, expected 6500, got 1935963739
MMAP2 with unexpected tid, expected 6500, got 23919
27917287430500 342882834 PERF_RECORD_MMAP2 6500/6500: [0x3b7e400000(0x3b8000) @ 0 00:1d 309187 9016]: /usr/lib64/libc-2.16.so
MMAP2 with unexpected cpu, expected 0, got 342882834
MMAP2 with unexpected pid, expected 6500, got 909192754
MMAP2 with unexpected tid, expected 6500, got 7303982
61316297195411 0 PERF_RECORD_EXIT(6500:6500):(6500:6500)
---- end ----
Validate PERF_RECORD_* events & perf_sample fields: FAILED!
[root@sandy ~]#

So everything that is in perf_sample, i.e. in the variable area, selected via
sample_type, is invalid for PERF_RECORD_MMAP2.

This is on:

[root@sandy ~]# uname -a
Linux sandy.ghostprotocols.net.home 3.11.0+ #1 SMP Wed Sep 4 16:47:14 BRT 2013 x86_64 x86_64 x86_64 GNU/Linux
[root@sandy ~]#

Humm, looking at perf_event_mmap_output it seems this was missed, will rebuild
a kernel and retest...

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2207efc..dd236b6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5039,6 +5039,7 @@ static void perf_event_mmap_output(struct perf_event *event,
 		mmap_event->event_id.header.size += sizeof(mmap_event->maj);
 		mmap_event->event_id.header.size += sizeof(mmap_event->min);
 		mmap_event->event_id.header.size += sizeof(mmap_event->ino);
+		mmap_event->event_id.header.size += sizeof(mmap_event->ino_generation);
 	}
 
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
 
> - Arnaldo
> 
> diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
> index 72d8881..b8a7056 100644
> --- a/tools/perf/tests/perf-record.c
> +++ b/tools/perf/tests/perf-record.c
> @@ -50,7 +50,7 @@ int test__PERF_RECORD(void)
>  	struct perf_sample sample;
>  	const char *cmd = "sleep";
>  	const char *argv[] = { cmd, "1", NULL, };
> -	char *bname;
> +	char *bname, *mmap_filename;
>  	u64 prev_time = 0;
>  	bool found_cmd_mmap = false,
>  	     found_libc_mmap = false,
> @@ -212,6 +212,7 @@ int test__PERF_RECORD(void)
>  
>  				if ((type == PERF_RECORD_COMM ||
>  				     type == PERF_RECORD_MMAP ||
> +				     type == PERF_RECORD_MMAP2 ||
>  				     type == PERF_RECORD_FORK ||
>  				     type == PERF_RECORD_EXIT) &&
>  				     (pid_t)event->comm.pid != evlist->workload.pid) {
> @@ -220,7 +221,8 @@ int test__PERF_RECORD(void)
>  				}
>  
>  				if ((type == PERF_RECORD_COMM ||
> -				     type == PERF_RECORD_MMAP) &&
> +				     type == PERF_RECORD_MMAP ||
> +				     type == PERF_RECORD_MMAP2) &&
>  				     event->comm.pid != event->comm.tid) {
>  					pr_debug("%s with different pid/tid!\n", name);
>  					++errs;
> @@ -236,7 +238,12 @@ int test__PERF_RECORD(void)
>  				case PERF_RECORD_EXIT:
>  					goto found_exit;
>  				case PERF_RECORD_MMAP:
> -					bname = strrchr(event->mmap.filename, '/');
> +					mmap_filename = event->mmap.filename;
> +					goto check_bname;
> +				case PERF_RECORD_MMAP2:
> +					mmap_filename = event->mmap2.filename;
> +				check_bname:
> +					bname = strrchr(mmap_filename, '/');
>  					if (bname != NULL) {
>  						if (!found_cmd_mmap)
>  							found_cmd_mmap = !strcmp(bname + 1, cmd);
> @@ -245,7 +252,7 @@ int test__PERF_RECORD(void)
>  						if (!found_ld_mmap)
>  							found_ld_mmap = !strncmp(bname + 1, "ld", 2);
>  					} else if (!found_vdso_mmap)
> -						found_vdso_mmap = !strcmp(event->mmap.filename, "[vdso]");
> +						found_vdso_mmap = !strcmp(mmap_filename, "[vdso]");
>  					break;
>  
>  				case PERF_RECORD_SAMPLE:
