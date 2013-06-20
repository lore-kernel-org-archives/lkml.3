Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935509Ab3FTBlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:41:32 -0400
Received: from ozlabs.org ([203.10.76.45]:58412 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935237Ab3FTBlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:41:31 -0400
Message-ID: <1371692489.21846.14.camel@concordia>
Subject: Re: [PATCH 2/2] perf tools: Make Power7 events available for perf
From: Michael Ellerman <michael@ellerman.id.au>
To: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, sukadev@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, icycoder@gmail.com
Date: Thu, 20 Jun 2013 11:41:29 +1000
In-Reply-To: <1371633326-7696-2-git-send-email-runzhen@linux.vnet.ibm.com>
References: <1371633326-7696-1-git-send-email-runzhen@linux.vnet.ibm.com>
	 <1371633326-7696-2-git-send-email-runzhen@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 17:15 +0800, Runzhen Wang wrote:
> Power7 supports over 530 different perf events but only a small
> subset of these can be specified by name, for the remaining
> events, we must specify them by their raw code:
> 
>         perf stat -e r2003c <application>
> 
> This patch makes all the POWER7 events available in sysfs.
> So we can instead specify these as:
> 
>         perf stat -e 'cpu/PM_CMPLU_STALL_DFU/' <application>
> 
> where PM_CMPLU_STALL_DFU is the r2003c in previous example.
> 
> Before this patch is applied, the size of power7-pmu.o is:
> 
> $ size arch/powerpc/perf/power7-pmu.o
>    text	   data	    bss	    dec	    hex	filename
>    3073	   2720	      0	   5793	   16a1	arch/powerpc/perf/power7-pmu.o
> 
> and after the patch is applied, it is:
> 
> $ size arch/powerpc/perf/power7-pmu.o
>    text	   data	    bss	    dec	    hex	filename
>   14451	  31112	      0	  45563	   b1fb	arch/powerpc/perf/power7-pmu.o

OK so that's ~38K. Which is not terrible.

Can you measure the runtime overhead as well. I suspect it will be more.


You'll notice below that each event name is repeated four times, which
for 530 events is a bit ugly.

I think we should be able to do something better using the C
preprocessor, this is exactly the sort of thing it's good at.

What I mean is something like we do with arch/powerpc/include/asm/systbl.h,
where we define the list of syscalls once, and then include it in
multiple places, using different macro definitions to get different
outputs.

So perhaps you'd define the list of events like:

#define EVENT(PM_CMPLU_STALL_FXU, 0x20014)
#define EVENT(PM_CMPLU_STALL_DIV, 0x40014)

etc.

Then you do something approximately like:

#define EVENT(_name, _code)	POWER_EVENT_ATTR(_name, _code)
#include "event-list.h"
#undef EVENT

#define EVENT(_name, _code)	POWER_EVENT_PTR(_name)

static struct attribute *power7_events_attr[] = {
#include "event-list.h"
};


You will obviously need to rework the POWER_EVENT macros to make that
work, but it should be possible.

The end result will be we have a single list of the events which we can
check for accuracy once. And we can be sure that there are no mixups
between events.


> diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
> index d1821b8..55e2404 100644
> --- a/arch/powerpc/perf/power7-pmu.c
> +++ b/arch/powerpc/perf/power7-pmu.c
> @@ -53,37 +53,544 @@
>  /*
>   * Power7 event codes.
>   */

...

> +#define PME_PM_MRK_DERAT_MISS_64K                 0x2d05c
> +#define PME_PM_INST_PTEG_FROM_DL2L3_MOD           0x4e054
> +#define PME_PM_L2_ST_MISS                         0x26082
> +#define PME_PM_MRK_PTEG_FROM_L21_SHR              0x4d056
> +#undef  LWSYNC
    ^
What is this doing here?

That is not your macro to undefine. Please be more careful.

> +#define PME_PM_LWSYNC                             0xd094



cheers

