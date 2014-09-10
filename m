Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaIJPvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:51:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:43630 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbaIJPvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:51:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,499,1406617200"; 
   d="scan'208";a="571206007"
Message-ID: <5410724B.8000803@intel.com>
Date: Wed, 10 Sep 2014 08:46:19 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org
CC: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC/PATCH v2 02/10] x86_64: add KASan support
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-3-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1410359487-31938-3-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overall, the approach here looks pretty sane.  As you noted, it would be
nice to keep PAGE_OFFSET in one place, but it's not a deal breaker for
me.  The use of the vmemmap code looks to be a nice fit.

Few nits below.

On 09/10/2014 07:31 AM, Andrey Ryabinin wrote:
> 16TB of virtual addressed used for shadow memory.
> It's located in range [0xffff800000000000 - 0xffff900000000000]
> Therefore PAGE_OFFSET has to be changed from 0xffff880000000000
> to 0xffff900000000000.
...
> It would be nice to not have different PAGE_OFFSET with and without CONFIG_KASAN.
> We have big enough hole between vmemmap and esp fixup stacks.
> So how about moving all direct mapping, vmalloc and vmemmap 8TB up without
> hiding it under CONFIG_KASAN?

Is there a reason this has to be _below_ the linear map?  Couldn't we
just carve some space out of the vmalloc() area for the kasan area?


>  arch/x86/Kconfig                     |  1 +
>  arch/x86/boot/Makefile               |  2 ++
>  arch/x86/boot/compressed/Makefile    |  2 ++
>  arch/x86/include/asm/kasan.h         | 20 ++++++++++++
>  arch/x86/include/asm/page_64_types.h |  4 +++
>  arch/x86/include/asm/pgtable.h       |  7 ++++-
>  arch/x86/kernel/Makefile             |  2 ++
>  arch/x86/kernel/dumpstack.c          |  5 ++-
>  arch/x86/kernel/head64.c             |  6 ++++
>  arch/x86/kernel/head_64.S            | 16 ++++++++++
>  arch/x86/mm/Makefile                 |  3 ++
>  arch/x86/mm/init.c                   |  3 ++
>  arch/x86/mm/kasan_init_64.c          | 59 ++++++++++++++++++++++++++++++++++++
>  arch/x86/realmode/Makefile           |  2 +-
>  arch/x86/realmode/rm/Makefile        |  1 +
>  arch/x86/vdso/Makefile               |  1 +
>  include/linux/kasan.h                |  3 ++
>  lib/Kconfig.kasan                    |  1 +
>  18 files changed, 135 insertions(+), 3 deletions(-)
>  create mode 100644 arch/x86/include/asm/kasan.h
>  create mode 100644 arch/x86/mm/kasan_init_64.c

This probably deserves an update of Documentation/x86/x86_64/mm.txt, too.

> +void __init kasan_map_shadow(void)
> +{
> +	int i;
> +
> +	memcpy(early_level4_pgt, init_level4_pgt, 4096);
> +	load_cr3(early_level4_pgt);
> +
> +	clear_zero_shadow_mapping(kasan_mem_to_shadow(PAGE_OFFSET),
> +				kasan_mem_to_shadow(0xffffc80000000000UL));

This 0xffffc80000000000UL could be PAGE_OFFSET+MAXMEM.


