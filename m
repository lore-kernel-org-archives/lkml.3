Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaKJLHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:07:51 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40185 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaKJLHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:07:50 -0500
Message-ID: <54609C82.9020103@arm.com>
Date: Mon, 10 Nov 2014 11:07:46 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: AMR: sun7i: CPU hotplug support?
References: <545FC215.7010802@web.de> <20141109231744.GC2989@lukather> <5460554A.1060701@web.de> <5460766B.8070000@web.de> <546082A8.60401@arm.com> <5460870C.9010109@web.de> <54608ADC.4050500@arm.com> <54609479.8010203@web.de>
In-Reply-To: <54609479.8010203@web.de>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 10 Nov 2014 11:07:47.0111 (UTC) FILETIME=[8F1A7370:01CFFCD6]
X-MC-Unique: 114111011074703901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/11/14 10:33, Jan Kiszka wrote:
> On 2014-11-10 10:52, Marc Zyngier wrote:
>> On 10/11/14 09:36, Jan Kiszka wrote:
>>> On 2014-11-10 10:17, Marc Zyngier wrote:
>>>> On 10/11/14 08:25, Jan Kiszka wrote:
>>>>> On 2014-11-10 07:03, Jan Kiszka wrote:
>>>>>> On 2014-11-10 00:17, Maxime Ripard wrote:
>>>>>>> Hi Jan,
>>>>>>> 
>>>>>>> On Sun, Nov 09, 2014 at 08:35:49PM +0100, Jan Kiszka 
>>>>>>> wrote:
>>>>>>>> did anyone already happen to look into enabling CPU 
>>>>>>>> hotplug for the Allwinner A20 in upstream? I'm
>>>>>>>> currently running the sunxi-next branch on Banana Pi,
>>>>>>>> and echo 0 > .../cpu1/online just hangs the system.
>>>>>>>> The old 3.4 LeMaker kernel works fine in this regard.
>>>>>>>> I can try to look into details and port things over,
>>>>>>>> just want to avoid duplicate efforts.
>>>>>>> 
>>>>>>> Having hotplug support would indeed be very welcome.
>>>>>>> 
>>>>>>> However, it should be done in u-boot, through PSCI, and
>>>>>>> not in the kernel itself.
>>>>>>> 
>>>>>>> As far as I'm aware, no one worked actively on it,
>>>>>>> beside some WIP commit from Marc a while ago: 
>>>>>>> https://git.kernel.org/cgit/linux/kernel/git/maz/u-boot.git/commit/?h=wip/psci&id=45379c0f9cf812f0f62722f4015ec907fa5dc144
>>>>>>
>>>>>>
>>>>>>>
>>>>
>>>>>>>
>>
>>>>>>> 
OK - I guess I will need a little guidance in then: Is there a good
>>>>>> reference board to study and to derive from? And maybe
>>>>>> also: What is missing or not working in that u-boot
>>>>>> branch? If I get this interface right, I just takes some
>>>>>> device tree bits to enable this for the kernel afterward,
>>>>>> correct?
>>>>> 
>>>>> Started to play with that patch in naive ways: CPU0 locks
>>>>> up when offlining CPU1 - unless I disable the FIQ signal
>>>>> from CPU1. Then it "works", both offlining and onlining
>>>>> again. However, I suspect that this only parks CPU1 in wfi
>>>>> and does not do anything interesting to it.
>>>> 
>>>> Here's how this is supposed to work: - CPU1 sends a FIQ to
>>>> CPU0, bringing it into secure mode. - CPU0 then kills CPU1 by
>>>> doing the magic incantations on the power controller
>>>> 
>>>> What is missing here is all the cache cleaning before
>>>> signalling CPU0. If you add that, things should look a lot
>>>> better (patches welcome).
>> 
>>> Unsure about this, or maybe this was too simplistic: I added
>>> calls to u-boot's flush_dcache_all and invalidate_icache_all
>>> (right after disabling the cache, just like the vendor kernel
>>> does), but CPU0 still locks up. I suspect there is still a bug
>>> in the FIQ handling. There is also a suspicious single "@"
>>> printed on the console. I'll play with the FIQ handler a bit.
>> 
>> The '@' is just my own debug stuff, and might be causing issues
>> too.
>> 
>> Now, you have to realise that by the time you call into this
>> code, u-boot itself is long gone. Only the tiny bit of code
>> dealing with PSCI still lives in a bank of static, secure memory.
>> So calling into u-boot for anything is doomed. You need to
>> actually put the code inside the PSCI backend.
> 
> OK - seems like quite a bit of code needs to be pulled over...
> 
> Meanwhile I'm still starring at psci_fiq_enter: ... movw	r8,
> #(GICC_BASE & 0xffff) movt	r8, #(GICC_BASE >> 16) ldr	r9, [r8,
> #GICC_IAR] movw	r10, #0x3ff movt	r10, #0 cmp	r9, r10 bne	out1 movw
> r10, #0x3fe cmp	r9, r10 bne	out1 ...
> 
> How can GICC_IAR be 0x3ff and 0x3fe at the same time? These tests
> seems bogus. What was the actual intention here?

Yup, that looks like a massive brain fart. These two 'bne' should
really be 'beq's... You want to get out if you either read that there
is no interrupt (0x3ff) or an interrupt for non-secure (0x3fe).

	M.
- -- 
Jazz is not dead. It just smells funny...
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJUYJx9AAoJECPQ0LrRPXpD/0kP/jwdNF2Ahtj05biOkCOTmp3V
PUPNbffo8366UZeOLMjt7Wplde+//swOiLOq0uERS5IYj+QCMOA4F9hWOSO527zn
v1j6374hAW1F8p8waGRxOGEffUgZGhXPmOxQAIsr7iqsIrvUVbE6KcNS5ofs+29R
lWEaNW08L09CxcDA7szZzhVcMfu3oUxjzVFnnh6uhHG5DMxhCWt3IgEj2cLUR+VC
ER/VAS9r0/4Bl5sZ7VO+GeToolgswIlIGgjkqifwrKFYH8XSyIxN8LDrNLAR1F4Q
RQYfo3I7UGZcOPzz+BJcOsROohx2wtDeW6VxnRsE5WkE/udx++C7Ty9IquFrvPxA
1u8pzTrra27ZdxbrV2vS8YVo8bQktTdz8IjITuvWVX/cutXBdqIeP75EXYQQXeCg
TuO26Huce4McEtn7bOEQac6SxLpTitGM+EAdrlhV9Dg7bCp1mKfzlIM4t6KuowEU
53mniGtDoLlnyUy+N4X6KyUmvqqyRNyC+c3ZWmP5xoB3VcQ1IJKuSEHSS9bJxIKb
J2FNQN7v+C9P0d/1bItVqlpz6PiLcdWFFrfvDCxOe0uqkacwzhdlMMzrYYuMgAIi
e0u8fqYunECZliT5OMaRhqBwSsniZmw2bBf6ZaUqlKgXc5MsxjncNakOKMQkQjip
FwtcX/9StOztp43Laj7o
=LZJR
-----END PGP SIGNATURE-----

