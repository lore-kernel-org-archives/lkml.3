Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbaGWJjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:39:15 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:44814 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaGWJjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:39:14 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53CF822E.7050601@amd.com>
References: <20140709093124.11354.3774.stgit@patser>
	<53CE6AFA.1060807@vodafone.de>
	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
	<53CE84AA.9030703@amd.com>
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
Date: Wed, 23 Jul 2014 11:39:13 +0200
Message-ID: <CAKMK7uG85KV94PTqkzvY8RPxg6ApRKHVZrD20e48GHZM=s06=w@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
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

On Wed, Jul 23, 2014 at 11:36 AM, Christian König
<christian.koenig@amd.com> wrote:
> Am 23.07.2014 11:30, schrieb Daniel Vetter:
>
>> On Wed, Jul 23, 2014 at 11:27 AM, Christian König
>> <christian.koenig@amd.com> wrote:
>>>
>>> You submit a job to the hardware and then block the job to wait for
>>> radeon
>>> to be finished? Well than this would indeed require a hardware reset, but
>>> wouldn't that make the whole problem even worse?
>>>
>>> I mean currently we block one userspace process to wait for other
>>> hardware
>>> to be finished with a buffer, but what you are describing here blocks the
>>> whole hardware to wait for other hardware which in the end blocks all
>>> userspace process accessing the hardware.
>>
>> There is nothing new here with prime - if one context hangs the gpu it
>> blocks everyone else on i915.
>>
>>> Talking about alternative approaches wouldn't it be simpler to just
>>> offload
>>> the waiting to a different kernel or userspace thread?
>>
>> Well this is exactly what we'll do once we have the scheduler. But
>> this is an orthogonal issue imo.
>
>
> Mhm, could have the scheduler first?
>
> Cause that sounds like reducing the necessary fence interface to just a
> fence->wait function.

The scheduler needs to keep track of a lot of fences, so I think we'll
have to register callbacks, not a simple wait function. We must keep
track of all the non-i915 fences for all oustanding batches. Also, the
scheduler doesn't eliminate the hw queue, only keep it much slower so
that we can sneak in higher priority things.

Really, scheduler or not is orthogonal.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
