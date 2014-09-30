Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaI3WOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:14:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43089 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaI3WOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:14:38 -0400
Message-ID: <542B2B4A.7060002@codeaurora.org>
Date: Tue, 30 Sep 2014 16:14:34 -0600
From: Jeffrey Hugo <jhugo@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>
CC: Suman Anna <s-anna@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Eric Holmberg <eholmber@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: [PATCH v4] hwspinlock: qcom: Add support for Qualcomm HW Mutex
 block
References: <1412051728-3289-1-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1412051728-3289-1-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/29/2014 10:35 PM, Bjorn Andersson wrote:
> From: Kumar Gala <galak@codeaurora.org>
>
> Add driver for Qualcomm Hardware Mutex block that exists on newer
> Qualcomm SoCs.
>
> Cc: Jeffrey Hugo <jhugo@codeaurora.org>
> Cc: Eric Holmberg <eholmber@codeaurora.org>
> Cc: Courtney Cavin <courtney.cavin@sonymobile.com>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> [bjorn: added pm_runtime calls, from Courtney,
> 	added sfpb-mutex compatible,
> 	updated DT binding documentation formatting,
> 	replaced msm prefix with qcom,
> 	cleaned up includes]
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>
> We need this driver to add support for the shared memory manager, so I'm
> reviving Kumars patch from a year ago, with some additional sprinkles on top.
>
> Changes since v3:
>   - Reverted back to getting stride from of_match, per Kumars request
>
> Changes since v2:
>   - MODULE_DEVICE_TABLE
>   - Changed prefix to qcom
>   - Cleaned up includes
>   - Rely on reg and num-locks to figure out stride, instead of of_match data
>
> Changes since v1:
>   - Added the pm_runtime calls needed to be able to boot a kernel with
>     pm_runtime and this driver, patch from Courtney.
>   - Added sfpb-mutex compatible, for re-use of the driver in family A platforms.
>   - Updated formatting of DT binding documentation, while adding the extra
>     compatible.
>   - Dropped Stephen Boyds Reviewed-by due to these changes.
>   .../devicetree/bindings/hwlock/qcom-hwspinlock.txt |   35 +++++
>   drivers/hwspinlock/Kconfig                         |   11 ++
>   drivers/hwspinlock/Makefile                        |    1 +
>   drivers/hwspinlock/qcom_hwspinlock.c               |  151 ++++++++++++++++++++
>   4 files changed, 198 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt
>   create mode 100644 drivers/hwspinlock/qcom_hwspinlock.c
>

<snip>

> +static int qcom_hwspinlock_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	const struct of_device_id *match;
> +	struct hwspinlock_device *bank;
> +	struct hwspinlock *hwlock;
> +	struct resource *res;
> +	void __iomem *iobase;
> +	unsigned stride, i;
> +	size_t array_size;
> +	u32 num_locks;
> +	int ret;
> +
> +	match = of_match_device(qcom_hwspinlock_of_match, &pdev->dev);
Didn't this have error handling in v2?
> +
> +	ret = of_property_read_u32(node, "qcom,num-locks", &num_locks);
> +	if (ret || num_locks == 0)
> +		return -ENODEV;
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mutex-base");
> +	iobase = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(iobase))
> +		return PTR_ERR(iobase);
> +
> +	array_size = num_locks * sizeof(*hwlock);
> +	bank = devm_kzalloc(&pdev->dev, sizeof(*bank) + array_size, GFP_KERNEL);
> +	if (!bank)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, bank);
> +
> +	stride = (unsigned)match->data;
> +	for (i = 0, hwlock = &bank->lock[0]; i < num_locks; i++, hwlock++)
> +		hwlock->priv = iobase + i * stride;
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	ret = hwspin_lock_register(bank, &pdev->dev, &qcom_hwspinlock_ops,
> +						BASE_ID, num_locks);
> +	if (ret)
> +		pm_runtime_disable(&pdev->dev);
> +
> +	return ret;
> +}
> +
> +static int qcom_hwspinlock_remove(struct platform_device *pdev)
> +{
> +	struct hwspinlock_device *bank = platform_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = hwspin_lock_unregister(bank);
> +	if (ret) {
> +		dev_err(&pdev->dev, "%s failed: %d\n", __func__, ret);
> +		return ret;
> +	}
> +
> +	pm_runtime_disable(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver qcom_hwspinlock_driver = {
> +	.probe		= qcom_hwspinlock_probe,
> +	.remove		= qcom_hwspinlock_remove,
> +	.driver		= {
> +		.name	= "qcom_hwspinlock",
> +		.of_match_table = qcom_hwspinlock_of_match,
> +	},
> +};
> +
> +static int __init qcom_hwspinlock_init(void)
> +{
> +	return platform_driver_register(&qcom_hwspinlock_driver);
> +}
> +/* board init code might need to reserve hwspinlocks for predefined purposes */
> +postcore_initcall(qcom_hwspinlock_init);
> +
> +static void __exit qcom_hwspinlock_exit(void)
> +{
> +	platform_driver_unregister(&qcom_hwspinlock_driver);
> +}
> +module_exit(qcom_hwspinlock_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Hardware spinlock driver for Qualcomm SoCs");
> +MODULE_AUTHOR("Kumar Gala <galak@codeaurora.org>");
> +MODULE_AUTHOR("Jeffrey Hugo <jhugo@codeaurora.org>");
> +MODULE_AUTHOR("Eric Holmberg <eholmber@codeaurora.org>");
>


Jeffrey Hugo
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation.
