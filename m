Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab3ASN1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 08:27:52 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:43252 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3ASN1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 08:27:51 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <50F9DF53.4090601@ionic.de>
References: <50F9DF53.4090601@ionic.de>
Date: Sat, 19 Jan 2013 14:27:48 +0100
Message-ID: <CAKMK7uExHc=PEBpn2vPrX+sQcv=U7VuvsJHRxc-SSOh=_G_1Dg@mail.gmail.com>
Subject: Re: i915-related and general system freezes with specific kernel
 config // IOMMU
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Mihai Moldovan <ionic@ionic.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mihai,

You have a gen4.5 chipset which is known to be utterly broken for
IOMMU+intel gpu. Looks like a few distros started enabling IOMMU by
default (fc18 has similar issues) and we've never added the proper
quirks. See https://bugzilla.kernel.org/show_bug.cgi?id=51921 for a
proposed patch to fix this (i.e. automatically set
intel_iommu=igfx_off for affected platfroms). Testing highly welcome.

Cheers, Daniel

On Sat, Jan 19, 2013 at 12:48 AM, Mihai Moldovan <ionic@ionic.de> wrote:
> Hi Daniel, David and everyone else,
>
> I'm experiencing system freezes on a box using the vanilla 3.7.2 (actually down
> to 3.2 or something) kernel with a custom configuration.
>
> There are two problems:
>
>   [*] related to i915 with modeset enabled; upon loading the kernel module with
> modeset=1, the box will instantly freeze.
>   [*] seemingly unrelated to i915; the box will randomly freeze without any
> clear indication of why and moreover no apparent trigger.
>
> After months, nay, years of being "locked" into 3.0.2 for the random freezes and
> i915 problems, I started playing with the kernel again and out of sheer
> desperation installed the current debian testing kernel, based on 3.2.35.
>
> From what I could see, it worked fine... no more crashes, neither when loading
> i915, nor randomly after some time (well, at least not for a day.)
>
> This time out of frustration, I ripped the config file used by debian to build
> the kernel out of its deb package and rebuilt my (almost[1]) vanilla 3.7.2
> kernel with this configuration exactly, updated via the oldconfig target and
> changed to include AHCI, RAID and SCSI drivers statically, so that I wouldn't
> need some initramfs to boot my system ... and ... with this config, I am not
> experiencing any i915 problems nor system freezes?!
>
> I then tried to spot any "obvious" differences between the two config files and
> to "approximate" my config file to the debian config.
>
> Comparing the dmesg output from 3.7.2 built with the slightly modified debian
> config to my 3.7.2 built with my config, I came across IOMMU entries which
> differed. My kernel config enables Intel IOMMU by default, while the debian
> config doesn't.
>
> Looking up IOMMU stuff in Documentation/, I found out that IOMMU *may* have bugs
> with the internal graphics card and there is an option called
> intel_iommu=igfx_off to disable IOMMU remapping for the integrated graphics card...
>
> I tried booting "my" kernel with intel_iommu=igfx_off and lo and behold, no more
> crashes when loading i915 with modeset enabled! Yay... but anyway, that's
> definitely a kernel bug.
>
> Next, regarding the random freezes... so did the kernel booted with
> intel_iommu=igfx_off. It seems the random freeze issue is kind of decoupled of
> the graphics issue.
>
> Testing further, I rebooted using iommu=off and intel_iommu=off. So far, I had
> no random crashes, but the system uptime of XXXXREPLACEMEXXXX minutes is too
> small to draw conclusions yet.
>
> Anyway, booting with both options made my USB ports unusable. Also, my PCIe and
> PCI WiFi cards stopped working. Seems like the kernel can't enumerate those
> devices due to... guess what, DMA remapping errors!
>
> Note that the debian-config kernel with CONFIG_INTEL_IOMMU=y and
> CONFIG_INTEL_IOMMU_DEFAULT_ON=n did not produce such errors. Both my USB and
> WiFi cards have been working.
>
> Any idea why is that?
>
> As I'm not sure who to CC exactly, I'm adding both the i915 and Intel IOMMU
> maintainers Daniel and David.
>
> I have included several files:
>
>   [*] the "debianish" config file
>   [*] my current config file (IOMMU still on by default)
>   [*] dmesg for the kernel built with the "debianish" config file
>   [*] dmesg for the kernel built with "my" config file, no IOMMU options passed
>   [*] dmesg for the kernel built with "my" config file, intel_iommu=igfx_off passed
>   [*] dmesg for the kernel built with "my" config file, iommu=off and
> intel_iommu=off passed
>
> Hope we can squash those bugs!
>
> Best regards,
>
>
>
> Mihai
>
>
>
>
> [1] only one "external" patch applied to ath9k, totally unrelated to the rest of
> the system, just changing regulatory stuff.
>



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
