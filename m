Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3AWS6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 13:58:13 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34390 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3AWS6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:58:01 -0500
Date: Wed, 23 Jan 2013 10:57:33 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Jiri Olsa <jolsa@redhat.com>, linuxppc-dev@ozlabs.org,
        Anton Blanchard <anton@au1.ibm.com>, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        mingo <mingo@elte.hu>
Subject: Re: [PATCH] perf: Fix compile warnings in tests/attr.c
Message-ID: <20130123185733.GA22906@us.ibm.com>
References: <20130119013052.GA24693@us.ibm.com>
 <20130121135906.GD1995@krava.brq.redhat.com>
 <20130121213823.GA4774@us.ibm.com>
 <1358898333.29791.14.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358898333.29791.14.camel@concordia>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012318-5806-0000-0000-00001EA86B84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman [michael@ellerman.id.au] wrote:
| > | make: *** [tests/attr.o] Error 1
| > | 
| > | i386 compiles fine
| > 
| > __u64 is 'unsigned long long' on x86 and PRIu64 is 'llu' which is fine.
| > 
| > __u64 is 'unsigned long' on Power and PRIu64 is 'lu' which is again fine.
| > 
| > But __u64 is 'unsigned long long' on x86_64, but PRIu64 is '%lu' bc __WORDSIZE
| > is 64.
| 
| 
| This is a bit of a mess, but let me see if I can help explain it.

Yes it is :-) thanks for explaining it.

| 
| The root of the problem is that you're mixing up the kernel type __u64,
| with the userspace format specifier PRIu64.

struct perf_event_attr is shared with user space and is using __u64. Should
it use uint64_t instead ?

| 
| PRIu64 is the format specifier for printing a uint64_t, it _may_ also be
| the right specifier for a __u64, but there's no guarantee of that - as
| you have discovered.
| 
| Inside the kernel both x86 and powerpc use unsigned long long always, in
| 32-bit and 64-bit code. That means in the kernel we can always use %llu.
| 
| On x86 that definition is also exported to userspace, so on x86 __u64 is
| always unsigned long long. As you noticed this potentially differs from
| uint64_t, which can be confusing. However it means in x86 userspace code
| you can always print a __u64 with %llu.
| 
| On powerpc we default to using definitions that match userspace, so
| __u64 changes depending on your wordsize, and so you must use PRIu64
| etc. to print them.

Well, using __u64 and PRIu64 seems breaks x86-64...

| 
| There is however support in recent powerpc kernels to switch to using
| unsigned long long even on 64-bit. See commit 2c9c6ce.
| 
| You need to define __SANE_USERSPACE_TYPES__ before including types.h.
| Then you can always use %llu to print __u64.

but __SANE_USERSPACE_TYPES__ with __u64 and %llu seems to work on x86,
x86-64, powerpc.

Will modify my patch to add __SANE_USERSPACE_TYPES__ but leave the %llu
as is.

Sukadev

