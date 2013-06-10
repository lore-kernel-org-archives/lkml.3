Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3FJXJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 19:09:16 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33930 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab3FJXJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 19:09:15 -0400
Date: Mon, 10 Jun 2013 16:08:27 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Anton Blanchard <anton@au1.ibm.com>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf/Power7: Save dcache_src fields in sample record.
Message-ID: <20130610230827.GB2666@us.ibm.com>
References: <20130607204008.GA3281@us.ibm.com>
 <CABPqkBTqt5cdD9AHvvzzqcMnvpiQ8iH=3cq0=Y8Edp09KiRPEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTqt5cdD9AHvvzzqcMnvpiQ8iH=3cq0=Y8Edp09KiRPEA@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061023-5806-0000-0000-000021A388B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian [eranian@google.com] wrote:
| > Further, in the above REM_CCE1 case, Power7 can also identify if the data came
| > from the L2 or L3 cache of another core on the same chip. To describe this to
| > user space, we propose to set ->mem_lvl to:
| >
| >         PERF_MEM_LVL_REM_CCE1|PERF_MEM_LVL_L2
| >
| >         PERF_MEM_LVL_REM_CCE1|PERF_MEM_LVL_L3
| 
| 
| Normally, that would be interpreted as:
|     - hit/miss on remote cache (1 hop) OR level 2 cache
| 
| But on PPC7, you're saying that this must be interpreted as:
|     - hit/miss on L2 cache of sibling core

Hmm, my proposed usage is an AND.

Did not realize it was strictly an OR of the levels. If so, we will have
to define and use the extra levels I guess.

BTW, are there architectures that use the OR interpretation - IOW, are
arbitrary combinations like local L1 or a remote 2-hop node's cache used ?

| 
| How do you intend to document this interpretation?

Not sure yet as this is an early patch. 'perf report' man page would be
one place.

Do/should architectures have the flexibility of interpretation ?

Personally, if we cannot interpret them as the AND of two levels, I think
we would be better off defining the new levels below.

| 
| >
| >
| > Either that or we could leave REM_CCE1 unused in Power and add two more levels:
| >
| >         PERF_MEM_XLVL_REM_L2_CCE1
| >         PERF_MEM_XLVL_REM_L3_CCE1
| >
| > The former approach seems less confusing and this patch uses that approach.

<snip>

| > @@ -654,7 +655,7 @@ union perf_mem_data_src {
| >  #define PERF_MEM_LVL_REM_CCE2  0x800 /* Remote Cache (2 hops) */
| >  #define PERF_MEM_LVL_IO                0x1000 /* I/O memory */
| >  #define PERF_MEM_LVL_UNC       0x2000 /* Uncached memory */
| > -#define PERF_MEM_LVL_SHIFT     5
| > +#define PERF_MEM_LVL_SHIFT     5      /* see also extended levels below */
| >
| >  /* snoop mode */
| >  #define PERF_MEM_SNOOP_NA      0x01 /* not available */
| > @@ -679,6 +680,13 @@ union perf_mem_data_src {
| >  #define PERF_MEM_TLB_OS                0x40 /* OS fault handler */
| >  #define PERF_MEM_TLB_SHIFT     26
| >
| > +#define PERF_MEM_XLVL_REM_RAM3 0x01 /* Remote memory (3 hops) */
| > +#define PERF_MEM_XLVL_REM_CCE3 0x02 /* Remote cache (3 hops) */
| > +#define PERF_MEM_XLVL_SHIFT    33
| > +
| 
| You need to define a N/A bit there too.
| Thats' necessary to indicate not available on non PPC architectures,
| such as x86.

Ok.

| 
| >
| > +/* Miscellaneous flags */
| > +#define PERF_MEM_MISC_CCE_MOD  0x4000 /* cache-hit, but entry was modified */
| > +
| Where is that flag used?
| If internal, then it needs to be moved to the internal-only version of
| the header.

It is not internal, but the line snuck in when I was splitting a patch.

It refers to another feature in Power7 that I was trying to map into the
perf_mem_data_src hierarchy. Power7 also indicates whether the entry we
found in the cache was modified or shared.

Like with the HIT or MISS, it would/could be another state associated with
each of the levels:

	PERF_MEM_LVL_REM_CCE1
	PERF_MEM_LVL_REM_CCE2
	PERF_MEM_XLVL_REM_CCE3

I was toying with the idea of setting

	->mem_level = LVL_REM_CCE1|LVL_L2;
	->mem_misc = PERF_MEM_MISC_CCE_MOD;

to say that the cache entry we found in the sibling's L2 core was modified/dirty.
(where ->mem_misc is carved out of the ->mem_rsvd bits).

Will come back to it after addressing the XLVL* part.

Thanks for the comments.

Sukadev

