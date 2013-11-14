Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3KNRgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:36:20 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52965 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab3KNRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:36:12 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20131114165142.GA11645@bratislava.fso.intel.com>
References: <1384394383-8582-1-git-send-email-olof@lixom.net>
	<20131114165142.GA11645@bratislava.fso.intel.com>
Date: Thu, 14 Nov 2013 09:36:10 -0800
Message-ID: <CAOesGMjbwV=kJUHPnr5Nk7sYTXjM4Z3kxqDUDNJEbda8HWNFTA@mail.gmail.com>
Subject: Re: [PATCH] i915: Use 120MHz LVDS SSC clock for gen5/gen6/gen7
From: Olof Johansson <olof@lixom.net>
To: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Duncan Laurie <dlaurie@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 8:53 AM, Rodrigo Vivi <rodrigo.vivi@gmail.com> wrote:
> On Wed, Nov 13, 2013 at 05:59:43PM -0800, Olof Johansson wrote:
>> From: Duncan Laurie <dlaurie@chromium.org>
>>
>> We had been using a DMI table workaround to select the right
>> frequency for devices, but this is fragile and must be updated
>> with every new platform.
>>
>> Instead the default case when VBT is missing is changed to use
>> 120MHz clock for LVDS SSC for these generations.
>>
>> The docs for 2010-Core, SandyBridge, and IvyBridge all indicate
>> that the reference frequency for LVDS is 120MHz:
>>
>> "2010 Core"
>> http://intellinuxgraphics.org/IHD_OS_Vol3_Part3r2.pdf
>> page 38
>> Reference Frequency: 120MHz for CRT and LVDS.  100MHz for the FDI.
>>
>> "2011 SandyBridge"
>> http://intellinuxgraphics.org/documentation/SNB/IHD_OS_Vol3_Part3.pdf
>> page 33
>> Reference Frequency: 120MHz for CRT, HDMI, LVDS.  100MHz for the FDI.
>>
>> "2012 IvyBridge"
>> http://intellinuxgraphics.org/documentation/IVB/IHD_OS_Vol3_Part4.pdf
>> page 27
>> Reference Frequency: 120 MHz for CRT, HDMI, LVDS, 100MHz for the FDI.
>
> Checked. You are right.
> And actually true even for HSW and BDW. 120 is the default and 100 is for test mode.

Yeah, the patch predates HSW/BDW, so it was not mentioned.

>> Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
>> [olof: Fixup for recent base, switched from if/else to single call]
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> ---
>>
>> Daniel,
>>
>> This applies on top of -next, which I'm presuming is close to your
>> for-3.13 base right now. It'd be good to see this go in since it's needed
>> to boot on Chromebooks (with developer mode off), and is thus blocking
>> testing next/mainline on a regular basis here.
>>
>> Thanks!
>>
>> -Olof
>>
>>  drivers/gpu/drm/i915/intel_bios.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
>> index 6dd622d733b9..e4fba39631a5 100644
>> --- a/drivers/gpu/drm/i915/intel_bios.c
>> +++ b/drivers/gpu/drm/i915/intel_bios.c
>> @@ -790,7 +790,12 @@ init_vbt_defaults(struct drm_i915_private *dev_priv)
>>
>>       /* Default to using SSC */
>>       dev_priv->vbt.lvds_use_ssc = 1;
>> -     dev_priv->vbt.lvds_ssc_freq = intel_bios_ssc_frequency(dev, 1);
>> +     /*
>> +      * Core/SandyBridge/IvyBridge use alternative (120MHz) reference
>> +      * clock for LVDS.
>> +      */
>> +     dev_priv->vbt.lvds_ssc_freq = intel_bios_ssc_frequency(dev,
>> +                     !HAS_PCH_SPLIT(dev));
>
> I'm just not convinced this is the right way to fix this here.
> Mainly because for most of platforms the alternate is 100 and default is 120.
> The ideal in my opinion should be to invert the alternate inside ssc_freqeuncy function and use the exception, that is probably IS_PINEVIEW(dev)...
>
> Not sure though... just a guess since this alternate was implemented for pineview...

Seeing the history of some of this code (changes, followed by reverts,
etc), I wanted to stay conservative with what we know works from a few
years in the field by now. The vbt defaults are only used by
Chromebooks, as far as I know, so it's not a code path shared with
other platforms today. Also, the ssc_freq bit from the vbios table is
passed into this function, so I don't think there's much point in
reversing the logic in there just for one of the two code paths.

Finally, from elsewhere in the same file:

/*
 * The genX designation typically refers to the render engine, so render
 * capability related checks should use IS_GEN, while display and other checks
 * have their own (e.g. HAS_PCH_SPLIT for ILK+ display, IS_foo for
particular
 * chips, etc.).
 */

Since this is display and not rendering related, that seems like the
right thing to base it on instead of generation tests.

I'm open for suggestions on improvements though, of course.


-Olof
