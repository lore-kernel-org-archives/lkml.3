Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaHDNnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:43:17 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:35174 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaHDNnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:43:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Aug 2014 15:43:06 +0200
From: Stefan Agner <stefan@agner.ch>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
In-Reply-To: <53D8DB3D.7030403@pengutronix.de>
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
Message-ID: <cd33e1b365502ec0cb3b5bee6dc4fb61@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-07-30 13:47, schrieb Marc Kleine-Budde:
> On 07/29/2014 09:29 AM, Stefan Agner wrote:
>> Am 2014-07-28 18:28, schrieb Marc Kleine-Budde:
>>> On 07/28/2014 06:20 PM, Stefan Agner wrote:
>>>> I'm not sure whether you really want to keep the FLEXCAN_CTRL_ERR_STATE
>>>> commented out...
>>>
>>> No, please remove this change and redo the test.
>>>
>>
>> Ok, removed that change and did the tests again:
>>
>> == Wrong Bitrate test
>>
>> [  146.485022] flexcan 40020000.flexcan can0: bitrate error 0.7%
>> [  148.401793] flexcan 40020000.flexcan can0: writing ctrl=0x17092001
>> [  148.408263] flexcan 40020000.flexcan can0: flexcan_set_bittiming:
>> mcr=0x5980000f ctrl=0x17092001
>> [  148.408298] flexcan 40020000.flexcan can0: flexcan_chip_start:
>> writing mcr=0x79a20208
>> [  148.408328] flexcan 40020000.flexcan can0: flexcan_chip_start:
>> writing ctrl=0x1709ac51
>> [  148.414373] flexcan 40020000.flexcan can0: flexcan_chip_start:
>> reading mcr=0x60a20208 ctrl=0x1709ac51
>> ^---- Initialization
>> [  152.968685] flexcan_irq, esr=00040080
>> [  152.972386] flexcan_irq, ctrl=1709ac51
>> [  155.488623] flexcan_irq, esr=00040080
>> [  155.492326] flexcan_irq, ctrl=1709ac51
>> ^---- Two messages with right bitrate
>> [  171.014124] flexcan_irq, esr=00058d0a
>> [  171.017823] flexcan_irq, ctrl=1709ac51
>> ^---- One message with wrong bitrate
>> [  171.021631] flexcan 40020000.flexcan can0: Error Warning IRQ
>> [  171.021660] flexcan 40020000.flexcan can0: Error Passive IRQ
> 
> Thanks for the test, so far looks promising :) With this setup the other
> CAN node repeats the CAN frame until it's ACKed. Because there is no
> node with a compatible bitrate, there is no ACking CAN node.
> 
> Can you add a third CAN node to the network. The second and third node
> should use the same bitrate, while your vf610 uses a different one. With
> the new setup it should take more than one frame until the vf610 goes
> into error warning and even more frames to error passive. This way we
> can see it the error warning interrupt is connected or not. The error
> counters should increase with each "wrong" bitrate frame it sees, you
> can check with:
> 
>     ip -details link show can0
> 
> The output looks like this:
> 
>> 4: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN mode DEFAULT qlen 10
>>     link/can
>>     can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
>                               ^^^^^^^^^^^^^^^^^^^^^^
>>     bitrate 1000000 sample-point 0.750
>>     tq 125 prop-seg 2 phase-seg1 3 phase-seg2 2 sjw 1
>>     sja1000: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..64 brp-inc 1
>>     clock 8000000
> 
> When one of the berr-counter crosses 96 (and stays below 128) a warning
> interrupt should be generated.

Ok, created this setup, could successfully communicate with all three
nodes. I then set the Vybrid to half of the bitrate. When I send a frame
from Vybrid, the berr-counter tx immediately ends up at 128 and the
device is in ERROR-PASSIVE:

root@colibri-vf:~# ip -details link show can1
3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
mode DEFAULT group default qlen 10
    link/can  promiscuity 0 
    can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0 
    bitrate 124990 sample-point 0.739 
    tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
    flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
    clock 83368421
root@colibri-vf:~# cansend can1 1F334455#1122334455667788
interface = can1, family = 29, type = 3, proto = 1
root@colibri-vf:~# [  818.886664] flexcan_irq, esr=00062242
[  818.890365] flexcan_irq, ctrl=1c3dac57

root@colibri-vf:~# ip -details link show can1
3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
mode DEFAULT group default qlen 10
    link/can  promiscuity 0 
    can state ERROR-PASSIVE (berr-counter tx 128 rx 0) restart-ms 0 
    bitrate 124990 sample-point 0.739 
    tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
    flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
    clock 83368421


When I send the frames from another device on the bus, I can see the rx
count incrementing by one on each frame I send. As you expected, the
device changes to ERROR-WARNING when crossing the 96 frame boundary:

root@colibri-vf:~# ip -details link show can1
3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
mode DEFAULT group default qlen 10
    link/can  promiscuity 0 
    can state ERROR-ACTIVE (berr-counter tx 0 rx 92) restart-ms 0 
    bitrate 124990 sample-point 0.739 
    tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
    flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
    clock 83368421
root@colibri-vf:~# [  448.331150] flexcan_irq, esr=0005050a
[  448.334851] flexcan_irq, ctrl=1c3dac57
ip -details link show can1
3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
mode DEFAULT group default qlen 10
    link/can  promiscuity 0 
    can state ERROR-WARNING (berr-counter tx 0 rx 102) restart-ms 0 
    bitrate 124990 sample-point 0.739 
    tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
    flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
    clock 83368421

However, once reaching 128, I don't get another interrupt and the device
stays in ERROR-WARNING:

3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN
mode DEFAULT group default qlen 10
    link/can  promiscuity 0 
    can state ERROR-WARNING (berr-counter tx 0 rx 128) restart-ms 0 
    bitrate 124990 sample-point 0.739 
    tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
    flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
    clock 83368421

Is this the expected behavior on receive?

--
Stefan
