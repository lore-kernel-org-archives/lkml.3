Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3KLO5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:57:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33215 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab3KLO5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:57:16 -0500
Date: Tue, 12 Nov 2013 15:57:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        jolsa@redhat.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
Message-ID: <20131112145707.GV5056@laptop.programming.kicks-ass.net>
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
 <1384267617-3446-5-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384267617-3446-5-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 07:46:56AM -0700, David Ahern wrote:
> When recording raw_syscalls for the entire system, e.g.,
>     perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
> 
> you end up with a negative feedback loop as perf itself calls write() fairly
> often. This patch handles the problem by mmap'ing the file in chunks of 64M at
> a time and copies events from the event buffers to the file avoiding write
> system calls.

You know this completely fails the moment you trace faults, because
every new access to one of those pages (to mark it dirty) will trigger a
fault. And we'll take a bunch more faults -- one for each page -- than
we ever did write() syscalls.

Anyway the over all performance improvements still make it worth it. But
the above seems like a false argument in favour of this.
