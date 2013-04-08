Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936445Ab3DHKRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:17:06 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33842 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935542Ab3DHJvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:42 -0400
Message-ID: <1365414692.2753.83.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [PATCH cpuset] Use rebuild_sched_domains() in
 cpuset_hotplug_workfn()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org
Date: Mon, 08 Apr 2013 17:51:32 +0800
In-Reply-To: <515BF737.7070105@huawei.com>
References: <1364886990.5859.12.camel@ThinkPad-T5421.cn.ibm.com>
	 <515BF737.7070105@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040809-2674-0000-0000-00000882F1F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-03 at 17:32 +0800, Li Zefan wrote:
> On 2013/4/2 15:16, Li Zhong wrote:
> > In cpuset_hotplug_workfn(), partition_sched_domains() is called without
> > hotplug lock held, which is actually needed (stated in the function
> > header of partition_sched_domains()). 
> > 
> > This patch tries to use rebuild_sched_domains() to solve the above
> > issue, and makes the code looks a little simpler.
> > 
Hi Zefan, 

Thanks for your quick review.

> I guess you found this just by code inspection, right?

Ah, yes :)

> The change looks fine and safe at a first glance, but we don't have
> time to review the patch for now.
> 
> However I don't know why partition_sched_domains() has to be called
> with hotplug lock held.
> 
> After a quick scan, seems the only place in partition_sched_domains()
> that might need hotplug lock is arch_update_cpu_topology().

and cpu_attach_domain(), which is called by partition_sched_domains()
also states that it needs hotplug lock be held.

It seems that the code is moved out of hotplug critical section after it
is converted to work functions. 

Thanks, Zhong

> 
> It would be better if you had CCed the scheduler guys...They may
> know the answer.
> 
> > Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> > ---
> >  kernel/cpuset.c |   13 ++-----------
> >  1 files changed, 2 insertions(+), 11 deletions(-)
> > 
> > diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> > index 4f9dfe4..515a713 100644
> > --- a/kernel/cpuset.c
> > +++ b/kernel/cpuset.c
> > @@ -2222,17 +2222,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
> >  	flush_workqueue(cpuset_propagate_hotplug_wq);
> >  
> >  	/* rebuild sched domains if cpus_allowed has changed */
> > -	if (cpus_updated) {
> > -		struct sched_domain_attr *attr;
> > -		cpumask_var_t *doms;
> > -		int ndoms;
> > -
> > -		mutex_lock(&cpuset_mutex);
> > -		ndoms = generate_sched_domains(&doms, &attr);
> > -		mutex_unlock(&cpuset_mutex);
> > -
> > -		partition_sched_domains(ndoms, doms, attr);
> > -	}
> > +	if (cpus_updated)
> > +		rebuild_sched_domains();
> >  }
> >  
> 
> 


