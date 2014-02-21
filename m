Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaBUXYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:24:03 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:64491 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaBUXYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:24:01 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402212255590.21251@ionos.tec.linutronix.de>
References: <1393019430-13200-1-git-send-email-john.stultz@linaro.org>
	<alpine.DEB.2.02.1402212255590.21251@ionos.tec.linutronix.de>
Date: Fri, 21 Feb 2014 15:24:00 -0800
Message-ID: <CALAqxLUJYT9G2ekEk_BoNNL4T6Pjiq56KR_i87GLnSuyddWS0Q@mail.gmail.com>
Subject: Re: [PATCH] [RFC] time: Improve negative offset handling in timekeeping_inject_offset
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 2:54 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 21 Feb 2014, John Stultz wrote:
>> I fully agree with this, but since the existing interface
>> only accepts #7 style negative timespecs, we have to continue
>> to support that style for this interface.
>>
>> Another possible view is that the rule that the tv_nsec
>> value always be [0,1e9). And that while maybe non-intuitive,
>> the #7 style representations are valid and the existing
>> interface is correct, thus no further change is needed.
>
> We have the requirement all over the place in the kernel to use
> normalized timespecs in the #7 form where: 0 <= tv_nsec < 1e9
>
[snip]
> If you have the 0 <= tv_nsec < 1e9 enforcement, then you catch that
> issue way before the add actually makes the tv_nsec value negative and
> causes some undechifferable wreckage.
>
> Sure you might argue that the requirement is:
>
>      -1e9 < tv_nsec < 1e9
>
> but then you need to allow all combinations of signs of tv_sec/tv_nsec
> just for compatibility reasons.
>
> Sure our normalize function can cope with that, but where is the
> point?
>
> We already enforce the 0 <= tv_nsec < 1e9 on all timespec interfaces
> (kernel interal and syscalls), which in turn forces people to use
> timespec_add/sub_ns or timespec_normalize.

Though we also require timespecs to be for positive intervals (at
least from a user-space side), so this case doesn't have a whole bunch
of precedent to follow.

And as an in-kernel counter example, I think the wall_to_monotonic
timespec is represented in {-1, -500} style.


> Why can't the adjtimex folks not handle that? They already have to
> handle the kernel readouts which are in the normalized form. So what's
> the problem to feed their computational value through
> normalize/sub/add whatever before handing it to the kernel.

Having libc handle the translation is indeed another option (one
Richard already brought up in private).  It rubs me a little bit the
wrong way as its fairly easy to handle this in kernel and then we
don't have compatability issues depending on what the libc
implementation does.

[snip]
> I really prefer that people use proper helper functions to
> add/sub/normalize timespecs into a single representation instead of
> having to look at a gazillion of permutations of the same unparseable
> crap.
>
> Aside of that, if we allow that for adjtimex, then how do we argue the
> restriction on all other timespec related interfaces?

I'd say the rule that the signs must agree is a good one to start out
with. However, in the case with this interface, we allow for the
awkward {-3,500} style values to be compatible with earlier releases.

But yes, we can just leave it as is, and it is a bit academic. But
mostly for me this is just about making the interface a bit more
intuitive when working with negative relative intervals, and maybe
more importantly making clear the precedent should any other userspace
interface do something similar.

thanks
-john
