Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab3GQCRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 22:17:31 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:61405 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3GQCRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 22:17:30 -0400
MIME-Version: 1.0
In-Reply-To: <1373901620-2021-10-git-send-email-mgorman@suse.de>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
	<1373901620-2021-10-git-send-email-mgorman@suse.de>
Date: Wed, 17 Jul 2013 10:17:29 +0800
Message-ID: <CAJd=RBDhYMifi8hp7dX5TQrAegNwmaU9wYPtHCjBv5Dhp1E4BQ@mail.gmail.com>
Subject: Re: [PATCH 09/18] sched: Add infrastructure for split shared/private
 accounting of NUMA hinting faults
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 11:20 PM, Mel Gorman <mgorman@suse.de> wrote:
>  /*
>   * Got a PROT_NONE fault for a page on @node.
>   */
> -void task_numa_fault(int node, int pages, bool migrated)
> +void task_numa_fault(int last_nid, int node, int pages, bool migrated)

For what is the new parameter?

>  {
>         struct task_struct *p = current;
> +       int priv;
>
>         if (!sched_feat_numa(NUMA))
>                 return;
>
> +       /* For now, do not attempt to detect private/shared accesses */
> +       priv = 1;
> +
>         /* Allocate buffer to track faults on a per-node basis */
>         if (unlikely(!p->numa_faults)) {
> -               int size = sizeof(*p->numa_faults) * nr_node_ids;
> +               int size = sizeof(*p->numa_faults) * 2 * nr_node_ids;
>
>                 /* numa_faults and numa_faults_buffer share the allocation */
>                 p->numa_faults = kzalloc(size * 2, GFP_KERNEL);
> @@ -900,7 +915,7 @@ void task_numa_fault(int node, int pages, bool migrated)
>                         return;
>
>                 BUG_ON(p->numa_faults_buffer);
> -               p->numa_faults_buffer = p->numa_faults + nr_node_ids;
> +               p->numa_faults_buffer = p->numa_faults + (2 * nr_node_ids);
>         }
>
>         /*
> @@ -914,7 +929,7 @@ void task_numa_fault(int node, int pages, bool migrated)
>         task_numa_placement(p);
>
>         /* Record the fault, double the weight if pages were migrated */
> -       p->numa_faults_buffer[node] += pages << migrated;
> +       p->numa_faults_buffer[task_faults_idx(node, priv)] += pages << migrated;
>  }
>
