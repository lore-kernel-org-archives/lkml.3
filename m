Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaEPJ5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:57:41 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:56620 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbaEPJ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:57:38 -0400
MIME-Version: 1.0
X-Originating-IP: [217.156.156.35]
In-Reply-To: <tip-143e1e28cb40bed836b0a06567208bd7347c9672@git.kernel.org>
References: <1397209481-28542-2-git-send-email-vincent.guittot@linaro.org>
	<tip-143e1e28cb40bed836b0a06567208bd7347c9672@git.kernel.org>
Date: Fri, 16 May 2014 10:57:37 +0100
X-Google-Sender-Auth: 6LnsIy_bJdsrFzPHqNkavA9S6iQ
Message-ID: <CAAG0J9915TAT-9JUjz5cMQ_ze7jayhNpKpjZdCZG9JzW1ocBsA@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Rework sched_domain topology definition
From: James Hogan <james.hogan@imgtec.com>
To: mingo@kernel.org, hanjun.guo@linaro.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, schwidefsky@de.ibm.com,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        jason.low2@hp.com, tony.luck@intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, heiko.carstens@de.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        dietmar.eggemann@arm.com, "David S. Miller" <davem@davemloft.net>,
        bhelgaas@google.com, benh@kernel.crashing.org,
        preeti@linux.vnet.ibm.com, fenghua.yu@intel.com,
        vincent.guittot@linaro.org
Cc: linux-tip-commits@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        metag <linux-metag@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On 8 May 2014 11:43, tip-bot for Vincent Guittot <tipbot@zytor.com> wrote:
> Commit-ID:  143e1e28cb40bed836b0a06567208bd7347c9672
> Gitweb:     http://git.kernel.org/tip/143e1e28cb40bed836b0a06567208bd7347c9672
> Author:     Vincent Guittot <vincent.guittot@linaro.org>
> AuthorDate: Fri, 11 Apr 2014 11:44:37 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 7 May 2014 13:33:49 +0200
>
> sched: Rework sched_domain topology definition
>
> We replace the old way to configure the scheduler topology with a new method
> which enables a platform to declare additionnal level (if needed).
>
> We still have a default topology table definition that can be used by platform
> that don't want more level than the SMT, MC, CPU and NUMA ones. This table can
> be overwritten by an arch which either wants to add new level where a load
> balance make sense like BOOK or powergating level or wants to change the flags
> configuration of some levels.
>
> For each level, we need a function pointer that returns cpumask for each cpu,
> a function pointer that returns the flags for the level and a name. Only flags
> that describe topology, can be set by an architecture. The current topology
> flags are:
>
>  SD_SHARE_CPUPOWER
>  SD_SHARE_PKG_RESOURCES
>  SD_NUMA
>  SD_ASYM_PACKING
>
> Then, each level must be a subset on the next one. The build sequence of the
> sched_domain will take care of removing useless levels like those with 1 CPU
> and those with the same CPU span and no more relevant information for
> load balancing than its children.
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Hanjun Guo <hanjun.guo@linaro.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Jason Low <jason.low2@hp.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: linux390@de.ibm.com
> Cc: linux-ia64@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> Link: http://lkml.kernel.org/r/1397209481-28542-2-git-send-email-vincent.guittot@linaro.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/ia64/include/asm/topology.h |  24 ----
>  arch/s390/include/asm/topology.h |   2 -
>  arch/tile/include/asm/topology.h |  33 ------
>  include/linux/sched.h            |  53 +++++++++
>  include/linux/topology.h         | 128 +++------------------
>  kernel/sched/core.c              | 233 ++++++++++++++++++++-------------------
>  6 files changed, 186 insertions(+), 287 deletions(-)


> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 2a4298f..656b035 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -985,6 +1006,38 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
>
>  bool cpus_share_cache(int this_cpu, int that_cpu);
>
> +typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
> +typedef const int (*sched_domain_flags_f)(void);

I just noticed, since May 9th, linux-next (ARCH=metag, gcc 4.2.4, with
meta2_smp_defconfig) is showing loads of warnings due to the above
line:

include/linux/sched.h +1010 : warning: type qualifiers ignored on
function return type

Looks to me that the const serves no purpose in this context and could
be removed.

Cheers
James
