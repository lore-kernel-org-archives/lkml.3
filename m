Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaCGBhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:37:18 -0500
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:51534 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaCGBhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:37:16 -0500
Message-ID: <1394156230.2555.19.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 5/7] x86: mm: new tunable for single vs full TLB flush
From: Davidlohr Bueso <davidlohr@hp.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ak@linux.intel.com, kirill.shutemov@linux.intel.com, mgorman@suse.de,
        alex.shi@linaro.org, x86@kernel.org, linux-mm@kvack.org,
        dave.hansen@linux.intel.com
Date: Thu, 06 Mar 2014 17:37:10 -0800
In-Reply-To: <20140306004527.6C232C54@viggo.jf.intel.com>
References: <20140306004519.BBD70A1A@viggo.jf.intel.com>
	 <20140306004527.6C232C54@viggo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 16:45 -0800, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> +
> +If you believe that invlpg is being called too often, you can
> +lower the tunable:
> +
> +	/sys/debug/kernel/x86/tlb_single_page_flush_ceiling
> +

Whenever this tunable needs to be updated, most users will not know what
a invlpg is and won't think in terms of pages either. How about making
this in units of Kb instead? But then again most of those users won't be
looking into tlb flushing issues anyways, so...

While obvious, tt should also mention that this does not apply to
hugepages.

> +This will cause us to do the global flush for more cases.
> +Lowering it to 0 will disable the use of invlpg.
> +
> +You might see invlpg inside of flush_tlb_mm_range() show up in
> +profiles, or you can use the trace_tlb_flush() tracepoints. to
> +determine how long the flush operations are taking.
> +
> +Essentially, you are balancing the cycles you spend doing invlpg
> +with the cycles that you spend refilling the TLB later.
> +
> +You can measure how expensive TLB refills are by using
> +performance counters and 'perf stat', like this:
> +
> +perf stat -e
> +	cpu/event=0x8,umask=0x84,name=dtlb_load_misses_walk_duration/,
> +	cpu/event=0x8,umask=0x82,name=dtlb_load_misses_walk_completed/,
> +	cpu/event=0x49,umask=0x4,name=dtlb_store_misses_walk_duration/,
> +	cpu/event=0x49,umask=0x2,name=dtlb_store_misses_walk_completed/,
> +	cpu/event=0x85,umask=0x4,name=itlb_misses_walk_duration/,
> +	cpu/event=0x85,umask=0x2,name=itlb_misses_walk_completed/
> +
> +That works on an IvyBridge-era CPU (i5-3320M).  Different CPUs
> +may have differently-named counters, but they should at least
> +be there in some form.  You can use pmu-tools 'ocperf list'
> +(https://github.com/andikleen/pmu-tools) to find the right
> +counters for a given CPU.
> +
> _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


