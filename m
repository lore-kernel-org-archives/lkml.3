Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaHVB15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:27:57 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:13098 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755514AbaHVB1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:27:55 -0400
Date: Thu, 21 Aug 2014 18:27:49 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] mfd: qcom-rpm: Driver for the Qualcomm RPM
Message-ID: <20140822012748.GB12494@sonymobile.com>
References: <1407796988-25872-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1407796988-25872-3-git-send-email-bjorn.andersson@sonymobile.com>
 <20140821132204.GH4266@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140821132204.GH4266@lee--X1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21 Aug 06:22 PDT 2014, Lee Jones wrote:
> > diff --git a/drivers/mfd/qcom_rpm.c b/drivers/mfd/qcom_rpm.c
> > +static const struct qcom_rpm_data msm8660_template = {
> > +	.version = -1,
> 
> -1?
> 

2 would be a better number...

> > +	.resource_table = msm8660_rpm_resource_table,
> > +	.n_resources = ARRAY_SIZE(msm8660_rpm_resource_table),
> > +};
> 
> [...]
> 
> > +struct qcom_rpm *dev_get_qcom_rpm(struct device *dev)
> > +{
> > +	return dev_get_drvdata(dev);
> > +}
> > +EXPORT_SYMBOL(dev_get_qcom_rpm);
> 
> No need for this at all.  Use dev_get_drvdata() direct instead.
> 

I see that others have put this as static inline in the header file, so I will
follow that. I don't want to expose this directly in the implementation of the
clients.

Let me know if you object.

> [...]
> 
> > +static int qcom_rpm_probe(struct platform_device *pdev)
> > +{
[...]
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	rpm->status_regs = devm_ioremap_resource(&pdev->dev, res);
> > +	rpm->ctrl_regs = rpm->status_regs + 0x400;
> > +	rpm->req_regs = rpm->status_regs + 0x600;
> > +	if (IS_ERR(rpm->status_regs))
> > +		return PTR_ERR(rpm->status_regs);
> 
> You should probably do this _before_ using it above.
> 

There's no difference in behaviour, but it just feels cleaner than:

res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
rpm->status_regs = devm_ioremap_resource(&pdev->dev, res);
if (IS_ERR(rpm->status_regs))
	return PTR_ERR(rpm->status_regs);
rpm->ctrl_regs = rpm->status_regs + 0x400;
rpm->req_regs = rpm->status_regs + 0x600;

If you don't like it, I'll change it.

[...]
> > +
> > +	writel(fw_version[0], RPM_CTRL_REG(rpm, 0));
> > +	writel(fw_version[1], RPM_CTRL_REG(rpm, 1));
> > +	writel(fw_version[2], RPM_CTRL_REG(rpm, 2));
> 
> A comment documenting what this is doing would be helpful here.
> 

Sounds reasonable, this seems to be incorrect now that I had to investigate
what's really happening. So I'll update it.

[...]
> > +}
> > +
> > +static int qcom_rpm_remove_child(struct device *dev, void *unused)
> > +{
> > +	platform_device_unregister(to_platform_device(dev));
> > +	return 0;
> > +}
> > +
> > +static int qcom_rpm_remove(struct platform_device *pdev)
> > +{
> > +	device_for_each_child(&pdev->dev, NULL, qcom_rpm_remove_child);
> 
> of_platform_depopulate()?
> 

Forgot that we had that now, will update.

> > +	return 0;
> > +}
> > +
> > +static struct platform_driver qcom_rpm_driver = {
> > +	.probe = qcom_rpm_probe,
> > +	.remove = qcom_rpm_remove,
> > +	.driver  = {
> > +		.name  = "qcom_rpm",
> > +		.owner = THIS_MODULE,
> 
> Remove this line, it's taken care of for you.
> 

OK

> > +		.of_match_table = qcom_rpm_of_match,
> > +	},
> > +};
> > +
> > +static int __init qcom_rpm_init(void)
> > +{
> > +	return platform_driver_register(&qcom_rpm_driver);
> > +}
> > +arch_initcall(qcom_rpm_init);
> > +
> > +static void __exit qcom_rpm_exit(void)
> > +{
> > +	platform_driver_unregister(&qcom_rpm_driver);
> > +}
> > +module_exit(qcom_rpm_exit)
> > +
> > +MODULE_DESCRIPTION("Qualcomm Resource Power Manager driver");
> > +MODULE_LICENSE("GPL v2");
> 
> No one authored this driver?
> 

Thought that was optional, will update.


Thanks for the review!

Regards,
Bjorn
