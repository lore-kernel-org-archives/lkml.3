Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648Ab3GaRoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:44:07 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:54069 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab3GaRoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:44:04 -0400
Date: Wed, 31 Jul 2013 14:43:55 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/9] perf tools: add test for reading object code
Message-ID: <20130731174355.GI3614@ghostprotocols.net>
References: <1374760890-30558-1-git-send-email-adrian.hunter@intel.com>
 <1374760890-30558-2-git-send-email-adrian.hunter@intel.com>
 <874nbd3mob.fsf@sejong.aot.lge.com>
 <51F82BF1.7060401@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F82BF1.7060401@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 31, 2013 at 12:11:13AM +0300, Adrian Hunter escreveu:
> On 29/07/2013 9:28 a.m., Namhyung Kim wrote:
> >>+
> >>+static int do_test_code_reading(void)
> >>+{
> >>+	struct machines machines;
> >>+	struct machine *machine;
> >>+	struct thread *thread;
> >>+	struct perf_record_opts opts = {
> >>+		.mmap_pages	     = UINT_MAX,
> >>+		.user_freq	     = UINT_MAX,
> >>+		.user_interval	     = ULLONG_MAX,
> >>+		.freq		     = 40000,
> >
> >Is it intended to use the freq of 40000 instead of 4000 (default)?
> 
> Yes.  The "workload" is small so a higher sampling rate is preferable.

But preferably one that is less than:

[root@zoo ~]# cat /proc/sys/kernel/perf_event_max_sample_rate
25000
[root@zoo ~]#

That is the reason why this test is failing on this Ivy Bridge notebook:

[root@zoo ~]# dmesg | grep perf_event_max_sample_rate
[ 4068.969761] perf samples too long (2552 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[ 4069.842176] perf samples too long (5039 > 5000), lowering kernel.perf_event_max_sample_rate to 25000
[root@zoo ~]# 

Look at kernel/events/core.c.

So keeping it at 4k may not be a bad idea, or at least have code that reads
/proc/sys/kernel/perf_event_max_sample_rate if using the highest freq is
desired.

- Arnaldo
