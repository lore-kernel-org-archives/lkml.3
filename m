Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab3J1VNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:13:33 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58840 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3J1VNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:13:31 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/2] clk/zynq/clkc: Add 'fclk-enable' feature
Date: Mon, 28 Oct 2013 22:13:28 +0100
Message-ID: <1592656.1ojHcSlzVh@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.6-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1381425018-5653-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1381425018-5653-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soren,

On Thursday 10 of October 2013 10:10:17 Soren Brinkmann wrote:
> In some use cases Zynq's FPGA clocks are used as static clock
> generators for IP in the FPGA part of the SOC for which no Linux driver
> exists and would control those clocks. To avoid automatic
> gating of these clocks in such cases a new property - fclk-enable - is
> added to the clock controller's DT description to accomodate such use
> cases. It's value is a bitmask, where a set bit results in enabling
> the corresponding FCLK through the clkc.
> 
> FPGA clocks are handled following the rules below:
> 
> If an FCLK is not enabled by bootloaders, that FCLK will be disabled in
> Linux. Drivers can enable and control it through the CCF as usual.
> 
> If an FCLK is enabled by bootloaders AND the corresponding bit in the
> 'fclk-enable' DT property is set, that FCLK will be enabled by the clkc,
> resulting in an off by one reference count for that clock. Ensuring it
> will always be running.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> v2:
>  - change default value for fclk-enable to '0'
> ---
>  Documentation/devicetree/bindings/clock/zynq-7000.txt |  4 ++++
>  drivers/clk/zynq/clkc.c                               | 18
> +++++++++++++++--- 2 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/clock/zynq-7000.txt
> b/Documentation/devicetree/bindings/clock/zynq-7000.txt index
> d99af878f5d7..11fdd146ec83 100644
> --- a/Documentation/devicetree/bindings/clock/zynq-7000.txt
> +++ b/Documentation/devicetree/bindings/clock/zynq-7000.txt
> @@ -22,6 +22,10 @@ Required properties:
>  Optional properties:
>   - clocks : as described in the clock bindings
>   - clock-names : as described in the clock bindings
> + - fclk-enable : Bit mask to enable FCLKs in cases no proper CCF

Since it's a vendor specific property, it should include vendor prefix.

Also CCF is a Linux-specific implementation detail, which DT bindings
should not be involved into. If you really need to implement this using
this way, then at least property description should say something like 
this:

xlnx,fclk-enable : Bit mask of bits of fclk enable register that must
be statically enabled at boot-up time.

However, I wonder why you can't simply define an FPGA block using a single 
node, which would be a consumer to all the fclk clocks you need to enable 
and then make a driver for it that would simply enable all clocks 
specified in clocks property.

Best regards,
Tomasz

