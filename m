Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbbAGSLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:11:37 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32834 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbbAGSLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:11:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
References: <20150104190123.GA20153@amd> <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <20150104201026.GA23427@amd> <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
 <20150104203724.GA16372@amd> <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
 <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 7 Jan 2015 18:11:15 +0000
X-Google-Sender-Auth: MagnAkF28ioFig8pjgTUP33JAZw
Message-ID: <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 January 2015 at 04:51, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> From: Nicolas Pitre <nicolas.pitre@linaro.org>
> Date: Sun, 4 Jan 2015 22:28:58 -0500
> Subject: [PATCH] ARM: disentangle timer based delays and bogomips calibration
>
> The bogomips value is a pseudo CPU speed value originally used to calibrate
> loop-based small delays.  It is also exported to user space through the
> /proc filesystem and some user space apps started relying on it.
>
> Modern hardware can vary their CPU clock at run time making the bogomips
> value less reliable for delay purposes. With the advent of high resolution
> timers, small delays migrated to timer polling loops instead.  Strangely
> enough, the bogomips value calibration became timer based too, making it
> way more bogus than it already was as a CPU speed representation and people
> using it via /proc/cpuinfo started complaining.
>
> Since it was wrong for user space to rely on a "bogus" mips value to start
> with, the initial responce from kernel people was to remove it.  This broke
> user space even more as some applications then refused to run altogether.
> The bogomips export was therefore reinstated in commit 4bf9636c39 ("Revert
> 'ARM: 7830/1: delay: don't bother reporting bogomips in /proc/cpuinfo'").
>
> Because the reported bogomips is orders of magnitude away from the
> traditionally expected value for a given CPU when timer based delays are
> in use, and because lumping bogomips and timer based delay loops is rather
> senseless anyway, let's calibrate bogomips using a CPU loop all the time
> even when timer based delays are available.  Timer based delays don't
> need any calibration and /proc/cpuinfo will provide somewhat sensible
> values again.
>
> In practice, calls to __delay() will now always use the CPU based loop.
> Things remain unchanged for udelay() and its derivatives.

I think this makes sense since __delay() expects the number of loops
as argument rather than a duration scaled by some factor (based on the
generic timer frequency).

FWIW:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Minor comment below:

>  unsigned long calibrate_delay_is_known(void)
>  {
>         delay_calibrated = true;
> -       return lpj_fine;
> +
> +       /* calibrate bogomips even when timer based delays are used */
> +       return 0;
>  }

Do we need to remove delay_calibrated = true as well? We do it further
down again in calibration_delay_done() .

-- 
Catalin
