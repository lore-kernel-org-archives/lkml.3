Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaHJUJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 16:09:30 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51490 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaHJUJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 16:09:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?utf-8?Q?J=C3=B6rg?= Otte <jrg.otte@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CADDKRnDD_W5yJLo2otWXH8oEgmGdMP0N_p7wenBQbh17xKGZJg@mail.gmail.com>
	<CA+55aFzDpH8ntPO=JMdJ4Pu-SFV=9HQsXBcPakrZZq2mE9rJsA@mail.gmail.com>
Date: Sun, 10 Aug 2014 13:05:32 -0700
In-Reply-To: <CA+55aFzDpH8ntPO=JMdJ4Pu-SFV=9HQsXBcPakrZZq2mE9rJsA@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 10 Aug 2014 11:11:56 -0700")
Message-ID: <8761i0hzzn.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1+mxxw75uYr3Iy4Qiqn+XxJHF8bzUNMeDs=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3822]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [proc:] 3.16.0-10436-g9138475: access denied to /proc/1540/task/1540/net/dev
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, Aug 10, 2014 at 10:25 AM, Jörg Otte <jrg.otte@gmail.com> wrote:
>> My network interface eth0 doesn't come up in 3.16.0-10436-g9138475
>> I am seeing following "security problem" in dmesg:
>>
>> audit: type=1400 audit(1407684227.003:28): apparmor="DENIED"
>>   operation="open" profile="/sbin/dhclient"
>>   name="/proc/1540/task/1540/net/dev" pid=1540 comm="dhclient"
>>   requested_mask="r" denied_mask="r" fsuid=0 ouid=0
>>
>> I think the problem is introduced by the following commits, especially
>> 6ba8ed7:
>
> Ok.  Just to be sure, can you verify by reverting or bisecting exactly
> which one breaks for you? I suspect it's commits 344470cac42e and
> e81324407269 (commit 6ba8ed79a3cc just adds a "net" entry to the
> thread case too, not just the task). Well, only e81324407269 will
> matter for *this* case, but the /proc/mounts issue is basically
> identical.
>
> Eric, some or all of those need to be reverted, and regardless you
> need to stop thinking you can just change things.
>
> I realize that you knew about this possibility, but you now need to
> not just realize that "it is possible that this breaks things" to
> really stop doing crap like this. If you realize you are changing
> semantics or moving files around, you need to go "I must not do that".
>
> This crazy namespace disease of trying to "fix" things by breaking
> existing code MUST STOP. I'm growing really tired of this.

My apologies.  I really didn't think it would matter.  Certainly not
matter so much that people have machines that don't boot.  I am making
a note to myself that security policies are crazy and changes to /proc
should take that into account.  Sigh.

It seems clear that 344470cac42e and e81324407269 are causing more
trouble than the small amount of pain they were meant to solve, so let's
just revert them.

That does nothing for the weird multi-threadded apps that access
/proc/net/... and are surprised when it doesn't work.  It just leaves
them in the same shape they are today.

> It does sound like the problem may be specific to the fact that
> apparmor cares about the exact path we're using, and thus what
> *should* be harmless changes to the symlink from "current task" to
> "current thread" exposes things. Admittedly apparmor is a bit crazy if
> so, but I'm guessing your base apparmor config currently special-cases
> "/proc/<pid>" but _not_ "/proc/<pid>/task/<pid>"
>
> I'm wondering if we could/should make /proc/mount and /proc/net point
> to /proc/<pid> at _least_ when current->namespace ==
> current->thread_leader->namespace.

That might work.

Whatever is tried (besides a revert of 344470cac42e and e81324407269) it
looks like it is best left for another merge window.  Otherwise I am
afraid we will be playing whack-a-mole.

Linus would you like me to send pull request with those two changes reverted?

Eric
