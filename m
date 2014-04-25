Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaDYUp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 16:45:58 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47877 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaDYUpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 16:45:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, viro@zeniv.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>
References: <535A5C78.1070901@samsung.com> <535A75C1.3050901@samsung.com>
	<20140425182310.GA9128@redhat.com>
	<87sip15iy5.fsf@x220.int.ebiederm.org>
	<20140425192543.GA11908@redhat.com>
	<878uqt42q7.fsf@x220.int.ebiederm.org>
	<20140425200156.GA13727@redhat.com>
	<CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
Date: Fri, 25 Apr 2014 13:45:17 -0700
In-Reply-To: <CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
	(Dmitry Kasatkin's message of "Fri, 25 Apr 2014 23:20:54 +0300")
Message-ID: <874n1h16le.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18cluPz29B3a0Du8xCculLu7H39l4wsdWQ=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4098]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <dmitry.kasatkin@gmail.com> writes:

> On 25 April 2014 23:01, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 04/25, Eric W. Biederman wrote:
>>>
>>> Oleg Nesterov <oleg@redhat.com> writes:
>>>
>>> > Well. I _think_ that __fput() and ima_file_free() in particular should not
>>> > depend on current and/or current->nsproxy. If nothing else, fput() can be
>>> > called by the unrelated task which looks into /proc/pid/.
>>> >
>>> > But again, task_work_add() has more and more users, and it seems that even
>>> > __fput() paths can do "everything", so perhaps it would be safer to allow
>>> > to use ->nsproxy in task_work_run.
>>>
>>> Like I said, give me a clear motivating case.
>>
>> I agree, we need a reason. Currently I do not see one.
>>
>>> Right now not allowing
>>> nsproxy is turning up bugs in __fput.  Which seems like a good thing.
>>
>> This is what I certainly agree with ;)
>>
>
> Hi,
>
> IMA uses kernel_read API which does not know anything about caller.
> And of course security frameworks are at guard as usual.
>
> Exactly after reading first Eric's respons, I thought why to scratch
> the head when task work queues are indeed designed for tasks...

__fput has no guarantee of running in the task that close the file
descriptor.  If your code depends on that your code is broken.

> And if you to dig for the history, IMA-appraisal was stuck due to
> lockdep reporting even though it was on non-everlaping cases.
> IIRC files vs. directories...
>
> After that IIRC Al Viro discussed about delayed fput and IIRC Oleg
> (sorry if I am wrong) introduced task work queues.
>
> So IMA-appraisal was able to be upstreamed... That was ~3.4 time frame, IIRC
>
> Name space also dated around ~3.4??
> Apparmor namespace change was also around that time.
>
> 3.10 introduces this name space order change and broke IMA-appraisal.

IMA-appraisal is fundamentally broken because I can take a mandatory
file lock and prevent IMA-apprasial.

Using kernel_read is what allows this.

> Isn't it a clear motivating case???

kernel_read is not appropriate for IMA use.  The rest of this is just
the messenger.

IMA needs to use a cousin of kernel_read that operates at a lower level
than vfs_read.  A function that all of the permission checks and the
fsnotify work.

I am sorry to be the bearer of bad news.  But kernel_read is totally
inappropriate for IMA.

Eric

