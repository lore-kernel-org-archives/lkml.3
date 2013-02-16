Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3BPOuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 09:50:54 -0500
Received: from jonshouse.co.uk ([91.84.151.33]:53026 "EHLO
	mail.jonshouse.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3BPOux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 09:50:53 -0500
X-Greylist: delayed 785 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Feb 2013 09:50:52 EST
Subject: Stupid user with user-space questions, matrix LED driving with
 user space code only.
From: Jonathan Andrews <jon@jonshouse.co.uk>
Reply-To: jon@jonshouse.co.uk
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Feb 2013 14:37:56 +0000
Message-ID: <1361025476.4271.36.camel@jonspc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope this is the correct place, I expect to get abused.

I'm trying to do a mostly soft real-time task with a very small hard
real time element.

I've written some code to drive matrix LED signs using a Raspberry Pi.

Source here:
http://www.jonshouse.co.uk/download/128x32_red_green_led_sign.tar.gz


Since I last used linux you kernel people have fiddled with it yet
again:

Linux raspberrypi 3.6.11+ #375 PREEMPT Tue Feb 12 01:41:07 GMT 2013 armv6l GNU/Linux

I'm scanning an LED display to produce a 2 bits per pixel image.  The
code simply alters the amount of time any one LED is on, for higher
intensity pixels the true amount of "on" time is non critical.

I've marked my process as realtime.

My problem is that for very dim pixels the amount of "on" time for the
LED  is very critical, this is only a fraction of a percent of the total
processes timeslice.
It scans 100 frames of brightest, 100 frames of brighter and 1 frame of
dim pixels for example, so 200:1 ratio of don't care much /vs care a lot
timing !

To this end I'm using a hard coded small delay instead of usleep for the
tight timing section:

// Delay for ARM without yeilding to schedular, roughly calibrated but better than usleep for short delays
inline usleep_arm_hard(int usecs)
{
        long int outer,inner;

        for (outer=0;outer<usecs;outer++)
        {
                for (inner=0;inner<300;inner++)
                        asm("andeq r0, r0, r0");		// NOP
        }
}

The dim pixel code is timing critical (but as I said only a tiny
fraction of the total CPU usage). What I need to do is grab the CPU and
prevent any context switch (IRQ or PREEMPT) for this period.

I cant find a user space mechanism other than changing the kernel to
disable preemtion ? No simple /proc switch to turn it on/off ? If not
why - I cant be the only one who wants to toggle preemption off without
swapping kernels ?

The other issue is that of IRQs, my dim pixels on the display seem to
flash brighter from time to time, this I assume is partly preemption
(maybe possibly) and partly IRQ handling (more likely) allowing context
switches or just taking a while on slow hardware.

I need only a tiny fraction of the runtime to be hard real time, on
intel in the past i've simply disabled IRQs briefly with some inline
assembler.  
The Raspberry Pi board would also probably survive this as the only
active peripheral is ethenet, I suspect couple of missed IRQs would not
matter as once IRQs are re-enabled the USB/ethernet hardware will likely
have the data or it can be re-tried.  Does anyone have an example of a
dirty hack along these lines they can share with me :-) 

Do I have any simple mechanism available to disable (or defer) kernel
IRQ handling briefly from user space code, I suspect not but no harm in
asking ?

Thanks,
Jon

PS I'm not a kernel hacker - yes I know I could write a proper driver
for the task but I lack any real skill and the required time !



