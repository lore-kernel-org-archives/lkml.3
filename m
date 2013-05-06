Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3EFMyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:54:00 -0400
Received: from ozlabs.org ([203.10.76.45]:43425 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab3EFMx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:53:58 -0400
Message-ID: <1367844836.26741.1.camel@concordia>
Subject: Re: [PATCH] powerpc, perf: Clear out branch entries to avoid any
 previous stale values
From: Michael Ellerman <michael@ellerman.id.au>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org,
        benh@kernel.crashing.org
Date: Mon, 06 May 2013 22:53:56 +1000
In-Reply-To: <1367827480-5375-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1367827480-5375-1-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-06 at 13:34 +0530, Anshuman Khandual wrote:
> The 'to' field inside branch entries might contain stale values from previous
> PMU interrupt instances which had indirect branches. So clear all the values
> before reading a fresh set of BHRB entries after a PMU interrupt.
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  arch/powerpc/perf/core-book3s.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
> index c627843..09db68d 100644
> --- a/arch/powerpc/perf/core-book3s.c
> +++ b/arch/powerpc/perf/core-book3s.c
> @@ -1590,6 +1590,8 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
>  		if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK) {
>  			struct cpu_hw_events *cpuhw;
>  			cpuhw = &__get_cpu_var(cpu_hw_events);
> +			memset(cpuhw->bhrb_entries, 0,
> +				sizeof(struct perf_branch_entry) * BHRB_MAX_ENTRIES);
>  			power_pmu_bhrb_read(cpuhw);
>  			data.br_stack = &cpuhw->bhrb_stack;
>  		}

Wouldn't it be just as effective, and less overhead, to set .to = 0; in
the else branch in power_pmu_bhrb_read() ?

eg:

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index c627843..30af11a4 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1516,6 +1516,7 @@ void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
                        } else {
                                /* Update address, flags for current entry */
                                cpuhw->bhrb_entries[u_index].from = addr;
+                               cpuhw->bhrb_entries[u_index].to = 0;
                                cpuhw->bhrb_entries[u_index].mispred = pred;
                                cpuhw->bhrb_entries[u_index].predicted = ~pred;
 

cheers



