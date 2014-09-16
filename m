Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaIPXtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:49:09 -0400
Received: from www.sr71.net ([198.145.64.142]:54518 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753032AbaIPXtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:49:07 -0400
Message-ID: <5418CC6F.2040803@sr71.net>
Date: Tue, 16 Sep 2014 16:49:03 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@linux.intel.com,
        ak@linux.intel.com, Alex Chiang <achiang@hp.com>,
        Borislav Petkov <bp@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Mike Travis <travis@sgi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH] x86: Consider multiple nodes in a single socket to be
 "sane"
References: <20140915222641.D640BD8A@viggo.jf.intel.com> <20140916032920.GH2840@worktop.localdomain> <5417F228.9060301@sr71.net> <20140916175851.GC2848@worktop.localdomain>
In-Reply-To: <20140916175851.GC2848@worktop.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 10:58 AM, Peter Zijlstra wrote:
> the 'problem' is that we currently have the static order of
> the masks, if we were to flip the MC and NUMA masks we need a condition
> to do that on and make sure everything is aware of that.
> 
> CoD not being detectable sucks arse for sure :/

It's not like we can't detect it.  We just can't detect it *explicitly*.
 I think when we see nodes inside a package now, we have to trust that
they're OK.

One other data point here.  With an unpatched mainline, here's how the
sched domains look with cluster-on-die enabled:

# grep . /proc/sys/kernel/sched_domain/cpu9/domain?/name
/proc/sys/kernel/sched_domain/cpu9/domain0/name:SMT  // 2 threads
/proc/sys/kernel/sched_domain/cpu9/domain1/name:MC   // 18 threads cores
/proc/sys/kernel/sched_domain/cpu9/domain2/name:NUMA // 36 threads
/proc/sys/kernel/sched_domain/cpu9/domain3/name:NUMA // 72 threads

and with cluster-on-die disabled:

# grep . /proc/sys/kernel/sched_domain/cpu9/domain?/name
/proc/sys/kernel/sched_domain/cpu9/domain0/name:SMT
/proc/sys/kernel/sched_domain/cpu9/domain1/name:MC
/proc/sys/kernel/sched_domain/cpu9/domain2/name:NUMA

So, shockingly, the domains seem to be set up at at least conceptually
OK in both cases.

I think the domains in this case should _probably_ be conceptually:

	SMT -> COD_NUMA -> PKG -> SOCKET_NUMA

We could probably rig up sched_init_numa() to mix topology levels
between the ones that come out of sched_domain_topology and the NUMA
levels, although that doesn't sound very appealing.

Another option would be to:
1. Add a new "PKG" level and actually _build_ it with phys_proc_id
2. Make sure to tie the sysfs 'core_siblings' file to PKG
3. Leave the "MC" level as it is now, but define it as being the lowest-
   common-denominator of core grouping.  In other words, the "MC" group
   will stop at a NUMA node or a socket boundary, whichever it sees
   first.
4. Chop the "COD_NUMA" level off in sched_init_numa()

That seems a bit hackish though.
