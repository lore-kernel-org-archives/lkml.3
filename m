Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaJVO7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:59:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaJVO7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:59:08 -0400
Date: Wed, 22 Oct 2014 16:58:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, kan.liang@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v2 11/12] perf/x86: make HT bug workaround conditioned on
 HT enabled
Message-ID: <20141022145804.GC15126@krava.brq.redhat.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
 <1412872486-2930-12-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412872486-2930-12-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 06:34:45PM +0200, Stephane Eranian wrote:

SNIP

> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -12,6 +12,7 @@
>  #include <linux/init.h>
>  #include <linux/slab.h>
>  #include <linux/export.h>
> +#include <linux/watchdog.h>
>  
>  #include <asm/cpufeature.h>
>  #include <asm/hardirq.h>
> @@ -1811,7 +1812,7 @@ intel_start_scheduling(struct cpu_hw_events *cpuc)
>  	/*
>  	 * nothing needed if in group validation mode
>  	 */
> -	if (cpuc->is_fake)
> +	if (cpuc->is_fake || !is_ht_workaround_enabled())
>  		return;
>  	/*
>  	 * no exclusion needed
> @@ -1849,8 +1850,9 @@ intel_stop_scheduling(struct cpu_hw_events *cpuc)
>  	/*
>  	 * nothing needed if in group validation mode
>  	 */
> -	if (cpuc->is_fake)
> +	if (cpuc->is_fake || !is_ht_workaround_enabled())
>  		return;


Is it possible to change is_ht_workaround_enabled() result within
intel_start_scheduling and intel_stop_scheduling time frame? like
following would happen:


  is_ht_workaround_enabled == 1

  intel_start_scheduling -> spin_lock(&excl_cntrs->lock);

  # echo 0 > /sys/devices/cpu/ht_bug_workaround

  is_ht_workaround_enabled == 0

  intel_stop_scheduling -> wont call spin_unlock(&excl_cntrs->lock)


for some reason I can't get HT enabled on my HSW server, so I cannot try ;-)

jirka
