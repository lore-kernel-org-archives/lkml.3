Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbbAPP0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:26:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:45076 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbbAPP0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:26:43 -0500
Date: Fri, 16 Jan 2015 16:26:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH] perf: decouple unthrottling and rotating
Message-ID: <20150116152640.GI22386@worktop.programming.kicks-ass.net>
References: <1420642914-22760-1-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420642914-22760-1-git-send-email-mark.rutland@arm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 03:01:54PM +0000, Mark Rutland wrote:
> Currently the adjusments made as part of perf_event_task_tick use the
> percpu rotation lists to iterate over any active PMU contexts, but these
> are not used by the context rotation code, having been replaced by
> separate (per-context) hrtimer callbacks. However, some manipulation of
> the rotation lists (i.e. removal of contexts) has remained in
> perf_rotate_context. This leads to the following issues:
> 
> * Contexts are not always removed from the rotation lists. Removal of
>   PMUs which have been placed in rotation lists, but have not been
>   removed by a hrtimer callback can result in corruption of the rotation
>   lists (when memory backing the context is freed).
> 
>   This has been observed to result in hangs when PMU drivers built as
>   modules are inserted and removed around the creation of events for
>   said PMUs.
> 
> * Contexts which do not require rotation may be removed from the
>   rotation lists as a result of a hrtimer, and will not be considered by
>   the unthrottling code in perf_event_task_tick.
> 
> This patch solves these issues by moving any and all removal of contexts
> from rotation lists to only occur when the final event is removed from a
> context, mirroring the addition which only occurs when the first event
> is added to a context. The vestigal manipulation of the rotation lists
> is removed from perf_event_rotate_context.
> 
> As the rotation_list variables are not used for rotation, these are
> renamed to active_ctx_list, which better matches their current function.
> perf_pmu_rotate_{start,stop} are renamed to
> perf_pmu_ctx_{activate,deactivate}.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Reported-by: Johannes Jensen <johannes.jensen@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>

Thanks!
