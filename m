Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab3HTRzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:55:54 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55850 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3HTRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:55:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20130819172524.GA22268@redhat.com>
	<CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com>
	<20130819183319.GA24846@redhat.com>
	<CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com>
	<20130819184355.GA25362@redhat.com>
Date: Tue, 20 Aug 2013 10:55:40 -0700
In-Reply-To: <20130819184355.GA25362@redhat.com> (Oleg Nesterov's message of
	"Mon, 19 Aug 2013 20:43:55 +0200")
Message-ID: <87siy4z1pf.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18+TkBG9yvROexAgXXTy8kev+wJzgXq/wY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4756]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 08/19, Andy Lutomirski wrote:
>>
>> On Mon, Aug 19, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > So do you think this change is fine or not (ignoring the fact it needs
>> > cleanups) ?
>>
>> I think that removing the CLONE_VM check is fine (although there are
>> some other ones that should probably be removed as well), but I'm not
>> sure if that check needs replacing with something else.
>
> OK, thanks... but I still can't understand.
>
> The patch I sent is equivalent to the new one below. I just tried to
> unify it with another check in do_fork().

The patch below also needs CLONE_SIGHAND.  You can't meaningfully share
signal handlers if you can't represent the pid in the siginfo.  pids and
signals are too interconnected.

Eric

> Oleg.
>
> --- x/kernel/fork.c
> +++ x/kernel/fork.c
> @@ -1176,7 +1176,7 @@ static struct task_struct *copy_process(
>  	 * If the new process will be in a different pid namespace
>  	 * don't allow the creation of threads.
>  	 */
> -	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
> +	if ((clone_flags & (CLONE_THREAD | CLONE_PARENT | CLONE_NEWPID)) &&
>  	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
>  		return ERR_PTR(-EINVAL);
>  
