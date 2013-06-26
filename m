Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3FZQsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:48:22 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:61725 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab3FZQsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130626115420.GG28407@twins.programming.kicks-ass.net>
References: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
	<20130626115420.GG28407@twins.programming.kicks-ass.net>
Date: Wed, 26 Jun 2013 18:48:20 +0200
Message-ID: <CABPqkBQxEiNWN2g3_oTuMK77SPJ5VOBGJvkeN9AoZb=5JRsJJA@mail.gmail.com>
Subject: Re: [PATCH 0/7] perf, x86: Haswell LBR call stack support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 1:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jun 25, 2013 at 04:47:12PM +0800, Yan, Zheng wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> Haswell has a new feature that utilizes the existing Last Branch Record
>> facility to record call chains. When the feature is enabled, function
>> call will be collected as normal, but as return instructions are executed
>> the last captured branch record is popped from the on-chip LBR registers.
>> The LBR call stack facility can help perf to get call chains of progam
>> without frame pointer. When perf tool requests PERF_SAMPLE_CALLCHAIN +
>> PERF_SAMPLE_BRANCH_USER, this feature is dynamically enabled by default.
>> This feature can be disabled/enabled through an attribute file in the cpu
>> pmu sysfs directory.
>>
>> The LBR call stack has following known limitations
>>  1. Zero length calls are not filtered out by hardware
>>  2. Exception handing such as setjmp/longjmp will have calls/returns not
>>     match
>>  3. Pushing different return address onto the stack will have calls/returns
>>     not match
>>
>
> You fail to mention what happens when the callstack is deeper than the
> LBR is big -- a rather common issue I'd think.
>
LBR is statistical callstack. By nature, it cannot capture the entire chain.

> From what I gather if you push when full, the TOS rotates and eats the
> tail allowing you to add another entry to the head.
>
> If you pop when empty; nothing happens.
>
Not sure they know "empty" from "non empty", they just move the LBR_TOS
by one entry on returns.

> So on pretty much every program you'd be lucky to get the top of the
> callstack but can end up with nearly nothing.
>
You will get the calls closest to the interrupt.

> Given that, and the other limitations I don't think its a fair
> replacement for user callchains.

Well, the one advantage I see is that it works on stripped/optimized
binaries without fp or dwarf info. Compared to dwarf and the stack
snapshot, it does incur less overhead most likely. But yes, it comes
with limitations.
