Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbaGWTxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:53:43 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:43612 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693AbaGWTwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUhd41LFfF9epbVYJSOwqBq308Z8RZG9tzyPfx+Joe15Q@mail.gmail.com>
References: <1405626731-12220-1-git-send-email-adityakali@google.com>
 <1405626731-12220-6-git-send-email-adityakali@google.com> <CALCETrWXMMGzptvEu6TfzTjBou4t==W39_nNB5FJwSk2Zy8uCQ@mail.gmail.com>
 <CAGr1F2Ht1q_nYGJwmQvEEyj8r3R1stgD=g3s8_5zYOTogjz-UQ@mail.gmail.com>
 <CALCETrW6YpyJBmr3sZC6KL03GP4dcGYavQF5DFZfys6Cok-vpw@mail.gmail.com>
 <CAGr1F2GwZvZLPGLWKPPOt3vREwwVNbVPrgE6YJ01bACKejbc4Q@mail.gmail.com>
 <CALCETrVeeL71sfVdbzRx0FpGrvQKbviEmUcMEosbUU+UJNQu9w@mail.gmail.com>
 <CAGr1F2Fd_4=WUm4STPd4kdd5tNLO6aQ1OOQMKnRqyOKZSGvCpg@mail.gmail.com> <CALCETrUhd41LFfF9epbVYJSOwqBq308Z8RZG9tzyPfx+Joe15Q@mail.gmail.com>
From: Aditya Kali <adityakali@google.com>
Date: Wed, 23 Jul 2014 12:52:23 -0700
Message-ID: <CAGr1F2ET=v0nNKmoW+EyLp1bFuDHQotamFRzp=KeTNP7fvnqoQ@mail.gmail.com>
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

On Mon, Jul 21, 2014 at 3:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Jul 21, 2014 at 3:11 PM, Aditya Kali <adityakali@google.com> wrote:
>> On Fri, Jul 18, 2014 at 11:57 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Fri, Jul 18, 2014 at 11:51 AM, Aditya Kali <adityakali@google.com> wrote:
>>>> On Fri, Jul 18, 2014 at 9:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>> On Jul 17, 2014 1:56 PM, "Aditya Kali" <adityakali@google.com> wrote:
>>>>>>
>>>>>> On Thu, Jul 17, 2014 at 12:57 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>>>> > What happens if someone moves a task in a cgroup namespace outside of
>>>>>> > the namespace root cgroup?
>>>>>> >
>>>>>>
>>>>>> Attempt to move a task outside of cgroupns root will fail with EPERM.
>>>>>> This is true irrespective of the privileges of the process attempting
>>>>>> this. Once cgroupns is created, the task will be confined to the
>>>>>> cgroup hierarchy under its cgroupns root until it dies.
>>>>>
>>>>> Can a task in a non-init userns create a cgroupns?  If not, that's
>>>>> unusual.  If so, is it problematic if they can prevent themselves from
>>>>> being moved?
>>>>>
>>>>
>>>> Currently, only a task with CAP_SYS_ADMIN in the init-userns can
>>>> create cgroupns. It is stricter than for other namespaces, yes.
>>>
>>> I'm slightly hesitant to have unshare(CLONE_NEWUSER |
>>> CLONE_NEWCGROUPNS | ...) start having weird side effects that are
>>> visible outside the namespace, especially when those side effects
>>> don't happen (because the call fails entirely) if
>>> unshare(CLONE_NEWUSER) happens first.  I don't see a real problem with
>>> it, but it's weird.
>>>
>>
>> I expect this to be only in the initial version of the patch. We can
>> make this consistent with other namespaces once we figure out how
>> cgroupns can be safely enabled for non-init-userns.
>>
>>>>
>>>>> I hate to say it, but it might be worth requiring explicit permission
>>>>> from the cgroup manager for this.  For example, there could be a new
>>>>> cgroup attribute may_unshare, and any attempt to unshare the cgroup ns
>>>>> will fail with -EPERM unless the caller is in a may_share=1 cgroup.
>>>>> may_unshare in a parent cgroup would not give child cgroups the
>>>>> ability to unshare.
>>>>>
>>>>
>>>> What you suggest can be done. The current patch-set punts the problem
>>>> of permission checking by only allowing unshare from a
>>>> capable(CAP_SYS_ADMIN) process. This can be implemented as a follow-up
>>>> improvement to cgroupns feature if we want to open it to non-init
>>>> userns.
>>>>
>>>> Being said that, I would argue that even if we don't have this
>>>> explicit permission and relax the check to non-init userns, it should
>>>> be 'OK' to let ns_capable(current_user_ns(), CAP_SYS_ADMIN) tasks to
>>>> unshare cgroupns (basically, if you can "create" a cgroup hierarchy,
>>>> you should probably be allowed to unshare() it).
>>>
>>> But non-init-userns tasks can't create cgroup hierarchies, unless I
>>> misunderstand the current code.  And, if they can, I bet I can find
>>> three or four serious security issues in an hour or two. :)
>>>
>>
>> Task running in non-init userns can create cgroup hierarchies if you
>> chown/chgrp their cgroup root to the task user:
>
> Won't the systemd people hate you forever for this suggestion?  (I do
> exactly this myself...)
>

I was actually thinking this feature will really simplify container
management tools (since cgroupns allows you to recursively run them
inside containers without any hacks). I would appreciate any feedback
from them on how we can improve this to help their usecase.

Thanks for your comments!

>
>> This is a powerful feature as it allows non-root tasks to run
>> container-management tools and provision their resources properly. But
>> this makes implementing your suggestion of having 'cgroup.may_unshare'
>> file tricky as the cgroup owner (task) will be able to set it and
>> still unshare cgroupns. Instead, may be we could just check if the
>> task has appropriate (write?) permissions on the cgroup directory
>> before allowing nested cgroupns creation.
>
> I bet that systemd will want to set may_unshare but not give write
> access.  Who knows?
>
>> [shudder]
>> I am surprised that this even works correctly.
>>
>> Either way, may be checking cgroup directory permissions will work for
>> you? i.e., if you "chown" a cgroup directory to the user, it should be
>> OK if the user's task unshares cgroupns under that cgroup and you
>> don't care about moving tasks from under that cgroup. Without
>> ownership of the cgroup directory, creation of cgroupns will be
>> disallowed. What do you think?
>
> I think this is *safe* but may not useful for eventual systemd stuff.
> Not really sure.
>
> --Andy



-- 
Aditya
