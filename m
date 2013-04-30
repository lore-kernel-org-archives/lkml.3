Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732Ab3D3OC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760687Ab3D3OC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:02:58 -0400
Date: Tue, 30 Apr 2013 16:03:30 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
Message-ID: <20130430140330.GB10465@redhat.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
 <20130326140147.GB2029@redhat.com>
 <1365687946.8824.3.camel@laptop>
 <CA+55aFway4C89fTewKvED4RvFLaNdM-BVtkJ2YChsvracLKiyA@mail.gmail.com>
 <1365753356.17140.18.camel@laptop>
 <20130413144934.GA11556@redhat.com>
 <CA+55aFwMeAe6Mb9EPeT4Ke0W36z-XUK3BZvbOt+dMzdbJ3F1Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline
In-Reply-To: <CA+55aFwMeAe6Mb9EPeT4Ke0W36z-XUK3BZvbOt+dMzdbJ3F1Ew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 13, 2013 at 11:44:54AM -0700, Linus Torvalds wrote:
> PS. This is the "Make sure 'total' fits in 32 bits first" version. Not
> really tested, but it's just changing the order of operations a bit.
> 
>     /* We know one of the values has a bit set in the high 32 bits */
>     for (;;) {
>         /* Make sure "rtime" is the bigger of stime/rtime */
>         if (stime > rtime) {
>             u64 tmp = rtime; rtime = stime; stime = tmp;
>         }
> 
>         /* Make sure 'total' fits in 32 bits */
>         if (total >> 32)
>                 goto drop_precision;
> 
>         /* Does rtime (and thus stime) fit in 32 bits? */
>         if (!(rtime >> 32))
>                 break;
> 
>         /* Can we just balance rtime/stime rather than dropping bits? */
>         if (stime >> 31)
>             goto drop_precision;
> 
>         /* We can grow stime and shrink rtime and try to make them both fit */
>         stime <<= 1;
>         rtime >>= 1;
>         continue;
> 
> drop_precision:
>         /* We drop from rtime, it has more bits than stime */
>         rtime >>= 1;
>         total >>= 1;
>     }

For reference I'm attaching test program and script I used to validate
algorithm.

It generates lot of (possibly real) rtime, total, stime values for 4096
threads running for 10 years. Then compare scaled stime values caluclated
by above algorithm with precise python values. 

For all values generated, scaled stime relative error was less than 0.05%

Stanislaw

--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scale_stime.c"

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

        /* Make sure 'total' fits in 32 bits */
        if (total >> 32)
                goto drop_precision;

        /* Does rtime (and thus stime) fit in 32 bits? */
        if (!(rtime >> 32))
                break;

        /* Can we just balance rtime/stime rather than dropping bits? */
        if (stime >> 31)
            goto drop_precision;

        /* We can grow stime and shrink rtime and try to make them both fit */
        stime <<= 1;
        rtime >>= 1;
        continue;

drop_precision:
        /* We drop from rtime, it has more bits than stime */
        rtime >>= 1;
        total >>= 1;
    }

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

--aVD9QWMuhilNxW9f
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

max_rtime = 10*4096*364*24*60*60*1000;  # 10 years for 4096 threads

fail=False
K=1000
for i in range(0, K):
	rtime = random.randrange(max_rtime)
	total = int(random.uniform(0.1, 1.9) * rtime)

	for n in range(1, 100):
		stime = (n * total / 100)
		r1 = kernel_scale(rtime, total, stime)
		r2 = python_scale(rtime, total, stime)
		if (float(abs(r1 - r2)) / float(r2)) > 0.0005:
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
		

--aVD9QWMuhilNxW9f--
