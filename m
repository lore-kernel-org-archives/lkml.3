Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbaGVPnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:43:00 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:64461 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbaGVPmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:42:49 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53CE84AA.9030703@amd.com>
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
	<53CE2421.5040906@amd.com>
	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>
	<53CE56ED.4040109@vodafone.de>
	<20140722132652.GO15237@phenom.ffwll.local>
	<53CE6AFA.1060807@vodafone.de>
	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
	<53CE84AA.9030703@amd.com>
Date: Tue, 22 Jul 2014 17:42:48 +0200
Message-ID: <CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
        Dave Airlie <airlied@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 5:35 PM, Christian König
<christian.koenig@amd.com> wrote:
> Drivers exporting fences need to provide a fence->signaled and a fence->wait
> function, everything else like fence->enable_signaling or calling
> fence_signaled() from the driver is optional.
>
> Drivers wanting to use exported fences don't call fence->signaled or
> fence->wait in atomic or interrupt context, and not with holding any global
> locking primitives (like mmap_sem etc...). Holding locking primitives local
> to the driver is ok, as long as they don't conflict with anything possible
> used by their own fence implementation.

Well that's almost what we have right now with the exception that
drivers are allowed (actually must for correctness when updating
fences) the ww_mutexes for dma-bufs (or other buffer objects). Locking
correctness is enforced with some extremely nasty lockdep annotations
+ additional debugging infrastructure enabled with
CONFIG_DEBUG_WW_MUTEX_SLOWPATH. We really need to be able to hold
dma-buf ww_mutexes while updating fences or waiting for them. And
obviously for ->wait we need non-atomic context, not just
non-interrupt.

Agreed that any shared locks are out of the way (especially stuff like
dev->struct_mutex or other non-strictly driver-private stuff, i915 is
really bad here still).

So from the core fence framework I think we already have exactly this,
and we only need to adjust the radeon implementation a bit to make it
less risky and invasive to the radeon driver logic.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
