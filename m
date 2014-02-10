Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaBJSKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:10:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56230 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaBJSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:10:31 -0500
Date: Mon, 10 Feb 2014 19:10:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com, dave.martin@arm.com,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 7/7] perf: kill perf_event_context::pmu
Message-ID: <20140210181026.GD27965@twins.programming.kicks-ass.net>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
 <1392054264-23570-8-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392054264-23570-8-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 05:44:24PM +0000, Mark Rutland wrote:
> Currently portions of the perf subsystem assume that a
> perf_event_context is associated with a single pmu while in reality a
> single perf_event_context may be shared by a number of pmus, as commit
> 443772776c69 (perf: Disable all pmus on unthrottling and rescheduling)
> describes.
> 
> This patch removes perf_event_context::pmu, replacing it with a direct
> pointer to the associated perf_cpu_context and a task_ctx_nr (as all
> pmus sharing a context have the same task_ctx_nr). This makes the
> relationship between pmus and perf_event_contexts clearer and allows us
> to save on some pointer chasing.
> 
> This also fixes a potential misuse of ctx->pmu introduced in commit
> bad7192b842c (perf: Fix PERF_EVENT_IOC_PERIOD to force-reset the
> period), where ctx->pmu is disabled before modifying state on
> event->pmu. In this case the two pmus are not guaranteed to be the same.
> 
> As perf_pmu_rotate_{start,stop} only really care about the context they
> are rotating, they are renamed to perf_event_ctx_{start,stop}.

This very much relies on the previous patch where you make pmu_disable
iterate all the events.

We could also change this to keep a pmu list for each context and
iterate that instead. Given there is indeed a fair limit on different
PMUs in the system that iteration should be much shorter.


