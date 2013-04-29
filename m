Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513Ab3D2Ty1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:54:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab3D2TyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:54:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
Date: Mon, 29 Apr 2013 21:54:15 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, David Brown <davidb@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
References: <20130429162115.GA6893@kroah.com> <CA+55aFwU-bXZ7wn2dOcLNfPMcjDv3Jvqx_LTt7B+-tj4WcP8Mg@mail.gmail.com> <CA+55aFzLtBwsvVrnT2DrUOU+eYrQ5eiKeamRb4Y5+-TVgbuM5Q@mail.gmail.com>
In-Reply-To: <CA+55aFzLtBwsvVrnT2DrUOU+eYrQ5eiKeamRb4Y5+-TVgbuM5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304292154.15920.arnd@arndb.de>
X-Provags-ID: V02:K0:aYNW6f62ywuelR0zdFpt3Pn13ejUFVIuQB9csBTEEWf
 OgboqLJOwdk6hemMK9j94LJ9qddHR8K0fAqOZbhwYnlh4U1eug
 ygFxE2EAT+a0BE+hYeoSfBW33k3g44G2Z2340QmSN3SHLHZ1NH
 gjxs6dM079a9Gagqt3KS3MN+3RTQ38bEhwC6LXzm9KSoJV8YiS
 miP8pAIMvTY42Z5gxCnsNQfsY+s1Ai8KyG2v9izTp9sXvUTYZj
 tbJBfB3FmY64nFgbeA6rv2WQdV5mlr88WosQ/Qd+Cvp4mAQddo
 mhpFe4/4559BwCL2HFYFvL3X1yEn3YwtR5wltqangfwTrgaLM9
 HDYjTqVB0qQt5njn/7Ms=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 April 2013, Linus Torvalds wrote:
> And I'm calling the ARM people out on this idiocy. Arnd and Nico -
> stop encouraging this kind of crap. Move things to drivers only once
> there is actual reason for it. If it's some proprierary single-SoC
> thing, it can damn well stay away from other people. And it definitely
> shouldn't mess up autocomplete in some core location.

First of all, I have to admit that I did not notice ssbi getting submitted,
otherwise I would have suggested adding it to the drivers/bus directory
that we created a while ago for bus drivers.

I think there are good reasons for most of the drivers we have moved out
of arch/arm to stay out of there: we have added subdirectories for a lot
of drivers that are alike:

* drivers/irqchip
* drivers/clocksource
* drivers/cpufreq
* drivers/pinctrl
* drivers/pci/host
* drivers/pwm

All of these (and probably a couple I missed) now have a subsystem
maintainer who can look at the bigger picture across multiple platforms,
create common infrastructure to avoid code duplication and point out
when people create new drivers for hardware that already has an
existing driver in the same subsystem (this happens more than you'd
think).

Moreoever, a lot of ARM platforms in share even the most basic
building blocks with platforms on other architectures: powerpc,
mips, hexagon, c6x, sh, and even x86. I think it's much better to
consistently move those drivers into on directory per subsystem
rather than having only half the irqchip drivers in one directory
when they are shared across two architectures, and the rest hidden
away in some platform. In the end, it's not much different from
having a platform specific network driver sit under
drivers/net/ethernet rather than arch/arm/mach-foo even if we
know it's never going to be used elsewhere.
In case of SSBI, I assume it's also being used by arch/hexagon,
which is the other CPU core on many Qualcomm SoCs, but I'm sure
that David can comment better on that one, maybe it's only used
exclusively on SoCs that are ARM-only.

I think about two years ago, I tried to move a lot of simple "bus"
drivers into a common drivers/bus/ directory: amba, bcma, dio, eisa, hsi,
nubus, vlynq, vme, zorro out of their own top-level drivers directory.
That idea was almost universally rejected.

I did ask people submitting new bus infrastructure to use drivers/bus
though, and at least three of them were subsequently merged that way
(or are queued up for this merge window). If you like, we can try to
find a different place for those along with ssbi.

	Arnd
