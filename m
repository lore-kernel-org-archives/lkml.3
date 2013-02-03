Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3BCPY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:24:29 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:39225 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab3BCPYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 10:24:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        jmorris@namei.org, axboe@kernel.dk
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
	<87a9rltszn.fsf@xmission.com>
	<CAOS58YPhSz4DQT5-hTkH-wW_P3b5LK1WuEbWiR8uyNZPZdf_Gw@mail.gmail.com>
Date: Sun, 03 Feb 2013 07:24:11 -0800
In-Reply-To: <CAOS58YPhSz4DQT5-hTkH-wW_P3b5LK1WuEbWiR8uyNZPZdf_Gw@mail.gmail.com>
	(Tejun Heo's message of "Sun, 3 Feb 2013 06:13:53 -0800")
Message-ID: <87ehgxo1yc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/1e+jLPSqq37oLa4qNtK6Sb2RpQMogLiI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0335]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hey, Eric.
>
> On Sun, Feb 3, 2013 at 5:41 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Why the deep percpu magic?
>
> Eh? What's magical about it?  You preload percpu buffer if you're
> gonna be allocating an id from context which doesn't allow permissive
> allocation.  This is the same technique used by radix tree preloading.
>  The only reason idr did its own preloading was probably because it
> got implemented before we had proper percpu techniques.

Maybe.  I haven't been in the parts of the kernel that use the radix
tree preloading and I having just look at a bit of it I don't like it
either.  There is the same strong disconnect between the pieces whose
side effects are interacting.

At least with the radix tree the pieces are core kernel pieces that get
optimized like mad and you expect to have to think about.

idr is a boring thing you use because don't want to think about the
details.  Now you are asking people to really think about the details
when the touch a piece of code using idr.  I think that is the wrong
trade off.

>> Why don't associate idr_preload with an idr structure.
>
> Because then you end up with a lot more preloaded buffers which are
> much less useful.  You can't guarantee your preload target is the only
> one who's gonna use the preload buffer so you end up with this ugly
> -EAGAIN retry loop.  It's inefficient & inconvenient.

That argument makes sense.

>> When reading code with idr_preload I get this deep down creepy feeling.
>> What is this magic that is going on?
>
> Seriously, if this gives you deep creepy feeling, you need to get on
> with time.  It's a basic percpu technique.

But this isn't a basic percpu technique.  This is a basic percpu
technique hidden behind the wall.

Nothing about reading idr_preload() in a line of code says.  Hey look at
me I am version of preempt disable() that puts things in percpu
variables that you don't know about.

Nothing about idr_preload says don't you dair forget to pair me with
preload_end().

>> Can't we just put the preload list_head into struct idr make
>> idr_preload and idr_preload_end take an idr argument?
>
> Inefficient & inconvenient.

>> Maybe we can have a special structure we put on the stack that has
>> the list_head and the preload state instead.

This suggestion you didn't address at all.

If we can't put state in the structure because of the problem of
multiple accesses why can't we take the state out of the structure
entirely and put it into a stack local variable?

That would reduce the cognitive load because it becomes clear how
the pieces connect together.

That would remove the need for disabling preemption and other behind
the scenes magic.

>> The way this works just weirds me out and I really really don't like it.
>>
>> I would rather continue to use the existing functions as problematic as
>> they are as I don't need a course in deep magic to make sense of them.
>
> Heh, this is the weirdest review I got in quite a while.  Please sit
> down and read it again.

Please sit down and relook at your interface again.  People use idr
where they need a unique number associatedand they really don't care.
Having to think about hidden percpu variables and preemption being
disabled in the background brings with it a lot of extra work to use the
interface.

For the sake of a saving few lines of code you are desiging an interface
that is harder to use correctly, and harder to think about.

I think you are making completely the wrong trade off.  I don't want the
cognitive burden of having to think about percpu and preemption
disabling when using a boring utitlity function like the idr code.

Eric
