Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaGNXdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 19:33:53 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:65329 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaGNXdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 19:33:50 -0400
Date: Mon, 14 Jul 2014 16:33:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
cc: Stephane Eranian <eranian@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, perf: avoid spamming kernel log for bts buffer
 failure
In-Reply-To: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1407141633190.4920@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, David Rientjes wrote:

> It's unnecessary to excessively spam the kernel log anytime the BTS buffer 
> cannot be allocated, so make this allocation __GFP_NOWARN.
> 
> The user probably will want to at least find some artifact that the 
> allocation has failed in the past, probably due to fragmentation because 
> of its large size, when it's not allocated at bootstrap.  Thus, add a 
> WARN_ONCE() so something is left behind for them to understand why perf 
> commnads that require PEBS is not working properly.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Peter, would you like to ack this?  Trying to get this merged in time for 
the next merge window.

> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -311,9 +311,11 @@ static int alloc_bts_buffer(int cpu)
>  	if (!x86_pmu.bts)
>  		return 0;
>  
> -	buffer = kzalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL, node);
> -	if (unlikely(!buffer))
> +	buffer = kzalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL | __GFP_NOWARN, node);
> +	if (unlikely(!buffer)) {
> +		WARN_ONCE(1, "%s: BTS buffer allocation failure\n", __func__);
>  		return -ENOMEM;
> +	}
>  
>  	max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
>  	thresh = max / 16;
