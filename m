Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbaH1IX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:23:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:38343 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbaH1IXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:23:53 -0400
Date: Thu, 28 Aug 2014 10:23:48 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tony Lindgren <tony@atomide.com>, balbi@ti.com
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
Message-ID: <20140828082348.GA5413@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
 <1408124563-31541-16-git-send-email-bigeasy@linutronix.de>
 <20140815210211.GD9239@atomide.com>
 <53F5AF0D.5060409@linutronix.de>
 <20140821184416.GF10066@atomide.com>
 <53FE3779.5090908@linutronix.de>
 <20140827202313.GF16006@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140827202313.GF16006@atomide.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren | 2014-08-27 13:23:14 [-0700]:

>> which means I just enable DMA mode in UART and disable it. No DMA
>> operations were performed.
>> With this change I see a lost character now and then which means the
>> UART-IP goes into off and loses its context. Good. However I don't see
>> core off anymore. This looks like a bug beyond my responsibilities :)
>
>OK, that sounds like a bug still lurking around somewhere. The core
>domain won't hit idle if there are any hardware pieces blocking.

Yes.

>> I added code to cancel & and start DMA transfers in runtime suspend
>> callbacks.
>
>Do you mean just the OMAP_UART_SCR_DMAMODE_CTL related code, or
>also the dmaengine calls?

dmaengine calls are unused because up.dma is not assigned. It is 
basically like you wouldn't have the dma properties in the devicetree.
And while in that non-DMA mode I just set and unset the DMAMODE_CTL + 
DMAMODE_1 bits in the SCR register. Nothing else. Based on some testing
I just did, DMAMODE_CTL does not make the difference. DMAMODE_CTL +
DMAMODE_1 does.

>> However core-off with DMA won't work. I think we could document this in
>> the binding document. What do you think?
>
>There should not be such a limitation though. Maybe dump out the values
>of cm_idlest_per and cm_idlest1_core for working and failing off idle
>cases and see what the difference is?

I can't follow here. This is the working case:

usbhost_pwrdm (OFF),OFF:1,RET:1,INA:0,ON:2,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
sgx_pwrdm (OFF),OFF:1,RET:0,INA:0,ON:1,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
core_pwrdm (ON),OFF:109,RET:22,INA:71,ON:203,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0,RET-MEMBANK2-OFF:0
per_pwrdm (ON),OFF:137,RET:126,INA:0,ON:264,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
dss_pwrdm (ON),OFF:383,RET:861,INA:0,ON:1245,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
cam_pwrdm (OFF),OFF:1,RET:1,INA:0,ON:2,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
neon_pwrdm (ON),OFF:311,RET:889,INA:44,ON:1245,RET-LOGIC-OFF:0
mpu_pwrdm (ON),OFF:311,RET:889,INA:44,ON:1245,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
iva2_pwrdm (OFF),OFF:1,RET:1,INA:0,ON:2,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0,RET-MEMBANK2-OFF:0,RET-MEMBANK3-OFF:0,RET-MEMBANK4-OFF:0
usbhost_clkdm->usbhost_pwrdm (0)
sgx_clkdm->sgx_pwrdm (0)
per_clkdm->per_pwrdm (15)
cam_clkdm->cam_pwrdm (0)
dss_clkdm->dss_pwrdm (1)
d2d_clkdm->core_pwrdm (0)
iva2_clkdm->iva2_pwrdm (0)
mpu_clkdm->mpu_pwrdm (0)
core_l4_clkdm->core_pwrdm (20)
core_l3_clkdm->core_pwrdm (1)
neon_clkdm->neon_pwrdm (0)

non-working:

usbhost_pwrdm (OFF),OFF:1,RET:1,INA:0,ON:2,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
sgx_pwrdm (OFF),OFF:1,RET:0,INA:0,ON:1,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
core_pwrdm (ON),OFF:0,RET:0,INA:0,ON:1,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0,RET-MEMBANK2-OFF:0
per_pwrdm (ON),OFF:0,RET:0,INA:0,ON:1,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
dss_pwrdm (ON),OFF:253,RET:159,INA:0,ON:413,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
cam_pwrdm (OFF),OFF:1,RET:1,INA:0,ON:2,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
neon_pwrdm (ON),OFF:135,RET:242,INA:35,ON:413,RET-LOGIC-OFF:0
mpu_pwrdm (ON),OFF:135,RET:242,INA:35,ON:413,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0
iva2_pwrdm (OFF),OFF:1,RET:1,INA:0,ON:2,RET-LOGIC-OFF:0,RET-MEMBANK1-OFF:0,RET-MEMBANK2-OFF:0,RET-MEMBANK3-OFF:0,RET-MEMBANK4-OFF:0
usbhost_clkdm->usbhost_pwrdm (0)
sgx_clkdm->sgx_pwrdm (0)
per_clkdm->per_pwrdm (15)
cam_clkdm->cam_pwrdm (0)
dss_clkdm->dss_pwrdm (1)
d2d_clkdm->core_pwrdm (0)
iva2_clkdm->iva2_pwrdm (0)
mpu_clkdm->mpu_pwrdm (0)
core_l4_clkdm->core_pwrdm (21)
core_l3_clkdm->core_pwrdm (1)
neon_clkdm->neon_pwrdm (0)

so per_pwrdm and core_pwrdm remain on and I guess the former is where
the UART sits.

>It could be the either the dma or the uart hardware blocking. I guess
>it could be also an issue with runtime pm use somewhere.

So I just toggle the two DMA bits in SCR and the UART seems to block
since the DMA hw is not involved. Reading SCR back says that those bits
are not set.
To use DMA you don't have to enable it in SCR register you can also use
the FCR register. The manual says that you can only write this DMA
enable bit in the FCR register if the baud clock is not running. And
guess what: same thing: I only *toggle* the DMA enable bit here (it
remains 0 later) and the core won't hit idle.
Same effect if I toggle this bit while the baud clock is running (the
manual says that this bit can only be written if the baud clock is not
running). Seems like the UART is following its own specification and it
remains blocking once the DMA was enabled.
It would be nice if someone from the UART-IP team could ACK this.

Bah. Does it make sense to use runtime-PM if we can't hit core-off? I'm
thinking to add a printk once dma is enabled says that runtime-pm is
switched off.

>Tony

Sebastian
