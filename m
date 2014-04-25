Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaDYTlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:41:08 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60280 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaDYTlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:41:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        john.johansen@canonical.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, viro@ZenIV.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team@lists.ubuntu.com
References: <535A5C78.1070901@samsung.com> <535A75C1.3050901@samsung.com>
	<20140425182310.GA9128@redhat.com>
	<87sip15iy5.fsf@x220.int.ebiederm.org>
	<20140425192543.GA11908@redhat.com>
Date: Fri, 25 Apr 2014 12:40:32 -0700
In-Reply-To: <20140425192543.GA11908@redhat.com> (Oleg Nesterov's message of
	"Fri, 25 Apr 2014 21:25:43 +0200")
Message-ID: <878uqt42q7.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/+CdbdrT3lx6Q+v9r+oJCHMV6w1xai5u4=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4701]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 04/25, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > Eric, this makes me think again that we should do exit_task_namespaces()
>> > after exit_task_work(). We already discussed this before, but this looks
>> > like another indication this change makes sense.
>>
>> I know you mentioned something about that.  I haven't actually had much
>> time to think about it.
>>
>> > The problem with fput() from free_nsproxy() was hopefully also fixed by
>> > e7b2c4069252. The main motivation for "move" was "outside of exit_notify".
>> > Even if we fix the paths above task_work_add() can have another user which
>> > wants ->nsproxy.
>> >
>> > What do you think?
>>
>> I am scratching my head.  Delayed work that depends on current sort of
>> blows my mind.
>
> But task_work_add(task) was specially introduced to run a callback in the
> task's context.
>
>> That is utter nonsense.
>
> Yes I agree, _perhaps_ we can fix this particular problem without changing
> the exit_namespace/work ordering, and perhaps this makes sense anyway.
>
> Well. I _think_ that __fput() and ima_file_free() in particular should not
> depend on current and/or current->nsproxy. If nothing else, fput() can be
> called by the unrelated task which looks into /proc/pid/.
>
> But again, task_work_add() has more and more users, and it seems that even
> __fput() paths can do "everything", so perhaps it would be safer to allow
> to use ->nsproxy in task_work_run.

Like I said, give me a clear motivating case.  Right now not allowing
nsproxy is turning up bugs in __fput.  Which seems like a good thing.

Eric


