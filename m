Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3CFIgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:36:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:42625 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab3CFIge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:36:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,793,1355126400"; 
   d="scan'208";a="295725478"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, Benson Leung <bleung@chromium.org>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Olof Johansson <olofj@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: v3.9-rc1 instability on Chromebook Pixel with gmbus irq
In-Reply-To: <CAKMK7uEAzXG91GgmYhyeTLP3-Ahi9O+YD=A42xTLMBvf=20sgA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <CANLzEkvN1uGsS9WnN3OTntSXJw+Ut2z2Eqyn7etQwDSyOdxhKg@mail.gmail.com> <CAKMK7uEAzXG91GgmYhyeTLP3-Ahi9O+YD=A42xTLMBvf=20sgA@mail.gmail.com>
User-Agent: Notmuch/0.15.1+22~g943ed44 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 06 Mar 2013 10:37:03 +0200
Message-ID: <87y5e0vs9c.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Mar 2013, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Wed, Mar 6, 2013 at 3:35 AM, Benson Leung <bleung@chromium.org> wrote:
>> I'm working on touch devices Chromium OS, and I've noticed a
>> regression between 3.8 and 3.9-rc1, which was posted yesterday.
>>
>> The hardware in question is a Chromebook Pixel. For this device, we
>> have i2c input devices: atmel mxt224s touchpad and atmel mxt1664s
>> touchscreen. The touchpad is on bus 1, "i915 gmbus vga" at 1-004b. The
>> touchscreen is on bus 2, "i915 gmbus panel" at 2-004a.
>>
>> I was testing v3.9-rc1 on the Pixel and the touchscreen driver is
>> being returned -110 (-ETIMEDOUT) on an i2c_transfer after several
>> seconds of both touch devices working correctly. At the time of the
>> failure, there are no error messages from GMBUS that I can see, but
>> the bus never recovers. I can keep interacting with the touchscreen or
>> touchpad, and the interrupts trigger reads, but all subsequent reads
>> return -110.
>>
>> I noticed that between 3.8 and 3.9-rc1, your patch series to add gmbus
>> irq support was merged. After bisecting, I found that this commit
>> seems to be causing the timeout problem. Reverting it makes the
>> problem go away, and the bus is stable.
>
> Can you please retest with latest drm-intel-fixes merged into -rc1?
> Paulo's patch fixes a race in handling PCH interrupts (where the gmbus
> hw is) which matches rather well with your description here.

Also, some error paths only print with debug on. Did you try with
drm.debug=0xe?

BR,
Jani.


>
> Thanks, Daniel
>
>> commit 2c438c0273b76d6cb158f8bdd0aa3ebf66e48a28
>> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Date:   Sat Dec 1 13:53:46 2012 +0100
>>
>>     drm/i915: use gmbus irq to wait for gmbus idle
>>
>>     GMBUS_ACTIVE has inverted sense and so doesn't fit into the
>>     wait_hw_status helper, hence create a new gmbus_wait_idle functions.
>>     Also, we only care about the idle irq event and nothing else, which
>>     allows us to use the wait_event_timeout helper directly without
>>     jumping through hoops to catch NAKs.
>>
>>     Since gen2/3 don't have gmbus interrupts, handle them separately with
>>     the old wait_for macro.
>>
>>     This shaves another few ms off reading EDID from a hdmi screen on my
>>     testbox here. EDID reading with interrupt driven gmbus is now as fast
>>     as with busy-looping gmbus at 28 ms here (with negligible cpu
>>     overhead).
>>
>>     Reviewed-by: Imre Deak <imre.deak@intel.com>
>>     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>
>>
>> Is there anything I can do to help debug this some more?
>>
>> --
>> Benson Leung
>> Software Engineer, Chrom* OS
>> bleung@chromium.org
>
>
>
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
