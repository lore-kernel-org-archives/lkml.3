Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbaDWKXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:23:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:58908 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264AbaDWKW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:22:58 -0400
Date: Wed, 23 Apr 2014 12:22:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [perf] yet another 32/64-bit range check failure
Message-ID: <20140423102254.GL11096@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404222329590.28273@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404222329590.28273@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 11:40:07PM -0400, Vince Weaver wrote:
> 
> More fun found by the perf_fuzzer...
> 
> In kernel/events/core.c 
> SYSCALL_DEFINE5(perf_event_open,
> 
> We check if flags is valid like this:
> 
>         /* for future expandability... */
>         if (flags & ~PERF_FLAG_ALL)
>                 return -EINVAL;
> 
> but flags is a 64-bit value but ~PERF_FLAG_ALL is 32-bit.
> 
> This means values like 0x800000000000ULL are treated as valid even though 
> they aren't.
> 
> This is allowing events to be allocated memory but not being freed somehow
> before returning EINVAL (a memory leak).
> At least it looks like this is happening in the huge traces I have trying 
> to track down the perf_fuzzer memory corruption bug.
> 
> I'd send a patch to fix the above, but it's late and I can't figure out 
> where exactly to stick ULL to get PERF_FLAG_ALL to be upgraded to 64-bit.
> 
> Vince

Something like so should do I suppose.

---
Subject: perf: Fix perf_event_open(.flags) test

Vince noticed that we test the (unsigned long) flags field against an
(unsigned int) constant. This would allow setting the high bits on 64bit
platforms and not get an error.

There is nothing that uses the high bits, so it should be entirely
harmless, but we don't want userspace to accidentally set them anyway,
so fix the constants.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/uapi/linux/perf_event.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 853bc1ccb395..e3fc8f09d110 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -722,10 +722,10 @@ enum perf_callchain_context {
 	PERF_CONTEXT_MAX		= (__u64)-4095,
 };
 
-#define PERF_FLAG_FD_NO_GROUP		(1U << 0)
-#define PERF_FLAG_FD_OUTPUT		(1U << 1)
-#define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
-#define PERF_FLAG_FD_CLOEXEC		(1U << 3) /* O_CLOEXEC */
+#define PERF_FLAG_FD_NO_GROUP		(1UL << 0)
+#define PERF_FLAG_FD_OUTPUT		(1UL << 1)
+#define PERF_FLAG_PID_CGROUP		(1UL << 2) /* pid=cgroup id, per-cpu mode only */
+#define PERF_FLAG_FD_CLOEXEC		(1UL << 3) /* O_CLOEXEC */
 
 union perf_mem_data_src {
 	__u64 val;
