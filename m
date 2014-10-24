Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaJXHo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:44:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:7739 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaJXHo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:44:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="405262829"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 18/20] perf: Allocate ring buffers for inherited per-task kernel events
In-Reply-To: <20141023123855.GC12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com> <1413207948-28202-19-git-send-email-alexander.shishkin@linux.intel.com> <20141023123855.GC12706@worktop.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 24 Oct 2014 10:44:54 +0300
Message-ID: <87egtx3o95.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, Oct 13, 2014 at 04:45:46PM +0300, Alexander Shishkin wrote:
>> Normally, per-task events can't be inherited parents' ring buffers to
>> avoid multiple events contending for the same buffer. And since buffer
>> allocation is typically done by the userspace consumer, there is no
>> practical interface to allocate new buffers for inherited counters.
>> 
>> However, for kernel users we can allocate new buffers for inherited
>> events as soon as they are created (and also reap them on event
>> destruction). This pattern has a number of use cases, such as event
>> sample annotation and process core dump annotation.
>> 
>> When a new event is inherited from a per-task kernel event that has a
>> ring buffer, allocate a new buffer for this event so that data from the
>> child task is collected and can later be retrieved for sample annotation
>> or core dump inclusion. This ring buffer is released when the event is
>> freed, for example, when the child task exits.
>> 
>
> This causes a pinned memory explosion, not at all nice that.
>
> I think I see why and all, but it would be ever so good to not have to
> allocate so much memory.

Are there any controls we could use to limit such memory usage?
Theoretically, the buffers that we'd allocate for this are way smaller
than, for example, what we use if we try to capture a complete trace,
since we'd only be interested in the most recent trace data. We already
have RLIMIT_NPROC, which implicitly limits the number of these buffers,
for example. Or maybe we can introduce a new rlimit/sysctl/whatnot that
would limit the maximum amount of such memory per-cpu/system/user. What
do you think?

Per-cpu buffers with inheritance would solve this problem, but raises
other issues: we'd need sched_switch again to tell the traces apart and
since those buffers run in overwrite mode, a cpu hog task can
potentially overwrite any useful trace data.

Regards,
--
Alex
