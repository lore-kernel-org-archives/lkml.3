Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaLWDk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:40:26 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:56411 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaLWDkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:40:23 -0500
MIME-Version: 1.0
In-Reply-To: <1419304697-14789-4-git-send-email-cw00.choi@samsung.com>
References: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
	<1419304697-14789-4-git-send-email-cw00.choi@samsung.com>
Date: Tue, 23 Dec 2014 09:10:20 +0530
Message-ID: <CAEUmHyYnb8_HNnuz8BLhMOh01+gpXfTv63P-ubYE1DK9uptonA@mail.gmail.com>
Subject: Re: [PATCHv5 3/9] devfreq: event: Add exynos-ppmu devfreq-event driver
From: Varka Bhadram <varkabhadram@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kgene.kim@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>, rafael.j.wysocki@intel.com,
        Mark Rutland <mark.rutland@arm.com>, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, k.kozlowski@samsung.com, inki.dae@samsung.com,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 8:48 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch adds exynos-ppmu devfreq-event driver to get performance data
> of each IP for Samsung Exynos SoC. These event from Exynos PPMU provide
> useful information about the behavior of the SoC that you can use when
> analyzing system performance, and made visible and can be counted using
> logic in each IP.
>
> This patch is based on existing drivers/devfreq/exynos/exynos-ppmu.c
>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

(...)
> +static int exynos_ppmu_parse_dt(struct exynos_ppmu_data *data)
> +{
> +       struct device *dev = data->dev;
> +       struct device_node *np = dev->of_node;
> +       int ret = 0;
> +
> +       if (!np) {
> +               dev_err(dev, "failed to find devicetree node\n");
> +               return -EINVAL;
> +       }
> +
> +       /* Maps the memory mapped IO to control PPMU register */
> +       data->ppmu.base = of_iomap(np, 0);
> +       if (IS_ERR_OR_NULL(data->ppmu.base)) {
> +               dev_err(dev, "failed to map memory region\n");
> +               return -EINVAL;
-ENOMEM or -ENXIO is the proper error return value..?

> +       }
> +
> +       data->clk_ppmu = devm_clk_get(dev, "ppmu");
> +       if (IS_ERR(data->clk_ppmu)) {
> +               data->clk_ppmu = NULL;
> +               dev_warn(dev, "failed to get PPMU clock\n");
> +       }
If PPMU clk get fails..?  return PTR_ERR(data->clk_ppmu)
> +
> +       ret = of_get_devfreq_events(np, data);
> +       if (ret < 0) {
> +               dev_err(dev, "failed to parse exynos ppmu dt node\n");
> +               goto err;
> +       }
> +
> +       return 0;
> +
> +err:
> +       iounmap(data->ppmu.base);
> +
> +       return ret;
> +}
> +
> +static int exynos_ppmu_probe(struct platform_device *pdev)
> +{
> +       struct exynos_ppmu_data *data;
> +       struct devfreq_event_dev **edev;
> +       struct devfreq_event_desc *desc;
> +       int i, ret = 0, size;
> +
> +       data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       mutex_init(&data->lock);
> +       data->dev = &pdev->dev;
> +
> +       /* Parse dt data to get resource */
> +       ret = exynos_ppmu_parse_dt(data);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev,
> +                       "failed to parse devicetree for resource\n");
> +               return ret;
> +       }
> +       desc = data->desc;
> +
> +       size = sizeof(struct devfreq_event_dev *) * data->num_events;
> +       data->edev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
> +       if (!data->edev) {
> +               dev_err(&pdev->dev,
> +                       "failed to allocate memory devfreq-event devices\n");
> +               return -ENOMEM;
> +       }
> +       edev = data->edev;
> +       platform_set_drvdata(pdev, data);
> +
> +       for (i = 0; i < data->num_events; i++) {
> +               edev[i] = devfreq_event_add_edev(&pdev->dev, &desc[i]);
> +               if (IS_ERR(edev)) {
> +                       ret = PTR_ERR(edev);
> +                       dev_err(&pdev->dev,
> +                               "failed to add devfreq-event device\n");
> +                       goto err;
> +               }
> +       }
> +
> +       clk_prepare_enable(data->clk_ppmu);
> +
> +       return 0;
> +err:
> +       iounmap(data->ppmu.base);
> +
> +       return ret;
> +}
> +
> +static int exynos_ppmu_remove(struct platform_device *pdev)
> +{
> +       struct exynos_ppmu_data *data = platform_get_drvdata(pdev);
> +       int i, ret = 0;
> +
> +       for (i = 0; i < data->num_events; i++) {
> +               ret = devfreq_event_remove_edev(data->edev[i]);
> +               if (ret < 0) {
> +                       dev_err(&pdev->dev,
> +                               "failed to remove devfreq-event device\n");
> +                       goto err;
> +               }
> +       }
> +
> +err:
> +       clk_disable_unprepare(data->clk_ppmu);
> +       iounmap(data->ppmu.base);
> +
> +       return ret;
> +}
> +
> +static struct of_device_id exynos_ppmu_id_match[] = {
> +       { .compatible = "samsung,exynos-ppmu", },
> +       { /* sentinel */ },
> +};
> +
> +static struct platform_driver exynos_ppmu_driver = {
> +       .probe  = exynos_ppmu_probe,
> +       .remove = exynos_ppmu_remove,
> +       .driver = {
> +               .name   = "exynos-ppmu",
> +               .owner  = THIS_MODULE,
remove owner field. It will be populate by driver core.
> +               .of_match_table = exynos_ppmu_id_match,
> +       },
> +};
> +module_platform_driver(exynos_ppmu_driver);
> +
> +MODULE_DESCRIPTION("Exynos PPMU(Platform Performance Monitoring Unit) driver");
> +MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:exynos-ppmu");
> --
> 1.8.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks and Regards,
Varka Bhadram.
