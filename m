Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3CTX4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:56:20 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:26364
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754347Ab3CTX4S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:56:18 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzc89bhdb82hzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Wed, 20 Mar 2013 16:56:11 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <git@xilinx.com>,
        Jan =?utf-8?B?TMO8YmJl?= <jlu@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: RFC v2: Zynq Clock Controller
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.19.74.49]
X-RCIS-Action: ALLOW
Message-ID: <27dae808-1d3a-4001-8eb2-b0a6e2a34b8f@AM1EHSMHS013.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I spent some time working on this and incorporating feedback. Here's an updated proposal for a clock controller for Zynq:

Required properties:
 - #clock-cells : Must be 1
 - compatible : "xlnx,ps7-clkc"  (this may become 'xlnx,zynq-clkc' terminology differs a bit between Xilinx internal and mainline)
 - ps-clk-frequency : Frequency of the oscillator providing ps_clk in HZ
                     (usually 33 MHz oscillators are used for Zynq platforms)
 - clock-output-names : List of strings used to name the clock outputs. Shall be a list of the outputs given below.

Optional properties:
 - clocks : as described in the clock bindings
 - clock-names : as described in the clock bindings

Clock inputs:
The following strings are optional parameters to the 'clock-names' property in
order to provide optional (E)MIO clock sources.
 - swdt_ext_clk
 - gem0_emio_clk
 - gem1_emio_clk
 - mio_clk_XX          # with XX = 00..53

Example:
        clkc: clkc {
                #clock-cells = <1>;
                compatible = "xlnx,ps7-clkc";
                ps-clk-frequency = <33333333>;
                clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x", "cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x", "dci", "lqspi", "smc", "pcap", "gem0", "gem1", "fclk0", "fclk1", "fclk2", "fclk3", "can0", "can1", "sdio0", "sdio1", "uart0", "uart1", "spi0", "spi1", "dma", "usb0_aper", "usb1_aper", "gem0_aper", "gem1_aper", "sdio0_aper", "sdio1_aper", "spi0_aper", "spi1_aper", "can0_aper", "can1_aper", "i2c0_aper", "i2c1_aper", "uart0_aper", "uart1_aper", "gpio_aper", "lqspi_aper", "smc_aper", "swdt", "dbg_trc", "dbg_apb";  /* long list... explanation below */
                /* optional props */
                clocks = <&clkc 16>, <&clk_foo>;
                clock-names = "gem1_emio_clk", "can_mio_clk_23";
        };

With this revised bindings arbitrary upstream and downstream clock providers should be supported and it's also possible to loop back an output as input. The downside of supporting this is, that I don't see a way around explicitly listing the clock output names in the DT.
The reason for this is, that a downstream clock provider should use of_clk_get_parent_name() to obtain its parent clock name. For a block with multiple outputs of_clk_get_parent_name() can return a valid clock name only when 'clock-output-names' is present.
Probably the fclks are the only realistic use case to become parent of downstream clock providers, but I could imagine that e.g. a device driver like UART wants to use the CCF to model its internal clocks, hence it would require its parent clock name. Even though a device driver could use clk_get_parent() and __clk_get_name(), of_clk_get_parent_name() should probably work as well. I simply have a bad feeling about breaking of_clk_get_parent_name() for any clock.
But after all, I'm open for finding a better solution for this.


Similar, inputs for optional clock sources through (E)MIO pins can be defined as described in the clock bindings using the 'clocks' and 'clock-names' properties, with 'clock-names' being an arbitrary subset of the documented names. The actual parent clock names are internally resolved using of_clk_get_parent_name().


Regarding this monolithic solution versus a finer granular split:

On cost of more complex probing we would also have:
 - one clock driver covering the peripheral clocks
 - one for the CPU clock domain
 - one for the DDR clock domain
 - one for GEM
 - one for CAN
 - one for the APER clks
 - one for the PLLs
 - one for fclks
 - probably one for the debug clocks (not sure whether we need those)

Except for the peripheral one and probably the fclk, they would all be instantiated just once. So, there is not a lot of reuse going on.
Fclks I would probably also rather put into one driver with four outputs instead of instantiating a single output driver multiple times. Same for PLLs.

And then there is e.g. a mux for the system watchdog input which doesn't really fit anywhere and it would be pretty much ridiculous to have another clock driver just for that one and it would also become "hidden" in one of the others.

In my opinion that's just not necessary. We would create a bunch of clock drivers including DT bindings for them, probing would become more complex and it doesn't really help with the probe/naming issue. So, I don't think it's beneficial to go down that road.

The monolithic solution would need one custom driver for the PLLs, DT bindings wouldn't be required for it though. Everything else should be internally described using the clock-primitives.

Other than having a much simpler probe and init process, I still think it might be beneficial to have this monolithic block with a holistic view of the clock tree. For suspend e.g. I think the clock controller could export functions like zynq_clkc_(suspend|resume) and then the controller handles the PLL bypassing/shutdown.
Regarding full dynamic reparenting, I don't know how exactly that could work, but with the clock controller there is at least a block where that intelligence would be going and which has knowledge of all the 'struct clk *' required to reparent clocks.

Regarding the DT description, it is probably controversial what is considered better. I, like the Tegra folks, think having one clock controller in there is fine and hides irrelevant implementation details.

        Regards,
        Sören


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


