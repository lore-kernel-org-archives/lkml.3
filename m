Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422905AbaGRS5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:57:45 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:42721 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbaGRS5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:57:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAGr1F2GwZvZLPGLWKPPOt3vREwwVNbVPrgE6YJ01bACKejbc4Q@mail.gmail.com>
References: <1405626731-12220-1-git-send-email-adityakali@google.com>
 <1405626731-12220-6-git-send-email-adityakali@google.com> <CALCETrWXMMGzptvEu6TfzTjBou4t==W39_nNB5FJwSk2Zy8uCQ@mail.gmail.com>
 <CAGr1F2Ht1q_nYGJwmQvEEyj8r3R1stgD=g3s8_5zYOTogjz-UQ@mail.gmail.com>
 <CALCETrW6YpyJBmr3sZC6KL03GP4dcGYavQF5DFZfys6Cok-vpw@mail.gmail.com> <CAGr1F2GwZvZLPGLWKPPOt3vREwwVNbVPrgE6YJ01bACKejbc4Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 18 Jul 2014 11:57:22 -0700
Message-ID: <CALCETrVeeL71sfVdbzRx0FpGrvQKbviEmUcMEosbUU+UJNQu9w@mail.gmail.com>
Subject: Re: [PATCH 5/5] cgroup: introduce cgroup namespaces
To: Aditya Kali <adityakali@google.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Linux API <linux-api@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 11:51 AM, Aditya Kali <adityakali@google.com> wrote:
> On Fri, Jul 18, 2014 at 9:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Jul 17, 2014 1:56 PM, "Aditya Kali" <adityakali@google.com> wrote:
>>>
>>> On Thu, Jul 17, 2014 at 12:57 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> > What happens if someone moves a task in a cgroup namespace outside of
>>> > the namespace root cgroup?
>>> >
>>>
>>> Attempt to move a task outside of cgroupns root will fail with EPERM.
>>> This is true irrespective of the privileges of the process attempting
>>> this. Once cgroupns is created, the task will be confined to the
>>> cgroup hierarchy under its cgroupns root until it dies.
>>
>> Can a task in a non-init userns create a cgroupns?  If not, that's
>> unusual.  If so, is it problematic if they can prevent themselves from
>> being moved?
>>
>
> Currently, only a task with CAP_SYS_ADMIN in the init-userns can
> create cgroupns. It is stricter than for other namespaces, yes.

I'm slightly hesitant to have unshare(CLONE_NEWUSER |
CLONE_NEWCGROUPNS | ...) start having weird side effects that are
visible outside the namespace, especially when those side effects
don't happen (because the call fails entirely) if
unshare(CLONE_NEWUSER) happens first.  I don't see a real problem with
it, but it's weird.

>
>> I hate to say it, but it might be worth requiring explicit permission
>> from the cgroup manager for this.  For example, there could be a new
>> cgroup attribute may_unshare, and any attempt to unshare the cgroup ns
>> will fail with -EPERM unless the caller is in a may_share=1 cgroup.
>> may_unshare in a parent cgroup would not give child cgroups the
>> ability to unshare.
>>
>
> What you suggest can be done. The current patch-set punts the problem
> of permission checking by only allowing unshare from a
> capable(CAP_SYS_ADMIN) process. This can be implemented as a follow-up
> improvement to cgroupns feature if we want to open it to non-init
> userns.
>
> Being said that, I would argue that even if we don't have this
> explicit permission and relax the check to non-init userns, it should
> be 'OK' to let ns_capable(current_user_ns(), CAP_SYS_ADMIN) tasks to
> unshare cgroupns (basically, if you can "create" a cgroup hierarchy,
> you should probably be allowed to unshare() it).

But non-init-userns tasks can't create cgroup hierarchies, unless I
misunderstand the current code.  And, if they can, I bet I can find
three or four serious security issues in an hour or two. :)

> By unsharing
> cgroupns, the tasks can only confine themselves further under its
> cgroupns-root. As long as it cannot escape that hierarchy, it should
> be fine.

But they can also *lock* their hierarchy.

> In my experience, there is seldom a need to move tasks out of their
> cgroup. At most, we create a sub-cgroup and move the task there (which
> is allowed in their cgroupns). Even for a cgroup manager, I can't
> think of a case where it will be useful to move a task from one cgroup
> hierarchy to another. Such move seems overly complicated (even without
> cgroup namespaces). The cgroup manager can just modify the settings of
> the task's cgroup as needed or simply kill & restart the task in a new
> container.
>

I do this all the time.  Maybe my new systemd overlords will make me
stop doing it, at which point my current production setup will blow
up.

--Andy
