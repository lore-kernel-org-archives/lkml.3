Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaFWIp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:45:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35243 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaFWIp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:45:56 -0400
Message-ID: <53A7E93B.4060007@canonical.com>
Date: Mon, 23 Jun 2014 10:45:47 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Daniel Vetter <daniel@ffwll.ch>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-arch@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "Clark, Rob" <robdclark@gmail.com>, Colin Cross <ccross@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [REPOST PATCH 4/8] android: convert sync to fence api, v5
References: <20140618102957.15728.43525.stgit@patser> <20140618103711.15728.97842.stgit@patser> <20140619011556.GE10921@kroah.com> <20140619063727.GL5821@phenom.ffwll.local> <20140619114825.GB28111@ulmo> <CAKMK7uE_B3pCZB9orh5+BJGooNfyEa0APrZqRpXqYu5xfQ0PCQ@mail.gmail.com> <20140620205252.GC28814@mithrandir>
In-Reply-To: <20140620205252.GC28814@mithrandir>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

op 20-06-14 22:52, Thierry Reding schreef:
> On Thu, Jun 19, 2014 at 02:28:14PM +0200, Daniel Vetter wrote:
>> On Thu, Jun 19, 2014 at 1:48 PM, Thierry Reding
>> <thierry.reding@gmail.com> wrote:
>>>>> With these changes, can we pull the android sync logic out of
>>>>> drivers/staging/ now?
>>>> Afaik the google guys never really looked at this and acked it. So I'm not
>>>> sure whether they'll follow along. The other issue I have as the
>>>> maintainer of gfx driver is that I don't want to implement support for two
>>>> different sync object primitives (once for dma-buf and once for android
>>>> syncpts), and my impression thus far has been that even with this we're
>>>> not there.
>>>>
>>>> I'm trying to get our own android guys to upstream their i915 syncpts
>>>> support, but thus far I haven't managed to convince them to throw people's
>>>> time at this.
>>> This has been discussed a fair bit internally recently and some of our
>>> GPU experts have raised concerns that this may result in seriously
>>> degraded performance in our proprietary graphics stack. Now I don't care
>>> very much for the proprietary graphics stack, but by extension I would
>>> assume that the same restrictions are relevant for any open-source
>>> driver as well.
>>>
>>> I'm still trying to fully understand all the implications and at the
>>> same time get some of the people who raised concerns to join in this
>>> discussion. As I understand it the concern is mostly about explicit vs.
>>> implicit synchronization and having this mechanism in the kernel will
>>> implicitly synchronize all accesses to these buffers even in cases where
>>> it's not needed (read vs. write locks, etc.). In one particular instance
>>> it was even mentioned that this kind of implicit synchronization can
>>> lead to deadlocks in some use-cases (this was mentioned for Android
>>> compositing, but I suspect that the same may happen for Wayland or X
>>> compositors).
>> Well the implicit fences here actually can't deadlock. That's the
>> entire point behind using ww mutexes. I've also heard tons of
>> complaints about implicit enforced syncing (especially from opencl
>> people), but in the end drivers and always expose unsynchronized
>> access for specific cases. We do that in i915 for upload buffers and
>> other fun stuff. This is about shared stuff across different drivers
>> and different processes.
> Tegra K1 needs to share buffers across different drivers even for very
> basic use-cases since the GPU and display drivers are separate. So while
> I agree that the GPU driver can still use explicit synchronization for
> internal work, things aren't that simple in general.
>
> Let me try to reconstruct the use-case that caused the lock on Android:
> the compositor uses a hardware overlay to display an image. The system
> detects that there's little activity and instructs the compositor to put
> everything into one image and scan out only that (for power efficiency).
> Now with implicit locking the display driver has a lock on the image, so
> the GPU (used for compositing) needs to wait for it before it can
> composite everything into one image. But the display driver cannot
> release the lock on the image until the final image has been composited
> and can be displayed instead.
>
> This may not be technically a deadlock, but it's still a stalemate.
> Unless I'm missing something fundamental about DMA fences and ww mutexes
> I don't see how you can get out of this situation.
This sounds like a case for implicit shared fences. ;-) Reading and scanning out would
only wait for the last 'exclusive' fence, not on each other.

But in drivers/drm I can encounter a similar issue, people expect to be able to
overwrite the contents of the currently displayed buffer, so I 'solved' it by not adding
a fence on the buffer, only by waiting for buffer idle before page flipping.
The rationale is that the buffer is pinned internally, and the backing storage cannot
go away until dma_buf_unmap_attachment is called. So when you render to the
current front buffer without queuing a page flip you get exactly what you expect. ;-)

> Explicit vs. implicit synchronization may also become more of an issue
> as buffers are imported from other sources (such as cameras).
Yeah, but the kernel space primitives would in both cases be the same, so drivers don't need to implement 2 separate fencing mechanisms for that. :-)

~Maarten

