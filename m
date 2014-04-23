Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbaDWDgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 23:36:50 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34451 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaDWDgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 23:36:48 -0400
Date: Tue, 22 Apr 2014 23:40:07 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [perf] yet another 32/64-bit range check failure
Message-ID: <alpine.DEB.2.10.1404222329590.28273@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


More fun found by the perf_fuzzer...

In kernel/events/core.c 
SYSCALL_DEFINE5(perf_event_open,

We check if flags is valid like this:

        /* for future expandability... */
        if (flags & ~PERF_FLAG_ALL)
                return -EINVAL;

but flags is a 64-bit value but ~PERF_FLAG_ALL is 32-bit.

This means values like 0x800000000000ULL are treated as valid even though 
they aren't.

This is allowing events to be allocated memory but not being freed somehow
before returning EINVAL (a memory leak).
At least it looks like this is happening in the huge traces I have trying 
to track down the perf_fuzzer memory corruption bug.

I'd send a patch to fix the above, but it's late and I can't figure out 
where exactly to stick ULL to get PERF_FLAG_ALL to be upgraded to 64-bit.

Vince
