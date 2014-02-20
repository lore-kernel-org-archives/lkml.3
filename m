Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbaBTSQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:16:45 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35582 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753884AbaBTSQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:16:22 -0500
Message-ID: <53064672.3000807@hurleysoftware.com>
Date: Thu, 20 Feb 2014 13:16:18 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: locking changes in tty broke low latency feature
References: <20140219230623.736E8406062@ip-64-139-1-69.sjc.megapath.net> <53056E99.9070900@hurleysoftware.com>
In-Reply-To: <53056E99.9070900@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 09:55 PM, Peter Hurley wrote:
> On 02/19/2014 06:06 PM, Hal Murray wrote:
>>> Can you give me an idea of your device's average and minimum required
>>> latency (please be specific)?  Is your target arch x86 [so I can evaluate the
>>> the impact of bus-locked instructions relative to your expected]?
>>
>> The code I'm familiar with is ntpd and gpsd.  They run on almost any hardware
>> or OS and talk to a wide collection of devices.
>>
>> There is no hard requirement for latency.  They just work better with lower
>> latency.  The lower the better.
>>
>> People gripe about the latency due to USB polling which is about a ms.
>
> Have you tried 3.12+ without low_latency? I ripped out a lot of locks
> from 3.12+ so it's possible it already meets your requirements.

Using Alan's idea to mock up a latency test, I threw together a test jig
using two computers running 3.14-rc1 and my fwserial driver (modified to
not aggregrate writes) in raw mode where the target does this:

         while (1) {
                 read 64 bytes
                 compare to pattern
                 write 1 byte response
         }

and the sender does this:

         for (i = 0; i < 2000; i++) {
                 write 64-byte pattern
                 read 1 byte response
         }

Sender completes 2000 loops in 160ms total run time;
that's 80us average per complete round-trip.

Here's a snapshot of a function trace for 1 complete round trip at the target:

           <idle>-0     [007] d.h1  4856.935561: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000010 AR_req
           <idle>-0     [007] ..s1  4856.935566: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AR spd 2 tl 2a, ffc1 -> ffc0, ack_complete, BW req, 800000000004 40,0
           <idle>-0     [007] ..s1  4856.935567: tty_flip_buffer_push <-fwtty_port_handler
      kworker/7:0-6872  [007] ....  4856.935571: flush_to_ldisc <-process_one_work
  tty-latency-tes-6891  [003] ....  4856.935578: n_tty_write <-tty_write
           <idle>-0     [003] d.h1  4856.935591: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000001 AT_req
           <idle>-0     [003] ..s1  4856.935594: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AT spd 2 tl 12, ffc0 -> ffc1, ack_complete, BW req, 800000000004 1,0

The same snapshot explained:

The firewire controller IRQ for received packet in rx dma fifo:

           <idle>-0     [007] d.h1  4856.935561: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000010 AR_req

The firewire-ohci driver rx fifo tasklet running:

           <idle>-0     [007] ..s1  4856.935566: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AR spd 2 tl 2a, ffc1 -> ffc0, ack_complete, BW req, 800000000004 40,0

The fwserial driver schdeduling the rx data:

           <idle>-0     [007] ..s1  4856.935567: tty_flip_buffer_push <-fwtty_port_handler

The tty buffer input worker running:

      kworker/7:0-6872  [007] ....  4856.935571: flush_to_ldisc <-process_one_work

The test application having received the data, compared it,
and writing the 1-byte response:

  tty-latency-tes-6891  [003] ....  4856.935578: n_tty_write <-tty_write

The firewire controller IRQ for running the tx dma fifo:

           <idle>-0     [003] d.h1  4856.935591: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000001 AT_req

The firewire-ohci driver tx fifo tasklet acknowledging the sender
of the 64-byte packet has received the 1-byte response:

           <idle>-0     [003] ..s1  4856.935594: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AT spd 2 tl 12, ffc0 -> ffc1, ack_complete, BW req, 800000000004 1,0


... trace continued for another 4x 64-byte reads and 1 byte responses:

           <idle>-0     [007] d.h1  4856.935646: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000010 AR_req
           <idle>-0     [007] ..s1  4856.935650: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AR spd 2 tl 2b, ffc1 -> ffc0, ack_complete, BW req, 800000000004 40,0
           <idle>-0     [007] ..s1  4856.935651: tty_flip_buffer_push <-fwtty_port_handler
      kworker/7:0-6872  [007] ....  4856.935655: flush_to_ldisc <-process_one_work
  tty-latency-tes-6891  [003] ....  4856.935662: n_tty_write <-tty_write
           <idle>-0     [003] d.h1  4856.935674: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000001 AT_req
           <idle>-0     [003] ..s1  4856.935678: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AT spd 2 tl 13, ffc0 -> ffc1, ack_complete, BW req, 800000000004 1,0
           <idle>-0     [007] d.h1  4856.935729: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000010 AR_req
           <idle>-0     [007] ..s1  4856.935733: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AR spd 2 tl 2c, ffc1 -> ffc0, ack_complete, BW req, 800000000004 40,0
           <idle>-0     [007] ..s1  4856.935734: tty_flip_buffer_push <-fwtty_port_handler
      kworker/7:0-6872  [007] ....  4856.935738: flush_to_ldisc <-process_one_work
  tty-latency-tes-6891  [003] ....  4856.935746: n_tty_write <-tty_write
           <idle>-0     [003] d.h1  4856.935758: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000001 AT_req
           <idle>-0     [003] ..s1  4856.935762: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AT spd 2 tl 14, ffc0 -> ffc1, ack_complete, BW req, 800000000004 1,0
           <idle>-0     [007] d.h1  4856.935812: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000010 AR_req
           <idle>-0     [007] ..s1  4856.935816: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AR spd 2 tl 2d, ffc1 -> ffc0, ack_complete, BW req, 800000000004 40,0
           <idle>-0     [007] ..s1  4856.935817: tty_flip_buffer_push <-fwtty_port_handler
      kworker/7:0-6872  [007] ....  4856.935821: flush_to_ldisc <-process_one_work
  tty-latency-tes-6891  [003] ....  4856.935828: n_tty_write <-tty_write
           <idle>-0     [003] d.h1  4856.935844: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000001 AT_req
           <idle>-0     [003] ..s1  4856.935847: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AT spd 2 tl 15, ffc0 -> ffc1, ack_complete, BW req, 800000000004 1,0
           <idle>-0     [007] d.h1  4856.935895: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000010 AR_req
           <idle>-0     [007] ..s1  4856.935899: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AR spd 2 tl 2e, ffc1 -> ffc0, ack_complete, BW req, 800000000004 40,0
           <idle>-0     [007] ..s1  4856.935900: tty_flip_buffer_push <-fwtty_port_handler
      kworker/7:0-6872  [007] ....  4856.935904: flush_to_ldisc <-process_one_work
  tty-latency-tes-6891  [003] ....  4856.935911: n_tty_write <-tty_write
           <idle>-0     [003] d.h1  4856.935923: irq_handler: firewire_ohci 0000:07:06.0: IRQ 00000001 AT_req
           <idle>-0     [003] ..s1  4856.935927: log_ar_at_event.isra.33: firewire_ohci 0000:07:06.0: AT spd 2 tl 16, ffc0 -> ffc1, ack_complete, BW req, 800000000004 1,0


I think this shows that low_latency is unnecessary and should
just be removed/ignored by the tty core.

Let me know if you want my test jig (or fwserial patch). The test
was run on a 10-year old Vaio single-core laptop as the sender and
6-year old dual socket xeon workstation (so nothing super tricked
out for this test).


Regards,
Peter Hurley
