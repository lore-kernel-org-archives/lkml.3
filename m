Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaH1VKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 17:10:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaH1VKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 17:10:48 -0400
Date: Thu, 28 Aug 2014 23:11:10 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Takashi Iwai <tiwai@suse.de>, Andreas Mohr <andi@lisas.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
Message-ID: <20140828211110.GA24519@suse.cz>
References: <20140820024638.GA25240@rhlx01.hs-esslingen.de>
 <20140820051815.GA1109@core.coreip.homeip.net>
 <s5hwqa3hetu.wl-tiwai@suse.de>
 <20140820063130.GA11226@core.coreip.homeip.net>
 <s5htx57hc89.wl-tiwai@suse.de>
 <s5h4mx6rshs.wl-tiwai@suse.de>
 <20140824050716.GA523@rhlx01.hs-esslingen.de>
 <s5hppfpt520.wl-tiwai@suse.de>
 <53FF8B2B.3050506@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FF8B2B.3050506@ladisch.de>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 10:03:55PM +0200, Clemens Ladisch wrote:
> Takashi Iwai wrote:
> > did anyone test the patch at all...?
> 
> Appears to work.  The ymfpci gameport seems to be somewhat unreliable:
> 
>  analog.c: 100 out of 17347 reads (0%) on pci0000:06:06.1/gameport0 failed
>  analog.c: 122 out of 1111 reads (10%) on pci0000:06:07.0/gameport0 failed

The analog.c gameport read routine is unreliable by design. 

The 558 chip is not an ADC, it's an one-shot timer from 1971. The analog
position of the joystick is measured by timing bit changes on the
gameport.

analog.c does that without disabling interrupts, as the read can take
several milliseconds. analog.c instead detects when an interrupt influenced
the measurement too much and retries.

The retries are counted and reported.

10% is a largeish number, but still something the analog.c driver can
cope with and give reliable results. 

> There is still some dependence of the CPU speed on the loop counts
> calculated by gameport_time(), but it's not very high; the following are
> for 3200 and 800 MHz, 5 times each:
> 
>  gameport gameport7: EMU10K1 is pci0000:06:06.1/gameport0, io 0xe480, speed 651kHz
>  gameport gameport8: EMU10K1 is pci0000:06:06.1/gameport0, io 0xe480, speed 651kHz
>  gameport gameport9: EMU10K1 is pci0000:06:06.1/gameport0, io 0xe480, speed 651kHz
>  gameport gameport10: EMU10K1 is pci0000:06:06.1/gameport0, io 0xe480, speed 651kHz
>  gameport gameport11: EMU10K1 is pci0000:06:06.1/gameport0, io 0xe480, speed 651kHz
>  gameport gameport12: EMU10K1 is pci0000:06:06.1/gameport0, io 0xe480, speed 612kHz
>  gameport gameport13: EMU10K1 is pci0000:06:06.1/gameport0, io 0xe480, speed 612kHz
>  gameport gameport14: EMU10K1 is pci0000:06:06.1/gameport0, io 0xe480, speed 612kHz
>  gameport gameport15: EMU10K1 is pci0000:06:06.1/gameport0, io 0xe480, speed 611kHz
>  gameport gameport16: EMU10K1 is pci0000:06:06.1/gameport0, io 0xe480, speed 612kHz

The gameport speed is speed of the i/o to the port. It may change as
frequencies in the system change. It's used for timeouts on digital
gameport protocols only and thus a variation of less than 20% shouldn't cause
trouble.

The analog.c driver uses its own timing calibration to make the
analog_cooked_read() reliable even when the speed of the i/o operations
changes.

What is important is that the GET_TIME() macro is fast (0.1 usec or
less), precise (sub-microsecond resolution) and reliable. Digital
protocols also rely on udelay() and mdelay() waiting precisely for the
amount of time specified.

-- 
Vojtech Pavlik
Director SuSE Labs
