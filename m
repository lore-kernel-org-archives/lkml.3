Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab3KKOaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:30:19 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:41779 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab3KKOaN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:30:13 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat9gtPvzY0=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH 0/3] omapdss: venc: Add support for bypass and acbias.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <5280E617.3000004@ti.com>
Date: Mon, 11 Nov 2013 15:30:08 +0100
Cc: Belisko Marek <marek.belisko@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Marek Belisko <marek@goldelico.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <F97741D2-FC6F-4DBD-A0DD-E35304501993@goldelico.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com> <CAAfyv34j+YhEjtHyf7zg5oBoCV5ROEXow8VV0PQNHLTF5uDZJg@mail.gmail.com> <5280DBA6.50303@ti.com> <FB10035C-B13C-4A03-BE9C-0576806F2577@goldelico.com> <5280E617.3000004@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 11.11.2013 um 15:13 schrieb Tomi Valkeinen:

> On 2013-11-11 15:57, Dr. H. Nikolaus Schaller wrote:
>> Hi Tomi,
>> 
>> Am 11.11.2013 um 14:29 schrieb Tomi Valkeinen:
>> 
>>> Hi,
>>> 
>>> On 2013-11-05 09:24, Belisko Marek wrote:
>>>> Hi,
>>>> 
>>>> ping.
>>>> 
>>>> On Mon, Oct 14, 2013 at 11:02 PM, Marek Belisko <marek@goldelico.com> wrote:
>>>>> This patches is adding bypass and acbias functionality to omapdss venc driver.
>>>>> In first patch we export updatin bypass and acbias in devconf1 register. Next patch
>>>>> add handling for updating in venc driver and last patch add driver for opa362 which
>>>>> is used on gta04 board and set bypass + acbias.
>>>> Is there a chance to get this series to 3.13? Thanks.
>>> 
>>> Sorry, I haven't had time to do much reviewing.
>>> 
>>> The code in omap3-tvout.c should be included in the display.c file,
>>> which already contains some things like muxing.
>> 
>> Ok, that might be better - but we were not sure where to place code to
>> modify the DEVCONF1 registers. It is not directly DSS related but a special
>> control of the OMAP3 SoC. Therefore we think it is better located in omap3-tvout.c
> 
> The display.c file is not strictly DSS stuff, but DSS related "glue" for
> the SoC. For example, the muxing of the DSI pads is also done on the
> CONTROL module, and it's also in display.c.
> 
> The file is getting a bit large, so I'm not against splitting it. But I
> don't think there's point to add omap3-tvout.c file, which most likely
> will ever contain only that one function.

Yes that is very likely true.

The problem is that there is no other official API to modify the DEFCONF1
register. Therefore we introduced this (propsal).

Our first idea was a readDEFCONF1() and writeDEFCONF1() and use the
constants (bit patterns) you suggested below.

But we thought that it is not robust enough because a VENC driver or other
one could then change bits it is not responsible for.

> 
>>> Also, func(bool, bool)
>>> style functions are rather confusing to read. Maybe an enum would be
>>> better, so you'd instead have something like:
>>> 
>>> func(OMAP_VENC_TVOUTBYPASS | OMAP_VENC_TVACEN)
>> 
>> We have no special preference on that.
> 
> It's just about readability. Which one tells you better what the code does:
> 
> func(true, true);
> 
> or
> 
> func(OMAP_VENC_TVOUTBYPASS | OMAP_VENC_TVACEN);

Hm. Depends on. If the func is explaining enough it is clear. Or if I have
access to some header file. If I don't, the enum values are probably more
readable.

> 
>>> But the main issue is: while this series probably works well, I really
>>> don't like it that the OPA driver needs to pass bypass and acbias. It
>>> shouldn't know anything about such things. I'm just not certain how to
>>> implement that with the current omapdss driver.
>> 
>> Well, it must know bypass and acbias because it requires the OMAP
>> CPU to be configured accordingly. I.e. it is the one who pushes the
>> button. Or we get a problem that people might misconfigure it.
> 
> While the omapdss display drivers are currently OMAP specific, I want to
> (or at least try to) keep them platform independent. Afaik, acbias and
> bypass are OMAP VENC specific things, not something that every SoC with
> an analog TV-out have. Thus, the OPA driver should not know about them,
> and it should be something that only the DSS glue code in mach-omap2/
> and the venc driver know about.

Well, there must be a method how the OPA can tell the VENC that it exists
and the VENC can tell the SoC DEFCONF1 to enable bias and bypass.

> 
>> I would see it similar as a driver must be able to control power. Here
>> it must be able to control bypass and acbias in a special way that it works.
> 
> The difference is that on all possible SoCs where you could add OPA
> chip, you'll need to manage the power for OPA, and it's done in a common
> way. Whereas the bypass and acbias are OMAP specific things.

Maybe it looks as if it is an unsolvable problem. The OPA works only if acbias
and bypass are enabled, but is not allowed to tell that it is there.

> 
>>> I'll try to find time to think about this more, but I don't think I can
>>> merge this for 3.13.
>> 
>> Please take your time.
>> 
>> And please also consider the approach to merge it into 3.13 as it is
>> and we can then fix it in the weeks while release candidates are pushed.
> 
> If it was purely omapdss code, I could possibly take it. But it contains
> arch/arm code also,

because we think that it is unavoidable (no API to control the DEFCONF1
register exists yet).

Maybe one of the omap3 core maintainers can comment as well?

> and I don't want to cause needless changes on code
> that I do not maintain.

Yes, this should be avoided of course.

BR,
Nikolaus

