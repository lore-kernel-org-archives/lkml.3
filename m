Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaAOPCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:02:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbaAOPCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:02:00 -0500
Date: Wed, 15 Jan 2014 16:00:57 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, namhyung@kernel.org, mingo@kernel.org,
        dsahern@gmail.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/6] perf, tools: Support handling complete branch stacks
 as histograms v3
Message-ID: <20140115150057.GB17358@krava.redhat.com>
References: <1389661461-18996-1-git-send-email-andi@firstfloor.org>
 <1389661461-18996-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389661461-18996-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 05:04:17PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>

SNIP

>  
>  int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
>  {
> @@ -1248,9 +1249,98 @@ struct branch_info *machine__resolve_bstack(struct machine *machine,
>  	return bi;
>  }
>  
> +static int add_callchain_ip(struct machine *machine,
> +			    struct thread *thread,
> +			    struct symbol **parent,
> +			    struct addr_location *root_al,
> +			    int cpumode,
> +			    u64 ip)
> +{
> +	struct addr_location al;
> +
> +	al.filtered = false;
> +	al.sym = NULL;
> +	if (cpumode == -1) {
> +		int i;
> +
> +		for (i = 0; i < (int)NCPUMODES && !al.sym; i++) {
> +			/*
> +			 * We cannot use the header.misc hint to determine whether a
> +			 * branch stack address is user, kernel, guest, hypervisor.
> +			 * Branches may straddle the kernel/user/hypervisor boundaries.
> +			 * Thus, we have to try consecutively until we find a match
> +			 * or else, the symbol is unknown
> +			 */
> +			thread__find_addr_location(thread, machine, cpumodes[i],
> +					MAP__FUNCTION,
> +					ip, &al);
> +		}

above code is already in ip__resolve_ams, maybe we could add put this
into separate function like 'thread__find_addr_location_cpumodes'

jirka
