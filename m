Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3CFXMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:12:09 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:65126 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3CFXMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:12:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130306085231.GA4805@gmail.com>
References: <1362546223-20486-1-git-send-email-vlee@twitter.com>
	<20130306085231.GA4805@gmail.com>
Date: Wed, 6 Mar 2013 15:12:03 -0800
Message-ID: <CAKixpbiLtuYW4Tt770EEHxJK03Kq=LKtQzXULb2p5E_zh2Oc4w@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Fix LIBNUMA build with glibc 2.12 and older.
From: Vinson Lee <vlee@twitter.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 12:52 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Vinson Lee <vlee@twitter.com> wrote:
>
>> The tokens MADV_HUGEPAGE and MADV_NOHUGEPAGE are not available with
>> glibc 2.12 and older. Define these tokens if they are not already
>> defined.
>>
>> This patch fixes these build errors with older versions of glibc.
>>
>>     CC bench/numa.o
>> bench/numa.c: In function ???alloc_data???:
>> bench/numa.c:334: error: ???MADV_HUGEPAGE??? undeclared (first use in this function)
>> bench/numa.c:334: error: (Each undeclared identifier is reported only once
>> bench/numa.c:334: error: for each function it appears in.)
>> bench/numa.c:341: error: ???MADV_NOHUGEPAGE??? undeclared (first use in this function)
>> make: *** [bench/numa.o] Error 1
>>
>> Signed-off-by: Vinson Lee <vlee@twitter.com>
>> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Irina Tirdea <irina.tirdea@intel.com>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Pekka Enberg <penberg@kernel.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>
>> ---
>>  tools/perf/bench/bench.h |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
>> index a5223e6..6263f38 100644
>> --- a/tools/perf/bench/bench.h
>> +++ b/tools/perf/bench/bench.h
>> @@ -1,6 +1,13 @@
>>  #ifndef BENCH_H
>>  #define BENCH_H
>>
>> +#ifndef MADV_HUGEPAGE
>> +#define MADV_HUGEPAGE 14
>> +#endif
>> +#ifndef MADV_NOHUGEPAGE
>> +#define MADV_NOHUGEPAGE 15
>> +#endif
>
> Can we ignore Parisc which goes outside the asm-generic values of 14/15 and defines
> these as 67/68?
>
> On Parisc 14 is MADV_16K_PAGES, 15 is unused.
>
> Could we include <uapi/asm/mman.h> instead?
>
> Thanks,
>
>         Ingo

Including <uapi/asm/mman.h> in bench/numa.c also fixes the LIBNUMA
build for me only with WERROR=0. It adds many redefined warnings of
symbols from <sys/mman.h> such as MAP_GROWSDOWN, MAP_DENYWRITE,
MAP_EXECUTABLE. The header <sys/mman.h> cannot be removed as it is
needed for mmap.
