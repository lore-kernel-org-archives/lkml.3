Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbaFIRDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:03:34 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:57286 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933684AbaFIRDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140607181221.GB25068@e102568-lin.cambridge.arm.com>
References: <1402090985-8061-1-git-send-email-dianders@chromium.org>
	<20140607181221.GB25068@e102568-lin.cambridge.arm.com>
Date: Mon, 9 Jun 2014 10:03:31 -0700
X-Google-Sender-Auth: _eKRTm2ovh85RLJjiY_ogkcB4Yw
Message-ID: <CAD=FV=X17PeJ6JPE9Qyc1QT07AvA2PTE69Q87gz9a6MdUHgi4A@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: mcpm: Don't rely on firmware's secondary_cpu_start
From: Doug Anderson <dianders@chromium.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Inderpal Singh <inderpal.s@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        "olof@lixom.net" <olof@lixom.net>, Tushar Behera <trblinux@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lorenzo,

On Sat, Jun 7, 2014 at 11:12 AM, Lorenzo Pieralisi
<lorenzo.pieralisi@arm.com> wrote:
> On Fri, Jun 06, 2014 at 10:43:05PM +0100, Doug Anderson wrote:
>> On exynos mcpm systems the firmware is hardcoded to jump to an address
>> in SRAM (0x02073000) when secondary CPUs come up.  By default the
>> firmware puts a bunch of code at that location.  That code expects the
>> kernel to fill in a few slots with addresses that it uses to jump back
>> to the kernel's entry point for secondary CPUs.
>>
>> Originally (on prerelease hardware) this firmware code contained a
>> bunch of workarounds to deal with boot ROM bugs.  However on all
>> shipped hardware we simply use this code to redirect to a kernel
>> function for bringing up the CPUs.
>>
>> Let's stop relying on the code provided by the bootloader and just
>> plumb in our own (simple) code jump to the kernel.  This has the nice
>> benefit of fixing problems due to the fact that older bootloaders
>> (like the one shipped on the Samsung Chromebook 2) might have put
>> slightly different code into this location.
>>
>> Once suspend/resume is implemented for systems using exynos-mcpm we'll
>> need to make sure we reinstall our fixed up code after resume.  ...but
>> that's not anything new since IRAM (and thus the address of the
>> mcpm_entry_point) is lost across suspend/resume anyway.
>
> Can I ask you please what the firmware does for the boot (primary) cpu
> on cold-boot and warm-boot (resume from suspend) ?

On cold boot:

1. iROM loads BL1 from SPI flash
2. BL1 loads BL2 (SPL) from SPI flash
3. BL2 loads loads RO U-Boot from SPI flash
4. RO U-Boot (might) load RW U-Boot from SPI flash
5. U-Boot loads kernel from eMMC (or SD card or USB)
6. U-Boot boots kernel using bootm.


On resume from suspend:

1. iROM loads BL1 from SPI flash

2. BL1 loads BL2 (SPL) from SPI flash

3. BL2 does some basic init code (clocks, SDRAM out of self refresh,
...) and looks at some SoC registers that are preserved across
suspend/resume.  These registers contain flags indicating that this is
a resume from suspend and a pointer to the address in the kernel to
jump to at resume time.  The address of these registers and which bits
mean which flags is hardcoded and is part of the contract between the
bootloader and the kernel.

4. BL2 jumps to kernel.

---

I will note that BL1, BL2, and "RO U-Boot" are read only in production
systems.  Note that at resume time only Read-Only code is loaded from
persistent storage.  That means no extra verification is needed.  A
system exploit could survive suspend/resume but a reboot would clear
it and a reboot + suspend/resume wouldn't bring it back.


> Does it jump to a specific (hardcoded) location ?

I guess I could say it this way:

A) In resume from suspend, by agreement between the kernel and the
bootloader we'll jump to the address stored in 0x10040800 (INFORM0)

B) In bringing up a new CPU, by agreement between the kernel and the
bootloader we'll jump directly to 0x02073000 (and address in the SoC's
internal SRAM).


> Is the primary CPU (MPIDR) hardcoded in firmware so that on both
> cold and warm-boot firmware sees a specific MPIDR as "special" ?

Cold boot and resume from suspend are detected via various special
flags in various special locations.  Resume from suspend looks at
INFORM1 (0x10048004) for flags.  This register is 0 during a cold boot
and has special values set by the kernel at resume time.

It also looks as if some code looks at 0x10040900 (PMU_SPARE0) to help
tell initial cold boot and secondary CPU bringup.


> I am asking to check if on this platform CPUidle (where the notion of
> primary CPU disappears) has a chance to run properly.

I believe it should be possible, but we don't have CPUidle implemented
in our current system.  Abhilash may be able to comment more.


> Probably CPUidle won't attain idle states where IRAM content is lost, but I
> am still worried about the primary vs secondaries firmware boot behaviour.

I don't think iRAM can be turned off for CPUidle.


> What happens on reboot from suspend to RAM (or to put it differently,
> what does secure firmware do on reboot from suspend to RAM - in
> particular how is the "jump" address to bootloader/kernel set ?)

Should be described above now.

-Doug
