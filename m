Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaHEMie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:38:34 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:60323 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaHEMid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:38:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Aug 2014 14:38:20 +0200
From: Stefan Agner <stefan@agner.ch>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
In-Reply-To: <53E0A95E.8040502@pengutronix.de>
References: <cover.1405428166.git.stefan@agner.ch>
 <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch>
 <53C5398F.2000005@pengutronix.de>
 <1b8a8ca03b4a160027a79b722f697e25@agner.ch>
 <601adb6fe47279c115c1cc607365a00e@agner.ch>
 <53D25C9D.5080803@pengutronix.de>
 <e88108c655e2c16dc9cf6c4194547e73@agner.ch>
 <53D67A46.3060202@pengutronix.de>
 <b815c5c1f7faed334d1ed5370d51c180@agner.ch>
 <53D8DB3D.7030403@pengutronix.de>
 <cd33e1b365502ec0cb3b5bee6dc4fb61@agner.ch>
 <53DF9865.9060407@pengutronix.de>
 <0baf18a56e6cee86cc02e0d2f4ac4d9e@agner.ch>
 <53E0A95E.8040502@pengutronix.de>
Message-ID: <4e9d0d223af785f060103ad67c14272a@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-08-05 11:52, schrieb Marc Kleine-Budde:
> On 08/04/2014 06:01 PM, Stefan Agner wrote:
>> Am 2014-08-04 16:27, schrieb Marc Kleine-Budde:
>>> On 08/04/2014 03:43 PM, Stefan Agner wrote:
>>> [...]
>>>
>>>>> Thanks for the test, so far looks promising :) With this setup the other
>>>>> CAN node repeats the CAN frame until it's ACKed. Because there is no
>>>>> node with a compatible bitrate, there is no ACking CAN node.
>>>>>
>>>>> Can you add a third CAN node to the network. The second and third node
>>>>> should use the same bitrate, while your vf610 uses a different one. With
>>>>> the new setup it should take more than one frame until the vf610 goes
>>>>> into error warning and even more frames to error passive. This way we
>>>>> can see it the error warning interrupt is connected or not. The error
>>>>> counters should increase with each "wrong" bitrate frame it sees, you
>>>>> can check with:
>>>>>
>>>>>     ip -details link show can0
>>>>>
>>>>> The output looks like this:
>>>>>
>>>>>> 4: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN mode DEFAULT qlen 10
>>>>>>     link/can
>>>>>>     can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
>>>>>                               ^^^^^^^^^^^^^^^^^^^^^^
>>>>>>     bitrate 1000000 sample-point 0.750
>>>>>>     tq 125 prop-seg 2 phase-seg1 3 phase-seg2 2 sjw 1
>>>>>>     sja1000: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..64 brp-inc 1
>>>>>>     clock 8000000
>>>>>
>>>>> When one of the berr-counter crosses 96 (and stays below 128) a warning
>>>>> interrupt should be generated.
>>>>
>>>> Ok, created this setup, could successfully communicate with all three
>>>> nodes. I then set the Vybrid to half of the bitrate. When I send a frame
>>>> from Vybrid, the berr-counter tx immediately ends up at 128 and the
>>>> device is in ERROR-PASSIVE:
>>>
>>> This is expected.
>>>
>>>> root@colibri-vf:~# ip -details link show can1
>>>> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
>>>> mode DEFAULT group default qlen 10
>>>>     link/can  promiscuity 0
>>>>     can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
>>>>     bitrate 124990 sample-point 0.739
>>>>     tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
>>>>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>>>>     clock 83368421
>>>             ^^^^^^^^
>>>
>>> BTW: the can core has a really weird clock rate, have a look at the
>>> datasheet if you manage to route a 24 MHz clock (or another multiple of
>>> 8MHz) to the flexcan core. I had a quick glance at the datasheet, if I
>>> understand it correctly the Fast OSC clock runs with 24 MHz.
>>>
>>
>> This pinmux is actually part of the IPs CTRL register (see CLKSRC).
>> Currently this is set unconditionally to peripheral clock, which is on
>> my device 83.3 MHz (500MHz/6). This would be a bit bigger change. Just
>> thinking how to implement this.
> 
> Sigh! I've missed the fact, that this bit is _inside_ the CAN core
> (again). On the mx53 and imx6 this bit was obsolete and the clock was
> selected outside of the CAN core.
> 
>> Maybe we have to reference a third clock
>> "osc" and a device tree property fsl,can-clock-osc which one can choose
>> between "osc" and "per" what do you think?
> 
> Yes, but that's a different patch. I thought it would be as easy as on
> the mx53, where you just had to reconfigure the clock tree.
> 

Agreed.

>>>> root@colibri-vf:~# cansend can1 1F334455#1122334455667788
>>>> interface = can1, family = 29, type = 3, proto = 1
>>>> root@colibri-vf:~# [  818.886664] flexcan_irq, esr=00062242
>>>> [  818.890365] flexcan_irq, ctrl=1c3dac57
>>>>
>>>> root@colibri-vf:~# ip -details link show can1
>>>> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
>>>> mode DEFAULT group default qlen 10
>>>>     link/can  promiscuity 0
>>>>     can state ERROR-PASSIVE (berr-counter tx 128 rx 0) restart-ms 0
>>>>     bitrate 124990 sample-point 0.739
>>>>     tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
>>>>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>>>>     clock 83368421
>>>>
>>>>
>>>> When I send the frames from another device on the bus, I can see the rx
>>>> count incrementing by one on each frame I send. As you expected, the
>>>> device changes to ERROR-WARNING when crossing the 96 frame boundary:
>>>
>>> This is correct
>>>
>>
>> Just found out when using too high bitrate (500000 vs 125000), the error
>> counter immediately goes up to 128 (or even beyond) and ends up in
>> ERROR-PASSIVE:
> 
> Maybe there is a off-by-one error in the flexcan core, so that a rx
> error of 127 doesn't trigger an error passive interrupt.
> 
>> # ip -details link show can1
>> [  292.164820] flexcan_get_berr_counter, esr=00000000
>> [  292.169715] flexcan_get_berr_counter, esr=00040190
>> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
>> mode DEFAULT group default qlen 10
>>     link/can  promiscuity 0
>>     can state ERROR-PASSIVE (berr-counter tx 0 rx 135) restart-ms 0
>>     bitrate 298811 sample-point 0.777
>>     tq 371 prop-seg 3 phase-seg1 3 phase-seg2 2 sjw 1
>>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>>     clock 83368421
> 
> [...]
> 
>>>> However, once reaching 128, I don't get another interrupt and the device
>>>> stays in ERROR-WARNING:
>>>
>>> The contents of the esr reg would be interesting, especially the
>>> FLT_CONF part.
> 
>> root@vybridvf61-v11:~# [  222.221651] flexcan_irq, esr=0005050a
>> [  222.225349] flexcan_irq, ctrl=1c3dac57
> 
>> ip -details link show can1
>> [  223.791082] flexcan_get_berr_counter, esr=00000000
>> [  223.796246] flexcan_get_berr_counter, esr=00040180
>> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
>> mode DEFAULT group default qlen
>> 10
>>     link/can  promiscuity 0
>>     can state ERROR-WARNING (berr-counter tx 0 rx 96) restart-ms 0
>>     bitrate 124990 sample-point 0.739
>>     tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
>>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>>     clock 83368421
> 
>> root@vybridvf61-v11:~# ip -details link show can1
>> [  243.571175] flexcan_get_berr_counter, esr=00000000
>> [  243.576343] flexcan_get_berr_counter, esr=00040582
>> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
>> mode DEFAULT group default qlen
>> 10
>>     link/can  promiscuity 0
>>     can state ERROR-WARNING (berr-counter tx 0 rx 104) restart-ms 0
>>     bitrate 124990 sample-point 0.739
>>     tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
>>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>>     clock 83368421
>>
>> ...
>>
>> root@vybridvf61-v11:~# ip -details link show can1
>> [  299.831192] flexcan_get_berr_counter, esr=00000000
>> [  299.836358] flexcan_get_berr_counter, esr=00040582
>> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
>> mode DEFAULT group default qlen 10
>>     link/can  promiscuity 0
>>     can state ERROR-WARNING (berr-counter tx 0 rx 126) restart-ms 0
>>     bitrate 124990 sample-point 0.739
>>     tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
>>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>>     clock 83368421
>> root@vybridvf61-v11:~# ip -details link show can1
>> [  302.411025] flexcan_get_berr_counter, esr=00000000
>> [  302.416195] flexcan_get_berr_counter, esr=00040592
>> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
>> mode DEFAULT group default qlen 10
>>     link/can  promiscuity 0
>>     can state ERROR-WARNING (berr-counter tx 0 rx 128) restart-ms 0
>>     bitrate 124990 sample-point 0.739
>>     tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
>>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>>     clock 83368421
>>
>> The FLTCONF is in Error Passive, however the stack did not received that
>> information. I still have the printk in the interrupt, however I did not
>> get an interrupt here (while I get one when it switched to
>> ERROR-WARNING... But it looks like the ERRINT is still pending...
> 
> According to the datasheet the ERRINT indicates a bit error (bit 10...15
> is set), not the error passive state.
> 
> Marc

True, but fact is, I don't get a interrupt when the system switches from
ERROR-WARNING to ERROR-PASSIVE state. However, when I set berr-reporting
on, I get an interrupt (probably because of a change of bit 10...15),
but the state change is recognized:

ip -details link show can1
[ 2303.571656] flexcan_get_berr_counter, esr=00000000
[ 2303.576832] flexcan_get_berr_counter, esr=00040180
3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
mode DEFAULT group default qlen 10
    link/can  promiscuity 0 
    can <BERR-REPORTING> state ERROR-WARNING (berr-counter tx 0 rx 127)
restart-ms 0 
    bitrate 124990 sample-point 0.739 
    tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
    flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
    clock 83368421
root@vybridvf61-v11:~# [ 2307.023789] flexcan_irq, esr=0004051a
[ 2307.027490] flexcan_irq, ctrl=1c3dec57
ip -details link show can1
[ 2309.081840] flexcan_get_berr_counter, esr=00000000
[ 2309.087016] flexcan_get_berr_counter, esr=00040190
3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
mode DEFAULT group default qlen 10
    link/can  promiscuity 0 
    can <BERR-REPORTING> state ERROR-PASSIVE (berr-counter tx 0 rx 128)
restart-ms 0 
    bitrate 124990 sample-point 0.739 
    tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
    flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
    clock 83368421

It looks like, the FLTCONF state change itself doesn't lead to a
interrupt when the state changes to ERROR-PASSIVE. IMHO, this is also
not explicitly stated in the Vybrid RM (46.3.8).

What is the solution here? Force enabling ERR interrupt? The
FLEXCAN_HAS_BROKEN_ERR_STATE flag would be appropriate, however, this
was meant to work around the missing WRN_INT, which seems not to be the
case here...

--
Stefan

