Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaJUI7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:59:13 -0400
Received: from mail-bn1bon0115.outbound.protection.outlook.com ([157.56.111.115]:22635
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751730AbaJUI7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:59:06 -0400
From: Yuantian Tang <Yuantian.Tang@freescale.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: RE: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ
 platforms
Thread-Topic: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ
 platforms
Thread-Index: AQHP6bh2NIuvlhOTzUyj6ABxjLiyN5wz774AgAZVyiA=
Date: Tue, 21 Oct 2014 08:59:03 +0000
Message-ID: <6aaa50ef5f234fe2896f1c66eb646dfb@DM2PR03MB574.namprd03.prod.outlook.com>
References: <1413515616-15874-1-git-send-email-B29983@freescale.com>
 <CAKohpokotKSvQ13uU4MnCer+qzBUUbGVTd19y7xswCAEKk3nGQ@mail.gmail.com>
In-Reply-To: <CAKohpokotKSvQ13uU4MnCer+qzBUUbGVTd19y7xswCAEKk3nGQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB574;
x-forefront-prvs: 0371762FE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(51704005)(95666004)(105586002)(85852003)(120916001)(92566001)(106356001)(87936001)(106116001)(40100003)(64706001)(76576001)(86362001)(2656002)(99286002)(20776003)(101416001)(76176999)(66066001)(54356999)(33646002)(50986999)(110136001)(80022003)(108616004)(46102003)(97736003)(19580395003)(19580405001)(99396003)(85306004)(74316001)(31966008)(4396001)(21056001)(122556002)(107046002)(76482002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB574;H:DM2PR03MB574.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9L8xLri030312

> > -config PPC_CORENET_CPUFREQ
> > -       tristate "CPU frequency scaling driver for Freescale E500MC SoCs"
> > -       depends on PPC_E500MC && OF && COMMON_CLK
> > +config QORIQ_CPUFREQ
> > +       tristate "CPU frequency scaling driver for Freescale QorIQ SoCs"
> > +       depends on OF && COMMON_CLK
> >         select CLK_PPC_CORENET
> >         help
> > -         This adds the CPUFreq driver support for Freescale e500mc,
> > -         e5500 and e6500 series SoCs which are capable of changing
> > -         the CPU's frequency dynamically.
> > +         This adds the CPUFreq driver support for Freescale QorIQ SoCs
> > +         which are capable of changing the CPU's frequency dynamically.
> >
> >  config CPU_FREQ_PMAC
> >         bool "Support for Apple PowerBooks"
> 
> Don't need this duplication at all. Just move this to Kconfig instead of .arm and
> ppc.
> 
If I do so, menuconfig will display like this(on PPC):
	PowerPC CPU frequency scaling drivers  ----  
    QorIQ CPU Frequency scaling  --->    
  		<*> CPU frequency scaling driver for Freescale QorIQ SoCs
On ARM, there should be a similar problem.
Isn't weird?

Regards,
Yuantian
		
> > diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c
> > b/drivers/cpufreq/qoriq-cpufreq.c
> 
> >  /**
> >   * struct cpu_data - per CPU data struct @@ -69,9 +68,6 @@ static
> > const u32 *fmask;
> >
> >  static DEFINE_PER_CPU(struct cpu_data *, cpu_data);
> >
> > -/* cpumask in a cluster */
> > -static DEFINE_PER_CPU(cpumask_var_t, cpu_mask);
> > -
> >  #ifndef CONFIG_SMP
> >  static inline const struct cpumask *cpu_core_mask(int cpu)  { @@
> > -79,6 +75,79 @@ static inline const struct cpumask *cpu_core_mask(int
> > cpu)  }  #endif
> >
> > +#if defined(CONFIG_PPC_E500MC)
> > +static int get_cpu_physical_id(int cpu) {
> > +       return get_hard_smp_processor_id(cpu); } #elif
> > +defined(CONFIG_ARM)
> 
> Wouldn't a #else work here as there are just two platforms we are talking about ?
> 
> > +static int get_cpu_physical_id(int cpu) {
> > +       return topology_core_id(cpu);
> > +}
> > +#endif
> > +
> > +static u32 get_bus_freq(void)
> > +{
> > +       struct device_node *soc;
> > +       u32 sysfreq;
> > +
> > +       soc = of_find_node_by_type(NULL, "soc");
> > +       if (!soc)
> > +               return 0;
> > +
> > +       if (of_property_read_u32(soc, "bus-frequency", &sysfreq))
> > +               sysfreq = 0;
> > +
> > +       of_node_put(soc);
> > +
> > +       return sysfreq;
> > +}
> > +
> > +static struct device_node *cpu_to_clk_node(int cpu) {
> > +       struct device_node *np, *clk_np;
> > +
> > +       if (!cpu_present(cpu))
> > +               return NULL;
> > +
> > +       np = of_get_cpu_node(cpu, NULL);
> > +       if (!np)
> > +               return NULL;
> > +
> > +       clk_np = of_parse_phandle(np, "clocks", 0);
> > +       if (!clk_np)
> > +               return NULL;
> > +
> > +       of_node_put(np);
> > +
> > +       return clk_np;
> > +}
> > +
> > +/* traverse cpu nodes to get cpu mask of sharing clock wire */ static
> > +void set_affected_cpus(struct cpufreq_policy *policy) {
> > +       struct device_node *np, *clk_np;
> > +       struct cpumask *dstp = policy->cpus;
> > +       int i;
> > +
> > +       np = cpu_to_clk_node(policy->cpu);
> > +       if (!np)
> > +               return;
> > +
> > +       for_each_present_cpu(i) {
> > +               clk_np = cpu_to_clk_node(i);
> > +               if (!clk_np)
> > +                       continue;
> > +
> > +               if (clk_np == np)
> > +                       cpumask_set_cpu(i, dstp);
> 
> So you are depending on matching the clock-nodes from DT for getting this
> information, right ? There is nothing that the architecture gives?
> 
> > +
> > +               of_node_put(clk_np);
> > +       }
> > +       of_node_put(np);
> > +}
> > +
> >  /* reduce the duplicated frequencies in frequency table */  static
> > void freq_table_redup(struct cpufreq_frequency_table *freq_table,
> >                 int count)
> > @@ -105,6 +174,7 @@ static void freq_table_sort(struct
> cpufreq_frequency_table *freq_table,
> >         int i, j, ind;
> >         unsigned int freq, max_freq;
> >         struct cpufreq_frequency_table table;
> > +
> >         for (i = 0; i < count - 1; i++) {
> >                 max_freq = freq_table[i].frequency;
> >                 ind = i;
> > @@ -129,7 +199,7 @@ static void freq_table_sort(struct
> cpufreq_frequency_table *freq_table,
> >         }
> >  }
> >
> > -static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
> > +static int qoriq_cpufreq_cpu_init(struct cpufreq_policy *policy)
> >  {
> >         struct device_node *np;
> >         int i, count, ret;
> > @@ -145,10 +215,8 @@ static int corenet_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
> >                 return -ENODEV;
> >
> >         data = kzalloc(sizeof(*data), GFP_KERNEL);
> > -       if (!data) {
> > -               pr_err("%s: no memory\n", __func__);
> 
> Wasn't this useful ?
> 
> > +       if (!data)
> >                 goto err_np;
> > -       }
> >
> >         policy->clk = of_clk_get(np, 0);
> >         if (IS_ERR(policy->clk)) {
> > @@ -170,7 +238,7 @@ static int corenet_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
> >         }
> >
> >         if (fmask)
> > -               mask = fmask[get_hard_smp_processor_id(cpu)];
> > +               mask = fmask[get_cpu_physical_id(cpu)];
> >         else
> >                 mask = 0x0;
> >
> > @@ -201,13 +269,13 @@ static int corenet_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
> >         data->table = table;
> >
> >         /* update ->cpus if we have cluster, no harm if not */
> > -       cpumask_copy(policy->cpus, per_cpu(cpu_mask, cpu));
> > -       for_each_cpu(i, per_cpu(cpu_mask, cpu))
> > +       set_affected_cpus(policy);
> > +       for_each_cpu(i, policy->cpus)
> >                 per_cpu(cpu_data, i) = data;
> 
> Get rid of this per-cpu data and use policy->driver_data instead.
> 
> >
> >         /* Minimum transition latency is 12 platform clocks */
> >         u64temp = 12ULL * NSEC_PER_SEC;
> > -       do_div(u64temp, fsl_get_sys_freq());
> > +       do_div(u64temp, get_bus_freq());
> >         policy->cpuinfo.transition_latency = u64temp + 1;
> >
> >         of_node_put(np);
> > @@ -227,7 +295,7 @@ err_np:
> >         return -ENODEV;
> >  }
> >
> > -static int __exit corenet_cpufreq_cpu_exit(struct cpufreq_policy
> > *policy)
> > +static int __exit qoriq_cpufreq_cpu_exit(struct cpufreq_policy
> > +*policy)
> >  {
> >         struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
> >         unsigned int cpu;
> > @@ -236,13 +304,13 @@ static int __exit corenet_cpufreq_cpu_exit(struct
> cpufreq_policy *policy)
> >         kfree(data->table);
> >         kfree(data);
> >
> > -       for_each_cpu(cpu, per_cpu(cpu_mask, policy->cpu))
> > +       for_each_cpu(cpu, policy->cpus)
> >                 per_cpu(cpu_data, cpu) = NULL;
> >
> >         return 0;
> >  }
> >
> > -static int corenet_cpufreq_target(struct cpufreq_policy *policy,
> > +static int qoriq_cpufreq_target(struct cpufreq_policy *policy,
> >                 unsigned int index)
> >  {
> >         struct clk *parent;
> > @@ -252,18 +320,18 @@ static int corenet_cpufreq_target(struct
> cpufreq_policy *policy,
> >         return clk_set_parent(policy->clk, parent);  }
> >
> > -static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
> > -       .name           = "ppc_cpufreq",
> > +static struct cpufreq_driver qoriq_cpufreq_driver = {
> > +       .name           = "qoriq_cpufreq",
> >         .flags          = CPUFREQ_CONST_LOOPS,
> > -       .init           = corenet_cpufreq_cpu_init,
> > -       .exit           = __exit_p(corenet_cpufreq_cpu_exit),
> > +       .init           = qoriq_cpufreq_cpu_init,
> > +       .exit           = __exit_p(qoriq_cpufreq_cpu_exit),
> >         .verify         = cpufreq_generic_frequency_table_verify,
> > -       .target_index   = corenet_cpufreq_target,
> > +       .target_index   = qoriq_cpufreq_target,
> >         .get            = cpufreq_generic_get,
> >         .attr           = cpufreq_generic_attr,
> >  };
> >
> > -static const struct of_device_id node_matches[] __initdata = {
> > +static const struct of_device_id node_matches[] __initconst = {
> >         { .compatible = "fsl,p2041-clockgen", .data = &sdata[0], },
> >         { .compatible = "fsl,p3041-clockgen", .data = &sdata[0], },
> >         { .compatible = "fsl,p5020-clockgen", .data = &sdata[1], }, @@
> > -273,61 +341,43 @@ static const struct of_device_id node_matches[]
> __initdata = {
> >         {}
> >  };
> >
> > -static int __init ppc_corenet_cpufreq_init(void)
> > +static int __init qoriq_cpufreq_init(void)
> >  {
> >         int ret;
> >         struct device_node  *np;
> >         const struct of_device_id *match;
> >         const struct soc_data *data;
> > -       unsigned int cpu;
> >
> >         np = of_find_matching_node(NULL, node_matches);
> >         if (!np)
> >                 return -ENODEV;
> >
> > -       for_each_possible_cpu(cpu) {
> > -               if (!alloc_cpumask_var(&per_cpu(cpu_mask, cpu),
> GFP_KERNEL))
> > -                       goto err_mask;
> > -               cpumask_copy(per_cpu(cpu_mask, cpu),
> cpu_core_mask(cpu));
> > -       }
> > -
> >         match = of_match_node(node_matches, np);
> >         data = match->data;
> >         if (data) {
> >                 if (data->flag)
> >                         fmask = data->freq_mask;
> > -               min_cpufreq = fsl_get_sys_freq();
> > +               min_cpufreq = get_bus_freq();
> >         } else {
> > -               min_cpufreq = fsl_get_sys_freq() / 2;
> > +               min_cpufreq = get_bus_freq() / 2;
> >         }
> >
> >         of_node_put(np);
> >
> > -       ret = cpufreq_register_driver(&ppc_corenet_cpufreq_driver);
> > +       ret = cpufreq_register_driver(&qoriq_cpufreq_driver);
> >         if (!ret)
> > -               pr_info("Freescale PowerPC corenet CPU frequency scaling
> driver\n");
> > +               pr_info("Freescale QorIQ CPU frequency scaling
> > + driver\n");
> >
> >         return ret;
> > -
> > -err_mask:
> > -       for_each_possible_cpu(cpu)
> > -               free_cpumask_var(per_cpu(cpu_mask, cpu));
> > -
> > -       return -ENOMEM;
> >  }
> > -module_init(ppc_corenet_cpufreq_init);
> > +module_init(qoriq_cpufreq_init);
> >
> > -static void __exit ppc_corenet_cpufreq_exit(void)
> > +static void __exit qoriq_cpufreq_exit(void)
> >  {
> > -       unsigned int cpu;
> > -
> > -       for_each_possible_cpu(cpu)
> > -               free_cpumask_var(per_cpu(cpu_mask, cpu));
> > -
> > -       cpufreq_unregister_driver(&ppc_corenet_cpufreq_driver);
> > +       cpufreq_unregister_driver(&qoriq_cpufreq_driver);
> >  }
> > -module_exit(ppc_corenet_cpufreq_exit);
> > +module_exit(qoriq_cpufreq_exit);
> >
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Tang Yuantian <Yuantian.Tang@freescale.com>");
> > -MODULE_DESCRIPTION("cpufreq driver for Freescale e500mc series
> > SoCs");
> > +MODULE_DESCRIPTION("cpufreq driver for Freescale QorIQ series SoCs");
> 
> + comments from Kumar Gala :)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
