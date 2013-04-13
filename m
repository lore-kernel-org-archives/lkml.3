Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab3DMOtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:49:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab3DMOs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:48:59 -0400
Date: Sat, 13 Apr 2013 16:49:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
Message-ID: <20130413144934.GA11556@redhat.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
 <20130326140147.GB2029@redhat.com>
 <1365687946.8824.3.camel@laptop>
 <CA+55aFway4C89fTewKvED4RvFLaNdM-BVtkJ2YChsvracLKiyA@mail.gmail.com>
 <1365753356.17140.18.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <1365753356.17140.18.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 12, 2013 at 09:55:56AM +0200, Peter Zijlstra wrote:
> > The above is totally untested, but each step is pretty damn simple and
> > fairly cheap. Sure, it's a loop, but it's bounded to 32 (cheap)
> > iterations, and the normal case is that it's not done at all, or done
> > only a few times.
> 
> Right it gets gradually heavier the bigger the numbers get; which is
> more and more unlikely.
> 
> > And the advantage is that the end result is always that simple
> > 32x32/32 case that we started out with as the common case.
> > 
> > I dunno. Maybe I'm overlooking something, and the above is horrible,
> > but the above seems reasonably efficient if not optimal, and
> > *understandable*.
> 
> I suppose that entirely matters on what one is used to ;-) I had to
> stare rather hard at it for a little while.
> 
> But yes, you take it one step further and are willing to ditch rtime
> bits too and I suppose that's fine.
> 
> Should work,.. Stanislaw could you stick this into your userspace
> thingy and verify the numbers are sane enough? 

It works fine - gives relative error less than 0.1% for very big
numbers.

For the record I'm attaching test program and script.

Thanks
Stanislaw


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scale_stime5.c"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <strings.h>
#include <stdint.h>

typedef uint64_t u64;
typedef uint32_t u32;

static u64 div_u64_u32(u64 a, u32 b)
{
	return a / b;
}

static u64 scale_stime(u64 stime, u64 rtime, u64 total)
{

    /* We know one of the values has a bit set in the high 32 bits */
    for (;;) {
        /* Make sure "rtime" is the bigger of stime/rtime */
        if (stime > rtime) {
            u64 tmp = rtime; rtime = stime; stime = tmp;
       	}

        /* Do we need to balance stime/rtime bits? */
        if (rtime >> 32) {
            if (stime >> 31)
                goto drop_precision;

            /* We can grow rtime and shrink stime and try to make them both fit */
            stime <<= 1;
            rtime >>= 1;
            continue;
       	}

        /* stime/rtime fits in 32 bits, how about total? */
        if (!(total >> 32))
            break;

drop_precision:
        /* We drop from rtime, it has more bits than stime */
        rtime >>= 1;
        total >>= 1;
    }

	if (!total)
		return stime;
		
/* Make sure gcc understands that this is a 32x32->64 multiply,
 * followed by a 64/32->64 divide */
    return div_u64_u32((u64) (u32) stime * (u64) (u32) rtime, (u32)total);
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

	scaled = scale_stime(stime, rtime, total);
	printf("%llu\n", scaled);

	return 0;
}

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scale_stime_test5.py"

#!/usr/bin/python

import subprocess
import random
import math

def kernel_scale (rtime, total, stime):
	p = subprocess.Popen("./scale_stime5 " + str(rtime) + " " + str(total) + " " + str(stime) , shell=True, stdout=subprocess.PIPE)
	return int(p.stdout.read())

def python_scale (rtime, total, stime):
	return (stime * rtime) / total

max_rtime = 10*4096*364*24*60*60*1000;  # 10 years for 4096 threads

fail=False
K=10000
for i in range(0, K):
	rtime = random.randrange(max_rtime)
	total = int(random.uniform(0.1, 1.9) * rtime)

	for n in range(1, 100):
		stime = (n * total / 100)
		r1 = kernel_scale(rtime, total, stime)
		r2 = python_scale(rtime, total, stime)
		if (float(abs(r1 - r2)) / float(r2)) > 0.001:
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
	if (i % 100) == 99:
		print str(i/100) + "/" + str(K/100) + " OK"
		

--KsGdsel6WgEHnImy--
