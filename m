Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab3JOOEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:04:20 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46889 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758940Ab3JOOES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:04:18 -0400
Message-ID: <525D4B5F.4090005@gmail.com>
Date: Tue, 15 Oct 2013 08:04:15 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record: mmap output file
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com> <1381289214-24885-4-git-send-email-dsahern@gmail.com> <20131009055957.GA7664@gmail.com>
In-Reply-To: <20131009055957.GA7664@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/13 11:59 PM, Ingo Molnar wrote:
> Here are some thoughts on how 'perf record' tracing performance could be
> further improved:
>
> 1)
>
> The use of non-temporal stores (MOVNTQ) to copy the ring-buffer into the
> file buffer makes sure the CPU cache is not trashed by the copying - which
> is the largest 'collateral damage' copying does.
>
> glibc does not appear to expose non-temporal instructions so it's going to
> be architecture dependent - but we could build the copy_user_nocache()
> function from the kernel proper (or copy it - we could even simplify it:
> knowing that only large and page aligned buffers are going to be copied
> with it).
>
> See how tools/perf/bench/mem-mem* does that to be able to measure the
> kernel's memcpy() and memset() function performance.

Forgot about this suggestion as well. Added to the list for v3.

>
> 2)
>
> Yet another method would be to avoid the copies altogether via the splice
> system-call - see:
>
> 	git grep splice kernel/trace/
>
> To make splice low-overhead we'd have to introduce a mode to not mmap the
> data part of the perf ring-buffer and splice the data straight from the
> perf fd into a temporary pipe and over from the pipe into the target file
> (or socket).

I looked into splice and it was not clear it would be a good match. 
First, perf is setup to pull data from mmap's and there is not a 1:1 
association between mmap's and fd's (fd_in for splice). Second and more 
importantly, splice is also a system call and it would have to be 
invoked for each mmap each trip through the loop -- just like write() 
does today -- so it does not solve the feedback loop problem.

>
> OTOH non-temporal stores are incredibly simple and memory bandwidth is
> plenty on modern systems so I'd certainly try that route first.

I'll take a look.

David
