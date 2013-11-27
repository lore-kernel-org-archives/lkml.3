Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab3K0C3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:29:32 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:50165 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758389Ab3K0C3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:29:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAKb7UvhWCj1OaLi=52AYrS5oN3wfoP+E5zD0rYaKBXY2aU3MTw@mail.gmail.com>
References: <201311262303.26996.s.L-H@gmx.de>
	<201311270018.14980.s.L-H@gmx.de>
	<CAKb7UviWkEPnfgi3biTw6OqiSDU7Nnp9FYARMYv_S2h2zLU2LA@mail.gmail.com>
	<201311270135.19139.s.L-H@gmx.de>
	<CAKb7UvhWCj1OaLi=52AYrS5oN3wfoP+E5zD0rYaKBXY2aU3MTw@mail.gmail.com>
Date: Wed, 27 Nov 2013 12:29:29 +1000
Message-ID: <CAPM=9txVzuQ-ketvn6kYNmie7nSLr=QjnM0pKNe=DPdyPk0Z7g@mail.gmail.com>
Subject: Re: nouveau/ NV11: 3.12 freezes if X.org is started headless
From: Dave Airlie <airlied@gmail.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 12:15 PM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> On Tue, Nov 26, 2013 at 8:35 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
>> Hi
>>
>> On Wednesday 27 November 2013, Ilia Mirkin wrote:
>>> On Tue, Nov 26, 2013 at 7:18 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
>>> > Hi
>>> >
>>> > On Tuesday 26 November 2013, Ilia Mirkin wrote:
>>> >> On Tue, Nov 26, 2013 at 6:03 PM, Stefan Lippers-Hollmann <s.L-H@gmx.de> wrote:
>>> >> > v3.11 is fine, with and without monitor attached.
>>> >> > v3.12 is fine as long as X.org isn't started (but may fail to reboot
>>> >> >       cleanly). If a monitor is connected I don't observe any problems,
>>> >> >       it freezes without a monitor connected.
>>> >> > v3.13-rc1-95-gb975dc3 appears not to freeze without a monitor anymore
>>> >> >       (I didn't confirm that it's fine with a monitor attached), but I
>>> >> >       end up with the following Oops (this is before X.org is started).
>>>
>>> One more idea -- try it with nouveau.runpm=0 -- I've had some odd
>>> results with it on my older cards (but I don't remember hangs, but I
>>> also didn't spend a lot of time on it, just plopped the option in and
>>> moved on). This is a feature that got in in 3.12, and is really the
>>> only major nouveau-affecting change in that kernel for your card
>>> revision.
>>
>> You're spot on, that does the trick.
>
> Great to hear!
>
>>
>> # cat /sys/module/nouveau/parameters/agpmode
>> -1
>> # cat /sys/module/nouveau/parameters/runpm
>> 0
>>
>>   v3.13-rc1-95-gb975dc3
>> + http://cgit.freedesktop.org/~darktama/nouveau/commit/?id=0397aaaa009092427dc60aea8b3c21c00526d8ba
>> + nouveau.runpm=0
>> is now stable, with and without a monitor attached; as is
>>
>>   3.12.1 || v3.12.1-62-g4615252 (stable-queue.git)
>> + nouveau.runpm=0
>>
>
> Dave, looking at the code, it seems like runtime pm should only be
> getting activated by default for optimus systems. Stefan's is clearly
> not one of those, neither is mine. Unfortunately I have no clue how
> the runtime pm subsystem works, but it seems like runtime_suspend()
> may be getting called directly, e.g. if there are no monitors attached
> to nouveau, perhaps as a result of nouveau_crtc_set_config in
> dispnv04/crtc.c. Does the same if (runpm == -1 && !optimus) return
> -EBUSY check belong in the runtime_suspend callback?

Either that or it needs to be calling some of the other runtime
interfaces instead of runtime_autosuspend

maybe that last pm_runtime_put_autosuspend should be just
pm_runtime_put, but that might need testing on an optimus system.

Dave.
