Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaG1QTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:19:41 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:52772 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaG1QTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:19:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Mon, 28 Jul 2014 18:20:02 +0200
From: Stefan Agner <stefan@agner.ch>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
In-Reply-To: <53D25C9D.5080803@pengutronix.de>
References: <cover.1405428166.git.stefan@agner.ch>
 <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch>
 <53C5398F.2000005@pengutronix.de>
 <1b8a8ca03b4a160027a79b722f697e25@agner.ch>
 <601adb6fe47279c115c1cc607365a00e@agner.ch>
 <53D25C9D.5080803@pengutronix.de>
Message-ID: <e88108c655e2c16dc9cf6c4194547e73@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-07-25 15:33, schrieb Marc Kleine-Budde:
> On 07/25/2014 12:50 PM, Stefan Agner wrote:
>> Am 2014-07-16 08:43, schrieb Stefan Agner:
>>> Am 2014-07-15 16:24, schrieb Marc Kleine-Budde:
>>> <snip>
>>>>> @@ -150,18 +171,20 @@
>>>>>   * FLEXCAN hardware feature flags
>>>>>   *
>>>>>   * Below is some version info we got:
>>>>> - *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT
>>>>> - *                                Filter?   connected?
>>>>> - *   MX25  FlexCAN2  03.00.00.00     no         no
>>>>> - *   MX28  FlexCAN2  03.00.04.00    yes        yes
>>>>> - *   MX35  FlexCAN2  03.00.00.00     no         no
>>>>> - *   MX53  FlexCAN2  03.00.00.00    yes         no
>>>>> - *   MX6s  FlexCAN3  10.00.12.00    yes        yes
>>>>> + *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT  Memory err
>>>>> + *                                Filter?   connected?  detection
>>>>> + *   MX25  FlexCAN2  03.00.00.00     no         no         no
>>>>> + *   MX28  FlexCAN2  03.00.04.00    yes        yes         no
>>>>> + *   MX35  FlexCAN2  03.00.00.00     no         no         no
>>>>> + *   MX53  FlexCAN2  03.00.00.00    yes         no         no
>>>>> + *   MX6s  FlexCAN3  10.00.12.00    yes        yes         no
>>>>> + *   VF610 FlexCAN3  ?               no         no        yes
>>>>                                         ^^         ^^
>>>>
>>>> Can you check the datasheet if the flexcan core has a "Glitch Filter
>>>> Width Register (FLEXCANx_GFWR)"
>>>
>>>
>>> There is no such register called GFWR/Glitch Filter or similar.
>>>
>>>> Can you check if the core generates a warning interrupt with the current
>>>> setup, if you don't switch on bus error reporting? This means internally
>>>> the [TR]WRN_INT is connected and works as specified.
>>>
>>> Ok, so I disabled TWRNMSK (Bit 11) in the control register and printed
>>> out the error and status register (ESR1), this is what I get:
>>> [  191.285295] flexcan_irq, esr=00040080
>>> [  191.288996] flexcan_irq, ctrl=17092051
>>>
>>> Bit 17 (TWRNINT) is not set while TWRNMSK is disabled. Hence [TR]WRN_INT
>>> is not connected?
>>
>> Ping. Anything open/to do from my side?
> 
> Please keep the printing of esr and ctrl in the interrupt handler, add a
> #define DEBUG in the driver, but do not change anything else. Then:
> 

Ok, my changes look like this:

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 1c31a5d..fe8b81c 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -19,6 +19,7 @@
  *
  */
 
+#define DEBUG
 #include <linux/netdevice.h>
 #include <linux/can.h>
 #include <linux/can/dev.h>
@@ -743,6 +744,9 @@ static irqreturn_t flexcan_irq(int irq, void
*dev_id)
 
        reg_iflag1 = flexcan_read(&regs->iflag1);
        reg_esr = flexcan_read(&regs->esr);
+
+       printk("flexcan_irq, esr=%08x\n", reg_esr);
+       printk("flexcan_irq, ctrl=%08x\n", flexcan_read(&regs->ctrl));
        /* ACK all bus error and state change IRQ sources */
        if (reg_esr & FLEXCAN_ESR_ALL_INT)
                flexcan_write(reg_esr & FLEXCAN_ESR_ALL_INT,
&regs->esr);
@@ -885,8 +889,8 @@ static int flexcan_chip_start(struct net_device
*dev)
         */
        reg_ctrl = flexcan_read(&regs->ctrl);
        reg_ctrl &= ~FLEXCAN_CTRL_TSYN;
-       reg_ctrl |= FLEXCAN_CTRL_BOFF_REC | FLEXCAN_CTRL_LBUF |
-               FLEXCAN_CTRL_ERR_STATE;
+       reg_ctrl |= FLEXCAN_CTRL_BOFF_REC | FLEXCAN_CTRL_LBUF;// |
+               //FLEXCAN_CTRL_ERR_STATE;
        /*
         * enable the "error interrupt" (FLEXCAN_CTRL_ERR_MSK),
         * on most Flexcan cores, too. Otherwise we don't get

I'm not sure whether you really want to keep the FLEXCAN_CTRL_ERR_STATE
commented out...


> start the driver as usual:
> - configure bitrate
> - ifconfig can0 up
> - _do_not_ enable bit error reporint
> - start candump from gitorious with:
>   candump -e any,0:0,#FFFFFFFF
> - short circuit CAN-High and CAN-Low
> - send a CAN frame


root@colibri-vf:~# ip link set can0 type can bitrate 500000
[  146.140862] flexcan 40020000.flexcan can0: bitrate error 0.7%
root@colibri-vf:~# ip link set can0 up
[  146.661430] flexcan 40020000.flexcan can0: writing ctrl=0x17092001
[  146.667902] flexcan 40020000.flexcan can0: flexcan_set_bittiming:
mcr=0x5980000f ctrl=0x17092001
[  146.676790] flexcan 40020000.flexcan can0: flexcan_chip_start:
writing mcr=0x79a20208
[  146.684709] flexcan 40020000.flexcan can0: flexcan_chip_start:
writing ctrl=0x17092051
[  146.698228] flexcan 40020000.flexcan can0: flexcan_chip_start:
reading mcr=0x60a20208 ctrl=0x1709205

# cansend can0 1F334455#1122334455667788
interface = can0, family = 29, type = 3, proto = 

Nothing happens on candump.
 
> Another test is to setup a proper CAN bus, but configure the a second
> CAN node with a different bitrate. Start the can0 on vf610 as usual,
> then candump -e any,0:0,#FFFFFFFF, but do not send any CAN frames on the
> vf610. Then on the other system keep sending CAN frames, you might have
> to restart the CAN on the second system....

I'm using a PCAN-USB from Peak System for this test. When running with
the same bitrates on both sides (500000, things work smoothly as
expected:

# ip link set can0 type can bitrate 500000
# ip link set can0 up
# cansend can0 1F334455#1122334455667788

root@colibri-vf:~# ./candump -e any,0:0,#FFFFFFFF
  can0  1F334455   [8]  11 22 33 44 55 66 77 88

dmesg:
[  541.772502] flexcan_irq, esr=00040180
[  541.776207] flexcan_irq, ctrl=17092051

Then I reconfigure the system on my host:
# ip link set can0 down
# ip link set can0 type can bitrate 1000000
# ip link set can0 up
# cansend can0 1F334455#1122334455667788

Nothing happens on Vybrid side.


However, I got once this Kernel panic after I reconfigured to normal
mode. But I could not reproduce this.

[  461.954394] flexcan_irq, esr=00059d82
[  461.958093] flexcan_irq, ctrl=17092051
[  461.961873] ------------[ cut here ]------------
[  461.966536] WARNING: CPU: 0 PID: 0 at kernel/locking/mutex.c:826
mutex_trylock+0x1b0/0x208()
[  461.974982] DEBUG_LOCKS_WARN_ON(in_interrupt())
[  461.979347] Modules linked in:
[  461.982621] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
3.16.0-rc4-00017-ge9a974f-dirty #215
[  461.990896] Backtrace:
[  461.993412] [<80011e1c>] (dump_backtrace) from [<80011fb8>]
(show_stack+0x18/0x1c)
[  462.000991]  r6:806718ec r5:00000000 r4:00000000 r3:00000000
[  462.006836] [<80011fa0>] (show_stack) from [<8066e160>]
(dump_stack+0x88/0xa4)
[  462.014143] [<8066e0d8>] (dump_stack) from [<80028f48>]
(warn_slowpath_common+0x70/0x94)
[  462.022280]  r5:00000009 r4:808f9d50
[  462.025920] [<80028ed8>] (warn_slowpath_common) from [<80029010>]
(warn_slowpath_fmt+0x38/0x40)
[  462.034666]  r8:808f9e14 r7:8110cf7c r6:804c2fa0 r5:8e9ee000
r4:8094cdcc
[  462.041478] [<80028fdc>] (warn_slowpath_fmt) from [<806718ec>]
(mutex_trylock+0x1b0/0x208)
[  462.049792]  r3:807e3f6c r2:807e1b8c
[  462.053466] [<8067173c>] (mutex_trylock) from [<804c2fa0>]
(clk_prepare_lock+0x14/0xec)
[  462.061479]  r7:90880000 r6:8e81f800 r5:8e9ee000 r4:8e81f800
[  462.067280] [<804c2f8c>] (clk_prepare_lock) from [<804c50d0>]
(clk_prepare+0x14/0x2c)
[  462.075158]  r6:8e81f800 r5:8e9ee000 r4:8e81f800 r3:00000000
[  462.080918] [<804c50bc>] (clk_prepare) from [<803e7a50>]
(flexcan_get_berr_counter+0x24/0xd0)
[  462.089487]  r4:00000001 r3:00000000
[  462.093156] [<803e7a2c>] (flexcan_get_berr_counter) from [<803e895c>]
(flexcan_poll+0x40c/0x58c)
[  462.101992]  r8:0000000a r7:0000000a r6:8e372388 r5:8e172a80
r4:00000001 r3:00000000
[  462.109843] [<803e8550>] (flexcan_poll) from [<80511f90>]
(net_rx_action+0xcc/0x1b4)
[  462.117630]  r10:8e9ee6c0 r9:00000003 r8:0000000a r7:8fdde188
r6:808fa0c0 r5:8fdde180
[  462.125587]  r4:0000012c
[  462.128164] [<80511ec4>] (net_rx_action) from [<8002d290>]
(__do_softirq+0x120/0x26c)
[  462.136038]  r10:808fa080 r9:00000003 r8:00000100 r7:00000003
r6:808f8000 r5:808fa08c
[  462.143994]  r4:00000000
[  462.146566] [<8002d170>] (__do_softirq) from [<8002d6d4>]
(irq_exit+0xb0/0x104)
[  462.153923]  r10:806788ac r9:808f8000 r8:00000000 r7:0000005a
r6:808f8000 r5:808f5e2c
[  462.161877]  r4:808f8000
[  462.164459] [<8002d624>] (irq_exit) from [<8000f4bc>]
(handle_IRQ+0x58/0xb8)
[  462.171520]  r4:80900d2c r3:000000a0
[  462.175200] [<8000f464>] (handle_IRQ) from [<800086c0>]
(gic_handle_irq+0x30/0x68)
[  462.182818]  r8:8095c587 r7:90802100 r6:808f9f28 r5:80900ea0
r4:9080210c r3:000000a0
[  462.190671] [<80008690>] (gic_handle_irq) from [<80012ae4>]
(__irq_svc+0x44/0x5c)
[  462.198203] Exception stack(0x808f9f28 to 0x808f9f70)
[  462.203315] 9f20:                   00000001 00000001 00000000
80904070 8090098c 80900938
[  462.211517] 9f40: 8095c587 00000000 8095c587 808f8000 806788ac
808f9f7c 808f9f40 808f9f70
[  462.219746] 9f60: 80066a98 8000f834 20000013 ffffffff
[  462.224852]  r7:808f9f5c r6:ffffffff r5:20000013 r4:8000f834
[  462.230621] [<8000f80c>] (arch_cpu_idle) from [<8005fba4>]
(cpu_startup_entry+0x104/0x16c)
[  462.238964] [<8005faa0>] (cpu_startup_entry) from [<80668cf8>]
(rest_init+0xb0/0xd8)
[  462.246757]  r7:8ffffcc0 r3:00000000
[  462.250419] [<80668c48>] (rest_init) from [<808a5bf8>]
(start_kernel+0x340/0x3ac)
[  462.257979]  r5:8095c7c0 r4:80900a38
[  462.261620] [<808a58b8>] (start_kernel) from [<80008074>]
(0x80008074)
[  462.268204] ---[ end trace c9c9dee0ce2272a7 ]---
[  462.272899] flexcan 40020000.flexcan can0: Error Warning IRQ

candump showed this:
  can0  20000004   [8]  00 04 00 00 00 00 00 00   ERRORFRAME
	controller-problem{rx-error-warning}

> 
> Please send the outputs of candump and demsg to the list. It should
> generate a warning, error passive and finally a busoff message.
> 

--
Stefan

