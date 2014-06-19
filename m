Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbaFSPWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:22:52 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:54857 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbaFSPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140619063727.GL5821@phenom.ffwll.local>
References: <20140618102957.15728.43525.stgit@patser>
	<20140618103711.15728.97842.stgit@patser>
	<20140619011556.GE10921@kroah.com>
	<20140619063727.GL5821@phenom.ffwll.local>
Date: Thu, 19 Jun 2014 08:22:48 -0700
Message-ID: <CAMbhsRRZOHuDkW9GzWbBCQiBjdUFv7MtkB_qhx+pofT+38gugQ@mail.gmail.com>
Subject: Re: [REPOST PATCH 4/8] android: convert sync to fence api, v5
From: Colin Cross <ccross@google.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>,
        thellstrom@vmware.com, lkml <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Rob Clark <robdclark@gmail.com>, thierry.reding@gmail.com,
        Colin Cross <ccross@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARIN..." <linux-media@vger.kernel.org>
Cc: daniel@ffwll.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 11:37 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Jun 18, 2014 at 06:15:56PM -0700, Greg KH wrote:
>> On Wed, Jun 18, 2014 at 12:37:11PM +0200, Maarten Lankhorst wrote:
>> > Just to show it's easy.
>> >
>> > Android syncpoints can be mapped to a timeline. This removes the need
>> > to maintain a separate api for synchronization. I've left the android
>> > trace events in place, but the core fence events should already be
>> > sufficient for debugging.
>> >
>> > v2:
>> > - Call fence_remove_callback in sync_fence_free if not all fences have fired.
>> > v3:
>> > - Merge Colin Cross' bugfixes, and the android fence merge optimization.
>> > v4:
>> > - Merge with the upstream fixes.
>> > v5:
>> > - Fix small style issues pointed out by Thomas Hellstrom.
>> >
>> > Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> > Acked-by: John Stultz <john.stultz@linaro.org>
>> > ---
>> >  drivers/staging/android/Kconfig      |    1
>> >  drivers/staging/android/Makefile     |    2
>> >  drivers/staging/android/sw_sync.c    |    6
>> >  drivers/staging/android/sync.c       |  913 +++++++++++-----------------------
>> >  drivers/staging/android/sync.h       |   79 ++-
>> >  drivers/staging/android/sync_debug.c |  247 +++++++++
>> >  drivers/staging/android/trace/sync.h |   12
>> >  7 files changed, 609 insertions(+), 651 deletions(-)
>> >  create mode 100644 drivers/staging/android/sync_debug.c
>>
>> With these changes, can we pull the android sync logic out of
>> drivers/staging/ now?
>
> Afaik the google guys never really looked at this and acked it. So I'm not
> sure whether they'll follow along. The other issue I have as the
> maintainer of gfx driver is that I don't want to implement support for two
> different sync object primitives (once for dma-buf and once for android
> syncpts), and my impression thus far has been that even with this we're
> not there.

We have tested these patches to use dma fences to back the android
sync driver and not found any major issues.  However, my understanding
is that dma fences are designed for implicit sync, and explicit sync
through the android sync driver is bolted on the side to share code.
Android is not moving away from explicit sync, but we do wrap all of
our userspace sync accesses through libsync
(https://android.googlesource.com/platform/system/core/+/master/libsync/sync.c,
ignore the sw_sync parts), so if the kernel supported a slightly
different userspace explicit sync interface we could adapt to it
fairly easily.  All we require is that individual kernel drivers need
to be able to accept work alongisde an fd to wait on, and to return an
fd that will signal when the work is done, and that userspace has some
way to merge two of those fds, wait on an fd, and get some debugging
info from an fd.  However, this patch set doesn't do that, it has no
way to export a dma fence as an fd except through the android sync
driver, so it is not yet ready to fully replace android sync.

> I'm trying to get our own android guys to upstream their i915 syncpts
> support, but thus far I haven't managed to convince them to throw people's
> time at this.
>
> It looks like a step into the right direction, but until I have the proof
> in the form of i915 patches that I won't have to support 2 gfx fencing
> frameworks I'm opposed to de-staging android syncpts. Ofc someone else
> could do that too, but besides i915 I don't see a full-fledged (modeset
> side only kinda doesn't count) upstream gfx driver shipping on android.
> -Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
