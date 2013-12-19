Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3LSLOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:14:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:17364 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab3LSLOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:14:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="427153903"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 04/71] itrace: Infrastructure for instruction flow tracing units
In-Reply-To: <20131219102625.GC30183@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com> <20131217161126.GL13532@twins.programming.kicks-ass.net> <8761qmthr6.fsf@ashishki-desk.ger.corp.intel.com> <20131218133439.GR21999@twins.programming.kicks-ass.net> <8738lqtg0v.fsf@ashishki-desk.ger.corp.intel.com> <20131218141125.GT21999@twins.programming.kicks-ass.net> <87zjnys0gj.fsf@ashishki-desk.ger.corp.intel.com> <20131218150900.GU21999@twins.programming.kicks-ass.net> <87wqj1s2d3.fsf@ashishki-desk.ger.corp.intel.com> <20131219102625.GC30183@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.15.2+182~gd0bd88f (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 19 Dec 2013 13:14:09 +0200
Message-ID: <87r499rt32.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, Dec 19, 2013 at 09:53:44AM +0200, Alexander Shishkin wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>> > The thing is; why can't you zero-copy whatever buffer the hardware
>> > writes into, into the normal buffer?
>> 
>> I'm not sure I understand. You mean, have the buffer split between perf
>> data and trace data?
>
> Yep, I don't see any reason why this wouldn't work.
>
> When the hardware thing sends an interrupt to notify us its buffer is
> 'full', stop the recorder, try to create a single record in the buffer
> that's big enough + 1 page, then swizzle the hardware pages and the
> buffer pages for that record, using the +1 page to page align the actual
> data. Then (re)start the hardware on the 'new' pages.

We configure the hardware thing to send an interrupt *before* the buffer
is full, keep the recorder running while userspace saves stuff to
perf.data file. Recording only stops if perf fails to read the trace
data out fast enough and the buffer fills up. So you'd have a complete
trace.

Also, we have what we call a "snapshot" mode, where we keep the hardware
thing running, writing data to a circular buffer till it's stopped, in
case we're only interested in the most recent trace data to see what it
is that takes too long to respond, etc. And while it is running, we're
getting new records in the perf stream all the time (mmaps, etc).

Put simple: perf data and trace data are two different separate types of
information that originate from two different sources, can exist and
make sense separately from one another and should not be mixed.

Regards,
--
Alex
