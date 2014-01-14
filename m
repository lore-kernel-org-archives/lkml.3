Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaANVDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:03:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41364 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbaANVDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:03:41 -0500
Message-ID: <52D5A60C.7080800@ti.com>
Date: Tue, 14 Jan 2014 16:03:08 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Victor Kamensky <victor.kamensky@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Patch Tracking <patches@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Linaro Networking <linaro-networking@linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: OMAP4: sleep: byteswap data for big-endian
References: <1389625399-24087-1-git-send-email-taras.kondratiuk@linaro.org> <52D404DE.2020806@ti.com> <CAArO44samX_uMeC93w4DBbC+yskEmrvVt_i-5VV_seatM56ypw@mail.gmail.com> <52D55CE5.1060902@ti.com> <CAA3XUr2cnF_rxMYvZfjBx22Sa8YE45o_qUU8GNoerQwhWqxhNQ@mail.gmail.com> <CAGo_u6oKpRFnPAWaqr9NTNAJB+m56jiDgBUgvsiZpaQ-3SF2kw@mail.gmail.com> <CAA3XUr1_cNuPmMU6Fs6c7Si2So0VFGcLyGJe+tS_R47BVKRXnw@mail.gmail.com> <CAGo_u6p7ErrKOMy4Ljg3nehVpd=DOg3XDn6gZ1nrFE_OuOjsWg@mail.gmail.com>
In-Reply-To: <CAGo_u6p7ErrKOMy4Ljg3nehVpd=DOg3XDn6gZ1nrFE_OuOjsWg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 January 2014 03:56 PM, Nishanth Menon wrote:
> On Tue, Jan 14, 2014 at 2:20 PM, Victor Kamensky
> <victor.kamensky@linaro.org> wrote:
>> On 14 January 2014 09:56, Nishanth Menon <nm@ti.com> wrote:
>>> On Tue, Jan 14, 2014 at 11:35 AM, Victor Kamensky
>>> <victor.kamensky@linaro.org> wrote:
>>>>
>>>> When BE kernel is built Makefile does take of compiling code in BE
>>>> mode. I.e all proper flags like -mbig-endian and -Wl,--be8 will be set.
>>>
>>> Agreed, and I assume you cannot instead switch to LE mode when
>>> entering assembly assuming LE?
>>
>> Yes. Note that this asm interacts with other data in kernel that would
>> be in BE form. And after all linker will not allow to put together files
>> that were compiled in different endianity.
>>
>>> The reason I ask this is - most of our development is NOT in BE mode.
>>> we will continue to manipulate and add assembly - AM335x, DRA7/OMAP5
>>> etc.. and obviously not every code change will indulge in ensuring
>>> right markers will be in place.
>>>
>>> by ensuring readl_relaxed handles the variations, you have ensured
>>> that I dont need to care about drivers other than to ensure they use
>>> _relaxed variants. in the case of assembly, this does not seem long
>>> term manageable.
>>
>> Yes, I agree if it is outside of main use case it will get broken if not
>> attended to. Definitely universe entropy increases :) - if left without
>> attention things will decay. Note we admit that even with ARM CPU
>> core BE changes similar decay can happen eventually ...that is
>> what LNG BE group trying to prevent. I think
>> the deal here is that next user of it can/need to fix things if they
>> decayed.
>>
> 
> Personally, I have no idea what "LNG BE" stands for.. I see the
> approach we are attempting here is to do any interaction external to
> ARM boundary to go through the ARM_BE8 macro.
> 
> If we want to make this something we can live with, then the platforms
> will have to ensure memory operations external to ARM must be operated
> upon by these macros. Instead, an approach that may be used is to
> introduce accessors macros that will provide right instruction based
> on BE/LE build and BE/LE SoC peripheral behavior.
> 
>>>>
>>>>> is the idea of BE build meant to deal with having a single BE kernel
>>>>> build work for all platforms (including LE ones)?
>>>>
>>>> Sort of. The idea here to run BE image on OMAP4 chip, with
>>>> kernel that would deals with LE periphery correctly, but ARM
>>>> core run in BE with special kernel that compiled for BE case (i.e
>>>> CONFIG_CPU_BIG_ENDIAN is set).
>>>
>>> I still dont get the usecase - other than "hey, we do this coz we can
>>> do it!".. I mean, yep, it sounds great and all.. but 4 years down the
>>> line, is this still going to work? is this going to be interesting
>>> careabout? or we are just maintaining additional code for a passing
>>> fancy or proof-of-concept?
>>
>> Valid concern. From LNG BE group point of view it is not "we can do
>> it". It is more like we've done it. We have Pandaboard ES running BE
>> kernel for a while. It is in LNG BE tree. We used it as development
>> and testing vehicle for BE work for a while. We are very grateful to
>> the platform for that - it is affordable and easily available! Given,
>> beyond ongoing BE testing on Pandaboard in LNG there may not be valid
>> use case for further things on OMAP4 BE. We had discussion
>> with Santosh Shilimkar from TI during last Linaro connect what to
>> do with LNG BE Pandaboard series. Santosh suggested and we
>> agreed that we would try to contribute them back to community. And
>> that is what Taras is doing. IMHO even though there may not be real
> 
> ok.. some sort of Linaro thing about which I have no background about
> - but dont really care in this context.
> 
Nothing related Linaro. Its just that platforms are supporting ARM BE
mode and Linaro folks had working patches for Panda. So I suggested
to get them on the lists.

Regards,
Santosh
