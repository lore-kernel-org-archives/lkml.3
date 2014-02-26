Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaBZVet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:34:49 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62183 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaBZVes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:34:48 -0500
Message-ID: <530E5DE7.7060904@gmail.com>
Date: Wed, 26 Feb 2014 14:34:31 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andy Lutomirski <luto@amacapital.net>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com> <530D53EF.9090706@amacapital.net> <CABPqkBSECV6iG4T60-OTZsV2CrCtV=awUSt7SGLTdkX9i8T90g@mail.gmail.com> <CALCETrWXDYsxXBWPqNS8cK69756DNj5sUyk-Fho2r_5_wh-=mg@mail.gmail.com> <20140226185513.GL22728@two.firstfloor.org> <CALCETrVQ8SBg+YLuPmDevL+f2dzBjLJucfMvVHaB04E8QJSGXw@mail.gmail.com> <530E3E47.8010205@gmail.com> <CALCETrUHiDqT+VRbdEnGsEkMFqQt+ZqX+RTenp1ets8XMhrQ2Q@mail.gmail.com> <530E4B42.5090401@gmail.com> <20140226205322.GM22728@two.firstfloor.org>
In-Reply-To: <20140226205322.GM22728@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/14, 1:53 PM, Andi Kleen wrote:
>> Is there some reason not to enable frame pointers?
>
> It makes code slower.

Sure there is some overhead because of the push, mov, pop instructions 
per function. But, take for example the simple program below. Compile 
with and without frame pointers

gcc -Wall -fno-omit-frame-pointer  fp-test.c -owith-fp
gcc -Wall -fomit-frame-pointer     fp-test.c -ono-fp

$ time ./with-fp
real	0m9.187s
user	0m9.174s
sys	0m0.001s

$ time ./no-fp
real	0m11.749s
user	0m11.731s
sys	0m0.001s

>
> Especially on Atom CPUs, where it causes pipeline stalls, but
> also to some degree on others, because you lose one register and
> spend a little bit of time setting it up, so making small
> functions more expensive.
>
> Another issue is that you can't enable it on a lot of existing
> libraries, sometimes not even with a recompile. For example
> glibc assembler functions do not support it at all, which
> is a very common case.
>
> They are designed to use dwarf, but in practice dwarf
> is very slow (perf has to save the stack for every sample)
> and in practice doesn't always work (too small stack saving,
> wrong annotations, out of date or broken dwarf library etc.)

dwarf is often just not usable:

$ perf record --call-graph dwarf -- ./no-fp
[ perf record: Woken up 1521 times to write data ]
[ perf record: Captured and wrote 380.567 MB perf.data (~16627233 samples) ]
0x4003cf0 [0]: failed to process type: 0

Compared to the fp route:
$ perf record -g -- ./with-fp
[ perf record: Woken up 12 times to write data ]
[ perf record: Captured and wrote 2.948 MB perf.data (~128816 samples) ]

That is a huge difference. Not to mention the fact the dwarf file is 
useless which means radically lowering sample rate and increasing mmap size.

The efficiency of fp is worth the small amount of (theoretical) overhead 
-- at least for us with xeon CPUs.
>
> LBR callstack mode is not perfect either, and it has
> its own tradeoffs, but in many cases it seems to be a good
> and more efficient replacement for dwarf, when FP is not available.

Haswell only option -- based on the subject line?

David

--

$ cat fp-test.c

#include <stdlib.h>

static int i;

void e(void)
{
	i++;
}
void d(void)
{
	e();
}
void c(void)
{
	d();
}
void b(void)
{
	c();
}
void a(void)
{
	b();
}

int main(int argc, char *argv[])
{
	int iter = 1000000000;

	if (argc > 1)
		iter = atoi(argv[1]);

	while (--iter > 0)
		a();

	return 0;
}
