Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab3CGPP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:15:59 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:26331 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab3CGPP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:15:58 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Mar 2013 10:15:58 EST
Date: Thu, 7 Mar 2013 10:06:18 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Black screen with nouveau in 3.8.x (regression)
Message-ID: <20130307150618.GA31832@elliptictech.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

Yesterday I upgraded one of my machines to 3.8.2 from 3.6.6.  This
machine has an old NV36 AGP board.  With the new kernel, as soon as
nouveau takes over the console the display connected via DVI goes dark
(the monitor goes into standby mode).  The display connected via VGA
continues to work fine.

Starting Xorg does not correct the problem.  Nouveau seems to know
that the display is connected:

  % cat /sys/class/drm/card0-DVI-I-1/status
  connected

I don't see anything unusual in the log either (full log attached):

  % dmesg -t | grep -iE 'drm|nouveau'
  [drm] Initialized drm 1.1.0 20060810
  nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x436200a1
  nouveau  [  DEVICE][0000:01:00.0] Chipset: NV36 (NV36)
  nouveau  [  DEVICE][0000:01:00.0] Family : NV30
  nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
  nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
  nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
  nouveau  [   VBIOS][0000:01:00.0] BMP version 5.28
  nouveau  [   VBIOS][0000:01:00.0] version 04.36.20.21
  nouveau W[  PTIMER][0000:01:00.0] unknown input clock freq
  nouveau  [     PFB][0000:01:00.0] RAM type: DDR1
  nouveau  [     PFB][0000:01:00.0] RAM size: 256 MiB
  nouveau 0000:01:00.0: putting AGP V3 device into 8x mode
  nouveau  [     DRM] VRAM: 255 MiB
  nouveau  [     DRM] GART: 64 MiB
  nouveau  [     DRM] BMP BIOS found
  nouveau  [     DRM] BMP version 5.40
  nouveau  [     DRM] Bios version 04.36.20.21
  nouveau  [     DRM] DCB version 2.2
  nouveau  [     DRM] DCB outp 00: 01000300 00009c40
  nouveau  [     DRM] DCB outp 01: 02010310 00009c40
  nouveau  [     DRM] DCB outp 02: 04000302 00000000
  nouveau  [     DRM] DCB outp 03: 02020321 00000303
  nouveau  [     DRM] Loading NV17 power sequencing microcode
  nouveau  [     DRM] Saving VGA fonts
  [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
  [drm] No driver support for vblank timestamp query.
  nouveau  [     DRM] 0xE51A: Parsing digital output script table
  nouveau  [     DRM] 0 available performance level(s)
  nouveau  [     DRM] c: core 425MHz memory 501MHz voltage 1350mV
  nouveau  [     DRM] MM: using M2MF for buffer copies
  nouveau  [     DRM] Setting dpms mode 3 on vga encoder (output 0)
  nouveau  [     DRM] Setting dpms mode 3 on vga encoder (output 1)
  nouveau  [     DRM] Setting dpms mode 3 on tmds encoder (output 2)
  nouveau  [     DRM] Setting dpms mode 3 on TV encoder (output 3)
  nouveau  [     DRM] allocated 1280x1024 fb: 0x9000, bo ffff88007b6ae000
  fbcon: nouveaufb (fb0) is primary device
  nouveau  [     DRM] 0xE51A: Parsing digital output script table
  nouveau  [     DRM] Setting dpms mode 0 on tmds encoder (output 2)
  nouveau  [     DRM] Output DVI-I-1 is running on CRTC 0 using output C
  nouveau  [     DRM] Setting dpms mode 0 on vga encoder (output 1)
  nouveau  [     DRM] Output VGA-1 is running on CRTC 1 using output B
  fb0: nouveaufb frame buffer device
  drm: registered panic notifier
  [drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0 on minor 0

I started a bisection... here's the first steps so far.  I will try to
finish the procedure over the next couple days but I'm reporting this
now in case someone needs me to get some other info.

  git bisect start 'drivers/gpu/drm'
  # good: [3820288942d1c1524c3ee85cbf503fee1533cfc3] Linux 3.6.6
  git bisect good 3820288942d1c1524c3ee85cbf503fee1533cfc3
  # bad: [19b00d2dc9bedf0856e366cb7b9c7733ded659e4] Linux 3.8.2
  git bisect bad 19b00d2dc9bedf0856e366cb7b9c7733ded659e4
  # good: [a0d271cbfed1dd50278c6b06bead3d00ba0a88f9] Linux 3.6
  git bisect good a0d271cbfed1dd50278c6b06bead3d00ba0a88f9
  # bad: [daed2dbb7ea4d179e472396ce46377fe758d5faf] drm/i915: use the CPU and PCH transcoders on lpt_pch_enable
  git bisect bad daed2dbb7ea4d179e472396ce46377fe758d5faf
  # good: [df86b5765a48d5f557489577652bd6df145b0e1b] drm/savage: re-add busmaster enable, regression fix
  git bisect good df86b5765a48d5f557489577652bd6df145b0e1b
  # bad: [39df01cd6ce9f6dd755ace0030e2bebe75da7727] Merge branch 'drm-fixes-3.7' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
  git bisect bad 39df01cd6ce9f6dd755ace0030e2bebe75da7727

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

--GvXjxJ+pjyke8COw
Content-Type: application/x-xz
Content-Disposition: attachment; filename="nouveau-black-lcd.log.xz"
Content-Transfer-Encoding: base64

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
xf0AAdlUl8kCAGHmKLexxGf7AgAAAAAEWVo=

--GvXjxJ+pjyke8COw--
