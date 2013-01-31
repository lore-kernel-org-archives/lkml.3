Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3AaOtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 09:49:12 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:48522 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3AaOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 09:49:10 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAAQKjZNO0tJ3StYJ_kzLWCqz+1dv6A2PNqo1kavR7XtwfKnysQ@mail.gmail.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
	<1358253244-11453-5-git-send-email-maarten.lankhorst@canonical.com>
	<CAAQKjZMpFin6s+-z8ei+JcxcdFrWUpFZrsCuxv7AH+8wVfTUqw@mail.gmail.com>
	<20130131095726.GD5885@phenom.ffwll.local>
	<CAAQKjZNO0tJ3StYJ_kzLWCqz+1dv6A2PNqo1kavR7XtwfKnysQ@mail.gmail.com>
Date: Thu, 31 Jan 2013 15:49:09 +0100
Message-ID: <CAKMK7uG-Fr=FB9NnHmERJj5VXzXbrpAhPWsZJTCX_OsLV0wn-A@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 4/7] fence: dma-buf cross-device
 synchronization (v11)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Inki Dae <inki.dae@samsung.com>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 3:38 PM, Inki Dae <inki.dae@samsung.com> wrote:
> I think I understand as your comment but I don't think that I
> understand fully the dma-fence mechanism. So I wish you to give me
> some advices for it. In our case, I'm applying the dma-fence to
> mali(3d gpu) driver as producer and exynos drm(display controller)
> driver as consumer.
>
> And the sequence is as the following:
> In case of producer,
> 1. call fence_wait to wait for the dma access completion of others.
> 2. And then the producer creates a fence and a new reservation entry.
> 3. And then it sets the given dmabuf's resv(reservation_object) to the
> new reservation entry.
> 4. And then it adds the reservation entry to entries list.
> 5. And then it sets the fence to all dmabufs of the entries list.
> Actually, this work is to set the fence to the reservaion_object of
> each dmabuf.
> 6. And then the producer's dma start.
> 7. Finally, when the dma start is completed, we get the entries list
> from a 3d job command(in case of mali core, pp job) and call
> fence_signal() with each fence of each reservation entry.
>
> From here, is there my missing point?

Yeah, more or less. Although you need to wrap everything into ticket
reservation locking so that you can atomically update fences if you
have support for some form of device2device singalling (i.e. without
blocking on the cpu until all the old users completed). At least
that's the main point of Maarten's patches (and this does work with
prime between a few drivers by now), but ofc you can use cpu blocking
as a fallback.

> And I thought the fence from reservation entry at step 7 means that
> the producer wouldn't access the dmabuf attaching this fence anymore
> so this step wakes up all processes blocked. So I understood that the
> fence means a owner accessing the given dmabuf and we could aware of
> whether the owner commited its own fence to the given dmabuf to read
> or write through the fence's flags.

The fence doesn't give ownership of the dma_buf object, but only
indicates when the dma access will have completed. The relationship
between dma_buf/reservation and the attached fences specify whether
other hw engines can access the dma_buf, too (if the fence is
non-exclusive).

> If you give me some advices, I'd be happy.

Rob and Maarten are working on some howtos and documentation with
example code, I guess it'd be best to wait a bit until we have that.
Or just review the existing stuff Rob just posted and reply with
questions there.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
