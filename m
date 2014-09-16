Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaIPD3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 23:29:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaIPD3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 23:29:23 -0400
Date: Tue, 16 Sep 2014 05:29:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
        andreas.herrmann3@amd.com, mingo@kernel.org, hpa@linux.intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
Message-ID: <20140916032920.GH2840@worktop.localdomain>
References: <20140915222641.D640BD8A@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915222641.D640BD8A@viggo.jf.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 03:26:41PM -0700, Dave Hansen wrote:
> 
> I'm getting the spew below when booting with Haswell (Xeon
> E5-2699) CPUs and the "Cluster-on-Die" (CoD) feature enabled in
> the BIOS. 

What is that cluster-on-die thing? I've heard it before but never could
find anything on it.

> This also fixes sysfs because CPUs with the same 'physical_package_id'
> in /sys/devices/system/cpu/cpu*/topology/ are not listed together
> in the same 'core_siblings_list'.  This violates a statement from
> Documentation/ABI/testing/sysfs-devices-system-cpu:
> 
> 	core_siblings: internal kernel map of cpu#'s hardware threads
> 	within the same physical_package_id.
> 
> 	core_siblings_list: human-readable list of the logical CPU
> 	numbers within the same physical_package_id as cpu#.

No that statement is wrong; it assumes physical_package_id is a good
identifier for nodes. Clearly this is no longer true.

The idea is that core_siblings (or rather cpu_core_mask) is a mask of
all cores on a node. 

> The sysfs effects here cause an issue with the hwloc tool where
> it gets confused and thinks there are more sockets than are
> physically present.

Meh, so then we need another mask.

The important bit you didn't show was the scheduler domain setup. I
suspect it all works by accident, not by design.

> diff -puN arch/x86/kernel/smpboot.c~hsw-cod-is-sane arch/x86/kernel/smpboot.c
> --- a/arch/x86/kernel/smpboot.c~hsw-cod-is-sane	2014-09-15 14:56:20.012314468 -0700
> +++ b/arch/x86/kernel/smpboot.c	2014-09-15 14:58:58.837506644 -0700
> @@ -344,10 +344,13 @@ static bool match_llc(struct cpuinfo_x86
>  static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
>  {
>  	if (c->phys_proc_id == o->phys_proc_id) {
> -		if (cpu_has(c, X86_FEATURE_AMD_DCM))
> -			return true;
> -
> -		return topology_sane(c, o, "mc");
> +		/*
> +		 * We used to enforce that 'c' and 'o' be on the
> +		 * same node, but AMD's DCM and Intel's Cluster-
> +		 * on-Die (CoD) support both have physical
> +		 * processors that span NUMA nodes.
> +		 */
> +		return true;
>  	}
>  	return false;
>  }

This is wrong (and I suppose the AMD case was already wrong). That
function is supposed to match a multi-core group which is very much
supposed to be smaller-or-equal to a node, not spanning nodes.

The scheduler assumes: SMT <= LLC <= MC <= NODE and if setting the MC
mask to cover multiple nodes works, its by accident.
