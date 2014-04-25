Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaDYUwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:52:24 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:61502 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaDYUwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:52:22 -0400
MIME-Version: 1.0
In-Reply-To: <874n1h16le.fsf@x220.int.ebiederm.org>
References: <535A5C78.1070901@samsung.com>
	<535A75C1.3050901@samsung.com>
	<20140425182310.GA9128@redhat.com>
	<87sip15iy5.fsf@x220.int.ebiederm.org>
	<20140425192543.GA11908@redhat.com>
	<878uqt42q7.fsf@x220.int.ebiederm.org>
	<20140425200156.GA13727@redhat.com>
	<CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
	<874n1h16le.fsf@x220.int.ebiederm.org>
Date: Fri, 25 Apr 2014 23:52:20 +0300
Message-ID: <CACE9dm_56FvbJDVyxvTtd3yL+d89XYhZ-i038HJS-sUsZAPpaQ@mail.gmail.com>
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, viro@zeniv.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 April 2014 23:45, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Dmitry Kasatkin <dmitry.kasatkin@gmail.com> writes:
>
>> On 25 April 2014 23:01, Oleg Nesterov <oleg@redhat.com> wrote:
>>> On 04/25, Eric W. Biederman wrote:
>>>>
>>>> Oleg Nesterov <oleg@redhat.com> writes:
>>>>
>>>> > Well. I _think_ that __fput() and ima_file_free() in particular should not
>>>> > depend on current and/or current->nsproxy. If nothing else, fput() can be
>>>> > called by the unrelated task which looks into /proc/pid/.
>>>> >
>>>> > But again, task_work_add() has more and more users, and it seems that even
>>>> > __fput() paths can do "everything", so perhaps it would be safer to allow
>>>> > to use ->nsproxy in task_work_run.
>>>>
>>>> Like I said, give me a clear motivating case.
>>>
>>> I agree, we need a reason. Currently I do not see one.
>>>
>>>> Right now not allowing
>>>> nsproxy is turning up bugs in __fput.  Which seems like a good thing.
>>>
>>> This is what I certainly agree with ;)
>>>
>>
>> Hi,
>>
>> IMA uses kernel_read API which does not know anything about caller.
>> And of course security frameworks are at guard as usual.
>>
>> Exactly after reading first Eric's respons, I thought why to scratch
>> the head when task work queues are indeed designed for tasks...
>
> __fput has no guarantee of running in the task that close the file
> descriptor.  If your code depends on that your code is broken.
>
>> And if you to dig for the history, IMA-appraisal was stuck due to
>> lockdep reporting even though it was on non-everlaping cases.
>> IIRC files vs. directories...
>>
>> After that IIRC Al Viro discussed about delayed fput and IIRC Oleg
>> (sorry if I am wrong) introduced task work queues.
>>
>> So IMA-appraisal was able to be upstreamed... That was ~3.4 time frame, IIRC
>>
>> Name space also dated around ~3.4??
>> Apparmor namespace change was also around that time.
>>
>> 3.10 introduces this name space order change and broke IMA-appraisal.
>
> IMA-appraisal is fundamentally broken because I can take a mandatory
> file lock and prevent IMA-apprasial.
>

What file lock are you talking about?
IMA-appraisal does not depends on file locks...

> Using kernel_read is what allows this.
>
>> Isn't it a clear motivating case???
>
> kernel_read is not appropriate for IMA use.  The rest of this is just
> the messenger.
>
> IMA needs to use a cousin of kernel_read that operates at a lower level
> than vfs_read.  A function that all of the permission checks and the
> fsnotify work.
>
> I am sorry to be the bearer of bad news.  But kernel_read is totally
> inappropriate for IMA.
>

So you break IMA-appraisal and declare that it cannot be used now?

> Eric
>



-- 
Thanks,
Dmitry
