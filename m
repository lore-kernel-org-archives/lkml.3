Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3C3RVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 13:21:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42832 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757089Ab3C3RVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 13:21:05 -0400
X-IronPort-AV: E=Sophos;i="4.87,379,1363104000"; 
   d="scan'208";a="6974949"
Message-ID: <51571FA2.2050804@cn.fujitsu.com>
Date: Sun, 31 Mar 2013 01:23:46 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <eag0628@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v4 13/14] workqueue: implement NUMA affinity for unbound
 workqueues
References: <1364453020-2829-1-git-send-email-tj@kernel.org>	<1364453020-2829-14-git-send-email-tj@kernel.org>	<20130329224434.GC9862@htj.dyndns.org>	<CACvQF50c3m3eMiGKctagoOe6s3uhehfFy733imBfnLKTXSqZ4A@mail.gmail.com> <CAOS58YOgwB4s4-2e528T6SV36pDxLS3Zx+b5eR0L2kQjiZBEnw@mail.gmail.com>
In-Reply-To: <CAOS58YOgwB4s4-2e528T6SV36pDxLS3Zx+b5eR0L2kQjiZBEnw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/31 01:20:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/31 01:20:09,
	Serialize complete at 2013/03/31 01:20:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/03/13 00:32, Tejun Heo wrote:
> Hello, Lai.
> 
> 
> On Sat, Mar 30, 2013 at 9:13 AM, Lai Jiangshan <eag0628@gmail.com <mailto:eag0628@gmail.com>> wrote:
> 
> 
>         +       /* all pwqs have been created successfully, let's install'em */
>                 mutex_lock(&wq->mutex);
> 
>                 copy_workqueue_attrs(wq->unbound_attrs, new_attrs);
>         +
>         +       /* save the previous pwq and install the new one */
>                 for_each_node(node)
>         -               last_pwq = numa_pwq_tbl_install(wq, node, pwq);
>         +               pwq_tbl[node] = numa_pwq_tbl_install(wq, node, pwq_tbl[node]);
>         +
>         +       /* @dfl_pwq might not have been used, ensure it's linked */
>         +       link_pwq(dfl_pwq);
>         +       swap(wq->dfl_pwq, dfl_pwq);
> 
>                 mutex_unlock(&wq->mutex);
> 
>         -       put_pwq_unlocked(last_pwq);
>         +       /* put the old pwqs */
>         +       for_each_node(node)
>         +               put_pwq_unlocked(pwq_tbl[node]);
>         +       put_pwq_unlocked(dfl_pwq);
>         +
>         +       put_online_cpus();
>                 return 0;
> 
> 
> 
>     Forgot to free new_attrs in previous patch
>     (workqueue: fix unbound workqueue attrs hashing / comparison).
> 
>     Forgot to free tmp_attrs, pwq_tbl in this patch.
> 
> 
> Right, will fix. 
> 
>         +retry:
>         +       mutex_lock(&wq->mutex);
>         +
>         +       copy_workqueue_attrs(target_attrs, wq->unbound_attrs);
>         +       pwq = unbound_pwq_by_node(wq, node);
>         +
>         +       /*
>         +        * Let's determine what needs to be done.  If the target cpumask is
>         +        * different from wq's, we need to compare it to @pwq's and create
>         +        * a new one if they don't match.  If the target cpumask equals
>         +        * wq's, the default pwq should be used.  If @pwq is already the
>         +        * default one, nothing to do; otherwise, install the default one.
>         +        */
>         +       if (wq_calc_node_cpumask(wq->unbound_attrs, node, cpu_off, cpumask)) {
>         +               if (cpumask_equal(cpumask, pwq->pool->attrs->cpumask))
>         +                       goto out_unlock;
>         +       } else if (pwq != wq->dfl_pwq) {
>         +               goto use_dfl_pwq;
>         +       } else {
>         +               goto out_unlock;
>         +       }
>         +
>         +       /*
>         +        * Have we already created a new pwq?  As we could have raced with
>         +        * apply_workqueue_attrs(), verify that its attrs match the desired
>         +        * one before installing.
>         +        */
> 
> 
>     I don't see any race since there is get/put_online_cpu() in apply_workqueue_attrs().
> 
> 
> I don't know. I kinda want wq exclusion to be self-contained, but yeah the hotplug exclusion here is *almost* explicit so maybe it would be better to depend on it. Will think about it.
> 
>         +       mutex_unlock(&wq->mutex);
>         +       put_pwq_unlocked(old_pwq);
>         +       free_unbound_pwq(new_pwq);
>         +}
> 
> 
>     OK, your solution is what I suggested: swapping dfl_pwq <-> node pwq.
>     But when the last cpu of the node(of the wq) is trying to offline.
>     you need to handle the work items of node pwq(old_pwq in the code).
> 
>     you may handle the works which are still queued by migrating, OR by
>     flushing the works.
>     and you may handle busy works by temporary changing the cpumask of
>     the workers, OR by flushing the busy works.
> 
> 
> I don't think that's necessary.

Please document it.

> It's not like we have hard guarantee on attr changes anyway.
> Self-requeueing work items can get stuck with old attributes for quite a while,

It is OK for it is documented.

> and even per-cpu work items get migrated to other CPUs on CPU DOWN.

It is expected.

But for unbound wq when cpuhotplug
w/o NUMA affinity, works are    always   in the cpus  if   there is online cpu in wq's cpumask
w/ NUMA affinity, .........   NOT always ........     even ....................................

> Workqueue's affinity guarantee is very specific - the work item owner is
> responsible for flushing the work item during CPU DOWN if it wants
> to guarantee affinity over full execution. 

Could you add the comments and add Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
for the patchset?

Thanks,
Lai

