Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaGVPR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:17:58 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62804 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaGVPR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:17:57 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53CE6AFA.1060807@vodafone.de>
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
	<53CE2421.5040906@amd.com>
	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>
	<53CE56ED.4040109@vodafone.de>
	<20140722132652.GO15237@phenom.ffwll.local>
	<53CE6AFA.1060807@vodafone.de>
Date: Tue, 22 Jul 2014 17:17:56 +0200
Message-ID: <CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
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

On Tue, Jul 22, 2014 at 3:45 PM, Christian König
<deathsimple@vodafone.de> wrote:
>> Would that be something you can agree to?
>
>
> No, the whole enable_signaling stuff should go away. No callback from the
> driver into the fence code, only the other way around.
>
> fence->signaled as well as fence->wait should become mandatory and only
> called from process context without holding any locks, neither atomic nor
> any mutex/semaphore (rcu might be ok).

So for the enable_signaling, that's optional already. It's only for
drivers that don't want to keep interrupts enabled all the time. You
can opt out of that easily.

Wrt holding no locks at all while calling into any fence functions,
that's just not going to work out. The point here is to make different
drivers work together and we can rework all the ttm and i915 code to
work locklessly in all cases where they need to wait for someone to
complete rendering. Or at least I don't think that's feasible. So if
you insist that no one might call into radeon code then we simply need
to exclude radeon from participating in any shared fencing. But that's
a bit pointless.

>> Like I've said I think restricting the insanity other people are willing
>> to live with just because you don't like it isn't right. But it is
>> certainly right for you to insist on not being forced into any such
>> design. I think the above would achieve this.
>
>
> I don't think so. If it's just me I would say that I'm just to cautious and
> the idea is still save to apply to the whole kernel.
>
> But since Dave, Jerome and Ben seems to have similar concerns I think we
> need to agree to a minimum and save interface for all drivers.

Well I haven't yet seen a proposal that actually works. From an intel
pov I don't care that much since we don't care about desktop prime, so
if radeon/nouveau don't want to do that, meh. Imo the design as-is is
fairly sound, and as simple as it can get given the requirements. I
haven't heard an  argument convincing me otherwise, so I guess we
won't have prime support on linux that actually works, ever.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
