Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaKUHcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 02:32:45 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:55208 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaKUHco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 02:32:44 -0500
MIME-Version: 1.0
In-Reply-To: <20141120150033.4cd1ca25be4a9b00a7074149@linux-foundation.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com> <5461B906.1040803@samsung.com>
 <20141118125843.434c216540def495d50f3a45@linux-foundation.org>
 <CAPAsAGwZtfzx5oM73bOi_kw5BqXrwGd_xmt=m6xxU6uECA+H9Q@mail.gmail.com>
 <20141120090356.GA6690@gmail.com> <CACT4Y+aOKzq0AzvSJrRC-iU9LmmtLzxY=pxzu8f4oT-OZk=oLA@mail.gmail.com>
 <20141120150033.4cd1ca25be4a9b00a7074149@linux-foundation.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 21 Nov 2014 11:32:22 +0400
Message-ID: <CACT4Y+ZfWTTMn21QCU4y+rR9NXo6LZ3ZLcG5JhatGUshApPdqA@mail.gmail.com>
Subject: Re: [PATCH v6 00/11] Kernel address sanitizer - runtime memory debugger.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 2:00 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 20 Nov 2014 20:32:30 +0400 Dmitry Vyukov <dvyukov@google.com> wrote:
>
>> Let me provide some background first.
>
> Well that was useful.  Andrey, please slurp Dmitry's info into the 0/n
> changelog?
>
> Also, some quantitative info about the kmemleak overhead would be
> useful.
>
> In this discussion you've mentioned a few planned kasan enhancements.
> Please also list those and attempt to describe the amount of effort and
> complexity levels.  Partly so other can understand the plans and partly
> so we can see what we're semi-committing ourselves to if we merge this
> stuff.


The enhancements are:
1. Detection of stack out-of-bounds. This is done mostly in the
compiler. Kernel only needs adjustments in reporting.
2. Detection of global out-of-bounds. Kernel will need to process
compiler-generated list of globals during bootstrap. Complexity is
very low and it is isolated in Asan code.
3. Heap quarantine (delayed reuse of heap blocks). We will need to
hook into slub, queue freed blocks in an efficient/scalable way and
integrate with memory shrinker (register_shrinker). This will be
somewhat complex and touch production kernel code. Konstantin
Khlebnikov wants to make the quarantine available independently of
Asan, as part of slub debug that can be enabled at runtime.
4. Port Asan to slAb.
5. Do various tuning of allocator integration, redzones sizes,
speeding up what is currently considered debug-only paths in
malloc/free, etc.
6. Some people also expressed interest in ARM port.

The user-space Asan codebase is mostly stable for the last two years,
so it's not that we have infinite plans.
