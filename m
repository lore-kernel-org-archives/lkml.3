Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaJPVWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:22:41 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:33800 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaJPVWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:22:39 -0400
MIME-Version: 1.0
In-Reply-To: <20141016211236.GA4308@mail.hallyn.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-8-git-send-email-adityakali@google.com> <20141016211236.GA4308@mail.hallyn.com>
From: Aditya Kali <adityakali@google.com>
Date: Thu, 16 Oct 2014 14:22:18 -0700
Message-ID: <CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 2:12 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Aditya Kali (adityakali@google.com):
>> setns on a cgroup namespace is allowed only if
>> * task has CAP_SYS_ADMIN in its current user-namespace and
>>   over the user-namespace associated with target cgroupns.
>> * task's current cgroup is descendent of the target cgroupns-root
>>   cgroup.
>
> What is the point of this?
>
> If I'm a user logged into
> /lxc/c1/user.slice/user-1000.slice/session-c12.scope and I start
> a container which is in
> /lxc/c1/user.slice/user-1000.slice/session-c12.scope/x1
> then I will want to be able to enter the container's cgroup.
> The container's cgroup root is under my own (satisfying the
> below condition0 but my cgroup is not a descendent of the
> container's cgroup.
>
This condition is there because we don't want to do implicit cgroup
changes when a process attaches to another cgroupns. cgroupns tries to
preserve the invariant that at any point, your current cgroup is
always under the cgroupns-root of your cgroup namespace. But in your
example, if we allow a process in "session-c12.scope" container to
attach to cgroupns root'ed at "session-c12.scope/x1" container
(without implicitly moving its cgroup), then this invariant won't
hold.

>
>> * target cgroupns-root is same as or deeper than task's current
>>   cgroupns-root. This is so that the task cannot escape out of its
>>   cgroupns-root. This also ensures that setns() only makes the task
>>   get restricted to a deeper cgroup hierarchy.
>>
>> Signed-off-by: Aditya Kali <adityakali@google.com>
>> ---
>>  kernel/cgroup_namespace.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 42 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/cgroup_namespace.c b/kernel/cgroup_namespace.c
>> index c16604f..c612946 100644
>> --- a/kernel/cgroup_namespace.c
>> +++ b/kernel/cgroup_namespace.c
>> @@ -80,8 +80,48 @@ err_out:
>>
>>  static int cgroupns_install(struct nsproxy *nsproxy, void *ns)
>>  {
>> -     pr_info("setns not supported for cgroup namespace");
>> -     return -EINVAL;
>> +     struct cgroup_namespace *cgroup_ns = ns;
>> +     struct task_struct *task = current;
>> +     struct cgroup *cgrp = NULL;
>> +     int err = 0;
>> +
>> +     if (!ns_capable(current_user_ns(), CAP_SYS_ADMIN) ||
>> +         !ns_capable(cgroup_ns->user_ns, CAP_SYS_ADMIN))
>> +             return -EPERM;
>> +
>> +     /* Prevent cgroup changes for this task. */
>> +     threadgroup_lock(task);
>> +
>> +     cgrp = get_task_cgroup(task);
>> +
>> +     err = -EINVAL;
>> +     if (!cgroup_on_dfl(cgrp))
>> +             goto out_unlock;
>> +
>> +     /* Allow switch only if the task's current cgroup is descendant of the
>> +      * target cgroup_ns->root_cgrp.
>> +      */
>> +     if (!cgroup_is_descendant(cgrp, cgroup_ns->root_cgrp))
>> +             goto out_unlock;
>> +
>> +     /* Only allow setns to a cgroupns root-ed deeper than task's current
>> +      * cgroupns-root. This will make sure that tasks cannot escape their
>> +      * cgroupns by attaching to parent cgroupns.
>> +      */
>> +     if (!cgroup_is_descendant(cgroup_ns->root_cgrp,
>> +                               task_cgroupns_root(task)))
>> +             goto out_unlock;
>> +
>> +     err = 0;
>> +     get_cgroup_ns(cgroup_ns);
>> +     put_cgroup_ns(nsproxy->cgroup_ns);
>> +     nsproxy->cgroup_ns = cgroup_ns;
>> +
>> +out_unlock:
>> +     threadgroup_unlock(current);
>> +     if (cgrp)
>> +             cgroup_put(cgrp);
>> +     return err;
>>  }
>>
>>  static void *cgroupns_get(struct task_struct *task)
>> --
>> 2.1.0.rc2.206.gedb03e5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Aditya
