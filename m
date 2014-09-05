Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaIEPlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:41:46 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:60410 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaIEPlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:41:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140905151640.GN19379@twins.programming.kicks-ass.net>
References: <20140901181808.GA6427@leverpostej>
	<20140901190534.GC5806@worktop.ger.corp.intel.com>
	<20140902185807.GA7434@leverpostej>
	<20140903115013.GA3127@leverpostej>
	<20140904104402.GS4783@worktop.ger.corp.intel.com>
	<20140904110740.GB32228@leverpostej>
	<20140905151640.GN19379@twins.programming.kicks-ass.net>
Date: Fri, 5 Sep 2014 08:41:43 -0700
X-Google-Sender-Auth: w5unZhTAYw_pdyxnP8FBakkaOjI
Message-ID: <CA+55aFwhKyjNHuSThuPOejq1uLTXoqHwAtG8cfcx-Sqp83RKSg@mail.gmail.com>
Subject: Re: Possible race between CPU hotplug and perf_pmu_migrate_context
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Zheng <zheng.z.yan@intel.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 8:16 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> How horrible is the below patch (performance wise). It does pretty much
> the same thing except that percpu_rw_semaphore is a lot saner, its
> read side performance should be minimal in the absence of writes.

Ugh. Why do any locking at all (whether a new 'perf_rwsem' or using
'get_online_cpus()').

Wouldn't it be much nicer to just do what memory management routines
are *supposed* to do, and get a reference count to the context while
having a pointer to it?

IOW, why doesn't put_event() just have a

   get_ctx(ctx);
   ..
   put_ctx(ctx);

around its use of the context pointer? So if the context ends up being
migrated during this time, it doesn't get freed.

However, the more fundamental question is "what protects accesses to
'events->ctx'". Why is "put_event()" so special that *it* gets locking
for the reading of "event->ctx", but none of the other cases of
reading the ctx pointer gets it or needs it?

I'm getting the feeling that this race is bigger than just put_event().

            Linus
