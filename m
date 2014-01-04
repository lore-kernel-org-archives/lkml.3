Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaADGtL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 01:49:11 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63914 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaADGtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 01:49:08 -0500
MIME-Version: 1.0
In-Reply-To: <20140104061650.GB20272@core.coreip.homeip.net>
References: <20140104052756.GA32561@core.coreip.homeip.net>
	<CAHQ1cqG2=CX6ypONUgVgzjG_3nVJOBLq5LPYwN0BrzwOLCTxzQ@mail.gmail.com>
	<20140104061650.GB20272@core.coreip.homeip.net>
Date: Fri, 3 Jan 2014 22:49:07 -0800
Message-ID: <CAHQ1cqEQtXRaPWo6wYgpDrjwGhnAySvb7Jvs8KFRTTRb3g++GQ@mail.gmail.com>
Subject: Re: [PATCH] Input: ims-pcu - remove unneeded get_unaligned_xxx
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 10:16 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Fri, Jan 03, 2014 at 09:52:25PM -0800, Andrey Smirnov wrote:
>> On Fri, Jan 3, 2014 at 9:28 PM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>> > pcu->cmd_buf[IMS_PCU_DATA_OFFSET] is word aligned so we do not need to use
>> > get_unaligned_le16 to access it.
>> >
>> > Also let's add build time check to make sure it stays aligned.
>>
>> - AFAIK, there's no guarantee the "pcu" itself is aligned
>
> Yes. kmalloc returns aligned pointer, otherwise every access to members
> other than u8 would risk unaligned exception.

OK, fair point.

>
>> - This change assumes that aligning data on the 2-byte boundary is
>> sufficient for all architectures that do not allow unaligned data
>> access, which I don't think is a good assumption to make
>
> What arches require word access be double-word aligned?

I don't know and neither do I care. Even if there aren't any in Linux
today do you expect it to never add a support to one that would impose
such a restriction?

The whole point of get_unaligned_* "framework" is to provide drivers
with unified interface that would allow you not to care about
alignment. "Framework" in which architectures that support unaligned
access can fallback to good old functions like *_to_cpup and
architectures that do would provide the code to handle access in
whatever manner is best suited for them.

>
>> - On x86 or any other architecture that allows unaligned access
>> get_unaligned_le16() is actually results to call to le16_to_cpup(), so
>> this change doesn't really save anything while imposing restrictions
>> on the arrangement of the fields in struct ims_pcu and causing
>> unnecessary build errors.
>
> Unless somebody changes the layout there won't be any new build errors,
> will there?

So do you expect that code to never change from now on? I most likely
will be working on changes to support accelerometer data aggregation
and implementing associated with it input devices and this may or may
not require me to add fields to that structure, so what am I supposed
to do in that case? Juggle fields around until I find the right
combination that does not trigger build error?.

I honestly don't understand the purpose of this change, it doesn't
really save any performance, IMHO decreases potability of the driver,
so what is the gain. What does adding all the restrictions that this
change imposes buy us?

>
> Thanks.
>
> --
> Dmitry
