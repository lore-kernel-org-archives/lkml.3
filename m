Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3JVVTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:19:48 -0400
Received: from sandeen.net ([63.231.237.45]:56944 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab3JVVTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:19:47 -0400
Message-ID: <5266EBF0.901@sandeen.net>
Date: Tue, 22 Oct 2013 16:19:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        XFS FILESYSTEM <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfs: fix possible NULL dereference
References: <5265956F.4010700@sandeen.net> <20131021224459.GE16161@dastard> <5265B4D2.3000907@sandeen.net> <20131021231849.GL10553@sgi.com> <20131021235601.GG4446@dastard> <5265C03B.50701@sandeen.net> <20131022001732.GI4446@dastard> <CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com> <20131022203946.GB2797@dastard> <5266E4BD.8030601@sandeen.net> <20131022210300.GC2797@dastard>
In-Reply-To: <20131022210300.GC2797@dastard>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/13 4:03 PM, Dave Chinner wrote:
> On Tue, Oct 22, 2013 at 03:49:01PM -0500, Eric Sandeen wrote:
>> On 10/22/13 3:39 PM, Dave Chinner wrote:
>>> On Tue, Oct 22, 2013 at 08:12:51AM -0200, Geyslan Gregório Bem wrote:
>>>> 2013/10/21 Dave Chinner <david@fromorbit.com>:
>>>>> On Mon, Oct 21, 2013 at 07:00:59PM -0500, Eric Sandeen wrote:
>>>>>> On 10/21/13 6:56 PM, Dave Chinner wrote:
>>>>>>> On Mon, Oct 21, 2013 at 06:18:49PM -0500, Ben Myers wrote:
>>>>>
>>>>> Yes, but to continue the Devil's Advocate argument, the purpose of
>>>>> debug code isn't to enlightent the casual reader or drive-by
>>>>> patchers - it's to make life easier for people who actually spend
>>>>> time debugging the code. And the people who need the debug code
>>>>> are expected to understand why an ASSERT is not necessary. :)
>>>>>
>>>> Dave, Eric and Ben,
>>>>
>>>> This was catched by coverity (CID 102348).
>>>
>>> You should have put that in the patch description.
>>>
>>> Now I understand why there's been a sudden surge of irrelevant one
>>> line changes from random people that have never touched XFS before.
>>>
>>> <sigh>
>>>
>>> Ok, lets churn the code just to shut the stupid checker up. This
>>> doesn't fix a bug, it doesn't change behaviour, it just makes
>>> coverity happy. Convert it to the for loop plus ASSERT I mentioned
>>> in a previous message.
>>
>> You know, I respectfully disagree, but we might just have to agree
>> to disagree.  The code, as it stands, tests for a null ptr
>> and then dereferences it.  That's always going to raise some
>> eyebrows, coverity or not, debug code or not, drive by or not.
> 
>> So even for future developers, making the code more self-
>> documenting about this behavior would be a plus, whether it's by
>> comment, by explicit ASSERT(), or whatever.  (I don't think
>> that xfs_emerg() has quite enough context to make it obvious.)
> 
> Sure, but if weren't for the fact that Coverity warned about it,
> nobody other that us people who work on the XFS code day in, day out
> would have even cared about it.
> 
> That's kind of my point - again, as the Devil's Advocate - that
> coverity is encouraging drive-by "fixes" by people who don't
> actually understand any of the context, history and/or culture
> surrounding the code being modified.

They shouldn't have to, the code (or comments therein) should
make it obvious.  ;)  (in a perfect world...)

> I have no problems with real bugs being fixed, but if we are
> modifying code for no gain other than closing "coverity doesn't like
> it" bugs, then we *should* be questioning whether the change is
> really necessary.

But let's give Geyslan the benefit of the doubt, and realize that
Coverity does find real things, and even if it originated w/ a
Coverity CID, when one sees:

	if (!a)
		printk("a thing\n")

	a = a->b = . . . 

it looks suspicious to pretty much anyone.  I don't think Geyslan
sent it to shut Coverity up, he sent it because it looked like
a bug worth fixing (after Coverity spotted it).

Let's not be too hard on him for trying; I appreciate it more
than spelling fixes and whitespace cleanups.  ;)

I agree that some Coverity CIDs are false, and we shouldn't
mangle code just to make it happy, but I just don't think that's
what's going on here.  Let's imagine Geyslan saw 10 other CIDs
and elected not to send changes, because they didn't look like
they needed fixing, but this one looked like a bona fide bug.

> Asking the question may not change the outcome, but we need to ask
> and answer the question regardless.
 
>> (We don't have to change code to shut up coverity; we can flag
>> it in the database and nobody else will see it.)
> 
> Only if you are the first to see it and make an executive decision
> that it's not necessary to fix.... :/

Or, you find it, send a patch that seems reasonable, get massive
pushback, (hopefully) flag it, and resolve never come back to xfs
again.  ;)

-Eric
 
> Cheers,
> 
> Dave.
> 

