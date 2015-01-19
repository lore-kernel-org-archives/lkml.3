Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbbASKvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:51:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:40900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbbASKvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:51:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442221702"
Message-ID: <54BCE1BF.5050808@intel.com>
Date: Mon, 19 Jan 2015 11:51:43 +0100
From: Daniel Vetter <daniel.vetter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?windows-1252?Q?Ville_Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Jeremiah Mahler <jmmahler@gmail.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ander Conselvan de Oliveira <conselvan2@gmail.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [BUG, bisect] drm/i915: mouse pointer lags and overshoots
References: <20150117100635.GA1281@hudson.localdomain> <20150119090847.GQ10649@intel.com>
In-Reply-To: <20150119090847.GQ10649@intel.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/01/2015 10:08, Ville Syrjälä wrote:
> On Sat, Jan 17, 2015 at 02:06:35AM -0800, Jeremiah Mahler wrote:
>> Matt, all,
>>
>> Commit ea2c67bb4aff introduces a bug which causes the mouse to move in a
>> very unusual way, as if it has a lot of inertia.  It will lag behind and
>> then overshoot the expected position.
>>
>> I reproduced this bug on all my machines which use the drm/i915 drivers
>> and it affects all forms of mouse pointers including both touchpads and
>> usb mice.  The patch is present in linux-next 20150116.
>>
>>    commit ea2c67bb4affa84080c616920f3899f123786e56
>>    Author: Matt Roper <matthew.d.roper@intel.com>
>>    Date:   Tue Dec 23 10:41:52 2014 -0800
>>    
>>        drm/i915: Move to atomic plane helpers (v9)
> I guess this is caused by the atomic code refusing to update the plane
> more than once per vrefresh. So we need to allow the fps>vrefresh rate
> case to remove the regression.
>
> The old cursor code had basically a gross hack to allow this. It just
> unpinned the old fb before the display engine was done with it, and
> _after_ unpinning it flipped to the new buffer (with the obvious extra
> delay of the flip happening on the next vblank). So there was no
> guarantee the old buffer was still around (or had the correct content)
> while the display engine was still scanning it out. So to fix this
> properly we need a vblank worker of some sort.
>
> The other issues we nee to know which fb is being scanned out at which
> point to unpin the correct old buffer. For that we can use the hardware
> frame counter. We could use some other mechanims too (SURFLIVE, flip
> counter etc.) but the frame counter is the most ubiqitious method we
> have.
>
> The one extra problem is gen2 doesn't have even the frame counter, so
> some extra care would be needed there. I'm thinking for gen2 we might
> allow the driver to call into the vblank core code to update the cooked
> counter at any time based on the scanline counter and monotonic timestamp.
> That combined with the vblank evade mechanism should make reasonably sure
> we have an up to date notion of which frame is currently getting scanned
> out.
>
> We need the extra call into the vblank core since just after the vblank
> start, the vblank interrupt handler may not have executed yet (especially
> since gen2 vblank irq fires actually at the frame start which is a delayed
> version of the vblank start, even though the flip happes at vblank start).
> So we need an explicit call to make sure the cooked counter is already
> updated before the irq handler has executed. I have some changes lined
> up for the vblank code which I think could help make sure he extra call
> won't increment the counter spuriously, but I have to clean those up a
> bit before sending them out.
>
There's also an issue in (most) X drivers which exaberates this issues: 
When changing the cursor buffer the X cursor code does a a) disable 
cursor b) update cursor image c) enable cursor cycle. With latest 
upstream we /should/ be able to not block for just moving the cursor 
though when nothing crazy happens. Checking for that would be good.

For the real thing: Rob Clark also noticed this on msm with his atomic, 
I think we need a hint flag (only used internally) so that the 
legacy2atomic helpers and the driver core can correctly pass around 
semantics and we could recover the optimization. As long as we don't 
allow this hint flag to be set by userspace we could just completely 
drop the vblank wait - that would be buggy, but so is the old legacy 
implementation.
-Daniel
Intel Semiconductor AG
Registered No. 020.30.913.786-7
Registered Office: Badenerstrasse 549, 8048 Zurich, Switzerland

