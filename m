Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbaGVPsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:48:23 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:52301 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbaGVPsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:48:19 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <CADnq5_Moy78A5JfDM0LME6_-48PW72DJpYYvEthQ5b=_amU8KQ@mail.gmail.com>
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
	<53CE2421.5040906@amd.com>
	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>
	<53CE56ED.4040109@vodafone.de>
	<53CE6FB0.90500@canonical.com>
	<53CE7410.3090603@amd.com>
	<53CE74B5.3000201@canonical.com>
	<53CE77B4.6020801@amd.com>
	<CAKMK7uESXrDtCov8whOTsffg6eZdibF4qaTFaCubM=mnhN=gNQ@mail.gmail.com>
	<CADnq5_Moy78A5JfDM0LME6_-48PW72DJpYYvEthQ5b=_amU8KQ@mail.gmail.com>
Date: Tue, 22 Jul 2014 17:48:18 +0200
X-Google-Sender-Auth: aoYa1FRpaGUmJDlIKqgoeADSz54
Message-ID: <CAKMK7uGtfUTU=VwSnF07jncJsH1Ckie2m1FCjct60Yz88uE3cg@mail.gmail.com>
Subject: Re: [PATCH 09/17] drm/radeon: use common fence implementation for fences
From: Daniel Vetter <daniel@ffwll.ch>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Barnes, Jesse" <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 5:42 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> Fence-based syncing between userspace queues submitted stuff through
>> doorbells and anything submitted by the general simply wont work.
>> Which is why I think the doorbell is a stupid interface since I just
>> don't see cameras and v4l devices implementing all that complexity to
>> get a pure userspace side sync solution.
>>
>
> Like it or not this is what a lot of application writers want (look at
> mantle and metal and similar new APIs or android synpts).  Having
> queues and fences in userspace allows the application to structure
> things to best fit their own task graphs.  The app can decide how to
> deal with dependencies and synchronization explicitly instead of
> blocking the queues in the kernel for everyone.  Anyway, this is
> getting off topic.

Well there's explicit fences as used in opencl and android syncpts. My
plan is actually to support that in i915 using Maarten's struct fence
stuff (and there's just a very trivial patch for the android stuff in
merging needed to get there). What doesn't work is fences created
behind the kernel's back purely in userspace by giving shared memory
locations special meaning. Those get the kernel completely out of the
picture (as opposed to android syncpts, which just make sync
explicit).

I guess long-term we might need something like gpu futexes to make
that pure userspace syncing integrate a bit better, but imo that's (at
least for now) out of scope. For fences here I have the goal of one
internally representation used by both implicit syncing (dma-buf on
classic linux, e.g. prime) and explicit fencing on android or opencl
or something like that.

We don't have the code yet ready, but that's the direction i915 will
move towards for the near future. Jesse is working on some patches
already.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
