Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab3IQAYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 20:24:02 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33887 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3IQAX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 20:23:59 -0400
Message-ID: <5237A11C.1080408@linaro.org>
Date: Mon, 16 Sep 2013 17:23:56 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizefan@huawei.com>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] [RFC v2] seqcount: Add lockdep functionality to seqcount/seqlock
 structures
References: <1379117948-7385-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1379117948-7385-1-git-send-email-john.stultz@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 05:19 PM, John Stultz wrote:
> Currently seqlocks and seqcounts don't support lockdep.
>
> After running across a seqcount related deadlock in the timekeeping
> code, I used a less-refined and more focused varient of this patch
> to narrow down the cause of the issue.
>
> This is a first-pass attempt to properly enable lockdep functionality
> on seqlocks and seqcounts.
>
> Since seqcounts are used in the vdso gettimeofday code, I've provided
> lockdep accessors.
>
> I've also handled one cases where there were nested seqlock writers
> and there may be more edge cases.

Oof.

So I just noticed there's a bunch of places in the network code that use
fairly deeply embedded seqcounter: u64_stats_sync. There's almost never
an explicit initialization, as they assume they're zeroed when
allocated, but this causes trouble with the lockdep key initialization.

I'll have to go through each of these (about 25 cases) and make them
call seqcount_init(), but since I'm heading to plumbers tomorrow I might
not get to it until next week.

Anyway, let me know if you have any other thoughts on the patches.

thanks
-john

