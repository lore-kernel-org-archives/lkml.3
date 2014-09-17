Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbaIQTXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:23:42 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54618 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450AbaIQTXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:23:40 -0400
Date: Wed, 17 Sep 2014 21:23:37 +0200
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>, Andreas Mohr <andi@lisas.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: joystick - Use ktime for measuring timing
Message-ID: <20140917192337.GA27319@rhlx01.hs-esslingen.de>
References: <s5h8ulrzcwy.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h8ulrzcwy.wl-tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 10, 2014 at 05:57:17PM +0200, Takashi Iwai wrote:
> The current codes in gameport and analog joystick drivers for the time
> accounting have a long-standing problem when the system is running
> with CPU freq; since the timing is measured via TSC or sample counter,
> the calculation isn't reliable.

Thank you very much for having followed through on this!
(somehow you never seem to disappoint me :)

While working on testing this and doing various gameport/soundcard modifications,
I'm afraid I have seen the following checkpatch.pl (of v3.16) warnings:

WARNING: Missing a blank line after declarations
#164: FILE: drivers/input/joystick/analog.c:192:
+               unsigned int x;
+               GET_TIME(x);

WARNING: line over 80 characters
#224: FILE: drivers/input/joystick/analog.c:301:
+                               port->axes[j] = (delta(start, time[i]) << ANALOG_FUZZ_BITS) / port->loop;


BTW the commit as-is will not be compatible with v3.16
since there's no ktime_get_ns() there yet
and (to add insult to injury) even the #include header files have changed, too.

That's a bit of a pity since I just had intended to say
that it's a very good idea
to release a quick(&dirty) initial timing hotfix for gameport handling
*prior* to possibly doing any subsequent less-related gameport cleanup commits,
since the quick initial timing hotfix would be very prominent -stable material,
except it... ain't so (--> life sucks :-).

So, for -stable reasons it might be very worthwhile
to add some compat code to the analog.c patch -
I am currently using the following compat fix (on v3.16):

--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
@@ -36,7 +36,14 @@
 #include <linux/gameport.h>
 #include <linux/jiffies.h>
 #include <linux/timex.h>
-#include <linux/timekeeping.h>
+//#include <linux/timekeeping.h>
+#include <linux/hrtimer.h>
+
+static inline u64 ktime_get_ns(void)
+{
+       return ktime_to_ns(ktime_get());
+}
+


(which obviously isn't fit for purpose yet
since you'd need a versioned #include conditional,
and the name of this function when unconditionally added
is in direct conflict with the same-name > v3.16 one)


So, should that commit be improved
to have a simple versioning check
in order to be fully -stable deployable,
or would -stable be handled differently anyway?
(I'll now have these updates and checkpatch.pl stuff
maintained in a FIXUP commit locally)

So much for a quick status update
(I'll be rebooting into 3.16 now - my last kernel build was as low as 3.11.x even, WOW).

Thanks,

Andreas Mohr
