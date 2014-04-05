Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaDEJLK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 05:11:10 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41085 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaDEJLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 05:11:06 -0400
Message-ID: <533FC8A6.6050905@linux.com>
Date: Sat, 05 Apr 2014 11:11:02 +0200
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?UTF-8?B?VGVvZG9yYSBCxINsdcWjxIM=?= <teobaluta@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: David Lang <david@lang.hm>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>	<20140319201838.GA11403@redhat.com>	<CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com>	<20140321132816.GW15608@titan.lakedaemon.net>	<532DC3D3.9060008@linux.com>	<CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com>	<20140323193839.GY15608@titan.lakedaemon.net>	<CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com>	<20140401142051.GO28304@titan.lakedaemon.net>	<alpine.DEB.2.02.1404031353280.14073@nftneq.ynat.uz>	<20140404151542.GB28334@titan.lakedaemon.net>	<533EDB15.40305@linux.com> <CACV2jQCxfQzRydFD6KizFnquasqtqaz1O_yNnVDBetFA5UryrA@mail.gmail.com>
In-Reply-To: <CACV2jQCxfQzRydFD6KizFnquasqtqaz1O_yNnVDBetFA5UryrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/04/2014 11:42 PM, Teodora Băluţă wrote:
> On Fri, Apr 4, 2014 at 7:17 PM, Levente Kurusa <levex@linux.com> wrote:
>> Hi,
>>
>> On 04/04/2014 05:15 PM, Jason Cooper wrote:
>>> On Thu, Apr 03, 2014 at 01:57:04PM -0700, David Lang wrote:
>>>> On Tue, 1 Apr 2014, Jason Cooper wrote:
>>>>
>>>>>> Now I guess we need to think how to make it work without a
>>>>>> framebuffer. I already suggested using the ASCII characters,
>>>>>> but seeing the resolution of this QR code for example (147x147),
>>>>>> made me realize that we can't shuffle that into a 80x25 textmode
>>>>>> display. Any ideas how to fix that or should we just simply depend
>>>>>> on a framebuffer being present?
>>>>>
>>>>> I think depending on the framebuffer being present (via kconfig) is
>>>>> sane.  Folks running old systems know what they're in for, like missing
>>>>> shiny new features. ;-)
>>>>
>>>> First get it working and into acceptable form, but after that, take
>>>> a look at the various ASCII-art tools out there. While the display
>>>> may be limited to 80x25, that's not a hard requirement (and I'd
>>>> happily run systems with a smaller text console if this was an
>>>> option), and then you can look at the possibility of using
>>>> characters that represent more than one pixel per character. While
>>>> this may not be able to render everything perfectly, remember that
>>>> qr codes can include redundancy to correct for bad pixels, you may
>>>> be able to get something working.
>>
>> I am not sure depending on the error recovery is good practice.
>> We also have to take into account that scanners themselves also
>> create noise and may not be perfect. Better reserve the error
>> recovery for those details instead of messing the QR code with
>> characters...
> 
> You do have the option of error recovery for up to 30% recovery (H
> level), but that means the space you get for storing is smaller.
> 
>>
>>>
>>> I'm not sure this will work.  The screen space allocated to a single
>>> character isn't square.  However, the QR pixels are square.  I see a lot
>>> of fragile complexity ahead...
>>>
>>
>> ... not to mention this as well.
>>
>>
>> IMHO supporting textmode is just not worth the effort. Besides,
>> what would we gain from it? Supporting those devices without
>> a framebuffer? Do devices like that even exist anymore? In fact,
>> even to make this you need a screen, and AFAIK most screens come
>> with some kind of a framebuffer to drive them.
> 
> Guys, first things first is cleaning the library up. I haven't managed
> to do anything yet as I am working on my thesis (bachelor's degree,
> yay!). I will do some this weekend and that is removing the kanji mode
> support. So, Levente, pleaso do that parameter thing you mentioned.
> Merging that with the cleanup shouldn't be a problem. :-)

Awesome, good luck on your thesis, take your time, we are not
rushing. :-)

Yea, I began the work on the parameter and scaling but using
'oops.qr=' isn't easy to use in a file called 'print_oops.c'.
Reason is that KBUILD_MODNAME will become 'print_oops' and then
MODULE_PARAM_PREFIX will be 'print_oops.' (note the dot character)
and so the final parameter will be 'print_oops.qr'. I have solved
this with:

#undef MODULE_PARAM_PREFIX
#define MODULE_PARAM_PREFIX "oops."

but I think this is ugly and is a hack. The good solution
would be to change KBUILD_MODNAME to 'oops' but I am not sure
how to do that, since I have little to no knowledge (and
experience) in how kbuild works.

Or, we could use core_param and simply have 'oops_qr' or
'qr_oops'. In my humble opinion the latter sounds better.

Or, there is __setup as well and that could achieve 'oops.qr',
but that is for *very* core stuff and this is probably not *that*
core. :-)

So, yea, if anyone knows how to change KBUILD_MODNAME without
ugly hacks, I would be grateful to be informed.


> 
> I think writing the QR to the frame buffer is the way to do it for
> now. Doing a QR in text mode (as in displaying it, not as previously
> mentioned idea with the link base64 encoding &/ compression) would
> mean that for each square you get an ASCII character filling up your
> screen. To get an idea of how the QR looks on the frame buffer I've
> made a screenshot. That's the whole Oops message being encoded and
> compressed. [0]

I am not sure if we ever wanted to output a link, but yes filling the
screen with ASCII characters and relying on the error recovery to
ensure readability is very bad.

Nice screenshot, I had as well successfully set up a testsuite
with qemu that allows me to test if it displays correctly. I can
share the testsuite if needed.

> 
> The problem with frame buffer is that I currently implemented it using
> the generic frame buffer API. There are some issues as mentioned in
> the first post of this RFC [1]. Would making it work with KMS be
> better? Any opinions?

Not sure, since we are already in a very bad situation when the
Oops happens, I think it is better use something that has existed
for ages and seems to be a bit more simple, and has less chance to
fail. Adding a lot of new code to a fragile part of the kernel
is a hotbed for a recursive oops so I would say just stick with
fb for now...

Oh and another suggestion, I think placing it in the bottom-right
corner would be better since then we wouldn't overwrite some of
the timestamps and messages.


-- 
Regards,
Levente Kurusa
