Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbaGWJw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:52:59 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:64680 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbaGWJw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:52:58 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53CF84C7.2020507@vodafone.de>
References: <20140709093124.11354.3774.stgit@patser>
	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
	<53CE8A57.2000803@vodafone.de>
	<53CF58FB.8070609@canonical.com>
	<53CF5B9F.1050800@amd.com>
	<53CF5EFE.6070307@canonical.com>
	<53CF63C2.7070407@vodafone.de>
	<CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com>
	<53CF6622.6060803@amd.com>
	<53CF699D.9070902@canonical.com>
	<53CF6B18.5070107@vodafone.de>
	<CAKMK7uGd65HR11thcv8KjDw-RnTa7W-QGOzFGFd+oO_hp8wyHA@mail.gmail.com>
	<53CF7035.2060808@amd.com>
	<53CF7191.2090008@canonical.com>
	<CAKMK7uGLqzePAREsWhX0D1oN4FdqKwPgAL6x8sULpJSqYH5LwA@mail.gmail.com>
	<53CF765E.7020802@vodafone.de>
	<CAKMK7uE1G-EjbJ2RAXC3ZfkaCo=Gber5PJuRG623Yoz9D=FmGw@mail.gmail.com>
	<53CF8010.9060809@amd.com>
	<CAKMK7uEowhvc+4Jc6t2NAeE1joFaohJ6cP7sU-Akut6b3ta=1g@mail.gmail.com>
	<53CF822E.7050601@amd.com>
	<CAKMK7uG85KV94PTqkzvY8RPxg6ApRKHVZrD20e48GHZM=s06=w@mail.gmail.com>
	<CAKMK7uHEgdU+Uz-OnRGvT_wFjOXHpZmgZcrORsBrST_MY5_ADA@mail.gmail.com>
	<53CF84C7.2020507@vodafone.de>
Date: Wed, 23 Jul 2014 11:52:57 +0200
Message-ID: <CAKMK7uG1pOxiXN1NLkNBLOEJM45ZLarJCyLe6VWSu2vS0V0Oow@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
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

On Wed, Jul 23, 2014 at 11:47 AM, Christian König
<deathsimple@vodafone.de> wrote:
> Am 23.07.2014 11:44, schrieb Daniel Vetter:
>> On Wed, Jul 23, 2014 at 11:39 AM, Daniel Vetter <daniel.vetter@ffwll.ch>
>> wrote:
>>>
>>> The scheduler needs to keep track of a lot of fences, so I think we'll
>>> have to register callbacks, not a simple wait function. We must keep
>>> track of all the non-i915 fences for all oustanding batches. Also, the
>>> scheduler doesn't eliminate the hw queue, only keep it much slower so
>>> that we can sneak in higher priority things.
>>>
>>> Really, scheduler or not is orthogonal.
>>
>> Also see my other comment about interactions between wait_fence and
>> the i915 reset logic. We can't actually use it from within the
>> scheduler code since that would deadlock.
>
>
> Yeah, I see. You would need some way to abort the waiting on other devices
> fences in case of a lockup.
>
> What about an userspace thread to offload waiting and command submission to?

That's what your android guys currently do. They hate it. And google
explicitly created their syncpts stuff to move all that into the
kernel. That one does explicit fencing, but the end result is still
that you have fences as deps between different drivers.

The other problem is that dri/prime is running under an implicitly
sync'ed model, so there's no clear point/responsibility for who would
actually do the waiting. You'll end up with synchronous behaviour
since the render sooner or later needs to perfectly align with
client/compositor ipc.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
