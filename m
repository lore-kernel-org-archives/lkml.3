Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab3FZP37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:29:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32813 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3FZP3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:29:55 -0400
Date: Wed, 26 Jun 2013 13:54:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH 0/7] perf, x86: Haswell LBR call stack support
Message-ID: <20130626115420.GG28407@twins.programming.kicks-ass.net>
References: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372150039-15151-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 04:47:12PM +0800, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Haswell has a new feature that utilizes the existing Last Branch Record
> facility to record call chains. When the feature is enabled, function
> call will be collected as normal, but as return instructions are executed
> the last captured branch record is popped from the on-chip LBR registers.
> The LBR call stack facility can help perf to get call chains of progam
> without frame pointer. When perf tool requests PERF_SAMPLE_CALLCHAIN +
> PERF_SAMPLE_BRANCH_USER, this feature is dynamically enabled by default.
> This feature can be disabled/enabled through an attribute file in the cpu
> pmu sysfs directory.
> 
> The LBR call stack has following known limitations
>  1. Zero length calls are not filtered out by hardware
>  2. Exception handing such as setjmp/longjmp will have calls/returns not
>     match
>  3. Pushing different return address onto the stack will have calls/returns
>     not match
> 

You fail to mention what happens when the callstack is deeper than the
LBR is big -- a rather common issue I'd think.

>From what I gather if you push when full, the TOS rotates and eats the
tail allowing you to add another entry to the head.

If you pop when empty; nothing happens.

So on pretty much every program you'd be lucky to get the top of the
callstack but can end up with nearly nothing.

Given that, and the other limitations I don't think its a fair
replacement for user callchains.
