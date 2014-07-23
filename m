Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbaGWHCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:02:13 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58312 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaGWHCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:02:12 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53CF5B9F.1050800@amd.com>
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
	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
	<53CE8A57.2000803@vodafone.de>
	<53CF58FB.8070609@canonical.com>
	<53CF5B9F.1050800@amd.com>
Date: Wed, 23 Jul 2014 09:02:11 +0200
Message-ID: <CAKMK7uHCKFo-9-oi4=kBzMXeroCh47RM4c35qhciMHgFKfejFQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
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

On Wed, Jul 23, 2014 at 8:52 AM, Christian König
<christian.koenig@amd.com> wrote:
>> In the preliminary patches where I can sync radeon with other GPU's I've
>> been very careful in all the places that call into fences, to make sure that
>> radeon wouldn't try to handle lockups for a different (possibly also radeon)
>> card.
>
> That's actually not such a good idea.
>
> In case of a lockup we need to handle the lockup cause otherwise it could
> happen that radeon waits for the lockup to be resolved and the lockup
> handling needs to wait for a fence that's never signaled because of the
> lockup.

I thought the plan for now is that each driver handles lookups
themselfs for now. So if any batch gets stuck for too long (whether
it's our own gpu that's stuck or whether we're somehow stuck on a
fence from a 2nd gpu doesn't matter) the driver steps in with a reset
and signals completion to all its own fences that have been in that
pile-up. As long as each driver participating in fencing has means to
abort/reset we'll eventually get unstuck.

Essentially every driver has to guarantee that assuming dependent
fences all complete eventually that it _will_ complete its own fences
no matter what.

For now this should be good enough, but for arb_robusteness or people
who care a bit about their compute results we need reliable
notification to userspace that a reset happened. I think we could add
a new "aborted" fence state for that case and then propagate that. But
given how tricky the code to compute reset victims in i915 is already
I think we should leave this out for now. And even later on make it
strictly opt-in.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
