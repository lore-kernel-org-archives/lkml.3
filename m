Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaKESLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:11:54 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37235 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaKESLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:11:51 -0500
MIME-Version: 1.0
In-Reply-To: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
Date: Wed, 5 Nov 2014 10:11:50 -0800
Message-ID: <CAJAp7OgU64=KCuDhYEZTYppVeBz6wKvTDsof5vDRznfdZgAfZw@mail.gmail.com>
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
From: Bjorn Andersson <bjorn@kryo.se>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 5:33 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
[..]
> @@ -28,11 +144,27 @@ static int pmic_spmi_probe(struct spmi_device *sdev)
>  {
>         struct device_node *root = sdev->dev.of_node;
>         struct regmap *regmap;
> +       struct property *prop;
> +       int major, minor, ret;
> +       char *name, compatible[32];
>
>         regmap = devm_regmap_init_spmi_ext(sdev, &spmi_regmap_config);
>         if (IS_ERR(regmap))
>                 return PTR_ERR(regmap);
>
> +       ret = pmic_spmi_read_revid(regmap, &name, &major, &minor);
> +       if (!ret) {
> +               snprintf(compatible, ARRAY_SIZE(compatible), "qcom,%s-v%d.%d",
> +                        name, major, minor);
> +               prop = kzalloc(sizeof(*prop), GFP_KERNEL);
> +               if (prop) {
> +                       prop->name = kstrdup("compatible", GFP_KERNEL);
> +                       prop->value = kstrdup(compatible, GFP_KERNEL);
> +                       prop->length = strlen(prop->value);
> +                       of_update_property(root, prop);
> +               }
> +       }
> +

Why would you do this?
What benefit does it give to patch the of_node to have a more specific
compatible?

It is no longer matching any compatible defined in the kernel and is
anyone actually looking at this?

Reading out the revid information and providing that in some way to
the children could be beneficial, except for qpnp already giving you
this version information per block.

[..]
> @@ -45,7 +177,17 @@ static const struct of_device_id pmic_spmi_id_table[] = {
>         { .compatible = "qcom,spmi-pmic" },
>         { .compatible = "qcom,pm8941" },
>         { .compatible = "qcom,pm8841" },
> +       { .compatible = "qcom,pm8019" },
> +       { .compatible = "qcom,pm8226" },
> +       { .compatible = "qcom,pm8110" },
>         { .compatible = "qcom,pma8084" },
> +       { .compatible = "qcom,pmi8962" },
> +       { .compatible = "qcom,pmd9635" },
> +       { .compatible = "qcom,pm8994" },
> +       { .compatible = "qcom,pmi8994" },
> +       { .compatible = "qcom,pm8916" },
> +       { .compatible = "qcom,pm8004" },
> +       { .compatible = "qcom,pm8909" },
>         { }

This part is good, please send this out on it's own.

Regards,
Bjorn
