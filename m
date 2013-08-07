Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab3HGHpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:45:25 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53311 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab3HGHpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:45:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, xi.wang@gmail.com,
        nicolas.dichtel@6wind.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5200A5E6.9020803@asianux.com> <8761vibihw.fsf@xmission.com>
	<5201D62B.6080905@asianux.com>
Date: Wed, 07 Aug 2013 00:45:01 -0700
In-Reply-To: <5201D62B.6080905@asianux.com> (Chen Gang's message of "Wed, 07
	Aug 2013 13:07:55 +0800")
Message-ID: <87li4ex7uq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19K1sqyf974HgqP+l420Skn9WJCfG1Hk9M=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Chen Gang <gang.chen@asianux.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kernel/sysctl_binary.c: improve the usage of return value 'result'
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:

> On 08/07/2013 05:46 AM, Eric W. Biederman wrote:
>> Chen Gang <gang.chen@asianux.com> writes:
>> 
>> Have you tested this code?  Do you have anything that actually the
>> uses sysctl binary interface?
>> 
>
> No, I only compile about it, not give a test. It is really better to
> give a test, but it seems not quite necessary to must give a test
> (since it is a simple change).

Many programs have been broken by programmers not caring enough to test
their changes.  In this case it is doubly important because if you don't
test this code it is likely no one will run this code for months.

>> If you do have code that actually uses this interface please fix it not
>> to use it.  This code is fundamentally a stop gap measure and will
>> bit-rot in time and then we will remove it.
>> 
>
> OK, since these code will be removed, and this patch is not for bug
> fixing, so at least, this patch is useless.

The point of all of this is that it really helps if you stop and learn
the context of the code you are working on.  It also helps if you care
about the changes you are making.  

In this case the history of sysctl(2) is that someone copied sysctl(2)
from bsd.  Then someone quickly created /proc/sys/ to reflect the same
data in a friendlier format.  sysctl(2) was quickly deprecated and was
effectively never used in practice.  With one notable exception an old
use in glibc.

I was very nice a few years ago and instead of just deleting the code I
wrote a wrapper layer so that the binary interface would translate into
read/write operations on /proc/sys. Mostly that was about not letting
the maintenance of sysctl(2) be a drag on the maintenance of /proc/sys/.
People do care about /proc/sys and do test it and fix bugs with it.

>>> Improve the usage of return value 'result', so not only can make code
>>> clearer to readers, but also can improve the performance.
>>>
>>> Assign the return error code only when error occurs, so can save some
>>> instructions (some of them are inside looping).
>> 
>> That actually is a code pessimization, not an optimization.  As are most
>> of your proposed changes.  Only assigning the error code simply can not
>> generate better assembly code.
>> 
>
> Excuse me, my English is not quite well, I don't know about the meaning
> of 'pessimization' (I can not find it in my English-Chinese dictionary,
> in Thunderbird Spell Check, it is not a correct word either).

Pessimization is the opposite of optimization.  Both words are literally
ridiculous as optimization means to make something more optimum, and
pessimization means to make things more pessimal, and  optimum and
pessimal refer to the best and the worst possible situtations.  But
whoever let a silly dictionary meaning get in the way of a good use of a
word.

> But it seems it doesn't matter, what you want to say is only "it is not
> an optimization", is it correct ?

Correct.

>>> Rewrite the sysctl_getname() to make code clearer to readers, and also
>>> can save some instructions (it is mainly related with the usage of the
>>> variable 'result').
>> 
>> Again you are introducing branches and pessimizing the code in the name
>> of optimization.
>> 
>
> Hmm... it is useless for optimization.
>
> But in my opinion, at least, it can make code more clearer for C code
> readers, although it may make performance a litter lower.
>
> Please see the 2 implementations below, I feel 2nd is clearer than 1st,
> how about your feeling ?

My feeling is if you don't care about sysctl(2) enough to figure out the
history or compile test it, or even actually use it, it is highly
unlikely you actually care about reading the code.

I care just enough about the code to keep people who would not even
notice if it the code breaks from touching it.

> Do you mean: you don't care about "checkpatch.pl", because some of
> another reasons which in fact not related with "checkpatch.pl" though
> ?

checkpatch.pl is not the definition of good code, or good style but
meerly a tool to help point out problems before a human has to be bother
to look at it.  If a style problem is real it can be explained without
reference to an arbitrary tool.

>> The right answer to the code is to config it out and then you don't have
>> to worry about it one way or another.
>> 
>
> Pardon?
>
> Excuse me, my English is not quite well, I don't quite understand your
> meaning, could you please repeat again in details or say more clearly?

You can enable or disable this code with "make menuconfig".  Everyone
should just turn binary sysctl support off and ignore this code.   The
someday when the code has bit-rotted because no one actually cares we
can delete this code.

>> The sysctl binary path has never been properly maintained and I don't
>> intend to start.   But I will spend 5 minutes to say this patch seems to
>> make the code worse not better.
>>
>
> I guess no one ever invited you to maintain this file (for just as you
> said, this file will be removed), so don't worry about it.

We may get around to removing it.  There are just enough silly people
who think it is more important to keep open the possibility of keeping
strange old binaries running than to avoid code bugs that the code has
stayed this long.  But no one has ever cared enough to in practice to
maintain this code.

I use people sending patches to sysctl_binary.c as an opportunity to
educate people that their program is doing something silly and they
should change their ways.  sysctl_binary.c really is effectively a honey
pot for developers and organizations who are not paying attention.

Eric
