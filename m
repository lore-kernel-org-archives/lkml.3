Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3BAPIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 10:08:00 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:40337 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab3BAPH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 10:07:59 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1302011321220.17427@math.ut.ee>
References: <alpine.SOC.1.00.1302011321220.17427@math.ut.ee>
Date: Fri, 1 Feb 2013 10:01:25 -0500
Message-ID: <CAH3drwb-248ngSqiXZGU=X1k45V8wmN4127_0gr=AQA=px2g0g@mail.gmail.com>
Subject: Re: Radeon RV100 init fails with specific card+mobo - IRQ problem
From: Jerome Glisse <j.glisse@gmail.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 7:24 AM, Meelis Roos <mroos@linux.ee> wrote:
> I have a test PC with AMD 760MPX chipset (Tyan S2466 Tiger MPX board)
> and Radeon RV100-based AGP card where radeon KMS modesetting does not
> work (does not work with any kernel tried so far (2.6.32, 3.2, 3.7,
> 3.8-rc6).
>
> >From dmesg with drm.debug=0xc
>
> [    3.209617] agpgart-amdk7 0000:00:00.0: AMD 760MP chipset
> [    3.325408] agpgart-amdk7 0000:00:00.0: AGP aperture is 512M @ 0xc0000000
> [...]
> [    3.529106] [drm] Initialized drm 1.1.0 20060810
> [    3.797715] [drm] radeon defaulting to kernel modesetting.
> [    3.797817] [drm] radeon kernel modesetting enabled.
> [    3.799108] [drm] initializing kernel modesetting (RV100 0x1002:0x5159 0x1787:0x0F02).
> [    3.799277] [drm] register mmio base: 0xB2000000
> [    3.799354] [drm] register mmio size: 65536
> [    3.799629] agpgart-amdk7 0000:00:00.0: AGP 2.0 bridge
> [    3.799718] agpgart-amdk7 0000:00:00.0: putting AGP V2 device into 4x mode
> [    3.799811] radeon 0000:01:05.0: putting AGP V2 device into 4x mode
> [    3.799900] radeon 0000:01:05.0: GTT: 512M 0xC0000000 - 0xDFFFFFFF
> [    3.799985] radeon 0000:01:05.0: VRAM: 128M 0x00000000E0000000 - 0x00000000E7FFFFFF (64M used)
> [    3.800187] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    3.800268] [drm] Driver supports precise vblank timestamp query.
> [    3.800350] radeon 0000:01:05.0: Fatal error during GPU init
> [    3.800432] [drm] radeon: finishing device.
> [    3.800509] [TTM] Memory type 2 has not been initialized
> [    3.800590] [drm] radeon: cp finalized
> [    3.800756] radeon: probe of 0000:01:05.0 failed with error -22
>
>
> 01:05.0 VGA compatible controller [0300]: Advanced Micro Devices [AMD] nee ATI RV100 QY [Radeon 7000/VE] [1002:5159] (prog-if 00 [VGA controller])
>         Subsystem: Hightech Information System Ltd. Device [1787:0f02]
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B+ DisINTx-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
>         Region 1: I/O ports at 2000 [size=256]
>         Region 2: Memory at b2000000 (32-bit, non-prefetchable) [size=64K]
>         [virtual] Expansion ROM at b2020000 [disabled] [size=128K]
>         Capabilities: [58] AGP version 2.0
>                 Status: RQ=48 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
>                 Command: RQ=16 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>
> Adding some printks reveals it calls
> r100_init() -> radeon_irq_kms_init() -> drm_irq_install() ->
> drm_dev_to_irq() and that fails. So no IRQ, no KMS.
>
> lspci does not show Interrupt like on some other PCI devices.
> /proc/interrupts obviously does not contain the irq since we do not
> register any yet.
>
> There is no BIOS option of "Enable IRQ for VGA" or similar (BIOS is
> latest). Could this be the problem?
>
> What can I do to get KMS working on this computer?
>
> --
> Meelis Roos (mroos@linux.ee)

Try booting with radeon.agp_mode=-1

Cheers,
Jerome
