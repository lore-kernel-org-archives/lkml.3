Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3KQMIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 07:08:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56971 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab3KQMII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 07:08:08 -0500
Date: Sun, 17 Nov 2013 13:07:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [Intel-gfx] kernel 3.11.6 general protection fault
Message-ID: <20131117120734.GE27323@pd.tnic>
References: <201311132058.30310.Emanoil.Kotsev@fincom.at>
 <20131113200914.GG7251@phenom.ffwll.local>
 <20131113203319.GB23962@pd.tnic>
 <201311171235.17602.Emanoil.Kotsev@fincom.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201311171235.17602.Emanoil.Kotsev@fincom.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 12:35:16PM +0100, MPhil. Emanoil Kotsev wrote:
> After doing all of this I was able to reproduce the issue by
> overloading the system with following simple steps:
> 1. start a compilation of something (ex. kernel)
> 2. run another process hungry application (flashplayer in firefox)
> => system locks in about 3-5mins

Ha, so we're getting somewhere :)

> I also noticed that the board gets pretty hot, so in my opinion it
> locks because of thermal issue.

The symptoms we're seeing so far are very much consistent with a thermal
issue.

> I think this also would explain why I see errors at different
> processes (mostly Xorg), but with 3.12 I do not get any trace message
> in the log files. Could you advise which option should be enabled in
> the kernel or how I could log/trace if system locks.

Try enabling CONFIG_LOCKUP_DETECTOR, that could tell us where we're
hanging.

But, make sure to be on a console and not in X in order to get a chance
to see the message. What I do is reroute all log messages to /dev/tty8,
i.e. have

*.*		|/dev/tty8

in syslog.conf and switch to it with Ctrl-Alt-F8.

> How can I make sure that the cooling/temp works properly?
>
> Perhaps after upgrading in september the system is working under

What kind of upgrade exactly did you do to a laptop?

> heavier load and therefore I started having the issue, or something
> broke in software or hardware and it can not cool down properly. I
> don't think the kernel is the issue, because I had the same with older
> kernels that were working fine before.
>
> The fan looks clean and there is no dust or whatever in the cooling
> area, that would prevent colling. The physical position of the
> notebook (docking station) also did not change.

Does the issue happen if the laptop is not in the docking station?

In any case, you need to follow your steps back of the upgrade to have
at least a clue what causes the overheating.

Can you revert the upgrade and see whether it still happens?

Also, do you have sensors support for your hardware? IOW, can you
monitor the temperature of some hardware elements by running

$ sensors

?

For example, I see this on my box here:

$ sensors
fam15h_power-pci-00c4
Adapter: PCI adapter
power1:       45.64 W  (crit = 125.19 W)

k10temp-pci-00c3
Adapter: PCI adapter
temp1:        +19.2°C  (high = +70.0°C)
                       (crit = +90.0°C, hyst = +87.0°C)

radeon-pci-0100
Adapter: PCI adapter
temp1:        +80.0°C

so when something overheats, running "watch -n 1 sensors" could give
some hints.

Also, what does

$ grep . -EriIn /sys/devices/system/cpu/cpu0/cpufreq

give?

Also, can you connect your laptop to a serial or netconsole to collect
dmesg before and while the lockup happens?

Basically, we're looking for a hint about which part of the hw causes
the overheating...

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
