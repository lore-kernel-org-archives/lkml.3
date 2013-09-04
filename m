Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077Ab3IDHhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:37:04 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:51217 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab3IDHhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:37:02 -0400
MIME-Version: 1.0
Date: Wed, 4 Sep 2013 09:37:00 +0200
Message-ID: <CAEk6gTDzhO=2uij-Yps00SW5vJLoeeiixwgUGw9rc=51W+Ls_A@mail.gmail.com>
Subject: HW timers question (clocksource vs event)
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I'd like to install one timer that provokes IRQ on timeout to measure
IRQ latencies. I can see that in dw_apb_timer.c Linux driver that
there is clocksource and event type of timers.


Can someone please explain me what is really the difference between clocksource
and event type of timers? If I'd like to produce an interrupt every
100mS which one should be used?

Based on your instructions I have added test_timer to dw_apb_timer_of.c :

static void __init timer_init(void)
{
struct device_node *event_timer, *source_timer, *test_timer;

event_timer = of_find_matching_node(NULL, osctimer_ids);
if (!event_timer)
panic("No timer for clockevent");
add_clockevent(event_timer);

source_timer = of_find_matching_node(NULL, sptimer_ids);
if (!source_timer)
panic("No timer for clocksource");
add_clocksource(source_timer);

    //test_timer = of_find_matching_node(source_timer, sptimer_ids);
 test_timer = of_find_node_by_path("/soc/timer1@ffc09000");
if (!test_timer)
panic("test_TIMER: No timer for clockevent");
add_clockevent(test_timer);

of_node_put(event_timer);
of_node_put(source_timer);
    of_node_put(test_timer);

init_sched_clock();
}

I can now see the timer1 when I do cat proc/interrupts:

root@socfpga_cyclone5:~# cat /proc/interrupts
           CPU0       CPU1
525:       2242       2252       GIC  twd
648:         19          0       GIC  eth0
653:          0          0       GIC  dwc_otg, dwc_otg_pcd, dwc_otg_hcd:usb1
656:          0          0       GIC  dwc_otg, dwc_otg_pcd, dwc_otg_hcd:usb2
667:      54610          0       GIC  dw-mci
679:          0          0       GIC  ff705000.spi
682:          0          0       GIC  dw_spi0
684:          0          0       GIC  dw_spi1
686:          6          0       GIC  ffc04000.i2c
687:          0          0       GIC  ffc05000.i2c
690:        839          0       GIC  serial
696:          0          0       GIC  timer1
697:          9          0       GIC  timer2
IPI0:          0          0  CPU wakeup interrupts
IPI1:          0          0  Timer broadcast interrupts
IPI2:       1117       1139  Rescheduling interrupts
IPI3:          0          0  Function call interrupts
IPI4:          2          1  Single function call interrupts
IPI5:          0          0  CPU stop interrupts
Err:          0


However, it provokes 0 interruptions. Looks like it is not enabled,
although enabling procedure is same like for timer2.

I tried then initializing it to CPU1, this did not help neither.
I tried defining it as a clocksource - then it was not visible at all.

I have questions at this point - how to enable timer1 to start
periodically provoking interrupt?

Thanks and best regards,
Drasko
