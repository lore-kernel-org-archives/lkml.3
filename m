Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaDGSjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:39:01 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:63771 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbaDGSi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <52CAB05F.4010303@hartkopp.net>
References: <CANGgnMbszHzYe9pF2C6wag4MY_PfBG2qrMCC=rMmQnb-jyXXXw@mail.gmail.com>
	<52CAB05F.4010303@hartkopp.net>
Date: Mon, 7 Apr 2014 11:38:58 -0700
Message-ID: <CANGgnMZZu6tX0LyK4mQaYhixY9uhbQYee7XO5_HtNfT0REPghA@mail.gmail.com>
Subject: Re: [PATCH] genirq: Sanitize spurious interrupt detection of threaded irqs
From: Austin Schuh <austin@peloton-tech.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Did anything come of this patch?  Both Oliver and I have found that it
fixes real problems.  I have multiple machines which have been running
with the patch since December with no ill effects.

Thanks,
  Austin

On Mon, Jan 6, 2014 at 5:32 AM, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> Hi Thomas,
>
> I just wanted to add my
>
> Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
>
> In my setup with Core i7 and 20 CAN busses SJA1000 PCIe the problem
> disappeared with the discussed patch with the -rt kernel.
>
> The system was running at full CAN bus load over the weekend more than 72
> hours of operation without problems:
>
>            CPU0       CPU1       CPU2       CPU3
>   0:         40          0          0          0   IO-APIC-edge      timer
>   1:          1          0          0          0   IO-APIC-edge      i8042
>   8:          0          0          1          0   IO-APIC-edge      rtc0
>   9:         42         45         45         42   IO-APIC-fasteoi   acpi
>  16:          9          8          8          8   IO-APIC-fasteoi   ahci, ehci_hcd:usb1, can4, can5, can6, can7
>  17:  441468642  443275488  443609061  441436145   IO-APIC-fasteoi   can8, can10, can11, can9
>  18:  441975412  438811422  437317802  441209092   IO-APIC-fasteoi   can12, can13, can14, can15
>  19:  427310388  428661677  429813687  428095739   IO-APIC-fasteoi   can0, can1, can2, can3, can16, can17, can18, can19
> (..)
>
> Before the having the patch, it lasted 1 minutes to 1.5 hours (usually ~3
> minutes) until the irq was killed due to the spurious detection using Linux
> 3.10.11-rt (Debian linux-image-3.10-0.bpo.3-rt-686-pae).
>
> I also tested the patch on different latest 3.13-rc5+ (non-rt) kernels for two
> weeks now without problems.
>
> If you want me to test an improved version (as Austin suggested below) please
> send a patch.
>
> Best regards,
> Oliver
>
> On 23.12.2013 20:25, Austin Schuh wrote:
>> Hi Thomas,
>>
>> Did anything happen with your patch to note_interrupt, originally
>> posted on May 8th of 2013?  (https://lkml.org/lkml/2013/3/7/222)
>>
>> I am seeing an issue on a machine right now running a
>> config-preempt-rt kernel and a SJA1000 CAN card from PEAK.  It works
>> for ~1 day, and then proceeds to die with a "Disabling IRQ #18"
>> message.  I posted on the Linux CAN mailing list, and Oliver Hartkopp
>> was able to reproduce the issue only on a realtime kernel.  A function
>> trace ending when the IRQ was disabled shows that note_interrupt is
>> being called regularly from the IRQ handler threads, and one of the
>> threads is doing work (and therefore calling note_interrupt with
>> IRQ_HANDLED).
>>
>> Oliver Hartkopp and I ran tests over the weekend on numerous machines
>> and verified that the patch that you proposed fixes the problem.  We
>> think that the race condition that Till reported is causing the
>> problem here.
>>
>> In reply to the comment about using the upper bit of
>> threads_handled_last for holding the SPURIOUS_DEFERRED flag, while
>> that may still be an over-optimization, the code should still work.
>> All comparisons are done with the bit set, which just makes it a 31
>> bit counter.  It will take 8 more days for the counter to overflow on
>> my machine, so I won't know for certain until then.
>>
>> My only concern is that there may still be a small race condition with
>> this new code.  If the interrupt handler thread is running at a
>> realtime priority, but lower than another task, it may not get run
>> until a large number of IRQs get triggered, and then process them
>> quickly.  With your new handler code, this would be counted as one
>> single handled interrupt.  With the current constants, this is only a
>> problem if more than 1000 calls to the handler happen between IRQs.  I
>> starved my card's irq threads by running 4 tasks at a higher realtime
>> priority than the handler threads, and saw the number of unhandled
>> IRQs jump from 1/100000 to 3/100000, so that problem may not show up
>> in practice.
>>
>> Austin Schuh
>>
>> Tested-by: Austin Schuh <austin@peloton-tech.com>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-can" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
