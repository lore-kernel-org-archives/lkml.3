Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3K0Nom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:44:42 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:50124 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3K0Nok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:44:40 -0500
Date: Wed, 27 Nov 2013 10:44:34 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Chia-I Wu <olvaffe@gmail.com>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf timechart: dynamically determine event data offset
Message-ID: <20131127134434.GA11498@ghostprotocols.net>
References: <1381128514-16279-1-git-send-email-olvaffe@gmail.com>
 <20131022103223.GA29489@stfomichev-desktop>
 <20131125182139.GD20168@ghostprotocols.net>
 <20131126110536.GC3388@stfomichev-desktop>
 <20131126121026.GD27323@ghostprotocols.net>
 <20131126134755.GD3388@stfomichev-desktop>
 <20131126135709.GB14838@ghostprotocols.net>
 <20131126145437.GE3388@stfomichev-desktop>
 <87mwkqqlfl.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwkqqlfl.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 27, 2013 at 05:49:02PM +0900, Namhyung Kim escreveu:
> On Tue, 26 Nov 2013 18:54:37 +0400, Stanislav Fomichev wrote:
> > Since b000c8065a92 "tracing: Remove the extra 4 bytes of padding in events"
> > removed padding bytes, perf timechart got out of sync with the kernel's
> > trace_entry structure.

> > We can't just align perf's trace_entry definition with the kernel because we
> > want timechart to continue working with old perf.data. Instead, we now
> > calculate event data offset dynamically using offset of first non-common
> > event field in the perf.data.
 
> [SNIP]
> > @@ -304,13 +322,11 @@ struct trace_entry {
> >  	unsigned char		flags;
> >  	unsigned char		preempt_count;
> >  	int			pid;
> > -	int			lock_depth;
> >  };
 
> I had no chance to look into the timechart code in detail, but this is
> not good.  The format of each trace event (so the struct trace_entry)
> was described in the format file under the event directory on debugfs.
> For cpu_frequency event, I get the following:
 
>   $ cat /sys/kernel/debug/tracing/events/power/cpu_frequency/format 
>   name: cpu_frequency
>   ID: 315
>   format:
> 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> 	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
> 	field:int common_pid;	offset:4;	size:4;	signed:1;
 
> 	field:u32 state;	offset:8;	size:4;	signed:0;
> 	field:u32 cpu_id;	offset:12;	size:4;	signed:0;
 
>   print fmt: "state=%lu cpu_id=%lu", (unsigned long)REC->state, (unsigned long)REC->cpu_id
 
> So it's not same as above struct trace_entry even with your change.

It is... Albeit working just with patches is good and dandy and I even
was discussing with Jiri how patches should be clean and small, you're
not seeing the whole picture, see what is at the line just before
"unsigned char flags":

struct trace_entry {
        unsigned short          type;
        unsigned char           flags;
        unsigned char           preempt_count;
        int                     pid;
        int                     lock_depth;
};

Looking with pahole to see the offsets on a 64-bit arch:

[acme@ssdandy linux]$ pahole -C trace_entry /tmp/build/perf/builtin-timechart.o 
struct trace_entry {
	short unsigned int         type;                 /*     0     2 */
	unsigned char              flags;                /*     2     1 */
	unsigned char              preempt_count;        /*     3     1 */
	int                        pid;                  /*     4     4 */
	int                        lock_depth;           /*     8     4 */

	/* size: 12, cachelines: 1, members: 5 */
	/* last cacheline: 12 bytes */
};
[acme@ssdandy linux]$
[acme@ssdandy linux]$ uname -a
Linux ssdandy 3.12.0-rc6+ #2 SMP Mon Oct 21 11:19:07 BRT 2013 x86_64 x86_64 x86_64 GNU/Linux

And now on a 32-bit arch:

acme@linux-goap:~> pahole -C trace_entry /tmp/build/perf/builtin-timechart.o 
struct trace_entry {
	short unsigned int         type;                 /*     0     2 */
	unsigned char              flags;                /*     2     1 */
	unsigned char              preempt_count;        /*     3     1 */
	int                        pid;                  /*     4     4 */
	int                        lock_depth;           /*     8     4 */

	/* size: 12, cachelines: 1, members: 5 */
	/* last cacheline: 12 bytes */
};
acme@linux-goap:~> uname -a
Linux linux-goap 3.7.10-1.16-desktop #1 SMP PREEMPT Fri May 31 20:21:23 UTC 2013 (97c14ba) i686 i686 i386 GNU/Linux
acme@linux-goap:~>

Same signature, 32-bit, 64-bit userland, so whoever wrote timechart, Arjan, I
think, made no mistakes at using the kernel exported interface, choosing the
most efficient way to extract the data, casting to a struct.

Yeah, using the interface that searches for a field name to get the offset and
then add it to a pointer to then cast to the type will allow maximum flexibility,
but is not really efficient.

Doing that for something that is not performance critical (probably) as
timechart probably is not a problem, but so is not a problem using the patch
that does the cast after finding the offset of the first non-common field.

Having said that, I'll take the latest patch, using perf_evsel__intval et all,
if Namhyung sees no further problems with it.

BTW: in 'perf trace' I recently did some work to cache the offsets on a per evsel
private area, so that the string lookup is not done anymore in the raw_syscalls
tracepoint processing.

- Arnaldo
