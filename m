Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbaJUStg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:49:36 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53721 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaJUSte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:49:34 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVFKvtHpTfY3kuE5ZTrwQAzuDmk6dm-mbQffDHAZmq-KQ@mail.gmail.com>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-8-git-send-email-adityakali@google.com> <20141016211236.GA4308@mail.hallyn.com>
 <CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
 <20141016214710.GA4759@mail.hallyn.com> <87iojgmy3o.fsf@x220.int.ebiederm.org>
 <CALCETrUC=yW72d2hDzjESmZAt85x1WcGz4L-DrtY5YXAQxbpMA@mail.gmail.com>
 <44072106-c0f3-46b8-b2b5-9b1cbd1b7d88@email.android.com> <CALCETrXhGnBM_xx=Auz3WRQXkqhGGTWuZN=PU+A9HZ7Ek27FLA@mail.gmail.com>
 <87zjcq10ya.fsf@x220.int.ebiederm.org> <CALCETrVkMtsnEh57jFZrdx5vHbz97BdO7OuupT+xVNnWpJjxng@mail.gmail.com>
 <87lhoayo59.fsf@x220.int.ebiederm.org> <CALCETrVFKvtHpTfY3kuE5ZTrwQAzuDmk6dm-mbQffDHAZmq-KQ@mail.gmail.com>
From: Aditya Kali <adityakali@google.com>
Date: Tue, 21 Oct 2014 11:49:12 -0700
Message-ID: <CAGr1F2Ee2MCKOwALR2YV7ppDmyHxO6+EsHqSc1+WcwKFPPQB0w@mail.gmail.com>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
To: Andy Lutomirski <luto@amacapital.net>
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

On Mon, Oct 20, 2014 at 10:49 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Oct 20, 2014 at 10:42 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On Mon, Oct 20, 2014 at 9:49 PM, Eric W. Biederman
>>> <ebiederm@xmission.com> wrote:
>>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>> Possible solution:
>>>>>
>>>>> Ditch the pinning.  That is, if you're outside a cgroupns (or you have
>>>>> a non-ns-confined cgroupfs mounted), then you can move a task in a
>>>>> cgroupns outside of its root cgroup.  If you do this, then the task
>>>>> thinks its cgroup is something like "../foo" or "../../foo".
>>>>
>>>> Of the possible solutions that seems attractive to me, simply because
>>>> we sometimes want to allow clever things to occur.
>>>>
>>>> Does anyone know of a reason (beyond pretty printing) why we need
>>>> cgroupns to restrict the subset of cgroups processes can be in?
>>>>
>>>> I would expect permissions on the cgroup directories themselves, and
>>>> limited visiblilty would be (in general) to achieve the desired
>>>> visiblity.
>>>
>>> This makes the security impact of cgroupns very easy to understand,
>>> right?  Because there really won't be any -- cgroupns only affects
>>> reads from /proc and what cgroupfs shows, but it doesn't change any
>>> actual cgroups, nor does it affect any cgroup *changes*.
>>
>> It seems like what we have described is chcgrouproot aka chroot for
>> cgroups.  At which point I think there are potentially similar security
>> issues as for chroot.  Can we confuse a setuid root process if we make
>> it's cgroup names look different.
>>
>> Of course the confusing root concern is handled by the usual namespace
>> security checks that are already present.
>
> I think that the chroot issues are mostly in two categories: setuid
> confusion (not an issue here as you described) and chroot escapes.
> cgroupns escapes aren't a big deal, I think -- admins should deny the
> confined task the right to write to cgroupfs outside its hierarchy, by
> setting cgroupfs permissions appropriately and/or avoiding mounting
> cgroupfs outside the hierarchy.
>
>>
>> I do wonder if we think of this as chcgrouproot if there is a simpler
>> implementation.
>
> Could be.  I'll defer to Aditya for that one.
>

More than chcgrouproot, its probably closer to pivot_cgroup_root. In
addition to restricting the process to a cgroup-root, new processes
entering the container should also be implicitly contained within the
cgroup-root of that container. Implementing pivot_cgroup_root would
probably involve overloading mount-namespace to now understand cgroup
filesystem too. I did attempt combining cgroupns-root with mntns
earlier (not via a new syscall though), but came to the conclusion
that its just simpler to have a separate cgroup namespace and get
clear semantics. One of the issues was that implicitly changing cgroup
on setns to mntns seemed like a huge undesirable side-effect.

About pinning: I really feel that it should be OK to pin processes
within cgroupns-root. I think thats one of the most important feature
of cgroup-namespace since its most common usecase is to containerize
un-trusted processes - processes that, for their entire lifetime, need
to remain inside their container. And with explicit permission from
cgroup subsystem (something like cgroup.may_unshare as you had
suggested previously), we can make sure that unprivileged processes
cannot pin themselves. Also, maintaining this invariant (your current
cgroup is always under your cgroupns-root) keeps the code and the
semantics simple.

If we ditch the pinning requirement and allow the containarized
process to move outside of its cgroupns-root, we will have to address
atleast the following:
* what does its /proc/self/cgroup  (and /proc/<pid>/cgroup in general)
look like? We might need to just not show anything in
/proc/<pid>/cgroup in such case (for default hierarchy).
* how should future setns() and unshare() by such process behave?
* 'mount -t cgroup cgroup <mnt>' by such a process will yield unexpected result
* container will not remain migratable
* added code complexity to handle above scenarios

I understand that having process pinned to a cgroup hierarchy might
seem inconvenient. But even today (without cgroup namespaces), moving
a task from one cgroup to another can fail for reasons outside of
control of the task attempting the move (even if its privileged). So
the userspace should already handle this scenario. I feel its not
worth to add complexity in the kernel for this.

>>
>>>>> While we're at it, consider making setns for a cgroupns *not* change
>>>>> the caller's cgroup.  Is there any reason it really needs to?
>>>>
>>>> setns doesn't but nsenter is going to need to change the cgroup
>>>> if the pinning requirement is kept.  nsenenter is going to want to
>>>> change the cgroup if the pinning requirement is dropped.
>>>>
>>>
>>> It seems easy enough for nsenter to change the cgroup all by itself.
>>
>> Again.  I don't think anyone has suggested or implemented anything
>> different.
>
> The current patchset seems to punt on this decision by just failing
> the setns call if the caller is outside the cgroup in question.
>
> --Andy

-- 
Aditya
