Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbaBEUbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:31:00 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:51257 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718AbaBEUa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:30:56 -0500
Message-ID: <52F29F7C.4080502@gmail.com>
Date: Wed, 05 Feb 2014 22:30:52 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
CC: Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, freemangordon@abv.bg
Subject: Re: Re: [PATCH] ARM: OMAP2+: Add support for thumb mode on DT booted
 N900
References: <1391603582-11371-1-git-send-email-sre@debian.org> <CAHYPw2Ep9VP6Tem979ewcztdxkHkG8eR_U31U=f5ibsVa5AS4Q@mail.gmail.com> <20140205163117.GA15996@earth.universe> <CAHYPw2HX478ZZPfDTKCKSGhVdFc1-G5DszUR4vG+WRgZx=8+dQ@mail.gmail.com> <20140205171729.GA17974@earth.universe>
In-Reply-To: <20140205171729.GA17974@earth.universe>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On  5.02.2014 19:17, Sebastian Reichel wrote:
> Hi,
>
> On Wed, Feb 05, 2014 at 05:38:54PM +0100, Pali Rohár wrote:
>>> I assumed, that the workaround is not needed for this device type.
>>
>> That rx51 secure call must not be called on non secure devices (e.g.
>> qemu), because it cause kernel crash. So I thought that kernel should
>> write something like secure call is disabled on that device types.
>> Kernel code for errata 430973 will update ibe bit for non secure
>> devices.
>
> Do you see any advantage in having that message?
>

AIUI it will appear only when booting the kernel in "qemu -m rx51...", I 
am not aware of any other non-secure device manifesting itself as RX51. 
So there is little advantage of having that additional message IMO.

>>> I just added the warning for missing CONFIG_ARM_ERRATA_430973,
>>> because its very likely a misconfigured kernel.
>>
>> Yes, it can be misconfigured kernel, but if you do not have any thumb
>> binary (like stock Maemo 5 system), then it is safe and OK.
>
> I think running this kernel may also be a potential security
> problem. If I understand it right the ARM core is left in an
> unstable state when you run Thumb code, so this may result in
> funny effects in the kernel?
>
> -- Sebastian
>

In theory having that workaround disabled might be a security problem, 
but honestly, knowing its nature I don't think it is easily exploitable, 
if at all. The final result when bitten by it is a SIGILL, but in 
userspace, not in the kernel(assuming the kernel is ARM), and userspace 
runs in totally different mode (nonsecure, nonprivileged) compared to 
the kernel(nonsecure, privileged) and IIRC every mode has its own set of 
stack, registers etc. BTW I don't think the kernel itself can be 
thumb2-compiled for cores with that errata, but I might wrong. Also, as 
Pali noted, the problem appears if and only if there is an userspace 
binary containing thumb2 code. If all of the userspace is pure ARM, 
there is no problem. And as the errata workaround has its drawbacks (BTB 
is cleared on every context switch which affects performance), one might 
want to not have it enabled. Maybe that warning should be spit only if 
CONFIG_THUMB2_KERNEL (or whatever the option was) is enabled. Though if 
that option is enabled I'd rather #error during compile time if errata 
workaround is not enabled, instead of printing a warning while booting a 
system that will crash in a matter of seconds.

Ivo
