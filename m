Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3IMIqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:46:37 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54912 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3IMIqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:46:32 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAF6AEGtLP=S12tbiWSuHTGOrPEwftBC4ayxRRPhOL=2kEsi0DQ@mail.gmail.com>
References: <1379001449-17380-1-git-send-email-daniel.vetter@ffwll.ch>
	<CAF6AEGtLP=S12tbiWSuHTGOrPEwftBC4ayxRRPhOL=2kEsi0DQ@mail.gmail.com>
Date: Fri, 13 Sep 2013 10:46:32 +0200
Message-ID: <CAKMK7uFJNviGuT=F4=B8X22en2dOtthXzsmeQoDXmO0kx-DD7g@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: kill set_need_resched
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Rob Clark <robdclark@gmail.com>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 2:59 AM, Rob Clark <robdclark@gmail.com> wrote:
> I guess in i915 (and ttm) case, the issue arises due to need for CPU
> access to buffer via GTT?  In which case I should be safe to drop the
> set_need_resched() as well? (Since CPU always has direct access to the
> pages.)  Or am I missing something about the original issue that
> necessitated set_need_resched()?

For drm/i915 the _only_ reason we've had  it was to avoid life-locking
with our gpu reset work when the gpu hung. We've fixed that properly
now by using a wait-queue to stall when a gpu reset is pending and
proper locking in the gpu reset handler (plus tons of evil tests to
make sure it doesn't break, there's rather fragile lock-dropping and
tricky ordering involved). So if you don't have i915's broken gpu
reset handling from yonder you don't need our cargo-cult.

ttm's usage with a trylock+yield is a different form of duct-tape to
paper over locking inversions between copy_*_user callsites and the
pagefault handler.

In any case there's no way it actually works properly ;-)

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
