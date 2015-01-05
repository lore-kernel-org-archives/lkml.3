Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbbAESWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:22:23 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34874 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbbAESWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:22:21 -0500
MIME-Version: 1.0
In-Reply-To: <20150105142206.76ca2e18@lxorguk.ukuu.org.uk>
References: <20150104190123.GA20153@amd> <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
 <alpine.LFD.2.11.1501041526390.18844@knanqh.ubzr> <CA+55aFxRRcSJ5i=EcQ-qqMrz0icn28JKjQuH3xGU65hjpVm9hw@mail.gmail.com>
 <20150104211555.GB12302@n2100.arm.linux.org.uk> <20150105142206.76ca2e18@lxorguk.ukuu.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 5 Jan 2015 18:22:01 +0000
X-Google-Sender-Auth: WqTCW1nmz35dFROqEMHlz1E9Eb0
Message-ID: <CAHkRjk5EAUvdR5ED_M=dB+5yu3RtZLgo_aighUrozovHKnOp=w@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 January 2015 at 14:22, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>> This is not the case on ARM.  Here's an example where we use a hardware
>> timer for the delay loop:
>>
>> Calibrating delay loop (skipped), value calculated using timer frequency.. 6.00 BogoMIPS (lpj=12000)
>>
>> which is nowhere near the precision of the CPU clock rate.  So, when
>> we have a hardware timer based delay implementation, the bogomips
>> value which the kernel has access to (and thus the loops_per_jiffy
>> value) is totally ... bogus.
>
> So multiply it by a fudge factor so it looks similar and in proportion.

It's not that simple. The CPU frequency and the timer frequency are
independent. One SoC may have 6MHz timer, another SoC with a similar
CPU frequency may use a 24MHz timer (or maybe a much smaller one). So
a fudge factor is not really any better than choosing a constant
bogomips value at build time (say 2000).

If the always constant bogomips is not desirable, we are left with
having to do a dummy calibration to guess some value to be reported to
user as BogoMIPS. Even if we do this, on modern ARM processors it
rarely matches the CPU frequency, only on older/simpler CPUs. With
newer ones, the simple two instructions loop is never 2 cycles (it may
even differ on the same CPU depending on the kernel build, e.g. code
alignment affecting the branch prediction; I recall on ARM11MPCore the
average was half-cycle multiple because the loop took different number
of cycles on consecutive iterations).

(I'm not debating whether we should fix this problem or not, just
trying to find the right solution; reverting the original patch
doesn't entirely fix newer CPUs)

-- 
Catalin
