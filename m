Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934376Ab3CZOBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:01:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758268Ab3CZOBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:01:22 -0400
Date: Tue, 26 Mar 2013 15:01:48 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
Message-ID: <20130326140147.GB2029@redhat.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 03:49:02AM -0700, tip-bot for Frederic Weisbecker wrote:
> Commit-ID:  d9a3c9823a2e6a543eb7807fb3d15d8233817ec5
> Gitweb:     http://git.kernel.org/tip/d9a3c9823a2e6a543eb7807fb3d15d8233817ec5
> Author:     Frederic Weisbecker <fweisbec@gmail.com>
> AuthorDate: Wed, 20 Feb 2013 18:54:55 +0100
> Committer:  Frederic Weisbecker <fweisbec@gmail.com>
> CommitDate: Wed, 13 Mar 2013 18:18:14 +0100
> 
> sched: Lower chances of cputime scaling overflow
> 
> Some users have reported that after running a process with
> hundreds of threads on intensive CPU-bound loads, the cputime
> of the group started to freeze after a few days.
> 
> This is due to how we scale the tick-based cputime against
> the scheduler precise execution time value.
> 
> We add the values of all threads in the group and we multiply
> that against the sum of the scheduler exec runtime of the whole
> group.
> 
> This easily overflows after a few days/weeks of execution.
> 
> A proposed solution to solve this was to compute that multiplication
> on stime instead of utime:
>    62188451f0d63add7ad0cd2a1ae269d600c1663d
>    ("cputime: Avoid multiplication overflow on utime scaling")
> 
> The rationale behind that was that it's easy for a thread to
> spend most of its time in userspace under intensive CPU-bound workload
> but it's much harder to do CPU-bound intensive long run in the kernel.
> 
> This postulate got defeated when a user recently reported he was still
> seeing cputime freezes after the above patch. The workload that
> triggers this issue relates to intensive networking workloads where
> most of the cputime is consumed in the kernel.
> 
> To reduce much more the opportunities for multiplication overflow,
> lets reduce the multiplication factors to the remainders of the division
> between sched exec runtime and cputime. Assuming the difference between
> these shouldn't ever be that large, it could work on many situations.
> 
> This gets the same results as in the upstream scaling code except for
> a small difference: the upstream code always rounds the results to
> the nearest integer not greater to what would be the precise result.
> The new code rounds to the nearest integer either greater or not
> greater. In practice this difference probably shouldn't matter but
> it's worth mentioning.
> 
> If this solution appears not to be enough in the end, we'll
> need to partly revert back to the behaviour prior to commit
>      0cf55e1ec08bb5a22e068309e2d8ba1180ab4239
>      ("sched, cputime: Introduce thread_group_times()")
> 
> Back then, the scaling was done on exit() time before adding the cputime
> of an exiting thread to the signal struct. And then we'll need to
> scale one-by-one the live threads cputime in thread_group_cputime(). The
> drawback may be a slightly slower code on exit time.

Sorry for questioning this patch that late, but I thought this solution
is ok. However before providing backport to RHEL kernel, I made some 
analytics and test of this algorithm. I discovered that is pretty easy
to catch multiplication overflow, for example:

rtime: 16877346691
total: 12215365298
stime: 4886146119

will give scaled stime: 5240812402 , whereas correct value should be
6750938676. As problem can be triggered at random, and we can not
give any guaranties that it will not happen for particular time
duration bigger than 50 days (on one thread application), I'm not
considering this patch as good fix.

Of cource reverting 0cf55e1ec08bb5a22e068309e2d8ba1180ab4239 will not
help either, since is possible to have overflow on one thread.

Can we remove rtime multiplication at all and just use pure utime and
stime values? I think no. I don't know the details, but is possible that
we can have top "exploit" that will eat lot of cputime but "hide" itself
from tick, hence it will not be showed correctly as process which utilize
lot of cpu. Peter told about that some time ago.

Taking that, and analyze some other possibilities, I think best (or only
possible good) solution for this problem is use 128 bit math for
calculation. I tested (on user space) below code [1] and it give good
results. It use 128 bit multiplication and simplified 128 bit division.

This will require adding those 128 bit math primitives
http://thread.gmane.org/gmane.linux.kernel/1381801
which were initially required for Deadline scheduler, but then removed
from requirement. I hope it is ok to add them or some improved version.
I think soon or later 128 bit math will be required in more places in
the kernel.

Thoughts?

Stanislaw 

[1] 

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <strings.h>

typedef unsigned long long u64;
typedef unsigned __int128 u128;

#define clzll(x) __builtin_clzll(x)

static u64 div_u64(u64 a, u64 b)
{
	return a / b;
}

static u128 mul_u64_u64(u64 a, u64 b)
{
	u128 res = a;
	res *= b;

	return res;
}

static u64 div128_u64(u128 dividend, u64 divisor)
{
	u64 high = dividend >> 64;
	u64 quot;

	if (high == 0) {
		quot = div_u64(dividend, divisor);
	} else {
		int n = 64 - clzll(high);

		if ((divisor >> n) == 0) {
			/* Oh no */
			return 0;
		}

		quot = div_u64(dividend >> n, divisor >> n);

		if (quot != 0)
			quot--;
		if ((dividend - quot * divisor) >= divisor)
			quot++;
	}

	return quot;
}

u64 _scale_time(u64 rtime, u64 total, u64 time)
{
	u128 tmp = mul_u64_u64(time, rtime);

	return div128_u64(tmp, total);
}

u64 scale_time(u64 stime, u64 rtime, u64 total)
{
        u64 time, scaled;
	u64 utime = total - stime;
	int use_utime;

	if (utime < stime) {
		use_utime = 1;
		time = utime;
	} else {
		use_utime = 0;
		time = stime;
	}

	scaled = _scale_time(rtime, total, time);

	if (use_utime)
		scaled = rtime - scaled;

	return scaled;
}

int main(int argc, char *argv[])
{
	u64 rtime, total, stime, scaled;

	if (argc != 4)
		return;

	rtime = strtoll(argv[1], NULL, 10);
	total = strtoll(argv[2], NULL, 10);
	stime = strtoll(argv[3], NULL, 10);

	assert (total >= stime);
	
	scaled = scale_time(stime, rtime, total);
	printf("%llu\n", scaled);

	return 0;
}
