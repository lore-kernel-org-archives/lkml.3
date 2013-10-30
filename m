Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3J3SFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:05:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47968 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3J3SFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:05:38 -0400
Date: Wed, 30 Oct 2013 11:05:36 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH v3 04/10] spmi: Add MSM PMIC Arbiter SPMI controller
Message-ID: <20131030180536.GI21983@codeaurora.org>
References: <cover.1382985169.git.joshc@codeaurora.org>
 <7467ed718314cb98c9e40f135e9926cf14ed218b.1382985169.git.joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7467ed718314cb98c9e40f135e9926cf14ed218b.1382985169.git.joshc@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28, Josh Cartwright wrote:
> +
> +/**
> + * pa_write_data: write 1..4 bytes from buf to pmic-arb's register
> + * @bc byte-count -1. range: 0..3
> + * @reg register's address
> + * @buf buffer to write. length must be bc+1

Missing colon between variable and description.

> + */
> +static void
> +pa_write_data(struct spmi_pmic_arb_dev *dev, const u8 *buf, u32 reg, u8 bc)
> +{
> +	u32 data = 0;
> +	memcpy(&data, buf, (bc & 3) + 1);
> +	pmic_arb_base_write(dev, reg, data);
> +}
> +
[...]
> +static int pmic_arb_read_cmd(struct spmi_controller *ctrl,
> +			     u8 opc, u8 sid, u16 addr, u8 bc, u8 *buf)
> +{
> +	struct spmi_pmic_arb_dev *pmic_arb = spmi_controller_get_drvdata(ctrl);
> +	unsigned long flags;
> +	u32 cmd;
> +	int rc;
> +
> +	if (bc >= PMIC_ARB_MAX_TRANS_BYTES) {
> +		dev_err(&ctrl->dev,
> +			"pmic-arb supports 1..%d bytes per trans, but:%d requested",

Nitpick: Please replace the colon between but and %d with a space.

> +			PMIC_ARB_MAX_TRANS_BYTES, bc+1);

Space around that '+' please.

> +		return  -EINVAL;
> +	}
> +	dev_dbg(&ctrl->dev,
> +		"op:0x%x sid:%d bc:%d addr:0x%x\n", opc, sid, bc, addr);
> +
> +	/* Check the opcode */
> +	if (opc >= 0x60 && opc <= 0x7F)
> +		opc = PMIC_ARB_OP_READ;
> +	else if (opc >= 0x20 && opc <= 0x2F)
> +		opc = PMIC_ARB_OP_EXT_READ;
> +	else if (opc >= 0x38 && opc <= 0x3F)
> +		opc = PMIC_ARB_OP_EXT_READL;
> +	else
> +		return -EINVAL;
> +
> +	cmd = (opc << 27) | ((sid & 0xf) << 20) | (addr << 4) | (bc & 0x7);
> +
> +	spin_lock_irqsave(&pmic_arb->lock, flags);
> +	pmic_arb_base_write(pmic_arb, PMIC_ARB_CMD(pmic_arb->channel), cmd);
> +	rc = pmic_arb_wait_for_done(ctrl);
> +	if (rc)
> +		goto done;
> +
> +	/* Read from FIFO, note 'bc' is actually number of bytes minus 1 */
> +	pa_read_data(pmic_arb, buf, PMIC_ARB_RDATA0(pmic_arb->channel)
> +							, min_t(u8, bc, 3));

Nitpick: Weird comma starting a line here.

> +
> +	if (bc > 3)
> +		pa_read_data(pmic_arb, buf + 4,
> +				PMIC_ARB_RDATA1(pmic_arb->channel), bc - 4);
> +
> +done:
> +	spin_unlock_irqrestore(&pmic_arb->lock, flags);
> +	return rc;
> +}
> +
[...]
> +static int spmi_pmic_arb_probe(struct platform_device *pdev)
> +{
> +	struct spmi_pmic_arb_dev *pa;
> +	struct spmi_controller *ctrl;
> +	struct resource *res;
> +	int err, i;
> +
> +	ctrl = spmi_controller_alloc(&pdev->dev, sizeof(*pa));
> +	if (!ctrl)
> +		return -ENOMEM;
> +
> +	pa = spmi_controller_get_drvdata(ctrl);
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "core");
> +	pa->base = devm_ioremap_resource(&ctrl->dev, res);
> +	if (IS_ERR(pa->base)) {
> +		err = PTR_ERR(pa->base);
> +		goto err_put_ctrl;
> +	}
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "intr");
> +	pa->intr = devm_ioremap_resource(&ctrl->dev, res);
> +	if (IS_ERR(pa->intr)) {
> +		err = PTR_ERR(pa->intr);
> +		goto err_put_ctrl;
> +	}
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cnfg");
> +	pa->cnfg = devm_ioremap_resource(&ctrl->dev, res);
> +	if (IS_ERR(pa->cnfg)) {
> +		err = PTR_ERR(pa->cnfg);
> +		goto err_put_ctrl;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(pa->mapping_table); ++i)
> +		pa->mapping_table[i] = readl_relaxed(
> +				pa->cnfg + SPMI_MAPPING_TABLE_REG(i));
> +
> +	platform_set_drvdata(pdev, ctrl);
> +	spin_lock_init(&pa->lock);
> +
> +	pa->channel = 0;
> +	pa->max_apid = 0;
> +	pa->min_apid = PMIC_ARB_MAX_PERIPHS - 1;

That looks backwards. Is this right?

> +
> +	ctrl->cmd = pmic_arb_cmd;
> +	ctrl->read_cmd = pmic_arb_read_cmd;
> +	ctrl->write_cmd = pmic_arb_write_cmd;
> +
> +	err = spmi_controller_add(ctrl);
> +	if (err)
> +		goto err_put_ctrl;
> +
> +	dev_dbg(&ctrl->dev, "PMIC Arb Version 0x%x\n",
> +		pmic_arb_base_read(pa, PMIC_ARB_VERSION));
> +
> +	return 0;
> +
> +err_put_ctrl:
> +	spmi_controller_put(ctrl);
> +	return err;
> +}
> +
> +static int __exit spmi_pmic_arb_remove(struct platform_device *pdev)

__exit shouldn't be here. We want this function in modules.

> +{
> +	struct spmi_controller *ctrl = platform_get_drvdata(pdev);
> +	spmi_controller_remove(ctrl);
> +	return 0;
> +}
> +
> +static struct of_device_id spmi_pmic_arb_match_table[] = {
> +	{	.compatible = "qcom,spmi-pmic-arb", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, spmi_pmic_arb_match_table);
> +
> +static struct platform_driver spmi_pmic_arb_driver = {
> +	.probe		= spmi_pmic_arb_probe,
> +	.remove		= __exit_p(spmi_pmic_arb_remove),

Please drop this __exit_p() usage as well.

> +	.driver		= {
> +		.name	= "spmi_pmic_arb",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = spmi_pmic_arb_match_table,
> +	},
> +};
> +module_platform_driver(spmi_pmic_arb_driver);

MODULE_LICENSE()
MODULE_ALIAS()
?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
