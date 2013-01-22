Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab3AVXpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:45:36 -0500
Received: from ozlabs.org ([203.10.76.45]:39504 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab3AVXpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:45:35 -0500
Message-ID: <1358898333.29791.14.camel@concordia>
Subject: Re: [PATCH] perf: Fix compile warnings in tests/attr.c
From: Michael Ellerman <michael@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linuxppc-dev@ozlabs.org,
        Anton Blanchard <anton@au1.ibm.com>, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        mingo <mingo@elte.hu>
Date: Wed, 23 Jan 2013 10:45:33 +1100
In-Reply-To: <20130121213823.GA4774@us.ibm.com>
References: <20130119013052.GA24693@us.ibm.com>
	 <20130121135906.GD1995@krava.brq.redhat.com>
	 <20130121213823.GA4774@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 13:38 -0800, Sukadev Bhattiprolu wrote:
> Jiri Olsa [jolsa@redhat.com] wrote:
> | On Fri, Jan 18, 2013 at 05:30:52PM -0800, Sukadev Bhattiprolu wrote:
> | > From 4d266e5040c33103f5d226b0d16b89f8ef79e3ad Mon Sep 17 00:00:00 2001
> | > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> | > Date: Fri, 18 Jan 2013 11:14:28 -0800
> | > Subject: [PATCH] perf: Fix compile warnings in tests/attr.c
> | > 
> | > Replace '%llu' in printf()s with 'PRIu64' in 'tools/perf/tests/attr.c'
> | > to fix compile warnings (which become errors due to -Werror).
> | 
> | i386 and x86_64 compiles fine for me with gcc versions 4.6.3-2 and 4.7.2-2
> 
> But is broken on Power for 64bit :-( I am trying to fix that and thought
> that use of format specifiers like 'PRIu64' was the way to go.
> 
> | 
> | with your patch for x86_64 I'm getting following warnings/errors:
> 
> | 
> |     CC tests/attr.o
> | tests/attr.c: In function ‘store_event’:
> | tests/attr.c:69:4: error: format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 6 has type ‘__u64’ [-Werror=format]
> 
> Here is what I see on an x86_64 box, RHEL6.2 box:
> 
> 	$ rpm -qf /usr/include/linux/types.h
> 	kernel-headers-2.6.32-220.4.2.el6.x86_64
> 
> 	$ cat foo.c
> 	#include <linux/types.h>
> 
> 	$ cc -Werror -Wall foo.c
> 	In file included from /usr/include/asm-generic/types.h:7,
> 			 from /usr/include/asm/types.h:6,
> 			 from /usr/include/linux/types.h:4,
> 			 from foo5.c:1:
> 	/usr/include/asm-generic/int-ll64.h:31:2: error: #error __u64 defined as unsigned long long
> 
> where the #error is my debug message.
> 
> <snip>
> 
> | make: *** [tests/attr.o] Error 1
> | 
> | i386 compiles fine
> 
> __u64 is 'unsigned long long' on x86 and PRIu64 is 'llu' which is fine.
> 
> __u64 is 'unsigned long' on Power and PRIu64 is 'lu' which is again fine.
> 
> But __u64 is 'unsigned long long' on x86_64, but PRIu64 is '%lu' bc __WORDSIZE
> is 64.


This is a bit of a mess, but let me see if I can help explain it.

The root of the problem is that you're mixing up the kernel type __u64,
with the userspace format specifier PRIu64.

PRIu64 is the format specifier for printing a uint64_t, it _may_ also be
the right specifier for a __u64, but there's no guarantee of that - as
you have discovered.

Inside the kernel both x86 and powerpc use unsigned long long always, in
32-bit and 64-bit code. That means in the kernel we can always use %llu.

On x86 that definition is also exported to userspace, so on x86 __u64 is
always unsigned long long. As you noticed this potentially differs from
uint64_t, which can be confusing. However it means in x86 userspace code
you can always print a __u64 with %llu.

On powerpc we default to using definitions that match userspace, so
__u64 changes depending on your wordsize, and so you must use PRIu64
etc. to print them.

There is however support in recent powerpc kernels to switch to using
unsigned long long even on 64-bit. See commit 2c9c6ce.

You need to define __SANE_USERSPACE_TYPES__ before including types.h.
Then you can always use %llu to print __u64.

cheers

