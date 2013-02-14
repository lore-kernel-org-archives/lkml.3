Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab3BNLTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:19:03 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:42261 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3BNLTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:19:00 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <201302141022.00297.arnd@arndb.de>
References: <20130207151831.2868.5146.stgit@patser.local>
	<20130207151838.2868.69610.stgit@patser.local>
	<201302141022.00297.arnd@arndb.de>
Date: Thu, 14 Feb 2013 12:18:59 +0100
X-Google-Sender-Auth: gnCBDntE0GKyVyFm_q3PExaxQRE
Message-ID: <CAKMK7uG_gJ6+9vZ+MDStUgE-M-bDHM+Sk3cTDdVBxGCjhY6TLg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 2/3] mutex: add support for reservation
 style locks
From: Daniel Vetter <daniel@ffwll.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-mm-sig@lists.linaro.org, linux-arch@vger.kernel.org,
        a.p.zijlstra@chello.nl, x86@kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, robclark@gmail.com,
        tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 11:22 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
>>   These functions will return -EDEADLK instead of -EAGAIN if
>>   reservation_id is the same as the reservation_id that's attempted to
>>   lock the mutex with, since in that case you presumably attempted to
>>   lock the same lock twice.
>
> Since the user always has to check the return value, would it be
> possible to provide only the interruptible kind of this function
> but not the non-interruptible one? In general, interruptible locks
> are obviously harder to use, but they are much user friendlier when
> something goes wrong.

At least in drm/i915 we only use _interruptible locking on the
command-submission ioctls for all locks which could be held while
waiting for the gpu. We need unwind paths and ioctl restarting anyway
to bail out on catastrophic events like gpu hangs, so signal interrupt
handling comes for free.

Otoh in the modeset code we generally don't bother with that, since
unwinding a modeset sequence mid-way is something you don't want to do
really if your sanity is dear to you. But we also never need
mutli-object reservations in the modeset code, neither can I imagine a
future need for it.

So from my side we could drop the non-interruptible interface. But I
have not checked whether dropping this would complicate the ttm
conversion.

>> mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow:
>>   Similar to mutex_reserve_lock, except it won't backoff with -EAGAIN.
>>   This is useful when mutex_reserve_lock failed with -EAGAIN, and you
>>   unreserved all buffers so no deadlock can occur.
>
> Are these meant to be used a lot? If not, maybe prefix them with __mutex_
> instead of mutex_.

If you detect an inversion in a multi-buffer reservation you have to
drop all locks and call these functions on the buffer which failed
(that's the contention point, hence it's the right lock to sleep on).
So every place using ticket locks will also call the above slowpath
functions by necessity.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
