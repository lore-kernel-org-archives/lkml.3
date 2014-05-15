Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaEOOdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:33:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:49429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbaEOOdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:33:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1059,1389772800"; 
   d="scan'208";a="532450642"
Date: Thu, 15 May 2014 07:32:58 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@ghostprotocols.net, jolsa@redhat.com, jmario@redhat.com,
        dzickus@redhat.com
Subject: Re: [PATCH] perf/x86: fix Haswell precise store data source encoding
Message-ID: <20140515143258.GA19657@tassilo.jf.intel.com>
References: <20140515115337.GA2855@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515115337.GA2855@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 01:53:37PM +0200, Stephane Eranian wrote:
> 
> This patches fixes a bug in  precise_store_data_hsw() whereby
> it would set the data source memory level to the wrong value.
> 
> As per the the SDM Vol 3b Table 18-41 (Layout of Data Linear
> Address Information in PEBS Record), when status bit 0 is set
> this is a L1 hit, otherwise this is a L1 miss. 
> 
> This patch encodes the memory level according to the specification.

It's not enough. as I said it needs more fixes.

For most events it should be _NA, _STORE can be only specified
for the explicit _STORE events.

-Andi

> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index ae96cfa..81424f6 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -114,9 +114,13 @@ static u64 precise_store_data_hsw(u64 status)
>  
>  	dse.val = 0;
>  	dse.mem_op = PERF_MEM_OP_STORE;
> -	dse.mem_lvl = PERF_MEM_LVL_NA;
> +	dse.mem_lvl = PERF_MEM_LVL_L1;
> +
>  	if (status & 1)
> -		dse.mem_lvl = PERF_MEM_LVL_L1;
> +		dse.mem_lvl |= PERF_MEM_LVL_HIT;
> +	else
> +		dse.mem_lvl |= PERF_MEM_LVL_MISS;
> +
>  	/* Nothing else supported. Sorry. */
>  	return dse.val;
>  }

-- 
ak@linux.intel.com -- Speaking for myself only
