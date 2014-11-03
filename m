Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaKCXmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:42:53 -0500
Received: from mail-oi0-f47.google.com ([209.85.218.47]:44107 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaKCXmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:42:50 -0500
MIME-Version: 1.0
In-Reply-To: <87y4rvspnd.fsf@x220.int.ebiederm.org>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-6-git-send-email-adityakali@google.com> <CALCETrWzYPngmWPMWnSFyiTPDwNJYPpXUj1C-294uQgjvp9wcA@mail.gmail.com>
 <87y4rvspnd.fsf@x220.int.ebiederm.org>
From: Aditya Kali <adityakali@google.com>
Date: Mon, 3 Nov 2014 15:42:29 -0800
Message-ID: <CAGr1F2EophqP4h=KN1see3m0zG27+ZXqYZOTUO+RX6d2aRzZFA@mail.gmail.com>
Subject: Re: [PATCHv2 5/7] cgroup: introduce cgroup namespaces
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 5:58 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> On Fri, Oct 31, 2014 at 12:18 PM, Aditya Kali <adityakali@google.com> wrote:
>
> <snip>
>
>>> +static void *cgroupns_get(struct task_struct *task)
>>> +{
>>> +       struct cgroup_namespace *ns = NULL;
>>> +       struct nsproxy *nsproxy;
>>> +
>>> +       rcu_read_lock();
>>> +       nsproxy = task->nsproxy;
>>> +       if (nsproxy) {
>>> +               ns = nsproxy->cgroup_ns;
>>> +               get_cgroup_ns(ns);
>>> +       }
>>> +       rcu_read_unlock();
>>
>> How is this correct?  Other namespaces do it too, so it Must Be
>> Correct (tm), but I don't understand.  What is RCU protecting?
>
> The code is not correct.  The code needs to use task_lock.
>
> RCU used to protect nsproxy, and now task_lock protects nsproxy.
> For the reasons of of all of this I refer you to the commit
> that changed this, and the comment in nsproxy.h
>

My bad. This should be under task_lock. I will fix it.

> commit 728dba3a39c66b3d8ac889ddbe38b5b1c264aec3
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Mon Feb 3 19:13:49 2014 -0800
>
>     namespaces: Use task_lock and not rcu to protect nsproxy
>
>     The synchronous syncrhonize_rcu in switch_task_namespaces makes setns
>     a sufficiently expensive system call that people have complained.
>
>     Upon inspect nsproxy no longer needs rcu protection for remote reads.
>     remote reads are rare.  So optimize for same process reads and write
>     by switching using rask_lock instead.
>
>     This yields a simpler to understand lock, and a faster setns system call.
>
>     In particular this fixes a performance regression observed
>     by Rafael David Tinoco <rafael.tinoco@canonical.com>.
>
>     This is effectively a revert of Pavel Emelyanov's commit
>     cf7b708c8d1d7a27736771bcf4c457b332b0f818 Make access to task's nsproxy lighter
>     from 2007.  The race this originialy fixed no longer exists as
>     do_notify_parent uses task_active_pid_ns(parent) instead of
>     parent->nsproxy.
>
>     Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Eric



-- 
Aditya
