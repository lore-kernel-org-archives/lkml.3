Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaADRlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 12:41:45 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61781 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbaADRln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 12:41:43 -0500
MIME-Version: 1.0
In-Reply-To: <20140104074621.GD20272@core.coreip.homeip.net>
References: <20140104052756.GA32561@core.coreip.homeip.net>
	<CAHQ1cqG2=CX6ypONUgVgzjG_3nVJOBLq5LPYwN0BrzwOLCTxzQ@mail.gmail.com>
	<20140104061650.GB20272@core.coreip.homeip.net>
	<CAHQ1cqEQtXRaPWo6wYgpDrjwGhnAySvb7Jvs8KFRTTRb3g++GQ@mail.gmail.com>
	<20140104074621.GD20272@core.coreip.homeip.net>
Date: Sat, 4 Jan 2014 09:41:43 -0800
Message-ID: <CAHQ1cqEmpejiMPij+jQM0YEceShyHPRJ2dPkuaLkuBLYLXQyJg@mail.gmail.com>
Subject: Re: [PATCH] Input: ims-pcu - remove unneeded get_unaligned_xxx
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 11:46 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Jan 03, 2014 at 10:49:07PM -0800, Andrey Smirnov wrote:
>> On Fri, Jan 3, 2014 at 10:16 PM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>> > On Fri, Jan 03, 2014 at 09:52:25PM -0800, Andrey Smirnov wrote:
>> >> On Fri, Jan 3, 2014 at 9:28 PM, Dmitry Torokhov
>> >> <dmitry.torokhov@gmail.com> wrote:
>> >> > pcu->cmd_buf[IMS_PCU_DATA_OFFSET] is word aligned so we do not need to use
>> >> > get_unaligned_le16 to access it.
>> >> >
>> >> > Also let's add build time check to make sure it stays aligned.
>> >>
>> >> - AFAIK, there's no guarantee the "pcu" itself is aligned
>> >
>> > Yes. kmalloc returns aligned pointer, otherwise every access to members
>> > other than u8 would risk unaligned exception.
>>
>> OK, fair point.
>>
>> >
>> >> - This change assumes that aligning data on the 2-byte boundary is
>> >> sufficient for all architectures that do not allow unaligned data
>> >> access, which I don't think is a good assumption to make
>> >
>> > What arches require word access be double-word aligned?
>>
>> I don't know and neither do I care. Even if there aren't any in Linux
>> today do you expect it to never add a support to one that would impose
>> such a restriction?
>
> There is a lot of assumptions in kernel that might get broken by a
> random arch.

I fact that there are such assumptions in kernel doesn't mean we
should add more. IMHO, especially input drivers should be as CPU
architecture agnostic as possible.

> For example, the assumption that pointer and long require
> the same storage.

That is an assumption about compiler implementation, since the size of
the basic types is implementation-specific.

>
> Anyway, it looks like gcc has __alignof__(type) construct that will make
> sure we ensure the right alignment for type.
>
>>
>> The whole point of get_unaligned_* "framework" is to provide drivers
>> with unified interface that would allow you not to care about
>> alignment.
>
> No, it is not that you do not care about alignment, it is so that you
> can safely access data that you know to be unaligned.

Or the data the alignment of which you cannot guarantee, which was
exactly my point.

> Otherwise code would be littered with get_uanligned_*.
>
>> "Framework" in which architectures that support unaligned
>> access can fallback to good old functions like *_to_cpup and
>> architectures that do would provide the code to handle access in
>> whatever manner is best suited for them.
>>
>> >
>> >> - On x86 or any other architecture that allows unaligned access
>> >> get_unaligned_le16() is actually results to call to le16_to_cpup(), so
>> >> this change doesn't really save anything while imposing restrictions
>> >> on the arrangement of the fields in struct ims_pcu and causing
>> >> unnecessary build errors.
>> >
>> > Unless somebody changes the layout there won't be any new build errors,
>> > will there?
>>
>> So do you expect that code to never change from now on? I most likely
>> will be working on changes to support accelerometer data aggregation
>> and implementing associated with it input devices and this may or may
>> not require me to add fields to that structure, so what am I supposed
>> to do in that case? Juggle fields around until I find the right
>> combination that does not trigger build error?.
>>
>
> Umm, yes? And your juggling will be reduced to nothing if you add new
> fields at the end of the structure.

Oh, OK. I did not not expect you to be OK with such pointless
arbitrary limitations placed in order to save a handful of cycles in a
function that is not very often called, but if you are I don't believe
we would arrive anywhere with this argument.  Let's at least add an
appropriate comment to the structure warning the potential user that
the way it is organized is important, since it may affect layout and
break the build.

>
>> I honestly don't understand the purpose of this change, it doesn't
>> really save any performance,
>
> Technically it does as it does not require going through unaligned
> access on arches that can't do it.

OK, if we are going to stick to technicalities, then technically until
we actually compiled both versions of the code on the platforms in
question and did the actual performance measurements nothing can be
said about performance improvement and we can only speculate about
potential performance improvements.

>
>> IMHO decreases potability of the driver,
>
> I think that your concern can be solved with alignof.

OK, as I said before I don't think you and I will come to an agreement
on this one, since I see this change as a premature micro-optimization
that makes the code less abstract since now it has knowledge of CPU
alignment(which IMHO should be contained, as much as possible, in
architecture specific code) and you don't think that those are
actually problems of the patch. But since you the maintainer of the
subsystem and the final call about the inclusion of the patch is
yours, then you should do whatever you see fit(Or as another option
you can as ask other subsystems maintainers to weigh in on the
matter).

Anyway, TL;DR of the whole thing is:
 - Your arguments do not convince me in the slightest
 - I don't think that mine do you
 - Let's stop wasting out time
 - Do as you see fit, since you are the maintainer

Cheers,
Andrey

>
> Thanks.
>
> --
> Dmitry
