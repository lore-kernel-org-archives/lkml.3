Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbaKCXke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:40:34 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:55245 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaKCXkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:40:32 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrWzYPngmWPMWnSFyiTPDwNJYPpXUj1C-294uQgjvp9wcA@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-6-git-send-email-adityakali@google.com> <CALCETrWzYPngmWPMWnSFyiTPDwNJYPpXUj1C-294uQgjvp9wcA@mail.gmail.com>
From: Aditya Kali <adityakali@google.com>
Date: Mon, 3 Nov 2014 15:40:11 -0800
Message-ID: <CAGr1F2Fzxf7ESuznpezgP3zwe33TnWNDH-Y3rPWz8cNbfJRtsQ@mail.gmail.com>
Subject: Re: [PATCHv2 5/7] cgroup: introduce cgroup namespaces
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 5:02 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Oct 31, 2014 at 12:18 PM, Aditya Kali <adityakali@google.com> wrote:
>> Introduce the ability to create new cgroup namespace. The newly created
>> cgroup namespace remembers the cgroup of the process at the point
>> of creation of the cgroup namespace (referred as cgroupns-root).
>> The main purpose of cgroup namespace is to virtualize the contents
>> of /proc/self/cgroup file. Processes inside a cgroup namespace
>> are only able to see paths relative to their namespace root
>> (unless they are moved outside of their cgroupns-root, at which point
>>  they will see a relative path from their cgroupns-root).
>> For a correctly setup container this enables container-tools
>> (like libcontainer, lxc, lmctfy, etc.) to create completely virtualized
>> containers without leaking system level cgroup hierarchy to the task.
>> This patch only implements the 'unshare' part of the cgroupns.
>>
>
>> +       /* Prevent cgroup changes for this task. */
>> +       threadgroup_lock(current);
>
> This could just be me being dense, but what is the lock for?
>

threadgroup_lock() is there to prevent the task from changing cgroups
while we are unsharing cgroupns.
But it seems that this might be unnecessary now because we have
removed the pinning restriction. Without pinning, we don't care if the
task cgroup changes underneath us. I will remove it from here as well
as from cgroupns_install().

>> +
>> +       /* CGROUPNS only virtualizes the cgroup path on the unified hierarchy.
>> +        */
>> +       cgrp = get_task_cgroup(current);
>> +
>> +       err = -ENOMEM;
>> +       new_ns = alloc_cgroup_ns();
>> +       if (!new_ns)
>> +               goto err_out_unlock;
>> +
>> +       err = proc_alloc_inum(&new_ns->proc_inum);
>> +       if (err)
>> +               goto err_out_unlock;
>> +
>> +       new_ns->user_ns = get_user_ns(user_ns);
>> +       new_ns->root_cgrp = cgrp;
>> +
>> +       threadgroup_unlock(current);
>> +
>> +       return new_ns;
>> +
>> +err_out_unlock:
>> +       threadgroup_unlock(current);
>> +err_out:
>> +       if (cgrp)
>> +               cgroup_put(cgrp);
>> +       kfree(new_ns);
>> +       return ERR_PTR(err);
>> +}
>> +
>> +static int cgroupns_install(struct nsproxy *nsproxy, void *ns)
>> +{
>> +       pr_info("setns not supported for cgroup namespace");
>> +       return -EINVAL;
>> +}
>> +
>> +static void *cgroupns_get(struct task_struct *task)
>> +{
>> +       struct cgroup_namespace *ns = NULL;
>> +       struct nsproxy *nsproxy;
>> +
>> +       rcu_read_lock();
>> +       nsproxy = task->nsproxy;
>> +       if (nsproxy) {
>> +               ns = nsproxy->cgroup_ns;
>> +               get_cgroup_ns(ns);
>> +       }
>> +       rcu_read_unlock();
>
> How is this correct?  Other namespaces do it too, so it Must Be
> Correct (tm), but I don't understand.  What is RCU protecting?
>
> --Andy



-- 
Aditya
