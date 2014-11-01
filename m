Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbaKAADG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 20:03:06 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:47520 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaKAADD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 20:03:03 -0400
MIME-Version: 1.0
In-Reply-To: <1414783141-6947-6-git-send-email-adityakali@google.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com> <1414783141-6947-6-git-send-email-adityakali@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 31 Oct 2014 17:02:41 -0700
Message-ID: <CALCETrWzYPngmWPMWnSFyiTPDwNJYPpXUj1C-294uQgjvp9wcA@mail.gmail.com>
Subject: Re: [PATCHv2 5/7] cgroup: introduce cgroup namespaces
To: Aditya Kali <adityakali@google.com>
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

On Fri, Oct 31, 2014 at 12:18 PM, Aditya Kali <adityakali@google.com> wrote:
> Introduce the ability to create new cgroup namespace. The newly created
> cgroup namespace remembers the cgroup of the process at the point
> of creation of the cgroup namespace (referred as cgroupns-root).
> The main purpose of cgroup namespace is to virtualize the contents
> of /proc/self/cgroup file. Processes inside a cgroup namespace
> are only able to see paths relative to their namespace root
> (unless they are moved outside of their cgroupns-root, at which point
>  they will see a relative path from their cgroupns-root).
> For a correctly setup container this enables container-tools
> (like libcontainer, lxc, lmctfy, etc.) to create completely virtualized
> containers without leaking system level cgroup hierarchy to the task.
> This patch only implements the 'unshare' part of the cgroupns.
>

> +       /* Prevent cgroup changes for this task. */
> +       threadgroup_lock(current);

This could just be me being dense, but what is the lock for?

> +
> +       /* CGROUPNS only virtualizes the cgroup path on the unified hierarchy.
> +        */
> +       cgrp = get_task_cgroup(current);
> +
> +       err = -ENOMEM;
> +       new_ns = alloc_cgroup_ns();
> +       if (!new_ns)
> +               goto err_out_unlock;
> +
> +       err = proc_alloc_inum(&new_ns->proc_inum);
> +       if (err)
> +               goto err_out_unlock;
> +
> +       new_ns->user_ns = get_user_ns(user_ns);
> +       new_ns->root_cgrp = cgrp;
> +
> +       threadgroup_unlock(current);
> +
> +       return new_ns;
> +
> +err_out_unlock:
> +       threadgroup_unlock(current);
> +err_out:
> +       if (cgrp)
> +               cgroup_put(cgrp);
> +       kfree(new_ns);
> +       return ERR_PTR(err);
> +}
> +
> +static int cgroupns_install(struct nsproxy *nsproxy, void *ns)
> +{
> +       pr_info("setns not supported for cgroup namespace");
> +       return -EINVAL;
> +}
> +
> +static void *cgroupns_get(struct task_struct *task)
> +{
> +       struct cgroup_namespace *ns = NULL;
> +       struct nsproxy *nsproxy;
> +
> +       rcu_read_lock();
> +       nsproxy = task->nsproxy;
> +       if (nsproxy) {
> +               ns = nsproxy->cgroup_ns;
> +               get_cgroup_ns(ns);
> +       }
> +       rcu_read_unlock();

How is this correct?  Other namespaces do it too, so it Must Be
Correct (tm), but I don't understand.  What is RCU protecting?

--Andy
