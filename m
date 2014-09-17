Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbaIQW5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:57:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51596 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbaIQW5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:57:35 -0400
Date: Thu, 18 Sep 2014 00:57:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@linux.intel.com,
        ak@linux.intel.com, Alex Chiang <achiang@hp.com>,
        Borislav Petkov <bp@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Mike Travis <travis@sgi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
Message-ID: <20140917225726.GH2848@worktop.localdomain>
References: <20140915222641.D640BD8A@viggo.jf.intel.com>
 <20140916032920.GH2840@worktop.localdomain>
 <5417F228.9060301@sr71.net>
 <20140916175851.GC2848@worktop.localdomain>
 <5418CC6F.2040803@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5418CC6F.2040803@sr71.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 04:49:03PM -0700, Dave Hansen wrote:
> On 09/16/2014 10:58 AM, Peter Zijlstra wrote:
> > the 'problem' is that we currently have the static order of
> > the masks, if we were to flip the MC and NUMA masks we need a condition
> > to do that on and make sure everything is aware of that.
> > 
> > CoD not being detectable sucks arse for sure :/
> 
> It's not like we can't detect it.  We just can't detect it *explicitly*.

That's still suckage :-)

>  I think when we see nodes inside a package now, we have to trust that
> they're OK.

Its all we can do.

> One other data point here.  With an unpatched mainline, here's how the
> sched domains look with cluster-on-die enabled:
> 
> # grep . /proc/sys/kernel/sched_domain/cpu9/domain?/name
> /proc/sys/kernel/sched_domain/cpu9/domain0/name:SMT  // 2 threads
> /proc/sys/kernel/sched_domain/cpu9/domain1/name:MC   // 18 threads cores
> /proc/sys/kernel/sched_domain/cpu9/domain2/name:NUMA // 36 threads
> /proc/sys/kernel/sched_domain/cpu9/domain3/name:NUMA // 72 threads
> 
> and with cluster-on-die disabled:
> 
> # grep . /proc/sys/kernel/sched_domain/cpu9/domain?/name
> /proc/sys/kernel/sched_domain/cpu9/domain0/name:SMT
> /proc/sys/kernel/sched_domain/cpu9/domain1/name:MC
> /proc/sys/kernel/sched_domain/cpu9/domain2/name:NUMA
> 
> So, shockingly, the domains seem to be set up at at least conceptually
> OK in both cases.

Yeah, it works out by accident. It had to otherwise these patches
wouldn't work.

> We could probably rig up sched_init_numa() to mix topology levels
> between the ones that come out of sched_domain_topology and the NUMA
> levels, although that doesn't sound very appealing.
> 
> Another option would be to:
> 1. Add a new "PKG" level and actually _build_ it with phys_proc_id
> 2. Make sure to tie the sysfs 'core_siblings' file to PKG
> 3. Leave the "MC" level as it is now, but define it as being the lowest-
>    common-denominator of core grouping.  In other words, the "MC" group
>    will stop at a NUMA node or a socket boundary, whichever it sees
>    first.
> 4. Chop the "COD_NUMA" level off in sched_init_numa()

No, we should provide an arch override for sched_domain_topology which
has the right setup for the detected topology.

See arm,powerpc and s390, which already have his.
