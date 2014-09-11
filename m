Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaIKNBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:01:33 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58675 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaIKNB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:01:29 -0400
Date: Thu, 11 Sep 2014 05:59:45 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Peter Zijlstra <peterz@infradead.org>
cc: Hugh Dickins <hughd@google.com>, Chintan Pandya <cpandya@codeaurora.org>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] ksm: provide support to use deferrable timers
 for scanner thread
In-Reply-To: <20140910082726.GO6758@twins.programming.kicks-ass.net>
Message-ID: <alpine.LSU.2.11.1409110527200.2465@eggly.anvils>
References: <1408536628-29379-1-git-send-email-cpandya@codeaurora.org> <1408536628-29379-2-git-send-email-cpandya@codeaurora.org> <alpine.LSU.2.11.1408272258050.10518@eggly.anvils> <20140903095815.GK4783@worktop.ger.corp.intel.com>
 <alpine.LSU.2.11.1409080023100.1610@eggly.anvils> <20140908093949.GZ6758@twins.programming.kicks-ass.net> <alpine.LSU.2.11.1409091225310.8432@eggly.anvils> <20140910082726.GO6758@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Peter Zijlstra wrote:
> 
> Does it make sense to drive both KSM and khugepage the same way we drive
> the numa scanning? It has the benefit of getting rid of these threads,
> which pushes the work into the right accountable context (the task its
> doing the scanning for) and makes the scanning frequency depend on the
> actual task activity.

I expect it would be possible: but more work than I'd ever find time
to complete myself, with uncertain benefit.

khugepaged would probably be easier to convert, since it is dealing
with independent mms anyway.  Whereas ksmd is establishing sharing
between unrelated mms, so cannot deal with single mms in isolation.

But what's done by a single daemon today, could be passed from task
to task under mutex instead; with probably very different handling
of KSM's "unstable" tree (at present the old one is forgotten at the
start of each cycle, and the new one rebuilt from scratch: I expect
that would have to change, to removing rb entries one by one).

How well it would work out, I'm not confident to say.  And I think
we shall need an answer to the power question sooner than we can
turn the design of KSM on its head.  Vendors will go with what works
for them, never mind what our priniciples dictate.

Your suggestion of following the NUMA scanning did make me wonder
if I could use task_work: if there were already a re-arming task_work,
I could probably use that, and escape your gaze :)  But I don't think
it exists at present, and I don't think it's an extension that would
be welcomed, and I don't think it would present an efficient solution.

The most satisfying solution aesthetically, would be for KSM to write
protect the VM_MERGEABLE areas at some stage (when they "approach
stability", whatever I mean by that), and let itself be woken by the
faults (and if there are no write faults on any of the areas, then
there is no need for it to be awoken).

But I think that all those new faults would pose a very significant
regression in performance.

I don't have a good idea of where else to hook in at present.

Hugh
