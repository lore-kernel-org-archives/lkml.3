Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaBQIeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:34:23 -0500
Received: from relay.parallels.com ([195.214.232.42]:32970 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaBQIeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:34:21 -0500
Message-ID: <5301C984.40904@parallels.com>
Date: Mon, 17 Feb 2014 12:34:12 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Andrew Vagin <avagin@gmail.com>,
        Aditya Kali <adityakali@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, <linux-kernel@vger.kernel.org>,
        <criu@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [CRIU] [PATCH 1/3] prctl: reduce permissions to change boundaries
 of data, brk and stack
References: <1392387209-330-1-git-send-email-avagin@openvz.org> <1392387209-330-2-git-send-email-avagin@openvz.org> <874n41znl5.fsf@xmission.com> <20140214174314.GA5518@gmail.com> <20140214180129.GK13358@moon> <8761ohqzc6.fsf@xmission.com> <52FE72C1.9090100@parallels.com> <87txc1pibc.fsf@xmission.com>
In-Reply-To: <87txc1pibc.fsf@xmission.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2014 12:09 AM, Eric W. Biederman wrote:
> Pavel Emelyanov <xemul@parallels.com> writes:
> 
>> On 02/14/2014 11:16 PM, Eric W. Biederman wrote:
>>> Cyrill Gorcunov <gorcunov@gmail.com> writes:
>>>
>>>> On Fri, Feb 14, 2014 at 09:43:14PM +0400, Andrew Vagin wrote:
>>>>>> My brain hurts just looking at this patch and how you are justifying it.
>>>>>>
>>>>>> For the resources you are mucking with below all you have to do is to
>>>>>> verify that you are below the appropriate rlimit at all times and no
>>>>>> CAP_SYS_RESOURCE check is needed.  You only need CAP_SYS_RESOURCE
>>>>>> to exceed your per process limits.
>>>>>>
>>>>>> All you have to do is to fix the current code to properly enforce the
>>>>>> limits.
>>>>>
>>>>> I'm afraid what you are suggesting doesn't work.
>>>>>
>>>>> The first reason is that we can not change both boundaries in one call.
>>>>> But when we are restoring these attributes, we may need to move their
>>>>> too far.
>>>>
>>>> When this code was introduced, there were no user-namespace implementation,
>>>> if I remember correctly, so CAP_SYS_RESOURCE was enough barrier point
>>>> to prevent modifying this values by anyone. Now user-ns brings a limit --
>>>> we need somehow to provide a way to modify these mm fields having no
>>>> CAP_SYS_RESOURCE set. "Verifying rlimit" not an option here because
>>>> we're modifying members one by one (looking back I think this was not
>>>> a good idea to modify the fields in this manner).
>>>>
>>>> Maybe we could improve this api and provide argument as a pointer
>>>> to a structure, which would have all the fields we're going to
>>>> modify, which in turn would allow us to verify that all new values
>>>> are sane and fit rlimits, then we could (probably) deprecate old
>>>> api if noone except c/r camp is using it (I actually can't imagine
>>>> who else might need this api). Then CAP_SYS_RESOURCE requirement
>>>> could be ripped off. Hm? (sure touching api is always "no-no"
>>>> case, but maybe...)
>>>
>>> Hmm.  Let me rewind this a little bit.
>>>
>>> I want to be very stupid and ask the following.
>>>
>>> Why can't you have the process of interest do:
>>> 	ptrace(PTRACE_ATTACHME);
>>> 	execve(executable, args, ...);
>>>         
>>>         /* Have the ptracer inject the recovery/fixup code */
>>> 	/* Fix up the mostly correct process to look like it has been
>>>          * executing for a while.
>>>          */
>>
>> Let's imagine we do that.
>>
>> This means, that the whole memory contents should be restored _after_
>> the execve() call, since the execve() flushes old mappings. In
>> that case we lose the ability to preserve any shared memory regions
>> between any two processes. This "shared" can be either regular
>> MAP_SHARED mappings or MAP_ANONYMOUS but still not COW-ed ones.
> 
> If we have MAP_ANONYMOUS but not COW-ed mappings we have the correct
> executable, which implies we have everything else correct except for the
> brk and the stack addresses, because the process was started with fork.
> 
> So while that sounds like an interesting case to handle it does not seem
> to invalidate the idea of using exec to set all of the other fields when
> we need to set them.

Well, yes, what you propose we call "inheritable resources". These are, e.g.
SIDs or shared FD-table/MM-s. That's OK to restore them at fork(), but I'd like
to draw your attention to two concerns I have with this approach.

1. Inheritable resources can be potentially restored more than one time. Consider
   you have tasks tree look like this:

task-A  -[exe]-> A
 `- task-C1 -[exe]-> C
 `- task-C2 -[exe]-> C

IOW -- task A has executable A and two kids C1 and C2 that share executable C.

In that case the restore sequence should look like this

* Task A calls execve() on C
* Task A forks C1
* Task A forks C2
* Task A calls execve() on A

This does work, I agree, but task A has to call execve() two times. And even more, if
we had e.g. D1 and D2 kids with different exe D. Now, why I think that's a problem?
Please, see concern #2 :)


2. What you propose means we have to effectively strace and execve-ing task. As
compared with plain prlctl this is up to ~600 times slower. I've made such an experiment.

* Idle node with plenty of free RAM
* Simple proggie doing execve() on self for 1000 times, compiled statically to avoid
  ld.so spoiling the times, run under strace
* Another proggie doing open() + prlctl() 1000 times.

The first task took ~12 sec to complete. The second -- ~0.02 seconds.

If we take an average container of 100 tasks, even with all different exe links, your
approach would give us ~1 sec more to restore, while existing one would be almost
no op. And this hits us even without the inheritance scenario I demonstrated above.

Please, keep in mind, that checkpoint-restore in not only live-migration, we have
use cases where restore cannot be pre-restored for better down-time. It _must_ be
as fast as possible.



That said, Eric, I do agree with your concern about security, I _am_ ready to rework
this stuff and kill the whole bunch of prctls we have. But please! Very please! Can
we come up with mm->foo-s and ->exe_link restoration API that is at most ... 5 times
slower than existing prlctl? It's really-really important for us!

Maybe we can make prlctl() do lite-execve()? It will open the executable, read the
required amount of headers and just put data red from there onto mm-struct? This 
should be MUCH better, that full execve() with loading all binary data plus strace
and flushing old mm-s.

> Eric

Thanks,
Pavel

