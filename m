Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3CEUEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:04:42 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:14252
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757274Ab3CEUEk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:04:40 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzc89bh4015Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Tue, 5 Mar 2013 12:04:28 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <git@xilinx.com>
Subject: RFC: Zynq Clock Controller
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 05 Mar 2013 20:04:30.0350 (UTC) FILETIME=[A5AE82E0:01CE19DC]
X-RCIS-Action: ALLOW
Message-ID: <37032699-343e-485c-80e0-9b23e3706c58@VA3EHSMHS013.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As you know, I'm reviewing Zynq's clock implementation and try to find a way to go forward. It looks like most archs contain all clocks within a clock controller block which provides all the output clocks which are then used by device drivers etc. E.g. the Tegra CAR.

I do also see some benefits of this approach:
 - The DT description should never change even when the clock tree and/or functionality within the controller changes (assuming all required outputs are present)
 - the controller can handle more sophisticated clock operations, which go beyond the simple enable/disable the device drivers are doing

For this reasons, I'd like to propose moving Zynq into the same direction. I.e. adding a clock controller with the following DT description (details may change but the general idea should become clear):
	clkc: clkc {
                #clock-cells = <1>;
                compatible = "xlnx,ps7-clkc";
                ps_clk_frequency = <33333333>;	# board x-tal
                # optional props
                gem0_emio_clk_freq = <125000000>;
                gem1_emio_clk_freq = <50000000>;
                can_mio_clk_freq_xx = <1234>; # this is possible 54 times with xx = 00..53
        };

For the PLLs we can use Josh's implementation and extend it where needed. For everything else we can then use the clock primitives instead of using custom implementations, I think. The node should be a subnode to Zynq's SLCR.

Currently I have identified the following output clocks:
        armpll, ddrpll, iopll,
        cpu_6or4x, cpu_3or2x, cpu_2x, cpu_1x,
        ddr2x, ddr3x, dci,
        lqspi, smc, pcap, gem0, gem1, fclk0, fclk1, fclk2, fclk3, can0, can1,
        sdio0, sdio1, uart0, uart1, spi0, spi1,
        dma_aper, usb0_aper, usb1_aper, gem0_aper, gem1_aper,
        sdio0_aper, sdio1_aper, spi0_aper, spi1_aper, can0_aper, can1_aper,
        i2c0_aper, i2c1_aper, uart0_aper, uart1_aper, gpio_aper, lqspi_aper,
        smc_aper


Clock consumers would work as described in the clock bindings:
	consumer: zynq_dummy_peripheral {
	        compatible = "xlnx,foobar";
	        clocks = <&clkc 69>;
	};


Is this an acceptable solution? Does anybody see issues or has other feedback?

	Thanks,
	Sören


