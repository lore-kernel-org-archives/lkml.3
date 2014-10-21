Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaJUJPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:15:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46276 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932191AbaJUJPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:15:03 -0400
Date: Tue, 21 Oct 2014 10:14:12 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Ankit Jindal <ankit.jindal@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "patches@apm.com" <patches@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>
Subject: Re: [PATCH v3 5/6] Documentation: dt-bindings: Add binding info for
 X-Gene QMTM UIO driver
Message-ID: <20141021091412.GB15293@leverpostej>
References: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org>
 <1413871011-4101-6-git-send-email-ankit.jindal@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413871011-4101-6-git-send-email-ankit.jindal@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 06:56:49AM +0100, Ankit Jindal wrote:
> This patch adds device tree binding documentation for
> X-Gene QMTM UIO driver.
> 
> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
> ---
>  .../devicetree/bindings/uio/uio_xgene_qmtm.txt     |   53 ++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
> 
> diff --git a/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
> new file mode 100644
> index 0000000..288ed92
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
> @@ -0,0 +1,53 @@
> +APM X-Gene QMTM UIO nodes

The "UIO" can go.

> +The Applied Micro X-Gene SOC has on-chip QMTM (Queue manager
> +and Traffic manager). It is a device for managing hardware queues.
> +It also implements QoS among hardware queues hence term "traffic"
> +manager is present in its name. QMTM UIO nodes are defined for user
> +space access to this device using UIO framework.

The binding should describe the hardware, not the software. Please drop
mention of UIO, userspace, etc.

> +Required properties:
> +- compatible: Should be "apm,xgene-qmtm"
> +- reg: Address and length of the register set for the device. It contains the
> +  information of registers in the same order as described by reg-names.
> +- reg-names: Should contain the register set names
> +  - "csr": QMTM control and status register address space.
> +  - "fabric": QMTM memory mapped access to queue states.
> +- qpool: Points to the phandle of the node defining memory location for
> +	 creating QMTM queues. This could point either to the reserved-memory
> +	 node (as-per reserved memory bindings) or to the node of on-chip
> +	 SRAM etc. It is expected that size and location of qpool memory will
> +	 be configurable via bootloader.

Is that on-chip SRAM part of the QMTM, or is that a shared part of the
SoC?

It feels odd to have a phandle that can go to completely different
classes of node, especially as you will need to use a different API to
acquire the memory region within Linux.

> +- clocks: Reference to the clock entry.

Just the one clock? Does the clock input to the QMTM have a name?

> +- num-queues: Number of queues under this QMTM device.
> +- devid: QMTM identification number for the system having multiple QMTM devices.
> +	 This is used to form a unique id (a tuple of queue number and
> +	 device id) for the queues belonging to this device.

Is this just an arbitrary unique ID, or is this a non-probeable property
of the HW? If the former, isn't the base address sufficient as a unique
identifier?

Thanks,
Mark.

> +Example:
> +	qmtm1_uio_qpool: qmtm1_uio_qpool {
> +		reg = <0x0 0x0 0x0 0x0>
> +	};
> +
> +	qmtm1clk: qmtmclk@1f20c000 {
> +		compatible = "apm,xgene-device-clock";
> +		clock-output-names = "qmtm1clk";
> +		status = "ok";
> +	};
> +
> +	qmtm1_uio: qmtm_uio@1f200000 {
> +		compatible = "apm,xgene-qmtm";
> +		status = "disabled";
> +		reg = <0x0 0x1f200000 0x0 0x10000>,
> +		      <0x0 0x1b000000 0x0 0x400000>;
> +		reg-names = "csr", "fabric";
> +		qpool = <&qmtm1_uio_qpool>;
> +		clocks = <&qmtm1clk 0>;
> +		num-queues = <0x400>;
> +		devid = <1>;
> +	};
> +
> +	/* Board-specific peripheral configurations */
> +	&qmtm1_uio {
> +		status = "ok";
> +	};
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
