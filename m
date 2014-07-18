Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945993AbaGRSvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:51:42 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54628 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422774AbaGRSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrW6YpyJBmr3sZC6KL03GP4dcGYavQF5DFZfys6Cok-vpw@mail.gmail.com>
References: <1405626731-12220-1-git-send-email-adityakali@google.com>
 <1405626731-12220-6-git-send-email-adityakali@google.com> <CALCETrWXMMGzptvEu6TfzTjBou4t==W39_nNB5FJwSk2Zy8uCQ@mail.gmail.com>
 <CAGr1F2Ht1q_nYGJwmQvEEyj8r3R1stgD=g3s8_5zYOTogjz-UQ@mail.gmail.com> <CALCETrW6YpyJBmr3sZC6KL03GP4dcGYavQF5DFZfys6Cok-vpw@mail.gmail.com>
From: Aditya Kali <adityakali@google.com>
Date: Fri, 18 Jul 2014 11:51:17 -0700
Message-ID: <CAGr1F2GwZvZLPGLWKPPOt3vREwwVNbVPrgE6YJ01bACKejbc4Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] cgroup: introduce cgroup namespaces
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Linux API <linux-api@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 9:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Jul 17, 2014 1:56 PM, "Aditya Kali" <adityakali@google.com> wrote:
>>
>> On Thu, Jul 17, 2014 at 12:57 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > What happens if someone moves a task in a cgroup namespace outside of
>> > the namespace root cgroup?
>> >
>>
>> Attempt to move a task outside of cgroupns root will fail with EPERM.
>> This is true irrespective of the privileges of the process attempting
>> this. Once cgroupns is created, the task will be confined to the
>> cgroup hierarchy under its cgroupns root until it dies.
>
> Can a task in a non-init userns create a cgroupns?  If not, that's
> unusual.  If so, is it problematic if they can prevent themselves from
> being moved?
>

Currently, only a task with CAP_SYS_ADMIN in the init-userns can
create cgroupns. It is stricter than for other namespaces, yes.

> I hate to say it, but it might be worth requiring explicit permission
> from the cgroup manager for this.  For example, there could be a new
> cgroup attribute may_unshare, and any attempt to unshare the cgroup ns
> will fail with -EPERM unless the caller is in a may_share=1 cgroup.
> may_unshare in a parent cgroup would not give child cgroups the
> ability to unshare.
>

What you suggest can be done. The current patch-set punts the problem
of permission checking by only allowing unshare from a
capable(CAP_SYS_ADMIN) process. This can be implemented as a follow-up
improvement to cgroupns feature if we want to open it to non-init
userns.

Being said that, I would argue that even if we don't have this
explicit permission and relax the check to non-init userns, it should
be 'OK' to let ns_capable(current_user_ns(), CAP_SYS_ADMIN) tasks to
unshare cgroupns (basically, if you can "create" a cgroup hierarchy,
you should probably be allowed to unshare() it). By unsharing
cgroupns, the tasks can only confine themselves further under its
cgroupns-root. As long as it cannot escape that hierarchy, it should
be fine.
In my experience, there is seldom a need to move tasks out of their
cgroup. At most, we create a sub-cgroup and move the task there (which
is allowed in their cgroupns). Even for a cgroup manager, I can't
think of a case where it will be useful to move a task from one cgroup
hierarchy to another. Such move seems overly complicated (even without
cgroup namespaces). The cgroup manager can just modify the settings of
the task's cgroup as needed or simply kill & restart the task in a new
container.


> --Andy


Thanks,
-- 
Aditya
