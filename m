Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3F0SLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:11:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab3F0SLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:11:21 -0400
Message-ID: <51CC801C.5050600@redhat.com>
Date: Thu, 27 Jun 2013 14:10:36 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Matthew Wilcox <willy@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
References: <20130620201713.GV8211@linux.intel.com> <20130623100920.GA19021@gmail.com> <CA+55aFy+COdk5+ucwxtc1At=PAYTJxeUaUV6rP9XstHdNV0hbQ@mail.gmail.com>
In-Reply-To: <CA+55aFy+COdk5+ucwxtc1At=PAYTJxeUaUV6rP9XstHdNV0hbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 02:29 PM, Linus Torvalds wrote:

> You could try to do that either *in* the idle thread (which would take
> the context switch overhead - maybe negating some of the advantages),
> or alternatively hook into the scheduler idle logic before actually
> doing the switch.
>
> But anything that starts polling when there are other runnable
> processes to be done sounds really debatable. Even if it's "only" 5us
> or so. There's a lot of real work that could be done in 5us.

Having a hook into the idle code could be useful for
KVM, too.

In certain message passing workloads, we have seen
that the system throughput suffers greatly simply
by having the KVM thread's preempt notifiers save
CPU state when the guest goes idle, and re-load it
when the guest VCPU is activated again.

Avoiding the context switch overhead when nothing
else wants to run, but being immediately preempted
when something does, could be a big win.

Would it make sense to have some hook that says
"I *am* an idle thread right now", as opposed to
"context switch to the idle thread"?

That hook could even run the cpuidle code, and
switch to the real idle task (saving the current
task state), and put the CPU into a C-state, when
the expected sleep time is long...



