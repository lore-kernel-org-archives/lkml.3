Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaGVQwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:52:46 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:39385 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaGVQwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:52:45 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <53CE93D4.3010204@amd.com>
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
	<CAKMK7uFugmw_pP1nyA1ws5tMB6iCe1CqBHeWHoYzQ0wXE301EA@mail.gmail.com>
	<53CE93D4.3010204@amd.com>
Date: Tue, 22 Jul 2014 18:52:44 +0200
Message-ID: <CAKMK7uH7WfFP6cDhwBPaS+YeL17fxycFQjpNdRfJVgSjhac-kQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 6:39 PM, Christian König
<christian.koenig@amd.com> wrote:
>> Maybe I've mixed things up a bit in my description. There is
>> fence_signal which the implementor/exporter of a fence must call when
>> the fence is completed. If the exporter has an ->enable_signaling
>> callback it can delay that call to fence_signal for as long as it
>> wishes as long as enable_signaling isn't called yet. But that's just
>> the optimization to not required irqs to be turned on all the time.
>>
>> The other function is fence_is_signaled, which is used by code that is
>> interested in the fence state, together with fence_wait if it wants to
>> block and not just wants to know the momentary fence state. All the
>> other functions (the stuff that adds callbacks and the various _locked
>> and other versions) are just for fancy special cases.
>
> Well that's rather bad, cause IRQs aren't reliable enough on Radeon HW for
> such a thing. Especially on Prime systems and Macs.
>
> That's why we have this fancy HZ/2 timeout on all fence wait operations to
> manually check if the fence is signaled or not.
>
> To guarantee that a fence is signaled after enable_signaling is called we
> would need to fire up a kernel thread which periodically calls
> fence->signaled.

We actually have seen similar fun on some i915 platforms. I wonder
whether we shouldn't have something in the fence core for this given
how common it is. Currently we have the same trick with regular wakups
on platforms with unreliable interrupts, but I haven't yet looked at
how we'll do this with callbacks once we add the scheduler and fences.
It might be though that we've finally fixed these coherency issues
between the interrupt and the fence write for real.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
