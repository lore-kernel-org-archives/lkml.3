Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3AXCnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 21:43:00 -0500
Received: from ozlabs.org ([203.10.76.45]:42538 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab3AXCmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 21:42:54 -0500
Message-ID: <1358995372.17813.2.camel@concordia>
Subject: Re: [PATCH] perf: Fix compile warnings in tests/attr.c
From: Michael Ellerman <michael@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linuxppc-dev@ozlabs.org,
        Anton Blanchard <anton@au1.ibm.com>, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        mingo <mingo@elte.hu>
Date: Thu, 24 Jan 2013 13:42:52 +1100
In-Reply-To: <20130123185733.GA22906@us.ibm.com>
References: <20130119013052.GA24693@us.ibm.com>
	 <20130121135906.GD1995@krava.brq.redhat.com>
	 <20130121213823.GA4774@us.ibm.com> <1358898333.29791.14.camel@concordia>
	 <20130123185733.GA22906@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 10:57 -0800, Sukadev Bhattiprolu wrote:
> Michael Ellerman [michael@ellerman.id.au] wrote:
> | > | make: *** [tests/attr.o] Error 1
> | > | 
> | > | i386 compiles fine
> | > 
> | > __u64 is 'unsigned long long' on x86 and PRIu64 is 'llu' which is fine.
> | > 
> | > __u64 is 'unsigned long' on Power and PRIu64 is 'lu' which is again fine.
> | > 
> | > But __u64 is 'unsigned long long' on x86_64, but PRIu64 is '%lu' bc __WORDSIZE
> | > is 64.
> | 
> | 
> | This is a bit of a mess, but let me see if I can help explain it.
> 
> Yes it is :-) thanks for explaining it.
> 
> | 
> | The root of the problem is that you're mixing up the kernel type __u64,
> | with the userspace format specifier PRIu64.
> 
> struct perf_event_attr is shared with user space and is using __u64. Should
> it use uint64_t instead ?

Absolutely not. That's the whole reason we have __u64, it's so we can
define it in the kernel but share it with userspace, and not have it
conflict with any userspace types.


> | PRIu64 is the format specifier for printing a uint64_t, it _may_ also be
> | the right specifier for a __u64, but there's no guarantee of that - as
> | you have discovered.
> | 
> | Inside the kernel both x86 and powerpc use unsigned long long always, in
> | 32-bit and 64-bit code. That means in the kernel we can always use %llu.
> | 
> | On x86 that definition is also exported to userspace, so on x86 __u64 is
> | always unsigned long long. As you noticed this potentially differs from
> | uint64_t, which can be confusing. However it means in x86 userspace code
> | you can always print a __u64 with %llu.
> | 
> | On powerpc we default to using definitions that match userspace, so
> | __u64 changes depending on your wordsize, and so you must use PRIu64
> | etc. to print them.
> 
> Well, using __u64 and PRIu64 seems breaks x86-64...

Yes, see the previous paragraph.

> | There is however support in recent powerpc kernels to switch to using
> | unsigned long long even on 64-bit. See commit 2c9c6ce.
> | 
> | You need to define __SANE_USERSPACE_TYPES__ before including types.h.
> | Then you can always use %llu to print __u64.
> 
> but __SANE_USERSPACE_TYPES__ with __u64 and %llu seems to work on x86,
> x86-64, powerpc.

> Will modify my patch to add __SANE_USERSPACE_TYPES__ but leave the %llu
> as is.

Right. It will only work with newer kernel headers, but that's basically
unsolvable.

cheers

