Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934577Ab3DKIED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:04:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934485Ab3DKID5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:03:57 -0400
Date: Thu, 11 Apr 2013 10:04:33 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        hpa@zytor.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
Message-ID: <20130411080432.GA1380@redhat.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
 <20130326140147.GB2029@redhat.com>
 <CAFTL4hyJxwh056=bTsSFcpZ7QLRsvsGbni=ueUHE6c1n8dmQ7Q@mail.gmail.com>
 <20130410125111.GA12923@gmail.com>
 <CAFTL4hxsTMZhNqC9jkrc5L3zEr-KFhxvwHqk+q=0zRn6wraWSg@mail.gmail.com>
 <20130410173219.GG21951@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20130410173219.GG21951@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 10, 2013 at 07:32:19PM +0200, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > 2013/4/10 Ingo Molnar <mingo@kernel.org>:
> > >
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > >
> > >> Of course 128 bits ops are very expensive, so to help you evaluating the
> > >> situation, this is going to happen on every call to task_cputime_adjusted() and
> > >> thread_group_adjusted(), namely:
> > >
> > > It's really only expensive for divisions. Addition and multiplication should be
> > > straightforward and relatively low overhead, especially on 64-bit platforms.
> > 
> > Ok, well we still have one division in the scaling path. I'm mostly
> > worried about the thread group exit that makes use of it through
> > threadgroup_cputime_adjusted(). Not sure if we can avoid that.
> 
> I see, scale_stime()'s use of div64_u64_rem(), right?
> 
> I swapped out the details already, is there a link or commit ID that explains 
> where we hit 64-bit multiplication overflow? It's due to accounting in nanosecs,

No, values are converted to jiffies and then are multiplied. CONFIG_HZ=1000
make issue happen earlier compared to CONFIG_HZ=100.

> spread out across thousands of tasks potentially, right?

Thousands of tasks (in one process) running on thousands of CPUs machine
will make problem reproducible in hours or maybe minutes.
 
> But even with nsecs, a 64-bit variable ought to be able to hold hundreds of years 
> worth of runtime. How do we overflow?

We do rtime * stime. If process utilize 100% CPU we have stime = rtime .
That will overflow if rtime >= sqrt(0xffffffffffffffff) jiffies. That is
rtime >= 49 days assuming CONFIG_HZ=1000. With 50 threads running on
CPUS > 50 machine, this will give 1 day. In real application stime is
never equal to rtime, but can be near half of it, so still problem is
easy achievable.

Using quotient and remainder make problem less reproducible, but it
still happen depending on rtime / total ratio.

I wrote user space program that make same calculations as kernel and python
script that generate stime/rtime/total values (attached). It shows problem
can still be reproducible. For example:

FAIL!
rtime: 25386774344 <- 293 days (one thread, HZ=1000)
total: 27958813690
stime: 8387644107
kernel: 8275815093 <- kernel value
python: 7616032303 <- correct value

FAIL!
rtime: 16877346691 <- 195 days (one thread, HZ=1000)
total: 12215365298
stime: 4886146119
kernel: 5240812402 <- kernel value
python: 6750938676 <- correct value

Stanislaw


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scale_stime.c"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

typedef unsigned long long u64;

u64 div64_u64_rem(u64 a, u64 b, u64 *rem)
{
	u64 res = a / b;
	*rem = a % b;

	return res;

}

u64 div64_u64(u64 a, u64 b)
{
	return a / b;
}

u64 scale_stime(u64 stime, u64 rtime, u64 total)
{
        u64 rem, res, scaled;

        if (rtime >= total) {
                res = div64_u64_rem(rtime, total, &rem);
                scaled = stime * res;
                scaled += div64_u64(stime * rem, total);
        } else {
                res = div64_u64_rem(total, rtime, &rem);
                scaled = div64_u64(stime, res);
                scaled -= div64_u64(scaled * rem, total);
	}
	
	return scaled;
}

int main(int argc, char *argv[])
{
	u64 rtime, total, stime, scaled;

	if (argc != 4)
		return -1;

	rtime = strtoll(argv[1], NULL, 10);
	total = strtoll(argv[2], NULL, 10);
	stime = strtoll(argv[3], NULL, 10);

	assert (total >= stime);
	
	scaled = scale_stime(stime, rtime, total);
	printf("%llu\n", scaled);

	return 0;
}

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scale_stime_test.py"

#!/usr/bin/python

import subprocess
import random
import math

def kernel_scale (rtime, total, stime):
	p = subprocess.Popen("./scale_stime " + str(rtime) + " " + str(total) + " " + str(stime) , shell=True, stdout=subprocess.PIPE)
	return int(p.stdout.read())

def python_scale (rtime, total, stime):
	return (stime * rtime) / total


max_rtime = 364*24*60*60*1000  # 1 year (on one thread) 

fail=False

for i in range(0, 100):
	rtime = random.randrange(max_rtime)
	total = int(random.uniform(0.7, 1.3) * rtime)

	for n in range(1, 11):
		stime = (n * total / 10)
		r1 = kernel_scale(rtime, total, stime)
		r2 = python_scale(rtime, total, stime)
		if abs(r1 - r2) > 1:
			print "FAIL!"
			print "rtime: " + str(rtime)
			print "total: " + str(total)
			print "stime: " + str(stime)
			print "kernel: " + str(r1)
			print "python: " + str(r2)

			fail=True
			break
	if fail:
		break;
		

--azLHFNyN32YCQGCU--
