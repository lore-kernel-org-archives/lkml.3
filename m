Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaDZItR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 04:49:17 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:33066 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaDZItL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 04:49:11 -0400
MIME-Version: 1.0
In-Reply-To: <87bnvpvz3y.fsf@x220.int.ebiederm.org>
References: <535A5C78.1070901@samsung.com>
	<535A75C1.3050901@samsung.com>
	<20140425182310.GA9128@redhat.com>
	<87sip15iy5.fsf@x220.int.ebiederm.org>
	<20140425192543.GA11908@redhat.com>
	<878uqt42q7.fsf@x220.int.ebiederm.org>
	<20140425200156.GA13727@redhat.com>
	<CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
	<874n1h16le.fsf@x220.int.ebiederm.org>
	<CACE9dm_56FvbJDVyxvTtd3yL+d89XYhZ-i038HJS-sUsZAPpaQ@mail.gmail.com>
	<87iopxxfpp.fsf@x220.int.ebiederm.org>
	<CACE9dm-fdqDgFT5Pw1ry6XOuAhqmsEEiQMOFw=rooazBkdx-wg@mail.gmail.com>
	<87bnvpvz3y.fsf@x220.int.ebiederm.org>
Date: Sat, 26 Apr 2014 11:49:09 +0300
Message-ID: <CACE9dm_NxHyx_9_7L7hw0+xza8_5Q34cEDuhYMtgPNGyge8eAw@mail.gmail.com>
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, viro@zeniv.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>,
        MimiZ <mimi.e.zohar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2014 01:11, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Dmitry Kasatkin <dmitry.kasatkin@gmail.com> writes:
>
>> On 26 April 2014 00:27, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> Dmitry Kasatkin <dmitry.kasatkin@gmail.com> writes:
>>>
>>>> On 25 April 2014 23:45, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>> Dmitry Kasatkin <dmitry.kasatkin@gmail.com> writes:
>>>>>
>>>>>> On 25 April 2014 23:01, Oleg Nesterov <oleg@redhat.com> wrote:
>>>>>>> On 04/25, Eric W. Biederman wrote:
>>>>>>>>
>>>>>>>> Oleg Nesterov <oleg@redhat.com> writes:
>>>>>>>>
>>>>>>>> > Well. I _think_ that __fput() and ima_file_free() in particular should not
>>>>>>>> > depend on current and/or current->nsproxy. If nothing else, fput() can be
>>>>>>>> > called by the unrelated task which looks into /proc/pid/.
>>>>>>>> >
>>>>>>>> > But again, task_work_add() has more and more users, and it seems that even
>>>>>>>> > __fput() paths can do "everything", so perhaps it would be safer to allow
>>>>>>>> > to use ->nsproxy in task_work_run.
>>>>>>>>
>>>>>>>> Like I said, give me a clear motivating case.
>>>>>>>
>>>>>>> I agree, we need a reason. Currently I do not see one.
>>>>>>>
>>>>>>>> Right now not allowing
>>>>>>>> nsproxy is turning up bugs in __fput.  Which seems like a good thing.
>>>>>>>
>>>>>>> This is what I certainly agree with ;)
>>>>>>>
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> IMA uses kernel_read API which does not know anything about caller.
>>>>>> And of course security frameworks are at guard as usual.
>>>>>>
>>>>>> Exactly after reading first Eric's respons, I thought why to scratch
>>>>>> the head when task work queues are indeed designed for tasks...
>>>>>
>>>>> __fput has no guarantee of running in the task that close the file
>>>>> descriptor.  If your code depends on that your code is broken.
>>>>>
>>>>>> And if you to dig for the history, IMA-appraisal was stuck due to
>>>>>> lockdep reporting even though it was on non-everlaping cases.
>>>>>> IIRC files vs. directories...
>>>>>>
>>>>>> After that IIRC Al Viro discussed about delayed fput and IIRC Oleg
>>>>>> (sorry if I am wrong) introduced task work queues.
>>>>>>
>>>>>> So IMA-appraisal was able to be upstreamed... That was ~3.4 time frame, IIRC
>>>>>>
>>>>>> Name space also dated around ~3.4??
>>>>>> Apparmor namespace change was also around that time.
>>>>>>
>>>>>> 3.10 introduces this name space order change and broke IMA-appraisal.
>>>>>
>>>>> IMA-appraisal is fundamentally broken because I can take a mandatory
>>>>> file lock and prevent IMA-apprasial.
>>>>>
>>>>
>>>> What file lock are you talking about?
>>>> IMA-appraisal does not depends on file locks...
>>>
>>> It honors them.  Look at rw_verify_area, in vfs_read, in kernel_read.
>>>
>>> It sure looks like locks_mandatory_area can cause your kernel_read to
>>> fail.
>>>
>>>>> Using kernel_read is what allows this.
>>>>>
>>>>>> Isn't it a clear motivating case???
>>>>>
>>>>> kernel_read is not appropriate for IMA use.  The rest of this is just
>>>>> the messenger.
>>>>>
>>>>> IMA needs to use a cousin of kernel_read that operates at a lower level
>>>>> than vfs_read.  A function that all of the permission checks and the
>>>>> fsnotify work.
>>>>>
>>>>> I am sorry to be the bearer of bad news.  But kernel_read is totally
>>>>> inappropriate for IMA.
>>>>>
>>>>
>>>> So you break IMA-appraisal and declare that it cannot be used now?
>>>
>>> I didn't break it.  I read the code, and I read the back trace to see
>>> where the bug was.
>>>
>>> I see IMA-appraisal trying to read file data as if it were a user space
>>> application in such a way that it can get permission denied for a whole
>>> host of reasons.
>>>
>>> My understanding of IMA-appraisal is that using a code path that can
>>> give use permission denined when performing appraisal is a way for
>>> clever people to attack and avoid IMA-appraisal without violating any
>>> security policy.
>>>
>>
>> Interesting thing is that file was already open before and LSM gave OK for this.
>> Then re-reading the file on close in fact does not need any LSM
>> permission checks.
>
> And LSM are typically an implementation of mandatory access control.
> Which means they do the crazy thing of checking every file operation.
> Which means from one operation to the next they can give you -EPERM.
>
>> But as kernel_read API is still the same, it goes via the same checks...
>>
>> But on close with delayed fput nsproxy is missing ....
>
> And you might right in the same processor or you might be called in a
> completely different process with completely different credentials
> and security labels and the the lsm instead of crashing would silently
> tell you no, and you have even stranger bugs to track down.
>

task works are supposed to be called from process context and credentials
should stay the same on any CPU.

Isn't it?

And not taking into account to IMA, reverse order of exit_taskwork and
exit_namespaces
looks reasonable as it was before.

>>> Am I wrong.  Is it ok for IMA-appraisal to get permission denied when it
>>> wants to appraise a file?
>>>
>>
>> IMA is called after may_open...
>
> Which in the case of mandatory file locking, or lsms means little.
>

No, it does not mean little.
LSMs, which are AC models, can only impose additional restrictions,
not to relax them.

IMA is not AC LSM, it is integrity verification module.
But follows the same principal.
It may further to restrict the access by performing integrity checks...
It makes sure that that "OK" decision granted by LSM, was actually
based on trustworthy
file credentials...

> I am afraid your mental model of where linux does permission checks is
> about 20 years out of date.  Which is interesting to say to an lsm maintainer...
>

Be sure it's not. I am quite aware where linux does permission checks.

> Eric

IMA does kernel_read at file open.
At that point, security_file_permission might have certain sense as
process will be reading file after that.
Though, it will also happen during real file access..

In the case of IMA-appraisal, on file close, indeed file_permission
check is useless.
It may be "utter nonsense" as you say.


-- 
Thanks,
Dmitry
