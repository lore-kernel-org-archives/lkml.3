Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbaHEIQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:16:31 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55621 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaHEIQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:16:27 -0400
Date: Tue, 5 Aug 2014 10:16:38 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>, airlied@linux.ie,
        thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com
Subject: Re: [PATCH 09/19] drm/radeon: handle lockup in delayed work, v2
Message-ID: <20140805081638.GD8727@phenom.ffwll.local>
Mail-Followup-To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	airlied@linux.ie, thellstrom@vmware.com,
	nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, bskeggs@redhat.com,
	alexander.deucher@amd.com
References: <53DF4A7D.3040505@canonical.com>
 <53DF7516.2010408@amd.com>
 <53DF8BF2.4000309@canonical.com>
 <53DF9AC4.3010700@amd.com>
 <53DF9B58.8000403@canonical.com>
 <53DF9C88.6060107@amd.com>
 <53DF9F89.60202@canonical.com>
 <53DFA0EB.5040302@amd.com>
 <53DFA210.2020603@canonical.com>
 <53DFBD2E.5070001@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53DFBD2E.5070001@amd.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 07:04:46PM +0200, Christian König wrote:
> Am 04.08.2014 um 17:09 schrieb Maarten Lankhorst:
> >op 04-08-14 17:04, Christian König schreef:
> >>Am 04.08.2014 um 16:58 schrieb Maarten Lankhorst:
> >>>op 04-08-14 16:45, Christian König schreef:
> >>>>Am 04.08.2014 um 16:40 schrieb Maarten Lankhorst:
> >>>>>op 04-08-14 16:37, Christian König schreef:
> >>>>>>>It'a pain to deal with gpu reset.
> >>>>>>Yeah, well that's nothing new.
> >>>>>>
> >>>>>>>I've now tried other solutions but that would mean reverting to the old style during gpu lockup recovery, and only running the delayed work when !lockup.
> >>>>>>>But this meant that the timeout was useless to add. I think the cleanest is keeping the v2 patch, because potentially any waiting code can be called during lockup recovery.
> >>>>>>The lockup code itself should never call any waiting code and V2 doesn't seem to handle a couple of cases correctly either.
> >>>>>>
> >>>>>>How about moving the fence waiting out of the reset code?
> >>>>>What cases did I miss then?
> >>>>>
> >>>>>I'm curious how you want to move the fence waiting out of reset, when there are so many places that could potentially wait, like radeon_ib_get can call radeon_sa_bo_new which can do a wait, or radeon_ring_alloc that can wait on radeon_fence_wait_next, etc.
> >>>>The IB test itself doesn't needs to be protected by the exclusive lock. Only everything between radeon_save_bios_scratch_regs and radeon_ring_restore.
> >>>I'm not sure about that, what do you want to do if the ring tests fail? Do you have to retake the exclusive lock?
> >>Just set need_reset again and return -EAGAIN, that should have mostly the same effect as what we are doing right now.
> >Yeah, except for the locking the ttm delayed workqueue, but that bool should be easy to save/restore.
> >I think this could work.
> 
> Actually you could activate the delayed workqueue much earlier as well.
> 
> Thinking more about it that sounds like a bug in the current code, because
> we probably want the workqueue activated before waiting for the fence.

We've actually had a similar issue on i915 where when userspace never
waited for rendering (some shitty userspace drivers did that way back) we
never noticed that the gpu died. So launching the hangcheck/stuck wait
worker (we have both too) right away is what we do now.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
