Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3CKIg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:36:57 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:40248 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3CKIg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:36:56 -0400
Date: Mon, 11 Mar 2013 09:36:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vinson Lee <vlee@twitter.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v2] perf tools: Fix LIBNUMA build with glibc 2.12 and
 older.
Message-ID: <20130311083652.GE12742@gmail.com>
References: <CAKixpbiLtuYW4Tt770EEHxJK03Kq=LKtQzXULb2p5E_zh2Oc4w@mail.gmail.com>
 <1362710535-7219-1-git-send-email-vlee@twitter.com>
 <1362710535-7219-2-git-send-email-vlee@twitter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362710535-7219-2-git-send-email-vlee@twitter.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vinson Lee <vlee@twitter.com> wrote:

> The tokens MADV_HUGEPAGE and MADV_NOHUGEPAGE are not available with
> glibc 2.12 and older. Define these tokens if they are not already
> defined.
> 
> This patch fixes these build errors with older versions of glibc.
> 
>     CC bench/numa.o
> bench/numa.c: In function ???alloc_data???:
> bench/numa.c:334: error: ???MADV_HUGEPAGE??? undeclared (first use in this function)
> bench/numa.c:334: error: (Each undeclared identifier is reported only once
> bench/numa.c:334: error: for each function it appears in.)
> bench/numa.c:341: error: ???MADV_NOHUGEPAGE??? undeclared (first use in this function)
> make: *** [bench/numa.o] Error 1
> 
> Signed-off-by: Vinson Lee <vlee@twitter.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Irina Tirdea <irina.tirdea@intel.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  tools/perf/bench/bench.h |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
> index a5223e6..ed4ae8b 100644
> --- a/tools/perf/bench/bench.h
> +++ b/tools/perf/bench/bench.h
> @@ -1,6 +1,22 @@
>  #ifndef BENCH_H
>  #define BENCH_H
>  
> +#ifdef __hppa__
> +#ifndef MADV_HUGEPAGE
> +#define MADV_HUGEPAGE 67
> +#endif
> +#ifndef MADV_NOHUGEPAGE
> +#define MADV_NOHUGEPAGE 68
> +#endif
> +#else
> +#ifndef MADV_HUGEPAGE
> +#define MADV_HUGEPAGE 14
> +#endif
> +#ifndef MADV_NOHUGEPAGE
> +#define MADV_NOHUGEPAGE 15
> +#endif
> +#endif

This looks good to me. Two minor stylistic nits:

 - I think we want a short comment explaining what it's about,
   that this is for old glibc and that hppa messed up its madvise() 
   constants and needs a non-generic kludge.

 - for such multi-level #ifdef blocks we generally prefer this
   more readable form:

#ifdef __hppa__
# ifndef MADV_HUGEPAGE
#  define MADV_HUGEPAGE		67
# endif
# ifndef MADV_NOHUGEPAGE
#  define MADV_NOHUGEPAGE	68
# endif
#else
# ifndef MADV_HUGEPAGE
#  define MADV_HUGEPAGE		14
# endif
# ifndef MADV_NOHUGEPAGE
#  define MADV_NOHUGEPAGE	15
# endif
#endif

Thanks,

	Ingo
