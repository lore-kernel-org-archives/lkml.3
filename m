Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3HTUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:25:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55531 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3HTUZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:25:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20130819172524.GA22268@redhat.com>
	<CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com>
	<20130819183319.GA24846@redhat.com>
	<CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com>
	<20130819184355.GA25362@redhat.com>
	<CALCETrU4gTfzcpeEo-X7o-yZefKiw9BVNKdcN4fThUeiuZtOOg@mail.gmail.com>
	<20130820185043.GA24040@redhat.com>
	<CALCETrUjohT2D=jtVQ9mnbeUr2oJ9VoN812PtQhaB2ZZ89isNA@mail.gmail.com>
Date: Tue, 20 Aug 2013 13:25:16 -0700
In-Reply-To: <CALCETrUjohT2D=jtVQ9mnbeUr2oJ9VoN812PtQhaB2ZZ89isNA@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 20 Aug 2013 12:00:18 -0700")
Message-ID: <87zjscxg7n.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19UVIX1Pw5czcv6TEdqpzjRoYO7EtVghCQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4760]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Tue, Aug 20, 2013 at 11:50 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 08/20, Andy Lutomirski wrote:
>>>
>>> On Mon, Aug 19, 2013 at 11:43 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> > On 08/19, Andy Lutomirski wrote:
>>> >>
>>> >> On Mon, Aug 19, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>>> >> >
>>> >> > So do you think this change is fine or not (ignoring the fact it needs
>>> >> > cleanups) ?
>>> >>
>>> >> I think that removing the CLONE_VM check is fine (although there are
>>> >> some other ones that should probably be removed as well), but I'm not
>>> >> sure if that check needs replacing with something else.
>>> >
>>> > OK, thanks... but I still can't understand.
>>> >
>>> > The patch I sent is equivalent to the new one below. I just tried to
>>> > unify it with another check in do_fork().
>>>
>>> I was confused.
>>
>> Andy, I do not know how much you were confused, but I bet I am confused
>> much more ;)
>>
>>> Currently (with or without your patch), vfork() followed by
>>> unshare(CLONE_NEWUSER) or unshare(CLONE_NEWPID) will unshare the VM.
>>
>> Could you spell please?
>>
>> We never unshare the VM. CLONE_VM in sys_unshare() paths just means
>> "fail unless ->mm is not shared".
>>
>
> Argh.  In that case this is probably buggy, and I am just as confused
> as you.  This stuff is serious spaghetti code.
>
> sys_unshare will see CLONE_NEWPID or CLONE_NEWUSER and set
> CLONE_THREAD.  Then it will see CLONE_THREAD and set CLONE_VM.  Then
> check_unshare_flags will see CLONE_VM and fail if we just called
> vfork.
>
> Could this be made much more comprehensible by having a single list of
> shareable things are allowed to be shared across namespaces and
> enforcing the *same* list in clone and unshare?

Having a single function would be nice.

Unforutunately the logic is different (unshare attempts to silently add
the flags you need to make it work) and clone only unshares what you
tell it too.

Even more than that the meaning of half of the bits changes meaning
between unshare and clone.

For clone CLONE_VM means don't generate a new VM.
For unshare CLONE_VM means generate a new VM.

As for reorganizing shrug.  It is always possible to make things better
but clone doesn't look too scary to me.

Eric

