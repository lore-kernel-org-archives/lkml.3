Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935256Ab3GSHqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:46:49 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33431 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab3GSHq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:46:29 -0400
Date: Fri, 19 Jul 2013 09:46:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH] perf, x86: Enable PEBS mode automatically for
 mem-{loads,stores} v3
Message-ID: <20130719074625.GB22597@gmail.com>
References: <1374188619-19220-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374188619-19220-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> [The patch to enable this in the user tools has been sent separately]
> 
> With the earlier patches to automatically try cpu// and add
> a precise sys attribute, we can now enable PEBS for the mem-loads,
> mem-stores events everywhere.
> 
> This allows to use
> 
> perf record -e mem-loads ...
> 
> instead of
> 
> perf record -e cpu/mem-loads/p ...
> 
> Always use precise=2 even though it is costly pre-Haswell
> 
> Cc: eranian@google.com
> v2: Different white space
> v3: Always use precise=2, as people seem to think overhead doesn't matter.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index fbc9210..ef9236b 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -176,9 +176,12 @@ static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
>  	EVENT_EXTRA_END
>  };
>  
> -EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
> -EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
> -EVENT_ATTR_STR(mem-stores, mem_st_snb, "event=0xcd,umask=0x2");
> +EVENT_ATTR_STR(mem-loads, mem_ld_nhm,
> +		"event=0x0b,umask=0x10,ldlat=3,precise=2");
> +EVENT_ATTR_STR(mem-loads, mem_ld_snb,
> +		"event=0xcd,umask=0x1,ldlat=3,precise=2");
> +EVENT_ATTR_STR(mem-stores, mem_st_snb,
> +		"event=0xcd,umask=0x2,precise=2");

Note that here while checkpatch.pl warns about an overlong line, it's 
pointless to break the line because the result is not improved. Just keep 
the line overlong in such cases.

checkpatch is a discretionary tool: if it warns then check the place, 
improve it checkpatch is right and if an improvement is possible - don't 
make the code harder to read just to placate the checkpatch warning.

> @@ -2034,8 +2037,9 @@ static __init void intel_nehalem_quirk(void)
>  	}
>  }
>  
> -EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,     "event=0xcd,umask=0x1,ldlat=3");
> -EVENT_ATTR_STR(mem-stores,     mem_st_hsw,     "event=0xd0,umask=0x82")
> +EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,
> +		"event=0xcd,umask=0x1,ldlat=3,precise=2");

Ditto.

Thanks,

	Ingo
