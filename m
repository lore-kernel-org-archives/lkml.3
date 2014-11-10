Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaKJJwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:52:33 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35534 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaKJJwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:52:32 -0500
Message-ID: <54608ADC.4050500@arm.com>
Date: Mon, 10 Nov 2014 09:52:28 +0000
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
References: <545FC215.7010802@web.de> <20141109231744.GC2989@lukather> <5460554A.1060701@web.de> <5460766B.8070000@web.de> <546082A8.60401@arm.com> <5460870C.9010109@web.de>
In-Reply-To: <5460870C.9010109@web.de>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 10 Nov 2014 09:52:28.0721 (UTC) FILETIME=[09EEDA10:01CFFCCC]
X-MC-Unique: 114111009522909301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/11/14 09:36, Jan Kiszka wrote:
> On 2014-11-10 10:17, Marc Zyngier wrote:
>> On 10/11/14 08:25, Jan Kiszka wrote:
>>> On 2014-11-10 07:03, Jan Kiszka wrote:
>>>> On 2014-11-10 00:17, Maxime Ripard wrote:
>>>>> Hi Jan,
>>>>> 
>>>>> On Sun, Nov 09, 2014 at 08:35:49PM +0100, Jan Kiszka
>>>>> wrote:
>>>>>> did anyone already happen to look into enabling CPU
>>>>>> hotplug for the Allwinner A20 in upstream? I'm currently
>>>>>> running the sunxi-next branch on Banana Pi, and echo 0 >
>>>>>> .../cpu1/online just hangs the system. The old 3.4
>>>>>> LeMaker kernel works fine in this regard. I can try to
>>>>>> look into details and port things over, just want to
>>>>>> avoid duplicate efforts.
>>>>> 
>>>>> Having hotplug support would indeed be very welcome.
>>>>> 
>>>>> However, it should be done in u-boot, through PSCI, and not
>>>>> in the kernel itself.
>>>>> 
>>>>> As far as I'm aware, no one worked actively on it, beside
>>>>> some WIP commit from Marc a while ago: 
>>>>> https://git.kernel.org/cgit/linux/kernel/git/maz/u-boot.git/commit/?h=wip/psci&id=45379c0f9cf812f0f62722f4015ec907fa5dc144
>>>>
>>>>
>>>>>
>>
>>>>> 
OK - I guess I will need a little guidance in then: Is there a good
>>>> reference board to study and to derive from? And maybe also:
>>>> What is missing or not working in that u-boot branch? If I
>>>> get this interface right, I just takes some device tree bits
>>>> to enable this for the kernel afterward, correct?
>>> 
>>> Started to play with that patch in naive ways: CPU0 locks up
>>> when offlining CPU1 - unless I disable the FIQ signal from
>>> CPU1. Then it "works", both offlining and onlining again.
>>> However, I suspect that this only parks CPU1 in wfi and does
>>> not do anything interesting to it.
>> 
>> Here's how this is supposed to work: - CPU1 sends a FIQ to CPU0,
>> bringing it into secure mode. - CPU0 then kills CPU1 by doing the
>> magic incantations on the power controller
>> 
>> What is missing here is all the cache cleaning before signalling
>> CPU0. If you add that, things should look a lot better (patches
>> welcome).
> 
> Unsure about this, or maybe this was too simplistic: I added calls
> to u-boot's flush_dcache_all and invalidate_icache_all (right
> after disabling the cache, just like the vendor kernel does), but
> CPU0 still locks up. I suspect there is still a bug in the FIQ
> handling. There is also a suspicious single "@" printed on the
> console. I'll play with the FIQ handler a bit.

The '@' is just my own debug stuff, and might be causing issues too.

Now, you have to realise that by the time you call into this code,
u-boot itself is long gone. Only the tiny bit of code dealing with
PSCI still lives in a bank of static, secure memory. So calling into
u-boot for anything is doomed. You need to actually put the code
inside the PSCI backend.

Thanks,

	M.
- -- 
Jazz is not dead. It just smells funny...
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJUYIrRAAoJECPQ0LrRPXpDyjQQAMpDGLUwVODYi0lHFb20axqZ
Jjptkh6L2UJ2D2a2Ow17umrnIJqFjvVDasKtoxrBj79ya7LvHdfti4cFAjhZbh53
dOYmGqWHLP5N2Ue5KGs6zEpmW3bkUQRM2n03pTsqs907zN3XrjhfdtEqun5qAKTX
Kbk2X/CieQnGx9rYeZUAIiJm0qO4e9ijKFQCvxRDItr0Eb4voRwRCtWCiD530ZTc
34G7fpqTR4HKNRsaLeBRCUz3dJXP7KgW3VymIu35fAAyUlt0oMENrcX9qKb6AHR7
KM0JXkts+bMmxeddRPzEEikHvRfSgbFxTY0+6vsqi4DrsuihI5OG+6VqckZRrfpV
S74IkyEyBscSUhkRcXUEWsly9AcK7gvxlK0DqyR+5v+OOQd6RGfAfA8xYT6GbtpN
EZ8suyFWsl55QdolWx5Pqb8VfL0Z70AteWcMhJia6eg69hGo1YJVM6DJ93rvSwzx
x1UniBVBkp9/jZYJPgrCw0ywGXbWex7OcnTCscGAChkFMgFT/LiBCF16PKoyLhYu
oGoClNbwlLgo4xAoeB/pDLyO0eaOLQS7/w2LdLZGbPXMVqcXkYVS+vkdkfe099Hb
dYXOCkI8mcxDDisodtSg7W797bJMfjnCmfrXJuyfTbJW2nSrYgqw5yZNhhEhlWB3
n24nemun99pZ8di2HBSl
=C/8W
-----END PGP SIGNATURE-----

