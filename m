Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3CRK6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:58:15 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:50798 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3CRK6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:58:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x=narPBYBNMMs5Qw_rGSgVsSNumb_jw_88C1PNGEc6sSEw@mail.gmail.com>
References: <1363082299-10561-1-git-send-email-amit.daniel@samsung.com>
	<1363082299-10561-2-git-send-email-amit.daniel@samsung.com>
	<CAOh2x=narPBYBNMMs5Qw_rGSgVsSNumb_jw_88C1PNGEc6sSEw@mail.gmail.com>
Date: Mon, 18 Mar 2013 16:28:10 +0530
Message-ID: <CADGdYn5eghg4yyvKJVY+cs0=5KVALxvcUEWYPp=NB4=ZChdqkA@mail.gmail.com>
Subject: Re: [PATCH V4 1/4] cpufreq: exynos: Adding cpufreq driver for exynos5440
From: amit kachhap <amit.kachhap@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Tue, Mar 12, 2013 at 4:19 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> This is what Russell told me a long time back:
> "Don't use Adding, Fixing, etc words as this work is not something, which is
> already done."
>
> So your subject should have been: "cpufreq: exynos: Add cpufreq driver
> for exynos5440"
ok right.
>
> Fix it if you need another version, which i believe you do :)
yes no escape now :)
>
> On Tue, Mar 12, 2013 at 5:58 PM, Amit Daniel Kachhap
> <amit.daniel@samsung.com> wrote:
>> This patch adds dvfs support for exynos5440 SOC. This soc has 4 cores and
>> they scale at same frequency. The nature of exynos5440 clock controller is
>> different from previous exynos controllers so not using the common exynos
>> cpufreq framework. The major difference being interrupt notfication for
>
> s/notfication/notification
ok
>
>> frequency change. Also, OPP library is used for device tree parsing to get
>> different parameters like frequency, voltage etc. Since the opp library sorts
>> the frequency table in ascending order so they are again re-arranged in
>> descending order. This will have one-to-one mapping with the clock controller
>> state management logic.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  .../bindings/cpufreq/cpufreq-exynos5440.txt        |   29 ++
>>  drivers/cpufreq/Kconfig.arm                        |    9 +
>>  drivers/cpufreq/Makefile                           |    1 +
>>  drivers/cpufreq/exynos5440-cpufreq.c               |  466 ++++++++++++++++++++
>>  4 files changed, 505 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
>>  create mode 100644 drivers/cpufreq/exynos5440-cpufreq.c
>>
>> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
>> new file mode 100644
>> index 0000000..a0dbe0b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
>> @@ -0,0 +1,29 @@
>> +
>> +Exynos5440 cpufreq driver
>> +-------------------
>> +
>> +Exynos5440 SoC cpufreq driver for CPU frequency scaling.
>> +
>> +Required properties:
>> +- interrupts: Interrupt to know the completion of cpu frequency change.
>> +- operating-points: Table of frequencies and voltage CPU could be transitioned into,
>> +       in the decreasing order. Frequency should be in KHZ units and voltage
>
> s/KHZ/KHz
ok
>
>> +       should be in microvolts.
>
> probably s/microvolts/micro-volts ??
>
>> +
>> +Optional properties:
>> +- clock-latency: Clock monitor latency in microsecond.
>> +
>> +All the required listed above must be defined under node cpufreq.
>> +
>> +Example:
>> +--------
>> +       cpufreq@160000 {
>> +               compatible = "samsung,exynos5440-cpufreq";
>> +               reg = <0x160000 0x1000>;
>> +               interrupts = <0 57 0>;
>> +               operating-points = <
>> +                               1000000 975000
>> +                               800000  925000>;
>> +               clock-latency = <100000>;
>> +       };
>> +
>
>> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
>> +static void exynos_enable_dvfs(void)
>> +{
>
>> +       /* Set initial performance index */
>> +       for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
>> +               if (freq_table[i].frequency == dvfs_info->cur_frequency)
>> +                       break;
>> +
>> +       if (freq_table[i].frequency == CPUFREQ_TABLE_END) {
>> +               dev_crit(dvfs_info->dev, "Boot up frequency not supported\n");
>> +               /* Assign the highest frequency */
>> +               i = 0;
>> +               dvfs_info->cur_frequency = freq_table[i].frequency;
>
> What about:
>
> dvfs_info->cur_frequency = freq_table[0].frequency;
>
> as i don't see i being used again?
No It is used below for frequency setting.
>
>> +       }
>
>> +}
>
>> +static int exynos_target(struct cpufreq_policy *policy,
>> +                         unsigned int target_freq,
>> +                         unsigned int relation)
>> +{
>
>> +       if (cpufreq_frequency_table_target(policy, freq_table,
>> +                                          target_freq, relation, &index)) {
>> +               ret = -EINVAL;
>
> Use the error value returned by called functions, probably i gave this
> comment last time too?
yes my mistake.
>
>> +               goto out;
>> +       }
>
>> +}
>
>> +static void exynos_sort_descend_freq_table(void)
>> +{
>> +       struct cpufreq_frequency_table *freq_tbl = dvfs_info->freq_table;
>> +       int i = 0, index;
>> +       unsigned int tmp_freq;
>> +
>> +       /*
>> +        * Freq table is already in ascending order as it is created from
>> +        * OPP library, so just swap the elements to make it descending.
>
> why??
I explained this requirement in the patch commit. Will explain it here again.
>
>> +        */
>> +       for (i = 0; i < dvfs_info->freq_count / 2; i++) {
>> +               index = dvfs_info->freq_count - i - 1;
>> +               tmp_freq = freq_tbl[i].frequency;
>> +               freq_tbl[i].frequency = freq_tbl[index].frequency;
>> +               freq_tbl[index].frequency = tmp_freq;
>> +       }
>> +}
>> +
>
>> +static int exynos_cpufreq_probe(struct platform_device *pdev)
>> +{
>> +       int ret = -EINVAL;
>> +       struct device_node *np;
>> +       struct resource res;
>> +
>> +       np =  of_find_compatible_node(NULL, NULL, "samsung,exynos5440-cpufreq");
>> +       if (!np)
>> +               return -ENODEV;
>> +
>> +       dvfs_info = devm_kzalloc(&pdev->dev, sizeof(*dvfs_info), GFP_KERNEL);
>> +       if (!dvfs_info) {
>> +               ret = -ENOMEM;
>> +               goto err_put_node;
>> +       }
>> +
>> +       dvfs_info->dev = &pdev->dev;
>> +       dvfs_info->dev->of_node = np;
>> +
>> +       ret = of_address_to_resource(np, 0, &res);
>> +       if (ret)
>> +               goto err_put_node;
>> +
>> +       dvfs_info->base = devm_ioremap_resource(dvfs_info->dev, &res);
>> +       if (IS_ERR(dvfs_info->base)) {
>> +               ret = PTR_ERR(dvfs_info->base);
>> +               goto err_put_node;
>> +       }
>> +
>> +       dvfs_info->irq = irq_of_parse_and_map(np, 0);
>> +       if (dvfs_info->irq == 0) {
>
> maybe, if (!dvfs_info->irq) {
ok

Thanks,
Amit Daniel
>
>
>> +               dev_err(dvfs_info->dev, "No cpufreq irq found\n");
>> +               ret = -ENODEV;
>> +               goto err_put_node;
>> +       }
>> +
>> +       ret = of_init_opp_table(dvfs_info->dev);
>> +       if (ret) {
>> +               dev_err(dvfs_info->dev, "failed to init OPP table: %d\n", ret);
>> +               goto err_put_node;
>> +       }
>> +
>> +       ret = opp_init_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
>> +       if (ret) {
>> +               dev_err(dvfs_info->dev,
>> +                       "failed to init cpufreq table: %d\n", ret);
>> +               goto err_put_node;
>> +       }
>> +       dvfs_info->freq_count = opp_get_opp_count(dvfs_info->dev);
>> +       exynos_sort_descend_freq_table();
>> +
>> +       if (of_property_read_u32(np, "clock-latency", &dvfs_info->latency))
>> +               dvfs_info->latency = DEF_TRANS_LATENCY;
>> +
>> +       dvfs_info->cpu_clk = devm_clk_get(dvfs_info->dev, "armclk");
>> +       if (IS_ERR(dvfs_info->cpu_clk)) {
>> +               dev_err(dvfs_info->dev, "Failed to get cpu clock\n");
>> +               ret = PTR_ERR(dvfs_info->cpu_clk);
>> +               goto err_free_table;
>> +       }
>> +
>> +       dvfs_info->cur_frequency = clk_get_rate(dvfs_info->cpu_clk);
>> +       if (!dvfs_info->cur_frequency) {
>> +               dev_err(dvfs_info->dev, "Failed to get clock rate\n");
>> +               ret = -EINVAL;
>> +               goto err_free_table;
>> +       }
>> +       dvfs_info->cur_frequency /= 1000;
>> +
>> +       INIT_WORK(&dvfs_info->irq_work, exynos_cpufreq_work);
>> +       ret = devm_request_irq(dvfs_info->dev, dvfs_info->irq,
>> +                               exynos_cpufreq_irq, IRQF_TRIGGER_NONE,
>> +                               CPUFREQ_NAME, dvfs_info);
>> +       if (ret) {
>> +               dev_err(dvfs_info->dev, "Failed to register IRQ\n");
>> +               goto err_free_table;
>> +       }
>> +
>> +       ret = init_div_table();
>> +       if (ret) {
>> +               dev_err(dvfs_info->dev, "Failed to initialise div table\n");
>> +               goto err_free_table;
>> +       }
>> +
>> +       exynos_enable_dvfs();
>> +       ret = cpufreq_register_driver(&exynos_driver);
>> +       if (ret) {
>> +               dev_err(dvfs_info->dev,
>> +                       "%s: failed to register cpufreq driver\n", __func__);
>> +               goto err_free_table;
>> +       }
>> +
>> +       of_node_put(np);
>> +       dvfs_info->dvfs_enabled = true;
>> +       return 0;
>> +
>> +err_free_table:
>> +       opp_free_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
>> +err_put_node:
>> +       of_node_put(np);
>> +       dev_err(dvfs_info->dev, "%s: failed initialization\n", __func__);
>> +       return ret;
>> +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
