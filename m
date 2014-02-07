Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaBGOGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:06:01 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:50475 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaBGOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:06:00 -0500
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <alpine.LNX.2.00.1402071437400.24838@pobox.suse.cz>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
	<alpine.LRH.2.00.1401301648050.15677@twin.jikos.cz>
	<alpine.LNX.2.00.1402071052470.24838@pobox.suse.cz>
	<87a9e318m6.fsf@intel.com>
	<alpine.LNX.2.00.1402071437400.24838@pobox.suse.cz>
Date: Fri, 7 Feb 2014 15:05:59 +0100
Message-ID: <CAKMK7uGf0=13HpkeZf1WouutkB+kOpyT4NHXaXMVg5j6wEh_pQ@mail.gmail.com>
Subject: Re: [git pull] drm next tree
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jani Nikula <jani.nikula@intel.com>, Dave Airlie <airlied@linux.ie>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 2:40 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 7 Feb 2014, Jani Nikula wrote:
>
>> >> >   git://people.freedesktop.org/~airlied/linux drm-next
>> >> [ ... snip ... ]
>> >> > Daniel Vetter (59):
>> >> [ ... snip ... ]
>> >> >       drm/i915: dp aux irq support for g4x/vlv
>> >>
>> >> This commit causes all kinds of havoc on my ThinkPad x200s. It results in
>> > [ ... snip ... ]
>> >
>> > Not having received any response, I suggest the following for 3.14
>>
>> Daniel, it's your commit this bisects to...
>>
>> If we end up having to revert, I'd just touch the has_aux_irq part, for
>> example:
>>
>> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
>> index 5ede4e8..464c047 100644
>> --- a/drivers/gpu/drm/i915/intel_dp.c
>> +++ b/drivers/gpu/drm/i915/intel_dp.c
>> @@ -404,7 +404,7 @@ intel_dp_aux_ch(struct intel_dp *intel_dp,
>>       int i, ret, recv_bytes;
>>       uint32_t status;
>>       int try, precharge, clock = 0;
>> -     bool has_aux_irq = true;
>> +     bool has_aux_irq = INTEL_INFO(dev)->gen >= 5;
>>       uint32_t timeout;
>>
>>       /* dp aux is extremely sensitive to irq latency, hence request the
>
> That, obviously, works for my system as well. Feel free to add
>
>         Reported-and-tested-by: Jiri Kosina <jkosina@suse.cz>
>
> if you are going with this instead of the revert.

Sorry for missing your report here. Before we disable this again for
gen4 I want to make sure that it's the same irq misrouting issue which
was already the cause for the gmbus irq mess. Can you please boot with
pci=nomsi (so that i915 uses irq16)?

If that's confirmed then I think we should add the same comment we've
added in intel_i2c.c to this code so that no one dares to wake this
dragon again. I'll do that when I commit the fix.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
