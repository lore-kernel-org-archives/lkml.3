Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbbAVAYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:24:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20940 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbbAVAYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:24:00 -0500
Message-ID: <54C042D2.4040809@oracle.com>
Date: Wed, 21 Jan 2015 19:22:42 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org
CC: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v9 00/17]  Kernel address sanitizer - runtime memory debugger.
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 11:51 AM, Andrey Ryabinin wrote:
> Changes since v8:
> 	- Fixed unpoisoned redzones for not-allocated-yet object
> 	    in newly allocated slab page. (from Dmitry C.)
> 
> 	- Some minor non-function cleanups in kasan internals.
> 
> 	- Added ack from Catalin
> 
> 	- Added stack instrumentation. With this we could detect
> 	    out of bounds accesses in stack variables. (patch 12)
> 
> 	- Added globals instrumentation - catching out of bounds in
> 	    global varibles. (patches 13-17)
> 
> 	- Shadow moved out from vmalloc into hole between vmemmap
> 	    and %esp fixup stacks. For globals instrumentation
> 	    we will need shadow backing modules addresses.
> 	    So we need some sort of a shadow memory allocator
> 	    (something like vmmemap_populate() function, except
> 	    that it should be available after boot).
> 
> 	    __vmalloc_node_range() suits that purpose, except that
> 	    it can't be used for allocating for shadow in vmalloc
> 	    area because shadow in vmalloc is already 'allocated'
> 	    to protect us from other vmalloc users. So we need
> 	    16TB of unused addresses. And we have big enough hole
> 	    between vmemmap and %esp fixup stacks. So I moved shadow
> 	    there.

I'm not sure which new addition caused it, but I'm getting tons of
false positives from platform drivers trying to access memory they
don't "own" - because they expect to find hardware there.

I suspect we'd need to mark that memory region somehow to prevent
accesses to it from triggering warnings?


Thanks,
Sasha
