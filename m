Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaKXOwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:52:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:47695 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbaKXOwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:52:32 -0500
Date: Mon, 24 Nov 2014 11:52:27 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>
Subject: probe + report for following branch history. was Re: [PATCH 1/2]
 perf hists browser: Print overhead percent value for first-level callchain
Message-ID: <20141124145227.GE18625@kernel.org>
References: <1416816807-6495-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416816807-6495-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 24, 2014 at 05:13:26PM +0900, Namhyung Kim escreveu:
> Currently perf report on TUI doesn't print percent for first-level
> callchain entry.  I guess it (wrongly) assumes that there's only a
> single callchain in the first level.  This patch fixes it by handling
> the first level callchains same as others - if it's not 100% it should
> print the percent value.  Also it'll affect other callchains in the
> other way around - if it's 100% (single callchain) it should not print
> the percentage.
> 
> Before:
>   -   30.95%     6.84%  abc2     abc2              [.] a
>      - a

Thanks, with this the --stdio output matches --tui when --branch-history
is used in 'report', will push soon.

One thing I think would be great would be to make it possible to use:

  [root@zoo acme]# perf probe -L get_vma_policy
  <get_vma_policy@/usr/src/debug/kernel-3.17.fc20/linux-3.17.2-200.fc20.x86_64/mm/mempolicy.c:0>
        0  struct mempolicy *get_vma_policy(struct task_struct *task,
                          struct vm_area_struct *vma, unsigned long addr)
        2  {
        3         struct mempolicy *pol = get_task_policy(task);
           
        5         if (vma) {
        6                 if (vma->vm_ops && vma->vm_ops->get_policy) {
        7                         struct mempolicy *vpol = vma->vm_ops->get_policy(vma,
                                                                                  addr);
        9                         if (vpol)
                                          pol = vpol;
       11                 } else if (vma->vm_policy) {
                                  pol = vma->vm_policy;
         
                                  /*
                                   * shmem_alloc_page() passes
                                   * MPOL_F_SHARED policy with
                                   * a pseudo vma whose vma->vm_ops=NULL.
                                   * Take a reference
                                   * count on these policies which will be
                                   * dropped by
                                   * mpol_cond_put() later
                                   */
       20                         if (mpol_needs_cond_ref(pol))
       21                                 mpol_get(pol);
                          }
                  }
                  if (!pol)
                          pol = &default_policy;
                  return pol;
       27  }
         
  [root@zoo acme]#

Together with the srcline code, i.e. to allow matching the above with
the output from 'perf report', like here:

     2.40%  mmzone.c:69  [k] next_zones_zonelist            [kernel.vmlinux]
            |
            ---next_zones_zonelist mmzone.c:59
               __alloc_pages_nodemask mmzone.h:1039
               __alloc_pages_nodemask page_alloc.c:2775
               __alloc_pages_nodemask page_alloc.c:2765
               __alloc_pages_nodemask page_alloc.c:2765
               _cond_resched core.c:4180
               _cond_resched core.c:4175
               __alloc_pages_nodemask page_alloc.c:2765
               __alloc_pages_nodemask page_alloc.c:2765
               __alloc_pages_nodemask page_alloc.c:2765
               __alloc_pages_nodemask page_alloc.c:2751
               alloc_pages_vma mempolicy.c:2046
               alloc_pages_vma mempolicy.c:2046
               policy_zonelist mempolicy.c:1735
               policy_zonelist gfp.h:274
               policy_zonelist mempolicy.c:1717
               policy_zonelist mempolicy.c:1717
               policy_zonelist mempolicy.c:1715
               policy_zonelist mempolicy.c:1714
               alloc_pages_vma mempolicy.c:2046
               alloc_pages_vma mempolicy.c:2046
               policy_nodemask mempolicy.c:1709
               policy_nodemask mempolicy.c:1701
               alloc_pages_vma mempolicy.c:2046
               alloc_pages_vma seqlock.h:111
               get_vma_policy mempolicy.c:1650
               get_vma_policy mempolicy.c:1650
               get_vma_policy mempolicy.c:1634
               get_vma_policy mempolicy.c:1634
               get_vma_policy mempolicy.c:1629
               get_vma_policy mempolicy.c:1628
               get_vma_policy mempolicy.c:134

See the get_vma_policy lines? We need a way to ask both for 'perf probe -L' to
show absolute line numbers and also for the report code to show line numbers as
offsets from function start.

At some point being able to, as IIRC Andi suggested, to show the callchains via
the annotate widget would be fantastic as well, i.e. showing the callchain in a
window and in another window to show it as arrows in the source code, that
would move from function to function as we navigate on the callchain, as we
do already with jumps, calls, rets.

But the absolute line numbers on 'perf probe -L' and the offsets from function
start in 'report' look like low hanging fruits and a way to integrate further
'perf probe' with 'perf report', because both will look at the right file, keyed
by the build-id, etc.

- Arnaldo
