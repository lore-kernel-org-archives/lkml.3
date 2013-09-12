Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3ILMmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:42:21 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:50323 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab3ILMmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:42:20 -0400
MIME-Version: 1.0
In-Reply-To: <1378805550-29949-42-git-send-email-mgorman@suse.de>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
	<1378805550-29949-42-git-send-email-mgorman@suse.de>
Date: Thu, 12 Sep 2013 20:42:18 +0800
Message-ID: <CAJd=RBBOHXT=7NGAkLtcOCMna5g2GvaQG-Xc0mzrbp_mOQ4xyw@mail.gmail.com>
Subject: Re: [PATCH 41/50] sched: numa: Use {cpu, pid} to create task groups
 for shared faults
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mel

On Tue, Sep 10, 2013 at 5:32 PM, Mel Gorman <mgorman@suse.de> wrote:
>
> +void task_numa_free(struct task_struct *p)
> +{
> +       struct numa_group *grp = p->numa_group;
> +       int i;
> +
> +       kfree(p->numa_faults);
> +
> +       if (grp) {
> +               for (i = 0; i < 2*nr_node_ids; i++)
> +                       atomic_long_sub(p->numa_faults[i], &grp->faults[i]);
> +
use after free, numa_faults ;/

> +               spin_lock(&grp->lock);
> +               list_del(&p->numa_entry);
> +               grp->nr_tasks--;
> +               spin_unlock(&grp->lock);
> +               rcu_assign_pointer(p->numa_group, NULL);
> +               put_numa_group(grp);
> +       }
> +}
> +
