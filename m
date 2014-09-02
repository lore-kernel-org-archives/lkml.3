Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaIBKxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:53:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBKxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:53:01 -0400
Date: Tue, 2 Sep 2014 12:52:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/9] perf: Deny optimized switch for events read by
 PERF_SAMPLE_READ
Message-ID: <20140902105244.GI5806@worktop.ger.corp.intel.com>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-3-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1408977943-16594-3-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 04:45:36PM +0200, Jiri Olsa wrote:
> The optimized task context switch for cloned perf events just
> swaps whole perf event contexts (of current and next process)
> if it finds them suitable. Events from the 'current' context
> will now measure data of the 'next' context and vice versa.
> 
> This is ok for cases where we are not directly interested in
> the event->count value of separate child events, like:
>   - standard sampling, where we take 'period' value for the
>     event count
>   - counting, where we accumulate all events (children)
>     into a single count value
> 
> But in case we read event by using the PERF_SAMPLE_READ sample
> type, we are interested in direct event->count value measured
> in specific task. Switching events within tasks for this kind
> of measurements corrupts data.
> 
> Fixing this by setting/unsetting pin_count for perf event context
> once cloned event with PERF_SAMPLE_READ read is added/removed.
> The pin_count value != 0 makes the context not suitable for
> optimized switch.

no.. so the value of the counter is the sum of all the inherited events.
It doesn't matter if you flip it or not the sum is not affected.

PERF_SAMPLE_READ should return the value.
