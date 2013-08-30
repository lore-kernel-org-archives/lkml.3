Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3H3SFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:05:09 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:61634 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab3H3SFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:05:07 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <alpine.DEB.2.10.1308301334410.19094@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308301334410.19094@vincent-weaver-1.um.maine.edu>
Date: Fri, 30 Aug 2013 20:05:05 +0200
Message-ID: <CAMsRxfLSnNi_vESxYHM5w0tQrOtOPsEy3ythoViRMBbEi+XHGw@mail.gmail.com>
Subject: Re: perf_event: rdpmc self-monitoring overhead issue
From: Stephane Eranian <eranian@googlemail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 7:55 PM, Vince Weaver <vincent.weaver@maine.edu> wrote:
> Hello,
>
> I've finally found time to track down why perf_event/rdpmc self-monitoring
> overhead was so bad.
>
> To summarize, a test which does:
>
>    perf_event_open()
>    ioctl(PERF_EVENT_IOC_ENABLE)
>    read() /* either via syscall or  the rdpmc code listed in
>              include/uapi/linux/perf_event.h */
>    ioctl(PERF_EVENT_IOC_DISABLE)
>
> is done, and the number of cycles for each routine is taken using
> rdtsc().
>
> On a Core2 Processor the results look something like this for read:
>
>                               | read time for 1 event
>                               | median of 1024 runs
>                               |     (cycles)
>  -----------------------------|-------------------------
>    2.6.32-perfctr (rdpmc)     |       133
>    2.6.30-perfmon2            |      1264
>    3.10                       |      1482
>    3.10 (rdpmc)               |      3062
>
> As you can see, using the userspace-only rdpmc code is twice as slow as
> just using the read() syscall.
>
>
> I've tracked down the cause of this, and apparently it's due to
> the first access to the event's struct perf_event_mmap_page.  If
> outside of the read timing code I do an unrelated read of the mmap() page
> to fault it in, then the result is much more believable:
>
>   3.10 (rdpmc)                 |      123
>
You mean that the high cost in your first example comes from the fact
that you are averaging over all the iterations and not n-1 (where 1 is
the first). I don't see a flag in mmap() to fault it in immediately. But
why not document, that programs should touch the page once before
starting any timing measurements.

> So the question is, why do I have to explicitly in advance fault the
> page in?  Is there a way to force this to happen automatically?
>
> The perfctr code as far as I can tell doesn't touch its mmap page in
> advance.
> It uses vm_insert_page() to insert the page rather than the
> rb tree stuff that perf_event uses.
>
> I know part of this overhead is due to the construction of my benchmark
> and in theory would be mitigated if you were doing a large number
> of measurements in a program, but at the same time this is also a common
> pattern when self-monitoring: putting calipers around one chunk of code
> and taking one measurement (often in a timing-critical area where
> overhead matters).
>
> Vince
