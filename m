Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbbAZOTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:19:14 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:49155 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbbAZOTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:19:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Jan 2015 15:18:53 +0100
From: Stefan Agner <stefan@agner.ch>
To: Mark Rutland <mark.rutland@arm.com>
Cc: tglx@linutronix.de, jason@lakedaemon.net,
        Marc Zyngier <Marc.Zyngier@arm.com>, u.kleine-koenig@pengutronix.de,
        shawn.guo@linaro.org, kernel@pengutronix.de, arnd@arndb.de,
        robh+dt@kernel.org, Pawel Moll <Pawel.Moll@arm.com>,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v3 2/3] irqchip: vf610-mscm: dt-bindings: add
 MSCM bindings
In-Reply-To: <20150126133602.GG23313@leverpostej>
References: <1421309046-22452-1-git-send-email-stefan@agner.ch>
 <1421309046-22452-3-git-send-email-stefan@agner.ch>
 <20150126133602.GG23313@leverpostej>
Message-ID: <e8f5ff60a8da4c7539d9a33d162bb773@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-26 14:36, Mark Rutland wrote:
> On Thu, Jan 15, 2015 at 08:04:05AM +0000, Stefan Agner wrote:
>> Add binding documentation for Miscellaneous System Control Module
>> found in Freescale Vybrid SoC's.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  .../bindings/arm/freescale/fsl,vf610-mscm.txt         | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt b/Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt
>> new file mode 100644
>> index 0000000..e051b88
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt
>> @@ -0,0 +1,19 @@
>> +Freescale Vybrid Miscellaneous System Control Module
>> +
>> +The MSCM IP contains Access Control and TrustZone Security hardware,
>> +CPU Configuration registers and Interrupt Router control.
>> +
>> +Required properties:
>> +- compatible : "fsl,vf610-mscm", "syscon"
> 
> I'm a little concerned by this also being a syscon. What other devices
> need to refer to this block as a syscon?
> 

The block offers several functionality. I'm happy we can discuss this
here a bit more in depth, since I'm really not sure if the current
solution is the best solution...

Due to the general rule to not split hardware modules, I hesitated to
make different nodes out of it. However, this module has some quite
distinct sub-modules, hence I guess it would be also feasible to do so:

0x40001000-0x4000105C - Processor information e.g. which processor ID is
the accessing processor (processor identity), cache size etc...
0x40001800-0x40001820 - CPU2CPU directed interrupt generation/clear
registers...
0x40001880-0x4000195E - the actual interrupt router
0x40001C00-0x40001DDC - ACTZS TrustZone registers...

This driver accesses the first and the third block. The first block is
necessary since the driver needs to know which CPU ID it is running on
to actually program the interrupt router (Note: this is a heterogeneous
multiprocessing system. This are actually treated as two independent UP
systems, considering that Linux can also run on the Cortex-M4).

Hence, the syscon definition which would allow to access other areas as
needed, especially the processor information might be needed by any
other peripheral (driver) which needs to know what CPU it is running on.
What do you think?

OTH, we could as well split it up in three or even four nodes. The MSCM
interrupt router part just needs to access the the MSCM processor
information part somehow (syscon?)...

Fwiw, in our downstream kernel, the CPU2CPU interrupts are used for
Freescales messaging system (MCC). I hacked a special interface in that
early version of this driver, to export this functionality. But then I
guess such a functionality should not affect the device tree
bindings...?
http://git.toradex.com/cgit/linux-toradex.git/commit/?h=toradex_vf_3.18-next&id=6f0bbad6b805cf2014eec54531dbe4ddb4867a91

For detailed information, the module is documented in the public
reference manual, chapter 64.
http://www.freescale.com/webapp/sps/site/prod_summary.jsp?code=VF6xx&fpsp=1&tab=Documentation_Tab

>> +- interrupt-controller : Identifies the node as an interrupt controller
>> +- #interrupt-cells : Two cells, interrupt number and flags (IRQ type)
> 
> What numbers and flags are valid?
> 

The first cell is the hardware interrupt ID according to the MSCM
interrupt router. The flags gets passed to the GIC interrupt controller
only, hence those are the one which are supported by the GIC controller.


Will add that information, thx.

--
Stefan

> Mark.
> 
>> +- reg : the register range of the MSCM module
>> +
>> +Example:
>> +	mscm: mscm@40001000 {
>> +		compatible = "fsl,vf610-mscm", "syscon";
>> +		interrupt-controller;
>> +		#interrupt-cells = <2>;
>> +		interrupt-parent = <&intc>;
>> +		reg = <0x40001000 0x1000>;
>> +	}
>> --
>> 2.2.1
>>
>>
