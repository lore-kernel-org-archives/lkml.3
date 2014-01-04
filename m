Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaADHq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 02:46:29 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56624 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaADHq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 02:46:26 -0500
Date: Fri, 3 Jan 2014 23:46:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: ims-pcu - remove unneeded get_unaligned_xxx
Message-ID: <20140104074621.GD20272@core.coreip.homeip.net>
References: <20140104052756.GA32561@core.coreip.homeip.net>
 <CAHQ1cqG2=CX6ypONUgVgzjG_3nVJOBLq5LPYwN0BrzwOLCTxzQ@mail.gmail.com>
 <20140104061650.GB20272@core.coreip.homeip.net>
 <CAHQ1cqEQtXRaPWo6wYgpDrjwGhnAySvb7Jvs8KFRTTRb3g++GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqEQtXRaPWo6wYgpDrjwGhnAySvb7Jvs8KFRTTRb3g++GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 10:49:07PM -0800, Andrey Smirnov wrote:
> On Fri, Jan 3, 2014 at 10:16 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Fri, Jan 03, 2014 at 09:52:25PM -0800, Andrey Smirnov wrote:
> >> On Fri, Jan 3, 2014 at 9:28 PM, Dmitry Torokhov
> >> <dmitry.torokhov@gmail.com> wrote:
> >> > pcu->cmd_buf[IMS_PCU_DATA_OFFSET] is word aligned so we do not need to use
> >> > get_unaligned_le16 to access it.
> >> >
> >> > Also let's add build time check to make sure it stays aligned.
> >>
> >> - AFAIK, there's no guarantee the "pcu" itself is aligned
> >
> > Yes. kmalloc returns aligned pointer, otherwise every access to members
> > other than u8 would risk unaligned exception.
> 
> OK, fair point.
> 
> >
> >> - This change assumes that aligning data on the 2-byte boundary is
> >> sufficient for all architectures that do not allow unaligned data
> >> access, which I don't think is a good assumption to make
> >
> > What arches require word access be double-word aligned?
> 
> I don't know and neither do I care. Even if there aren't any in Linux
> today do you expect it to never add a support to one that would impose
> such a restriction?

There is a lot of assumptions in kernel that might get broken by a
random arch. For example, the assumption that pointer and long require
the same storage.

Anyway, it looks like gcc has __alignof__(type) construct that will make
sure we ensure the right alignment for type.

> 
> The whole point of get_unaligned_* "framework" is to provide drivers
> with unified interface that would allow you not to care about
> alignment.

No, it is not that you do not care about alignment, it is so that you
can safely access data that you know to be unaligned. Otherwise code
would be littered with get_uanligned_*.

> "Framework" in which architectures that support unaligned
> access can fallback to good old functions like *_to_cpup and
> architectures that do would provide the code to handle access in
> whatever manner is best suited for them.
> 
> >
> >> - On x86 or any other architecture that allows unaligned access
> >> get_unaligned_le16() is actually results to call to le16_to_cpup(), so
> >> this change doesn't really save anything while imposing restrictions
> >> on the arrangement of the fields in struct ims_pcu and causing
> >> unnecessary build errors.
> >
> > Unless somebody changes the layout there won't be any new build errors,
> > will there?
> 
> So do you expect that code to never change from now on? I most likely
> will be working on changes to support accelerometer data aggregation
> and implementing associated with it input devices and this may or may
> not require me to add fields to that structure, so what am I supposed
> to do in that case? Juggle fields around until I find the right
> combination that does not trigger build error?.
>

Umm, yes? And your juggling will be reduced to nothing if you add new
fields at the end of the structure.

> I honestly don't understand the purpose of this change, it doesn't
> really save any performance,

Technically it does as it does not require going through unaligned
access on arches that can't do it.

> IMHO decreases potability of the driver,

I think that your concern can be solved with alignof.

Thanks.

-- 
Dmitry
