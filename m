Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3BQHpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 02:45:53 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52730 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab3BQHpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 02:45:52 -0500
Subject: Re: Stupid user with user-space questions, matrix LED driving with
 user space code only.
From: anish kumar <anish198519851985@gmail.com>
To: jon@jonshouse.co.uk
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1361025476.4271.36.camel@jonspc>
References: <1361025476.4271.36.camel@jonspc>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Feb 2013 11:52:14 +0530
Message-ID: <1361082134.16206.24.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-16 at 14:37 +0000, Jonathan Andrews wrote:
> I hope this is the correct place, I expect to get abused.
> 
> I'm trying to do a mostly soft real-time task with a very small hard
> real time element.
> 
> I've written some code to drive matrix LED signs using a Raspberry Pi.
> 
> Source here:
> http://www.jonshouse.co.uk/download/128x32_red_green_led_sign.tar.gz
> 
> 
> Since I last used linux you kernel people have fiddled with it yet
> again:
> 
> Linux raspberrypi 3.6.11+ #375 PREEMPT Tue Feb 12 01:41:07 GMT 2013 armv6l GNU/Linux
> 
> I'm scanning an LED display to produce a 2 bits per pixel image.  The
> code simply alters the amount of time any one LED is on, for higher
> intensity pixels the true amount of "on" time is non critical.
> 
> I've marked my process as realtime.
> 
> My problem is that for very dim pixels the amount of "on" time for the
> LED  is very critical, this is only a fraction of a percent of the total
> processes timeslice.
> It scans 100 frames of brightest, 100 frames of brighter and 1 frame of
> dim pixels for example, so 200:1 ratio of don't care much /vs care a lot
> timing !
> 
> To this end I'm using a hard coded small delay instead of usleep for the
> tight timing section:
> 
> // Delay for ARM without yeilding to schedular, roughly calibrated but better than usleep for short delays
> inline usleep_arm_hard(int usecs)
> {
>         long int outer,inner;
> 
>         for (outer=0;outer<usecs;outer++)
>         {
>                 for (inner=0;inner<300;inner++)
>                         asm("andeq r0, r0, r0");		// NOP
>         }
> }
> 
> The dim pixel code is timing critical (but as I said only a tiny
> fraction of the total CPU usage). What I need to do is grab the CPU and
> prevent any context switch (IRQ or PREEMPT) for this period.
why you want to do this?
> 
> I cant find a user space mechanism other than changing the kernel to
> disable preemtion ? No simple /proc switch to turn it on/off ? If not
> why - I cant be the only one who wants to toggle preemption off without
> swapping kernels ?
you can't disable pre-emption from user space.
> 
> The other issue is that of IRQs, my dim pixels on the display seem to
> flash brighter from time to time, this I assume is partly preemption
> (maybe possibly) and partly IRQ handling (more likely) allowing context
> switches or just taking a while on slow hardware.
> 
> I need only a tiny fraction of the runtime to be hard real time, on
> intel in the past i've simply disabled IRQs briefly with some inline
> assembler. 
you shouldn't fiddle with irq's from user space but...
> The Raspberry Pi board would also probably survive this as the only
> active peripheral is ethenet, I suspect couple of missed IRQs would not
> matter as once IRQs are re-enabled the USB/ethernet hardware will likely
> have the data or it can be re-tried.  Does anyone have an example of a
> dirty hack along these lines they can share with me :-) 

> Do I have any simple mechanism available to disable (or defer) kernel
> IRQ handling briefly from user space code, I suspect not but no harm in
> asking ?
Use any sysfs to disable/enable the irq. This approach is very bad but
as you said you wanted a hack.
> Thanks,
> Jon
> 
> PS I'm not a kernel hacker - yes I know I could write a proper driver
> for the task but I lack any real skill and the required time !
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


