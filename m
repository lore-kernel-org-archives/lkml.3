Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbaAHUnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:43:08 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60632 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaAHUnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:43:04 -0500
Date: Wed, 8 Jan 2014 21:43:02 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Daniel Mack <zonque@gmail.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: Re: snd-usb: "delay: estimated 0, actual 352"
Message-ID: <20140108204302.GA1556@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hharbxlxf.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can very well believe that bogus triggering of this spewing message
is now fixed by your patch (thanks!), but:

I get the very same message here on OpenWrt's 3.10.24
(verified to be properly containing your patch!),
when playing usb-audio on TL-WDR3600 MIPS via MPD mp3 streaming, *and then*:

Execute

    modprobe zram num_devices=4

    # Set disksize of 16MB for /dev/zram0
    echo $((16*1024*1024)) > /sys/block/zram0/disksize

    mkswap /dev/zram0

    # For zram, use higher prio than for traditional swap devices.
    swapon -p 100 /dev/zram0

Executing these commands will cause the status/error message to
loop again (when doing so manually, it's directly after having executed
the swapon command).

IOW: messages did not appear, then mkswap, then infinite loop, then run
    mpd stop
then they're gone again.

Sample:

[183532.990000] delay: estimated 240, actual 0
[183533.000000] delay: estimated 240, actual 0
[183533.010000] delay: estimated 432, actual 288
[183533.020000] delay: estimated 528, actual 288
[183533.020000] delay: estimated 528, actual 288
[183533.030000] delay: estimated 288, actual 48
[183533.040000] delay: estimated 288, actual 48
[183533.050000] delay: estimated 432, actual 288
[183533.050000] delay: estimated 576, actual 288
[183533.060000] delay: estimated 528, actual 288


My running theory is that that mkswap causes a rather insurmountable
temporary lockup of relevant system processing resources,
which causes audio handling to get out of lock-step, infinitely
(*that* one really shouldn't happen, right!?),
not to be resolved until finally playback gets stopped again.

That message is discussed at
"MPD filling kern.log with "delay: estimated 0, actual xxx""
  http://www.raspberrypi.org/phpBB3/viewtopic.php?f=28&t=15204
as well, but I don't know whether that one is pre- or post-patch ;)
(as opposed to my case, which definitely is post-patch)


Note also that I'm experiencing rather weirdly crackling sound when using
    aplay /usr/share/sounds/alsa/Front_Center.wav
, but only *every other time* that I'm executing this command.
But in this aplay case this delay message does *not* get produced,
so I suspect that that crackling is a different issue.

Wellll... perhaps not quite:
snd-usb-audio param nrpacks=1 (as favourably mentioned by the URL above)
does solve both the mkswap looping error
and the aplay crackling (and solves arec crackling / echoes / corruption, too!).
However I guess that nrpacks=1 is not something that you would want to
have in an optimally performing system...


usb-audio running on a bus-powered USB2 hub connected to USB2 router port,
with certain other devices producing activity (FTDI RS232, X10 lirc remote).

Hmmmm (any interesting thoughts?),

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
