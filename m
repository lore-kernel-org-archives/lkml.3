Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3JWK6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:58:53 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:57076 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab3JWK6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:58:52 -0400
MIME-Version: 1.0
In-Reply-To: <5266EBF0.901@sandeen.net>
References: <5265956F.4010700@sandeen.net>
	<20131021224459.GE16161@dastard>
	<5265B4D2.3000907@sandeen.net>
	<20131021231849.GL10553@sgi.com>
	<20131021235601.GG4446@dastard>
	<5265C03B.50701@sandeen.net>
	<20131022001732.GI4446@dastard>
	<CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com>
	<20131022203946.GB2797@dastard>
	<5266E4BD.8030601@sandeen.net>
	<20131022210300.GC2797@dastard>
	<5266EBF0.901@sandeen.net>
Date: Wed, 23 Oct 2013 08:58:51 -0200
Message-ID: <CAGG-pUTtYomspBXn=RE7YFU=vu6rWZ1fU7CBO45Mmodj8DZFiQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        XFS FILESYSTEM <xfs@oss.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/22 Eric Sandeen <sandeen@sandeen.net>:
> On 10/22/13 4:03 PM, Dave Chinner wrote:
>> On Tue, Oct 22, 2013 at 03:49:01PM -0500, Eric Sandeen wrote:
>>> On 10/22/13 3:39 PM, Dave Chinner wrote:
>>>> On Tue, Oct 22, 2013 at 08:12:51AM -0200, Geyslan Gregório Bem wrote:
>>>>> 2013/10/21 Dave Chinner <david@fromorbit.com>:
>>>>>> On Mon, Oct 21, 2013 at 07:00:59PM -0500, Eric Sandeen wrote:
>>>>>>> On 10/21/13 6:56 PM, Dave Chinner wrote:
>>>>>>>> On Mon, Oct 21, 2013 at 06:18:49PM -0500, Ben Myers wrote:
>>>>>>
>>>>>> Yes, but to continue the Devil's Advocate argument, the purpose of
>>>>>> debug code isn't to enlightent the casual reader or drive-by
>>>>>> patchers - it's to make life easier for people who actually spend
>>>>>> time debugging the code. And the people who need the debug code
>>>>>> are expected to understand why an ASSERT is not necessary. :)
>>>>>>
>>>>> Dave, Eric and Ben,
>>>>>
>>>>> This was catched by coverity (CID 102348).
>>>>
>>>> You should have put that in the patch description.
>>>>
>>>> Now I understand why there's been a sudden surge of irrelevant one
>>>> line changes from random people that have never touched XFS before.
>>>>
>>>> <sigh>
>>>>
>>>> Ok, lets churn the code just to shut the stupid checker up. This
>>>> doesn't fix a bug, it doesn't change behaviour, it just makes
>>>> coverity happy. Convert it to the for loop plus ASSERT I mentioned
>>>> in a previous message.
>>>
>>> You know, I respectfully disagree, but we might just have to agree
>>> to disagree.  The code, as it stands, tests for a null ptr
>>> and then dereferences it.  That's always going to raise some
>>> eyebrows, coverity or not, debug code or not, drive by or not.
>>
>>> So even for future developers, making the code more self-
>>> documenting about this behavior would be a plus, whether it's by
>>> comment, by explicit ASSERT(), or whatever.  (I don't think
>>> that xfs_emerg() has quite enough context to make it obvious.)
>>
>> Sure, but if weren't for the fact that Coverity warned about it,
>> nobody other that us people who work on the XFS code day in, day out
>> would have even cared about it.
>>
>> That's kind of my point - again, as the Devil's Advocate - that
>> coverity is encouraging drive-by "fixes" by people who don't
>> actually understand any of the context, history and/or culture
>> surrounding the code being modified.
>
Dave, If Coverity had not caught this, I could have never sent a patch
to xfs in my entire life.
So, I need not to know the xfs culture, code or context to identify a
flagrant, intentional or not, code that seems a bug.
Open source world works this way, all can help, but only a few decide
to do it. And there many ways to do it; static analysis is only one.

> They shouldn't have to, the code (or comments therein) should
> make it obvious.  ;)  (in a perfect world...)
>
>> I have no problems with real bugs being fixed, but if we are
>> modifying code for no gain other than closing "coverity doesn't like
>> it" bugs, then we *should* be questioning whether the change is
>> really necessary.
>
> But let's give Geyslan the benefit of the doubt, and realize that
> Coverity does find real things, and even if it originated w/ a
> Coverity CID, when one sees:
>
>         if (!a)
>                 printk("a thing\n")
>
>         a = a->b = . . .
>
> it looks suspicious to pretty much anyone.  I don't think Geyslan
> sent it to shut Coverity up, he sent it because it looked like
> a bug worth fixing (after Coverity spotted it).
>
Eric, you're right. In this particular case, I didn't send to shut Coverity up.
And yeah, it looked like a bug that worth to fixing.

> Let's not be too hard on him for trying; I appreciate it more
> than spelling fixes and whitespace cleanups.  ;)
>
> I agree that some Coverity CIDs are false, and we shouldn't
> mangle code just to make it happy, but I just don't think that's
> what's going on here.  Let's imagine Geyslan saw 10 other CIDs
> and elected not to send changes, because they didn't look like
> they needed fixing, but this one looked like a bona fide bug.
>
Yep.

>> Asking the question may not change the outcome, but we need to ask
>> and answer the question regardless.
>
>>> (We don't have to change code to shut up coverity; we can flag
>>> it in the database and nobody else will see it.)
>>
>> Only if you are the first to see it and make an executive decision
>> that it's not necessary to fix.... :/
>
> Or, you find it, send a patch that seems reasonable, get massive
> pushback, (hopefully) flag it, and resolve never come back to xfs
> again.  ;)
Really, FWIW, the whole discussion to me is somewhat prolix. Let's see:

- We have a Coverity spot (Dereference after NULL check) = BUG.
- You identified that was intentional and isn't a bug. Ok?
- Regarding the "possible new patch" subject, I humbly pass the ball to you.

Thank you for the attention.

Geyslan
Regards.
>
> -Eric
>
>> Cheers,
>>
>> Dave.
>>
>
