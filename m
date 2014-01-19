Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaASHHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 02:07:49 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:24284 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbaASHHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 02:07:46 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Jan 2014 02:07:45 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al0GADV421IOAjao/2dsb2JhbABZgwuEC7g5gQUXdIJPBBEeHgQBGBEGBgIFFgQHAgsDAgECASckDQEFAgIXh2mndJwrF4EpjVaCdoFJAQOFK58xhV6Bb4FRKQ
Message-ID: <52DB7878.8000004@internode.on.net>
Date: Sun, 19 Jan 2014 17:32:16 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.2.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Anssi Hannula <anssi.hannula@iki.fi>,
        ALSA devel <alsa-devel@alsa-project.org>, xorg-driver-ati@lists.x.org,
        linux-kernel@vger.kernel.org
Subject: ALSA: hda - Fix possible races in HDMI driver - lockup on shutdown
 when radeon.audio=1 after using audacity
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have had reproducible lock-ups on shut-down (at the shutting down ALSA 
stage) of my AMD64 machine (Asus M3A78Pro motherboard, BIOS 1701 
01/27/2011, CPU AMD Athlon(tm) II X4 640 Processor) running the 64 bit 
Linux kernel more recent than 3.12 when *both* radeon.audio=1 was set 
and I had been running audacity 2.0.5. (iommu=noaperture is also set).

The problem was reproducible with the stock Debian kernel 
linux-image-3.13-rc6-amd64 version 3.13~rc6-1~exp1.

The machine is using an ATI/AMD 3850HD video card with a DVI cable to a 
DVI input on my monitor, and the default audio device is the 
motherboard's on-board audio device:

00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 
Azalia (Intel HDA)

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. 
[AMD/ATI] RV670 [Radeon HD 3690/3850]
01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] RV670/680 
HDMI Audio [Radeon HD 3690/3800 Series]

$ git bisect bad
cbbaa603a03cc46681e24d6b2804b62fde95a2af is the first bad commit
commit cbbaa603a03cc46681e24d6b2804b62fde95a2af
Author: Takashi Iwai <tiwai@suse.de>
Date:   Thu Oct 17 18:03:24 2013 +0200

     ALSA: hda - Fix possible races in HDMI driver

     Some per_pin fields and ELD contents might be changed dynamically in
     multiple ways where the concurrent accesses are still opened in the
     current code.  This patch fixes such possible races by using eld->lock
     in appropriate places.

     Reported-by: Anssi Hannula <anssi.hannula@iki.fi>
     Signed-off-by: Takashi Iwai <tiwai@suse.de>

:040000 040000 0c29281f82a3ebd9a704d481114f9cfcefea07c8 
d71fd101125cd29a628cb5e66c7ee4f56e28329b M      sound

When running audacity from the command line there was the following output:

ALSA lib pcm_dsnoop.c:618:(snd_pcm_dsnoop_open) unable to open slave
ALSA lib pcm_dmix.c:1022:(snd_pcm_dmix_open) unable to open slave
ALSA lib pcm.c:2239:(snd_pcm_open_noupdate) Unknown PCM cards.pcm.rear
ALSA lib pcm.c:2239:(snd_pcm_open_noupdate) Unknown PCM cards.pcm.center_lfe
ALSA lib pcm.c:2239:(snd_pcm_open_noupdate) Unknown PCM cards.pcm.side
ALSA lib pcm_dmix.c:1022:(snd_pcm_dmix_open) unable to open slave
Expression 'stream->playback.pcm' failed in 
'src/hostapi/alsa/pa_linux_alsa.c', line: 4611
Expression 'stream->playback.pcm' failed in 
'src/hostapi/alsa/pa_linux_alsa.c', line: 4611
Expression 'stream->playback.pcm' failed in 
'src/hostapi/alsa/pa_linux_alsa.c', line: 4611

I am happy to supply further information or run further tests to help in 
isolating the problem and verifying a solution.

Arthur.

