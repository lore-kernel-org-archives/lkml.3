Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaE0RxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:53:00 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34981 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaE0Rw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140527152115.GA30180@roeck-us.net>
References: <CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com>
	<20140526104824.63F13C42129@trevor.secretlab.ca>
	<CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com>
	<20140526112348.907B7C421A5@trevor.secretlab.ca>
	<A6195DFD-0447-4444-AC09-501C43F09924@konsulko.com>
	<20140526213303.C1C73C40E11@trevor.secretlab.ca>
	<20140526223630.GA32691@earth.universe>
	<5383D174.8070304@roeck-us.net>
	<20140527121236.3B818C40A5A@trevor.secretlab.ca>
	<9CF30A1A-5EB6-401E-A0D5-453CB99B4A83@konsulko.com>
	<20140527152115.GA30180@roeck-us.net>
Date: Tue, 27 May 2014 19:52:57 +0200
X-Google-Sender-Auth: lvTSy89wtViaJ4MaK8rZlhAoo88
Message-ID: <CAMuHMdXy_qn7jufr3_My4AQ_J_=-wzx6uXH15NiHzsth-ZH2jw@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sebastian Reichel <sre@kernel.org>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Günther,

On Tue, May 27, 2014 at 5:21 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Tue, May 27, 2014 at 03:24:35PM +0300, Pantelis Antoniou wrote:
>> On May 27, 2014, at 3:12 PM, Grant Likely wrote:
>> > On Mon, 26 May 2014 16:42:44 -0700, Guenter Roeck <linux@roeck-us.net> wrote:
>> >> On 05/26/2014 03:36 PM, Sebastian Reichel wrote:
>> >>> On Mon, May 26, 2014 at 10:33:03PM +0100, Grant Likely wrote:
>> >>>> After thinking about it more, I think it is very likely that removing
>> >>>> all the overlays is the correct thing to do in the kexec use-case. When
>> >>>> kexec-ing, it makes sense that we'd want the exact same behaviour from
>> >>>> the kexec'ed kernel. That means we want the device drivers to do the
>> >>>> same thing including loading whatever overlays they depend on.
>> >>>>
>> >>>> If the flattened tree was left applied, then the behaviour becomes
>> >>>> different.
>> >>>>
>> >>>> I say always remove the overlays unless explicitly told not to, but I'm
>> >>>> struggling to come up with use cases where keeping them applied is
>> >>>> desirable.
>> >>>
>> >>> I would assume, that I want them applied in most cases. DT describes
>> >>> the hardware. If I kexec into a new kernel I change software, not
>> >>> hardware.
>> >>>
>> >>> Maybe I'm missing the main purpose of the feature. I currently see
>> >>> two useful usecases for DT overlays:
>> >>>
>> >>> 1. The dtb the kernel is booted with cannot be changed for some
>> >>>    reason, but the board has additional hardware attached (e.g.
>> >>>    the user added a sensor on the i2c bus)
>> >>> 2. The hardware is changed on the fly (e.g. the user flashed the
>> >>>    FPGA part of a zynq processor), sensors on i2c bus, ...
>> >>>
>> >>> In both cases the kernel should be booted with the additional
>> >>> overlay information IMHO. Though for the second case it should
>> >>> be possible to remove the "programmed" hardware information
>> >>> somehow.
>> >>>
>> >>
>> >> 3. Some hot-plug device or card is inserted or removed.
>> >>
>> >> I would argue that the kernel should _not_ be booted with the overlay in place.
>> >> Otherwise the code handling overlays would have to have special handling
>> >> for the restart case, which is much more complex than just to re-insert
>> >> the overlay when it is determined that the device or card is still there.
>> >
>> > Exactly.
>> >
>>
>> Looks like we are levitating to the 'remove overlays on kexec' approach.
>> Is that correct?
>>
>
> Let's just assume for a minute that this is not the case, and that loaded
> overlays are passed on.
>
> This would be an interesting challenge for the overlay manager, as it would
> have to handle a number of startup conditions. After all, it can not take
> it as granted that the hardware state did not change after it was stopped
> in the old kernel, and before it was started in the new kernel.
> - overlay loaded, but hardware/device no longer present
>   -> unload overlay
> - overlay loaded, but different hardware present
>   -> unload old overlay, load new one
> - overlay not loaded, hardware present
>   -> load overlay
> - overlay loaded and matches hardware
>   -> do nothing
>
> In comparison, its task would be quite straightforward if loaded overlays
> are not passed on to the new kernel.
> - If hardware is present, load overlay
>
> Ultimately, I seem to be missing something, as I don't really see the benefit
> of passing on the loaded overlay(s) to the new kernel. Activation time, maybe,
> for the most common case (overlay loaded and matches hardware) ?

All of the above assume you're using a system with overlays and an overlay
manager. I.e. you have add-on devices together with an overlay DT.
One way to handle this is via auto-detection of capes, that identify themselves,
so the overlay manager knows which overlay to load.

I'm trying to look at it in a more generic way: you add hardware which is not
in the DT, so the DT must be modified (in some way or another) to match the
hardware.

If you run kexec, the added hardware is still there. In the absence of a system
with auto-detection of capes, the newly booted kernel cannot know that
hardware has been added, compared to a pristine system. If it's in the
DT passed through kexec, everything will work.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
