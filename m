Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaBJSIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:08:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56169 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaBJSI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:08:27 -0500
Date: Mon, 10 Feb 2014 19:08:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com, dave.martin@arm.com,
        Ingo Molnar <mingo@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/7] perf: Centralise context pmu disabling
Message-ID: <20140210180819.GC27965@twins.programming.kicks-ass.net>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
 <1392054264-23570-7-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392054264-23570-7-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 05:44:23PM +0000, Mark Rutland wrote:
> Commit 443772776c69 (perf: Disable all pmus on unthrottling and
> rescheduling) identified an issue with having multiple PMUs sharing a
> perf_event_context, but only partially solved the issue.
> 
> While ctx::pmu will be disabled across all of its events being
> scheduled, pmus which are not ctx::pmu will be repeatedly enabled and
> disabled between events being added, possibly counting imbetween
> pmu::add calls. This could be expensive and could lead to events
> counting for differing periods.
> 
> Instead, this patch adds new helpers to disable/enable all pmus which
> have events in a context. While perf_pmu_{dis,en}able may be called
> repeatedly for a particular pmu, disabling is reference counted such
> that the real pmu::{dis,en}able callbacks are only called once (were
> this not the case, the current code would be broken for ctx::pmu).
> 
> Uses of perf_pmu{disable,enable}(ctx->pmu) are replaced with
> perf_ctx_pmus_{disable,enable}(ctx). The now unnecessary calls to
> perf_pmu_enable and perf_pmu_disable added by 443772776c69 are removed.

Hurmn; instead of adding more for_each_event iterations we should be
reducing them.

Given that we currently schedule first to last and stop on the first
event that fails to schedule, we can terminate the ctx_sched_out() loop
when it finds the first event that wasn't actually scheduled.


