Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbaJHIka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:40:30 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:46705 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaJHIkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:40:24 -0400
Date: Wed, 8 Oct 2014 09:40:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC 6/7] mfd: qcom-smd-rpm: Driver for the Qualcomm RPM over SMD
Message-ID: <20141008084017.GD20647@lee--X1>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1412037291-16880-7-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412037291-16880-7-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014, Bjorn Andersson wrote:

> Driver for the Resource Power Manager (RPM) found in Qualcomm 8974 based
> devices.
> The driver exposes resources that child drivers can operate on; to
> implementing regulator, clock and bus frequency drivers.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
> 
> Note that the qcom_rpm_smd_write is equivalent of qcom_rpm_write and there is a
> possibility of re-using at least the clock implementation on top of this. This
> would however require some logic for calling the right implementation so I have
> not done it at this time to keep things as clean as possible.
> 
> An idea for improvement is that in qcom_rpm_smd_write we put the ack_status and
> completion on the stack and register this with idr using the message id, upon
> receiving the interrupt we would find the right client and complete this.
> Allowing for multiple requests to be in flight at any given time.
> 
> I did not implement this because I haven't done any measurements on what kind
> of improvements this could give and it would be a clean iteration ontop of
> this.
> 
>  drivers/mfd/Kconfig              |   14 ++
>  drivers/mfd/Makefile             |    1 +
>  drivers/mfd/qcom-smd-rpm.c       |  299 ++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/qcom-smd-rpm.h |    9 ++
>  4 files changed, 323 insertions(+)
>  create mode 100644 drivers/mfd/qcom-smd-rpm.c
>  create mode 100644 include/linux/mfd/qcom-smd-rpm.h


> +#define RPM_ERR_INVALID_RESOURCE "resource does not exist"
> +
> +static bool qcom_rpm_msg_is_invalid_resource(struct qcom_rpm_message *msg)
> +{
> +	size_t msg_len = sizeof(RPM_ERR_INVALID_RESOURCE) - 1;
> +
> +	if (msg->length != msg_len)
> +		return false;
> +
> +	if (memcmp(msg->message, RPM_ERR_INVALID_RESOURCE, msg_len))
> +		return false;
> +
> +	return true;
> +}

You can save yourself a hell of a lot of code by just doing:

if (memcmp(msg->message, RPM_ERR_INVALID_RESOURCE,
           min(msg_len, sizeof(RPM_ERR_INVALID_RESOURCE))))

... in qcom_smd_rpm_callback().

[...]

> +static int qcom_smd_rpm_probe(struct qcom_smd_device *sdev)
> +{
> +	const struct of_device_id *match;
> +	struct qcom_smd_rpm *rpm;
> +
> +	rpm = devm_kzalloc(&sdev->dev, sizeof(*rpm), GFP_KERNEL);
> +	if (!rpm)
> +		return -ENOMEM;
> +
> +	rpm->dev = &sdev->dev;
> +	mutex_init(&rpm->lock);
> +	init_completion(&rpm->ack);
> +
> +	match = of_match_device(qcom_smd_rpm_of_match, &sdev->dev);

You need to check the return value here.

> +	rpm->data = match->data;
> +	rpm->rpm_channel = sdev->channel;
> +
> +	dev_set_drvdata(&sdev->dev, rpm);
> +
> +	dev_info(&sdev->dev, "Qualcomm SMD RPM driver probed\n");

Please remove this line.

> +	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
> +}
> +
> +static void qcom_smd_rpm_remove(struct qcom_smd_device *sdev)
> +{
> +	dev_set_drvdata(&sdev->dev, NULL);

If you use the proper platform device interface you don't have to do
this.

> +	of_platform_depopulate(&sdev->dev);
> +}
> +
> +static struct qcom_smd_driver qcom_smd_rpm_driver = {
> +	.probe = qcom_smd_rpm_probe,
> +	.remove = qcom_smd_rpm_remove,
> +	.callback = qcom_smd_rpm_callback,
> +	.driver  = {
> +		.name  = "qcom_smd_rpm",
> +		.owner = THIS_MODULE,
> +		.of_match_table = qcom_smd_rpm_of_match,
> +	},
> +};
> +
> +module_qcom_smd_driver(qcom_smd_rpm_driver);

I don't like this.  What's wrong with the existing platform driver
code?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
