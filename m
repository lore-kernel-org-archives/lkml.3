Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaGKIPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:15:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaGKIPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:15:42 -0400
Date: Fri, 11 Jul 2014 10:15:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH 2/4] perf/x86: add support for sampling PEBS machine
 state registers
Message-ID: <20140711081510.GC21557@krava.redhat.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
 <1404857759-25105-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404857759-25105-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:15:57AM +0200, Stephane Eranian wrote:
> PEBS can capture machine state regs at retirement of the sampled
> instructions. When precise sampling is enabled on an event, PEBS
> is used, so substitute the interrupted state with the PEBS state.
> Note that not all registers are captured by PEBS. Those missing
> are replaced by the interrupt state counter-parts.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_ds.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index 980970c..d612bcd 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -925,6 +925,25 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  	regs.bp = pebs->bp;
>  	regs.sp = pebs->sp;
>  
> +	if (sample_type & PERF_SAMPLE_REGS_INTR) {
> +		regs.ax = pebs->ax;
> +		regs.bx = pebs->bx;
> +		regs.cx = pebs->cx;
> +		regs.si = pebs->si;
> +		regs.di = pebs->di;
> +
> +		regs.r8 = pebs->r8;
> +		regs.r9 = pebs->r9;
> +		regs.r10 = pebs->r10;
> +		regs.r11 = pebs->r11;
> +		regs.r12 = pebs->r12;
> +		regs.r13 = pebs->r13;
> +		regs.r14 = pebs->r14;
> +		regs.r14 = pebs->r15;
> +
> +		data.regs_intr.regs = &regs;

this assignement is not necessary, because you assign this regs pointer
again in perf_prepare_sample -> perf_sample_regs_intr later

jirka
