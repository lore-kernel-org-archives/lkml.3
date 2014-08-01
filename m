Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbaHAUKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:10:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbaHAUKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:10:51 -0400
Date: Fri, 1 Aug 2014 13:10:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org, Chris Zankel <chris@zankel.net>,
        Marc Gauthier <marc@cadence.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Steven Hill <Steven.Hill@imgtec.com>
Subject: Re: [PATCH v3 1/2] mm/highmem: make kmap cache coloring aware
Message-Id: <20140801131049.e94e0e6daec0180ac0236f68@linux-foundation.org>
In-Reply-To: <1406317427-10215-2-git-send-email-jcmvbkbc@gmail.com>
References: <1406317427-10215-1-git-send-email-jcmvbkbc@gmail.com>
	<1406317427-10215-2-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014 23:43:46 +0400 Max Filippov <jcmvbkbc@gmail.com> wrote:

> VIPT cache with way size larger than MMU page size may suffer from
> aliasing problem: a single physical address accessed via different
> virtual addresses may end up in multiple locations in the cache.
> Virtual mappings of a physical address that always get cached in
> different cache locations are said to have different colors.
> L1 caching hardware usually doesn't handle this situation leaving it
> up to software. Software must avoid this situation as it leads to
> data corruption.
> 
> One way to handle this is to flush and invalidate data cache every time
> page mapping changes color. The other way is to always map physical page
> at a virtual address with the same color. Low memory pages already have
> this property. Giving architecture a way to control color of high memory
> page mapping allows reusing of existing low memory cache alias handling
> code.
> 
> Provide hooks that allow architectures with aliasing cache to align
> mapping address of high pages according to their color. Such architectures
> may enforce similar coloring of low- and high-memory page mappings and
> reuse existing cache management functions to support highmem.
> 
> This code is based on the implementation of similar feature for MIPS by
> Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>.
> 

It's worth mentioning that xtensa needs this.

What is (still) missing from these changelogs is a clear description of
the end-user visible effects.  Does it fix some bug?  If so what?  Is
it a performace optimisation?  If so how much?  This info is the
top-line reason for the patchset and should be presented as such.

> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -28,6 +28,9 @@
>  #include <linux/highmem.h>
>  #include <linux/kgdb.h>
>  #include <asm/tlbflush.h>
> +#ifdef CONFIG_HIGHMEM
> +#include <asm/highmem.h>
> +#endif

Should be unneeded - the linux/highmem.h inclusion already did this.

Apart from that it all looks OK to me.  I'm assuming this is 3.17-rc1
material, but I am unsure because of the missing end-user-impact info. 
If it's needed in earlier kernels then we can tag it for -stable
backporting but again, the -stable team (ie: Greg) will want so see the
justification for that backport.
