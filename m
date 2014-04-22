Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbaDVQFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:05:50 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:53550 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249AbaDVQFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:05:43 -0400
Message-ID: <53569352.3050101@linaro.org>
Date: Tue, 22 Apr 2014 17:05:38 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v6 11/19] usb: phy: msm: Add device tree support and binding
 information
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com> <1398158438-21579-12-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1398158438-21579-12-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

On 22/04/14 10:20, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov"<iivanov@mm-sol.com>
>
> Allows MSM OTG controller to be specified via device tree.
>
> Signed-off-by: Ivan T. Ivanov<iivanov@mm-sol.com>
> ---
>   .../devicetree/bindings/usb/msm-hsusb.txt          |  67 +++++++++++++
>   drivers/usb/phy/phy-msm-usb.c                      | 108 +++++++++++++++++----
>   include/linux/usb/msm_hsusb.h                      |   6 +-
>   3 files changed, 159 insertions(+), 22 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> index 5ea26c6..ee4123d 100644
> --- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> +++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> @@ -15,3 +15,70 @@ Example EHCI controller device node:
>   		usb-phy = <&usb_otg>;
>   	};
>
> +USB PHY with optional OTG:
> +
> +Required properties:
> +- compatible:   Should contain:
> +  "qcom,usb-otg-ci" for chipsets with ChipIdea 45nm PHY
> +  "qcom,usb-otg-snps" for chipsets with Synopsys 28nm PHY
> +
> +- regs:         Offset and length of the register set in the memory map
> +- interrupts:   interrupt-specifier for the OTG interrupt.
> +
> +- clocks:       A list of phandle + clock-specifier pairs for the
> +                clocks listed in clock-names
> +- clock-names:  Should contain the following:
> +  "phy"         USB PHY reference clock
> +  "core"        Protocol engine clock
> +  "iface"       Interface bus clock
> +  "alt_core"    Protocol engine clock for targets with asynchronous
> +                reset methodology. (optional)
> +
> +- vdccx-supply: phandle to the regulator for the vdd supply for
> +                digital circuit operation.
> +- v1p8-supply:  phandle to the regulator for the 1.8V supply
> +- v3p3-supply:  phandle to the regulator for the 3.3V supply
> +
> +- resets:       A list of phandle + reset-specifier pairs for the
> +                resets listed in reset-names
> +- reset-names:  Should contain the following:
> +  "phy"         USB PHY controller reset
> +  "link"        USB LINK controller reset
> +
> +- qcom,otg-control: OTG control (VBUS and ID notifications) can be one of
> +                1 - PHY control
> +                2 - PMIC control
> +
> +Optional properties:
> +- dr_mode:      One of "host", "peripheral" or "otg". Defaults to "otg"
> +
> +- qcom,phy-init-sequence: PHY configuration sequence values. This is related to Device
> +                Mode Eye Diagram test. Start address at which these values will be
> +                written is ULPI_EXT_VENDOR_SPECIFIC. Value of -1 is reserved as
> +                "do not overwrite default value at this address".
> +                For example: qcom,phy-init-sequence = < -1 0x63 >;
> +                Will update only value at address ULPI_EXT_VENDOR_SPECIFIC + 1.

I don’t think DT maintainers will like the sound of it.
Sorry If I missed some old discussion on this.
But I don't this this is the correct way.

DT should describe the system hardware layout rather than initialization 
sequence.

The initialization code with magic values should go directly into the 
driver and depending on the dt-compatible driver should select the right 
sequence.

/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -30,9 +30,12 @@
>   #include <linux/debugfs.h>
>   #include <linux/seq_file.h>
>   #include <linux/pm_runtime.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>
>   #include <linux/usb.h>
>   #include <linux/usb/otg.h>
> +#include <linux/usb/of.h>
>   #include <linux/usb/ulpi.h>
>   #include <linux/usb/gadget.h>
>   #include <linux/usb/hcd.h>
> @@ -217,16 +220,16 @@ static struct usb_phy_io_ops msm_otg_io_ops = {
>   static void ulpi_init(struct msm_otg *motg)
>   {
>   	struct msm_otg_platform_data *pdata = motg->pdata;
> -	int *seq = pdata->phy_init_seq;
> +	int *seq = pdata->phy_init_seq, idx;
> +	u32 addr = ULPI_EXT_VENDOR_SPECIFIC;
>
> -	if (!seq)
> -		return;
> +	for (idx = 0; idx < pdata->phy_init_sz; idx++) {
> +		if (seq[idx] == -1)
> +			continue;
>
> -	while (seq[0] >= 0) {
>   		dev_vdbg(motg->phy.dev, "ulpi: write 0x%02x to 0x%02x\n",
> -				seq[0], seq[1]);
> -		ulpi_write(&motg->phy, seq[0], seq[1]);
> -		seq += 2;
> +				seq[idx], addr + idx);
> +		ulpi_write(&motg->phy, seq[idx], addr + idx);
>   	}
>   }

How is above change related to device trees?
>
> @@ -1343,25 +1346,87 @@ static void msm_otg_debugfs_cleanup(void)
>   	debugfs_remove(msm_otg_dbg_root);
>   }
>
> +static struct of_device_id msm_otg_dt_match[] = {
> +	{
> +		.compatible = "qcom,usb-otg-ci",
> +		.data = (void *) CI_45NM_INTEGRATED_PHY
> +	}, {
> +		.compatible = "qcom,usb-otg-snps",
> +		.data = (void *) SNPS_28NM_INTEGRATED_PHY
> +	}, {}
> +};
> +
> +static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
> +{
> +	struct msm_otg_platform_data *pdata;
> +	const struct of_device_id *id;
> +	struct device_node *node = pdev->dev.of_node;
> +	struct property *prop;
> +	int len, ret;
> +	u32 val;
> +
> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;
> +
> +	motg->pdata = pdata;
> +
> +	id = of_match_device(msm_otg_dt_match, &pdev->dev);
> +	pdata->phy_type = (int) id->data;
> +
> +	pdata->mode = of_usb_get_dr_mode(node);
> +	if (pdata->mode == USB_DR_MODE_UNKNOWN)
> +		pdata->mode = USB_DR_MODE_OTG;
> +
> +	pdata->otg_control = OTG_PHY_CONTROL;
> +	if (!of_property_read_u32(node, "qcom,otg-control", &val))
> +		if (val == OTG_PMIC_CONTROL)
> +			pdata->otg_control = val;
> +
> +	prop = of_find_property(node, "qcom,phy-init-sequence", &len);
> +	if (!prop || !len)
> +		return 0;
> +
> +	pdata->phy_init_seq = devm_kzalloc(&pdev->dev, len, GFP_KERNEL);
> +	if (!pdata->phy_init_seq)
> +		return 0;
return -ENOMEM;
> +
> +	len /= sizeof(u32);
> +
> +	if (len >= ULPI_EXT_VENDOR_SPECIFIC) {
> +		dev_warn(&pdev->dev, "Too big PHY init sequence %d\n", len);
> +		return 0;
> +	}
> +
> +	ret = of_property_read_u32_array(node, "qcom,phy-init-sequence",
> +					 pdata->phy_init_seq, len);
> +	if (!ret)
> +		pdata->phy_init_sz = len;

empty line before return would be nice.
> +	return 0;
> +}
> +
>   static int msm_otg_probe(struct platform_device *pdev)
>   {
>   	int ret = 0;
> +	struct device_node *np = pdev->dev.of_node;
> +	struct msm_otg_platform_data *pdata;
>   	struct resource *res;
>   	struct msm_otg *motg;
>   	struct usb_phy *phy;
>
> -	dev_info(&pdev->dev, "msm_otg probe\n");
> -	if (!dev_get_platdata(&pdev->dev)) {
> -		dev_err(&pdev->dev, "No platform data given. Bailing out\n");
> -		return -ENODEV;
> -	}
> -
>   	motg = devm_kzalloc(&pdev->dev, sizeof(struct msm_otg), GFP_KERNEL);
>   	if (!motg) {
>   		dev_err(&pdev->dev, "unable to allocate msm_otg\n");
>   		return -ENOMEM;
>   	}
>
> +	pdata = dev_get_platdata(&pdev->dev);
> +	if (!pdata) {
shouldn’t this be
if (np) {
> +		ret = msm_otg_read_dt(pdev, motg);
> +		if (ret)
> +			return ret;
> +	}
> +
>   	motg->phy.otg = devm_kzalloc(&pdev->dev, sizeof(struct usb_otg),
>   				     GFP_KERNEL);
>   	if (!motg->phy.otg) {
> @@ -1369,17 +1434,17 @@ static int msm_otg_probe(struct platform_device *pdev)
>   		return -ENOMEM;
>   	}
>
> -	motg->pdata = dev_get_platdata(&pdev->dev);
>   	phy = &motg->phy;
>   	phy->dev = &pdev->dev;
>
> -	motg->phy_reset_clk = devm_clk_get(&pdev->dev, "usb_phy_clk");
> +	motg->phy_reset_clk = devm_clk_get(&pdev->dev,
> +					   np ? "phy" : "usb_phy_clk");
Not sure why should it be different in dt and non-dt.
>   	if (IS_ERR(motg->phy_reset_clk)) {
>   		dev_err(&pdev->dev, "failed to get usb_phy_clk\n");
>   		return PTR_ERR(motg->phy_reset_clk);
>   	}
>
> -	motg->clk = devm_clk_get(&pdev->dev, "usb_hs_clk");
> +	motg->clk = devm_clk_get(&pdev->dev, np ? "core" : "usb_hs_clk");

Not sure why should it be different in dt and non-dt.
>   	if (IS_ERR(motg->clk)) {
>   		dev_err(&pdev->dev, "failed to get usb_hs_clk\n");
>   		return PTR_ERR(motg->clk);
> @@ -1391,7 +1456,7 @@ static int msm_otg_probe(struct platform_device *pdev)
>   	 * operation and USB core cannot tolerate frequency changes on
>   	 * CORE CLK.
>   	 */
> -	motg->pclk = devm_clk_get(&pdev->dev, "usb_hs_pclk");
> +	motg->pclk = devm_clk_get(&pdev->dev, np ? "iface" : "usb_hs_pclk");
>   	if (IS_ERR(motg->pclk)) {
>   		dev_err(&pdev->dev, "failed to get usb_hs_pclk\n");
>   		return PTR_ERR(motg->pclk);
> @@ -1402,7 +1467,8 @@ static int msm_otg_probe(struct platform_device *pdev)
>   	 * clock is introduced to remove the dependency on AXI
>   	 * bus frequency.
>   	 */
> -	motg->core_clk = devm_clk_get(&pdev->dev, "usb_hs_core_clk");
> +	motg->core_clk = devm_clk_get(&pdev->dev,
> +				      np ? "alt_core" : "usb_hs_core_clk");
>
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	motg->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> @@ -1490,8 +1556,7 @@ static int msm_otg_probe(struct platform_device *pdev)
>   	platform_set_drvdata(pdev, motg);
>   	device_init_wakeup(&pdev->dev, 1);
>
> -	if (motg->pdata->mode == USB_DR_MODE_OTG &&
> -			motg->pdata->otg_control == OTG_USER_CONTROL) {
> +	if (motg->pdata->mode == USB_DR_MODE_OTG) {

How is this change related to DT?
>   		ret = msm_otg_debugfs_init(motg);
>   		if (ret)
>   			dev_dbg(&pdev->dev, "Can not create mode change file\n");
> @@ -1637,6 +1702,8 @@ static const struct dev_pm_ops msm_otg_dev_pm_ops = {
>   				msm_otg_runtime_idle)
>   };
>
> +MODULE_DEVICE_TABLE(of, msm_otg_dt_match);
> +
>   static struct platform_driver msm_otg_driver = {
>   	.probe = msm_otg_probe,
>   	.remove = msm_otg_remove,
> @@ -1644,6 +1711,7 @@ static struct platform_driver msm_otg_driver = {
>   		.name = DRIVER_NAME,
>   		.owner = THIS_MODULE,

>   		.pm = &msm_otg_dev_pm_ops,
> +		.of_match_table = msm_otg_dt_match,
>   	},
>   };
>

[snip --
> diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
> index 262ed80..bd68299 100644
> --- a/include/linux/usb/msm_hsusb.h
> +++ b/include/linux/usb/msm_hsusb.h
> @@ -100,8 +100,9 @@ enum usb_chg_type {
>   /**
>    * struct msm_otg_platform_data - platform device data
>    *              for msm_otg driver.
> - * @phy_init_seq: PHY configuration sequence. val, reg pairs
> - *              terminated by -1.
> + * @phy_init_seq: PHY configuration sequence values. Value of -1 is reserved as
> + *              "do not overwrite default vaule at this address".
> + * @phy_init_sz: PHY configuration sequence size.
>    * @vbus_power: VBUS power on/off routine.
>    * @power_budget: VBUS power budget in mA (0 will be treated as 500mA).
>    * @mode: Supported mode (OTG/peripheral/host).
> @@ -109,6 +110,7 @@ enum usb_chg_type {
>    */
>   struct msm_otg_platform_data {
>   	int *phy_init_seq;
> +	int phy_init_sz;
>   	void (*vbus_power)(bool on);
>   	unsigned power_budget;
>   	enum usb_dr_mode mode;
> --
---]

I think, this changeset should be a new patch.

thanks,
srini
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html
>
