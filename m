Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaJUFto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:49:44 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49485 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaJUFtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:49:23 -0400
MIME-Version: 1.0
In-Reply-To: <87lhoayo59.fsf@x220.int.ebiederm.org>
References: <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-8-git-send-email-adityakali@google.com> <20141016211236.GA4308@mail.hallyn.com>
 <CAGr1F2EH0ynfFihTh1dv=n1faxUh0zS3ggk303bwGnDnW2PUCw@mail.gmail.com>
 <20141016214710.GA4759@mail.hallyn.com> <87iojgmy3o.fsf@x220.int.ebiederm.org>
 <CALCETrUC=yW72d2hDzjESmZAt85x1WcGz4L-DrtY5YXAQxbpMA@mail.gmail.com>
 <44072106-c0f3-46b8-b2b5-9b1cbd1b7d88@email.android.com> <CALCETrXhGnBM_xx=Auz3WRQXkqhGGTWuZN=PU+A9HZ7Ek27FLA@mail.gmail.com>
 <87zjcq10ya.fsf@x220.int.ebiederm.org> <CALCETrVkMtsnEh57jFZrdx5vHbz97BdO7OuupT+xVNnWpJjxng@mail.gmail.com>
 <87lhoayo59.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Oct 2014 22:49:02 -0700
Message-ID: <CALCETrVFKvtHpTfY3kuE5ZTrwQAzuDmk6dm-mbQffDHAZmq-KQ@mail.gmail.com>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Aditya Kali <adityakali@google.com>,
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

On Mon, Oct 20, 2014 at 10:42 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> On Mon, Oct 20, 2014 at 9:49 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>> Possible solution:
>>>>
>>>> Ditch the pinning.  That is, if you're outside a cgroupns (or you have
>>>> a non-ns-confined cgroupfs mounted), then you can move a task in a
>>>> cgroupns outside of its root cgroup.  If you do this, then the task
>>>> thinks its cgroup is something like "../foo" or "../../foo".
>>>
>>> Of the possible solutions that seems attractive to me, simply because
>>> we sometimes want to allow clever things to occur.
>>>
>>> Does anyone know of a reason (beyond pretty printing) why we need
>>> cgroupns to restrict the subset of cgroups processes can be in?
>>>
>>> I would expect permissions on the cgroup directories themselves, and
>>> limited visiblilty would be (in general) to achieve the desired
>>> visiblity.
>>
>> This makes the security impact of cgroupns very easy to understand,
>> right?  Because there really won't be any -- cgroupns only affects
>> reads from /proc and what cgroupfs shows, but it doesn't change any
>> actual cgroups, nor does it affect any cgroup *changes*.
>
> It seems like what we have described is chcgrouproot aka chroot for
> cgroups.  At which point I think there are potentially similar security
> issues as for chroot.  Can we confuse a setuid root process if we make
> it's cgroup names look different.
>
> Of course the confusing root concern is handled by the usual namespace
> security checks that are already present.

I think that the chroot issues are mostly in two categories: setuid
confusion (not an issue here as you described) and chroot escapes.
cgroupns escapes aren't a big deal, I think -- admins should deny the
confined task the right to write to cgroupfs outside its hierarchy, by
setting cgroupfs permissions appropriately and/or avoiding mounting
cgroupfs outside the hierarchy.

>
> I do wonder if we think of this as chcgrouproot if there is a simpler
> implementation.

Could be.  I'll defer to Aditya for that one.

>
>>>> While we're at it, consider making setns for a cgroupns *not* change
>>>> the caller's cgroup.  Is there any reason it really needs to?
>>>
>>> setns doesn't but nsenter is going to need to change the cgroup
>>> if the pinning requirement is kept.  nsenenter is going to want to
>>> change the cgroup if the pinning requirement is dropped.
>>>
>>
>> It seems easy enough for nsenter to change the cgroup all by itself.
>
> Again.  I don't think anyone has suggested or implemented anything
> different.

The current patchset seems to punt on this decision by just failing
the setns call if the caller is outside the cgroup in question.

--Andy
