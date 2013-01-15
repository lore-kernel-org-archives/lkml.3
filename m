Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3AOKUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:20:01 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:55890 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab3AOKT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:19:59 -0500
MIME-Version: 1.0
In-Reply-To: <50F41C50.6090000@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
	<1357731938-8417-4-git-send-email-glommer@parallels.com>
	<CAFj3OHW5J8ypLZdW16AfiYR5y2S54mQxm5qka4m_3qsoGdD11A@mail.gmail.com>
	<50F41C50.6090000@parallels.com>
Date: Tue, 15 Jan 2013 18:19:58 +0800
Message-ID: <CAFj3OHWB8GF9UYcLdObptrY+BfB=EEwbBtsf17M1=6qfZt+k6g@mail.gmail.com>
Subject: Re: [PATCH v5 03/11] cgroup, sched: let cpu serve the same files as cpuacct
From: Sha Zhengju <handai.szj@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.cz>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:55 PM, Glauber Costa <glommer@parallels.com> wrote:
> On 01/14/2013 12:34 AM, Sha Zhengju wrote:
>>> +               struct kernel_cpustat *kcpustat = this_cpu_ptr(ca->cpustat);
>>> > +
>>> >                 kcpustat = this_cpu_ptr(ca->cpustat);
>> Is this reassignment unnecessary?
>>
>>
> No.
>

No?  No!

In task_group_account_field(), the following two hunks have the
similar behavior but different codes, there must be a trial in one of
them.

Hunk #1:
+#ifdef CONFIG_CGROUP_SCHED
+       rcu_read_lock();
+       tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
+                         struct task_group, css);

+       while (tg && (tg != &root_task_group)) {
+               struct kernel_cpustat *kcpustat =
this_cpu_ptr(tg->cpustat);   **HERE**
+
+               kcpustat->cpustat[index] += tmp;
+               tg = tg->parent;
+       }
+       rcu_read_unlock();
+#endif

Hunk #2:
#ifdef CONFIG_CGROUP_CPUACCT
        if (unlikely(!cpuacct_subsys.active))
                return;

        rcu_read_lock();
        ca = task_ca(p);
        while (ca && (ca != &root_cpuacct)) {
+               struct kernel_cpustat *kcpustat =
this_cpu_ptr(ca->cpustat); **HERE**
+
                kcpustat = this_cpu_ptr(ca->cpustat);   **HERE, which
is unnecessary**
                kcpustat->cpustat[index] += tmp;
                ca = parent_ca(ca);
        }
        rcu_read_unlock();
#endif


Also you can prove it by the following testcase.
#include <stdio.h>

int main(void)
{
        int i = 0;
        int array[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
        int *index = &array[0];

        while (i < 10) {
                int *ptr = index;

                printf("ptr=%d  %p, index = %d\n", *ptr, ptr, *index);
                index ++;
                i++;
                sleep(1);
        }

        return 0;
}

-- 
Thanks,
Sha
