Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3HFMVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 08:21:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58140 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab3HFMVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 08:21:42 -0400
Message-ID: <1375791698.12043.53.camel@hornet>
Subject: Re: [RFC 2/2] usb: dwc3: Add Qualcomm DWC3 glue layer driver
From: Pawel Moll <pawel.moll@arm.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 06 Aug 2013 13:21:38 +0100
In-Reply-To: <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
	 <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Aug 2013 12:21:38.0886 (UTC) FILETIME=[8036E660:01CE929F]
X-MC-Unique: 113080613214005601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 12:53 +0100, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

The same comment as for the RFC 1/2 here...

>  .../devicetree/bindings/usb/msm-ssusb.txt          |   39 +++++
>  drivers/usb/dwc3/Kconfig                           |    8 +
>  drivers/usb/dwc3/Makefile                          |    1 +
>  drivers/usb/dwc3/dwc3-msm.c                        |  175 ++++++++++++++++++++
>  4 files changed, 223 insertions(+)
>  create mode 100644 drivers/usb/dwc3/dwc3-msm.c
> 
> diff --git a/Documentation/devicetree/bindings/usb/msm-ssusb.txt b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> index 550b496..313ae0d 100644
> --- a/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> +++ b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> @@ -22,6 +22,23 @@ Required "supply-name" examples are:
>  	"v1p8" : 1.8v supply for SS-PHY
>  	"vddcx" : vdd supply for SS-PHY digital circuit operation
>  
> +Required properties :
> +- compatible : should be "qcom,dwc-usb3-msm"
> +- reg : offset and length of the register set in the memory map
> +	offset and length of the TCSR register for routing USB
> +	signals to either picoPHY0 or picoPHY1.
> +- clocks = <&usb30_master_cxc>, <&sys_noc_usb3_axi_cxc>, <&usb30_sleep_cxc>, <&usb30_mock_utmi_cxc>;
> +- clock-names = "core_clk", "iface_clk", "sleep_clk", "utmi_clk";
> +
> +Optional properties :
> +- gdsc-supply : phandle to the globally distributed switch controller
> +  regulator node to the USB controller.
> +
> +Sub nodes:
> +- Sub node for "DWC3- USB3 controller".
> +  This sub node is required property for device node. The properties of this subnode
> +  are specified in dwc3.txt.

Ah, this answers one of my questions - DWC3 comes from Synopsys.

>  Example device nodes:
>  
>  	dwc3_usb2: phy@f92f8800 {
> @@ -47,3 +64,25 @@ Example device nodes:
>  		vddcx-supply = <&supply>;
>  		v1p8-supply = <&supply>;
>  	};
> +
> +	usb@fd4ab000 {
> +		compatible = "qcom,dwc-usb3-msm";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		reg = <0xfd4ab000 0x4>;
> +
> +		clocks = <&usb30_master_cxc>, <&sys_noc_usb3_axi_cxc>, <&usb30_sleep_cxc>, <&usb30_mock_utmi_cxc>;
> +		clock-names = "core_clk", "iface_clk", "sleep_clk", "utmi_clk";
> +
> +		gdsc-supply = <&supply>;
> +		ranges;
> +
> +		dwc3@f9200000 {
> +			compatible = "snps,dwc3";

Note that the Documentation/devicetree/bindings/usb/dwc3.txt is
mentioning "synopsys,dwc3" (which is clearly in opposition to the
vendor-prefixes.txt file) and this compatible value is used in the
drivers/usb/dwc3/core.c and omap5.dtsi. Unless it has been already fixed
recently, could you take care of that?

> +			reg = <0xf9200000 0xcd00>;
> +			interrupts = <0 131 0>;
> +			interrupt-names = "irq";
> +			usb-phy = <&dwc3_usb2>, <&dwc3_usb3>;
> +			tx-fifo-resize;
> +		};
> +	};

And now I'm really confused... Maybe it's just lack of documentation...

How does the "qcom,dwc-usb3-msm" relate to "qcom,dwc-usb3"?

Paweł


