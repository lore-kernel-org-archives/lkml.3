Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbaJVSud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:50:33 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:56187 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbaJVSub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:50:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAGr1F2EBDCVrXZd7fOdffQ2C0c25T8co4wfxRc8P0Jb18yq2uQ@mail.gmail.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-8-git-send-email-adityakali@google.com> <20141016211236.GA4308@mail.hallyn.com>
 <CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
 <20141016214710.GA4759@mail.hallyn.com> <87iojgmy3o.fsf@x220.int.ebiederm.org>
 <CALCETrUC=yW72d2hDzjESmZAt85x1WcGz4L-DrtY5YXAQxbpMA@mail.gmail.com>
 <44072106-c0f3-46b8-b2b5-9b1cbd1b7d88@email.android.com> <CALCETrXhGnBM_xx=Auz3WRQXkqhGGTWuZN=PU+A9HZ7Ek27FLA@mail.gmail.com>
 <87zjcq10ya.fsf@x220.int.ebiederm.org> <CALCETrVkMtsnEh57jFZrdx5vHbz97BdO7OuupT+xVNnWpJjxng@mail.gmail.com>
 <87lhoayo59.fsf@x220.int.ebiederm.org> <CALCETrVFKvtHpTfY3kuE5ZTrwQAzuDmk6dm-mbQffDHAZmq-KQ@mail.gmail.com>
 <CAGr1F2Ee2MCKOwALR2YV7ppDmyHxO6+EsHqSc1+WcwKFPPQB0w@mail.gmail.com>
 <CALCETrWXDMRsexfvmh2CiMW4WX0ZLJ4pJvzHU55PEBk=NmnyZg@mail.gmail.com>
 <CAGr1F2FdQ4VF1_o7mdybZ-WhLLhFxdgkNnzotHOwnhLU8W+YCw@mail.gmail.com>
 <CALCETrXEAegFmSs2LnfSJR0tQmqZudnESDER8CoqKxOCBFMwdA@mail.gmail.com>
 <CAGr1F2HYGG9=jwugywD8tUdB+dOjN4z+3BSpqL_m2aaM+3Rz1A@mail.gmail.com>
 <CALCETrUtqozUE=Lr5d2dBKd_vaLzfVvVv8g6ZALz1MWqVzj9dQ@mail.gmail.com> <CAGr1F2EBDCVrXZd7fOdffQ2C0c25T8co4wfxRc8P0Jb18yq2uQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 22 Oct 2014 11:50:08 -0700
Message-ID: <CALCETrV+rWN-TqgghXYpSq6Noyu1Z7EOBk4_gs42Z92zJXNnZA@mail.gmail.com>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
To: Aditya Kali <adityakali@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 11:37 AM, Aditya Kali <adityakali@google.com> wrote:
> On Tue, Oct 21, 2014 at 5:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Tue, Oct 21, 2014 at 5:46 PM, Aditya Kali <adityakali@google.com> wrote:
>>> On Tue, Oct 21, 2014 at 3:42 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> On Tue, Oct 21, 2014 at 3:33 PM, Aditya Kali <adityakali@google.com> wrote:
>>>>>>
>>>>>>> And with explicit permission from
>>>>>>> cgroup subsystem (something like cgroup.may_unshare as you had
>>>>>>> suggested previously), we can make sure that unprivileged processes
>>>>>>> cannot pin themselves. Also, maintaining this invariant (your current
>>>>>>> cgroup is always under your cgroupns-root) keeps the code and the
>>>>>>> semantics simple.
>>>>>>
>>>>>> I actually think it makes the semantics more complex.  The less policy
>>>>>> you stick in the kernel, the easier it is to understand the impact of
>>>>>> that policy.
>>>>>>
>>>>>
>>>>> My inclination is towards keeping things simpler - both in code as
>>>>> well as in configuration. I agree that cgroupns might seem
>>>>> "less-flexible", but in its current form, it encourages consistent
>>>>> container configuration. If you have a process that needs to move
>>>>> around between cgroups belonging to different containers, then that
>>>>> process should probably not be inside any container's cgroup
>>>>> namespace. Allowing that will just make the cgroup namespace
>>>>> pretty-much meaningless.
>>>>
>>>> The problem with pinning is that preventing it causes problems
>>>> (specifically, either something potentially complex and incompatible
>>>> needs to be added or unprivileged processes will be able to pin
>>>> themselves).
>>>>
>>>> Unless I'm missing something, a normal cgroupns user doesn't actually
>>>> need kernel pinning support to effectively constrain its members'
>>>> cgroups.
>>>>
>>>
>>> So there are 2 scenarios to consider:
>>>
>>> We have 2 containers with cgroups: /container1 and /container2
>>> Assume process P is running under cgroupns-root '/container1'
>>>
>>> (1) process P wants to 'write' to cgroup.procs outside its
>>> cgroupns-root (say to /container2/cgroup.procs)
>>
>> This, at least, doesn't have the problem with unprivileged processes
>> pinning themselves.
>>
>>> (2) An admin process running in init_cgroup_ns (or any parent cgroupns
>>> with cgroupns-root above /container1) wants to write pid of process P
>>> to /container2/cgroup.procs (which lies outside of P's cgroupns-root)
>>>
>>> For (1), I think its ok to reject such a write. This is consistent
>>> with the restriction in cgroup_file_write added in 'Patch 6' of this
>>> set. I believe this should be independent of visibility of the cgroup
>>> hierarchy for P.
>>>
>>> For (2), we may allow the write to succeed if we make sure that the
>>> process doing the write is an admin process (with CAP_SYS_ADMIN in its
>>> userns AND over P's cgroupns->user_ns).
>>
>> Why is its userns relevant?
>>
>> Why not just check whether the target cgroup is in the process doing
>> the write's cgroupns? (NB: you need to check f_cred, here, not
>> current_cred(), but that's orthogonal.)  Then the policy becomes: no
>> user of cgroupfs can move any process outside of the cgroupfs's user's
>> cgroupns root.
>>
> Humm .. it doesn't have to be. I think its simpler to not enforce
> artificial permission checks unless there is a security concern (and
> in this case, there doesn't seem to be any). So I will leave the
> capability check out from here.
>
>> I think I'm okay with this.
>>
>>> If this write succeeds, then:
>>> (a) process P's /proc/<pid>/cgroup does not show anything when viewed
>>> by 'self' or any other process in P's cgrgroupns. I would really like
>>> to avoid showing relative paths or paths outside the cgroupns-root
>>
>> The empty string seems just as problematic to me.
>
> Actually, there is no right answer here. Our options are:
> * show relative path
> -- this will break userspace as /proc/<pid>/cgroup does not show
> relative paths today. This is also very ambiguous (is it relative to
> cgroupns-root or relative to /proc/<pid>cgroup file reader's cgroup?).
>

Confused now.  If ".." in /proc/pid/group would be ambiguous, then so
would a path relative to cgroupns root, right?  Or am I missing
something?

(I'm not saying that ".." is beautiful or that it won't confuse
things.  I'm just not sure why it's ambiguous.)

> * show absolute path
> -- this will also wrong as the process won't be able to make sense of
> it unless it has exposure to the global cgroup hierarchy.
> -- worse case is this that the global path also exists under the
> cgroupns-root ... so now the process thinks its in completely wrong
> cgroup
> -- this exposes system
>
> * show only "/"
> -- this is arguably better, but if the process tires to verify that
> its pid is in cgroup.procs of the cgroupns-root, its in for a
> surprise!
>
> In either case, whatever we expose, the userspace won't be able to use
> this path correctly (worse yet, it associates wrong cgroup for that
> path). So I think its best to not print out the line for default
> hierarchy at all. This happens today when cgroupfs is not mounted. I
> am open to other suggestions.

I suppose that ".." is a possible security problem.  If I can force
you to see lots of ..s in there, then I might be about to get you to
write outside cgroupfs.

Grr.  No great solution here.  I suppose that the empty string isn't
so bad.  We could also write something obviously invalid like
"(unreachable)".  As long as no one actually creates a cgroup called
"(unreachable)", then this could result in errors but not actual
confusion.

>>> * should we then also allow setns() without first entering the
>>> cgroupns-root? setns also checks the same conditions as in (a) plus it
>>> checks that your current cgroup is descendant of target cgroupns-root.
>>> Alternatively we can special-case setns() to own cgroupns so that it
>>> doesn't fail.
>>
>> I think setns should completely ignore the caller's cgroup and should
>> not change it.  Userspace can do this.
>>
>
> All above changes more or less means that tasks cannot pin themselves
> by unsharing cgroupns. Do you agree that we don't need that "explicit
> permission from cgroupfs" anymore (via cgroup.may_unshare file or
> other mechanism)?

Yes, I agree.

>
>>> * migration for these processes will be tricky, if not impossible. But
>>> the admin trying to do this probably doesn't care about it or will
>>> provision for it.
>>
>> Migration for processes in a mntns that have a current directory
>> outside their mntns is also difficult or impossible.  Same with
>> pidnses with an fd pointing at /proc/self from an outside-the-pid-ns
>> procfs.  Nothing new here.
>>
>> --Andy
>
> Thanks for the review!

No problem.
