Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaIPSPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:15:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46718 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbaIPSPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:15:49 -0400
Date: Tue, 16 Sep 2014 11:15:43 -0700
From: Jack Pham <jackp@codeaurora.org>
To: Andy Gross <agross@codeaurora.org>
Cc: Felipe Balbi <balbi@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kumar Gala <galak@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-usb@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [Patch v9 1/3] usb: dwc3: qcom: Add device tree binding
Message-ID: <20140916181543.GA19101@usblab-sd-06.qualcomm.com>
References: <1410550088-8754-1-git-send-email-agross@codeaurora.org>
 <1410550088-8754-2-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410550088-8754-2-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Fri, Sep 12, 2014 at 02:28:06PM -0500, Andy Gross wrote:
> +Example device nodes:
> +
> +		hs_phy: phy@100f8800 {
> +			compatible = "qcom,dwc3-hs-usb-phy";
> +			reg = <0x100f8800 0x30>;

Just wanted to point out that in our downstream code, the glue
device/driver, i.e. "qcom,dwc3", does claim an entire register region
that encompasses the same registers used by these PHYs. I noticed you're
not adding a reg resource to the glue node below in this patchset. In
order to allow multiple devices to use the overlapping regions, we avoid
calling devm_ioremap_resource() and instead call devm_ioremap_nocache()
directly which bypasses the request_mem_region() call, which I don't
think is an entirely correct thing to do.

On the other hand I'm trying to think of use cases on our other SOCs
(MSM8974, APQ8084) where the glue actually would need access to the same
or adjacent IO registers that couldn't just be handled directly by these
PHY drivers. Should we accommodate for the potential of overlapping
regions or should we just hold the line here and maybe only expose with
finer granularity the registers that will actually be needed by the PHYs
& glue respectively?

> +			clocks = <&gcc USB30_0_UTMI_CLK>;
> +			clock-names = "ref";
> +			#phy-cells = <0>;
> +
> +			status = "ok";
> +		};
> +
> +		ss_phy: phy@100f8830 {
> +			compatible = "qcom,dwc3-ss-usb-phy";
> +			reg = <0x100f8830 0x30>;
> +			clocks = <&gcc USB30_0_MASTER_CLK>;
> +			clock-names = "ref";
> +			#phy-cells = <0>;
> +
> +			status = "ok";
> +		};
> +
> +		usb3_0: usb30@0 {
> +			compatible = "qcom,dwc3";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			clocks = <&gcc USB30_0_MASTER_CLK>;
> +			clock-names = "core";
> +
> +			ranges;
> +
> +			status = "ok";
> +
> +			dwc3@10000000 {
> +				compatible = "snps,dwc3";
> +				reg = <0x10000000 0xcd00>;
> +				interrupts = <0 205 0x4>;
> +				phys = <&hs_phy>, <&ss_phy>;
> +				phy-names = "usb2-phy", "usb3-phy";
> +				tx-fifo-resize;
> +				dr_mode = "host";
> +			};
> +		};
> +

Thanks,
Jack
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
