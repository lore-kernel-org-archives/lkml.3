Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbbAPKqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:46:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:43863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbbAPKqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:46:47 -0500
Date: Fri, 16 Jan 2015 11:46:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: perf fuzzer crash [PATCH] perf: Get group events reference
 before moving the group
Message-ID: <20150116104644.GW23965@worktop.programming.kicks-ass.net>
References: <20150116075746.GB2658@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116075746.GB2658@krava.brq.redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 08:57:46AM +0100, Jiri Olsa wrote:
> We need to make sure, that no event in the group lost
> the last reference and gets removed from the context
> during the group move in perf syscall.
> 
> This could happen if the child exits and calls put_event
> on the parent event which got already closed, like in
> following scenario:
> 
>   - T1 creates software event E1
>   - T1 creates other software events as group with E1 as group leader
>   - T1 forks T2
>   - T2 has cloned E1 event that holds reference on E1
>   - T1 closes event within E1 group (say E3), the event stays alive
>     due to the T2 reference
>   - following happens concurently:
>     A) T1 creates hardware event E2 with groupleader E1
>     B) T2 exits
> 
> ad A) T1 triggers the E1 group move into hardware context:
>         mutex_lock(E1->ctx)
>           - remove E1 group only from the E1->ctx context, leaving
>             the goup links untouched
>         mutex_unlock(E1->ctx)
>         mutex_lock(E2->ctx)
>           - install E1 group into E2->ctx using the E1 group links
>         mutex_unlock(E2->ctx)
> 
> ad B) put_event(E3) is called and E3 is removed from E1->ctx
>       completely, including group links
> 
> If 'A' and 'B' races, we will get unbalanced refcounts,
> because of removed group links.
> 
> Adding get_group/put_group functions to handle the event
> ref's increase/decrease for the whole group.

Its a bandaid at best :/ The problem is (again) that we changes
event->ctx without any kind of serialization.

The issue came up before:

  https://lkml.org/lkml/2014/9/5/397

and I've not been able to come up with anything much saner.
