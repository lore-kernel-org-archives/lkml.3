Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945AbaLDRut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:50:49 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36188 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaLDRuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:50:46 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CALAqxLX0hvv5DeLRji7g+jVX+F2ipU_f04YtehjFnSV4i==q4w@mail.gmail.com>
References: <1417533733-2289-1-git-send-email-daniel.vetter@ffwll.ch>
	<1417534582-2977-1-git-send-email-daniel.vetter@ffwll.ch>
	<20141202163506.GG18921@nuc-i3427.alporthouse.com>
	<CALAqxLUCD7zxyNrZJnKUE3wbORyZez-bDvScGLXyTjVvvZdinA@mail.gmail.com>
	<20141203143029.GF32117@phenom.ffwll.local>
	<CALAqxLUYL91khoW=oLAp_FtPBrDnSazfYqVpkXYTBJsTjDsv+g@mail.gmail.com>
	<20141204104228.GJ32117@phenom.ffwll.local>
	<CALAqxLX0hvv5DeLRji7g+jVX+F2ipU_f04YtehjFnSV4i==q4w@mail.gmail.com>
Date: Thu, 4 Dec 2014 18:50:45 +0100
Message-ID: <CAKMK7uHQzqqtg=HBDfyMdZbOGNuzaMz10XeDdCnxkta+R8Sv9Q@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: compute wait_ioctl timeout correctly
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: John Stultz <john.stultz@linaro.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 6:42 PM, John Stultz <john.stultz@linaro.org> wrote:
> On Thu, Dec 4, 2014 at 2:42 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> On Wed, Dec 03, 2014 at 11:07:08AM -0800, John Stultz wrote:
>>> On Wed, Dec 3, 2014 at 6:30 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
>>> > On Tue, Dec 02, 2014 at 08:54:13AM -0800, John Stultz wrote:
>>> >> On Tue, Dec 2, 2014 at 8:35 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>>> >> > On Tue, Dec 02, 2014 at 04:36:22PM +0100, Daniel Vetter wrote:
>>> >> >> +static inline unsigned long nsecs_to_jiffies_timeout(const u64 m)
>>> >> >> +{
>>> >> >> +     u64 usecs = div_u64(m + 999, 1000);
>>> >> >> +     unsigned long j = usecs_to_jiffies(usecs);
>>> >> >> +
>>> >> >> +     return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);
>>> >> >
>>> >> > Or more concisely and review friendly:
>>> >> >
>>> >> > static inline unsigned long nsecs_to_jiffies_timeout(const u64 n)
>>> >> > {
>>> >> >         return min_t(u64, MAX_JIFFY_OFFSET, nsecs_to_jiffies64(n) + 1);
>>> >> > }
>>> >>
>>> >> Yea. This looks much nicer. Seems generic enough it might be better
>>> >> added next to nsec_to_jiffies64() in kernel/time/time.c or jiffies.h
>>> >> rather then in a driver header.
>>> >
>>> > Ok, that needs an EXPORT_SYMBOL for nsecs_to_jiffies64. Can I count your
>>> > "Yea" above as an ack for adding that and pulling it in through
>>> > drm-intel.git?
>>>
>>> Do you need an EXPORT_SYMBOL if you add the _timeout version next to
>>> nsecs_to_jiffies64 in time.c?
>>
>> I wouldn't but the patch from Imre to add all the _timeout was killed with
>> a few bikesheds so really not volunteering. And just moving this single
>> one doesn't make a lot of sense imo. Also the next patch I'll do is just
>> add the +1 that we lost to the code and call it a day, really ;-)
>>
>
> Sigh. So you're going to make me write a separate patch that moves it over?

We've written it already, Imre posted the link to the old discussion:

https://lkml.org/lkml/2013/5/10/187

But if the first attempt doesn't sufficiently stick I tend to chase
the patches any more. But if you want to resurrect this I could ping
Imre and ask him to pick it up again or you could rebase his patches.

> I know you'll probably say this is bikeshedding, but the reason why
> avoiding the EXPORT_SYMBOL on nsec_to_jiffies would be good is because
> nsec_to_jiffies explicitly states in the comments that its not for any
> use but the scheduler.

Well I only export the 64 variant, the other one (with the too small
return type which would overflow) is already exported with

commit d560fed6abe0f9975b509e4fb824e08ac19adc93
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Jul 16 21:04:31 2014 +0000

    time: Export nsecs_to_jiffies()

    Required for moving drivers to the nanosecond based interfaces.

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: John Stultz <john.stultz@linaro.org>

So I've figured this is ok.

> But still, I do see our change broke you here, so I'm not going to object.

Ok, thanks I'll pull this in through drm-intel for 3.19 (3.18 is kinda
done already I guess) with cc: stable.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
