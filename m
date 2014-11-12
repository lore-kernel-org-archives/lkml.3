Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaKLSlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:41:53 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19554 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaKLSlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:41:51 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-2e-5463a9ed56fb
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Colin Cross <ccross@google.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: [PATCH 2/2] cpuidle: exynos: add coupled cpuidle support for
 Exynos4210
Date: Wed, 12 Nov 2014 19:41:46 +0100
Message-id: <4297709.zGrpcvcSeS@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-70-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <54638E28.6050304@linaro.org>
References: <1415383252-20118-1-git-send-email-b.zolnierkie@samsung.com>
 <3813280.9hNcruz8Q6@amdc1032> <54638E28.6050304@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=utf-8
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jAd23K5NDDFatFrBYMKOd2WLeZ1mL
	1y8MLXoXXGWzONv0ht3izcPNjBbvDz1jtri8aw6bxefeI4wWM87vY7JYtesPowO3x85Zd9k9
	Fmwq9bhzbQ+bx+1/j5k9+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK2Pvks3sBSvkKn5vX8TW
	wPhCvIuRg0NCwERi/qGILkZOIFNM4sK99WxdjFwcQgKLGCWmnl3BDuG0MEls7t3NBFLFJmAl
	MbF9FSOILSKgJ9H4vo0JpIhZ4CuTxJt9r9hAEsICYRIbVy9nBNnAIqAq8XdaJEiYV0BT4sKH
	LywgtqiAp8TO6QfA5nAKaEkcnnyNCWJZG6PE+ec32SAaBCV+TL4H1sAsIC+xb/9UVpCZzALq
	ElOm5E5gFJiFpGoWkqpZCFULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTHwzPpHYyr
	GiwOMQpwMCrx8GZsTgoRYk0sK67MPcQowcGsJMLLtiQ5RIg3JbGyKrUoP76oNCe1+BCjNAeL
	kjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAMj+w3Zh+udRIx49Tb1+56qaTBqCMhaqPlZ+cws
	o8s7Sk53tWwWeVOUm1KkJDnLfc2i02fKhZZZcXN5vH1jlLVzwRovi3tBW5c+Vwh9ZX4z6zu3
	5PElRTsVX86yZV0ncP2Sb/+cWqkZtdNjGqx4Lz6b1DA553DVvVMhNkudNMUXXtFTYZ2TdElN
	iaU4I9FQi7moOBEA/duDk4MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, November 12, 2014 05:43:20 PM Daniel Lezcano wrote:
> On 11/12/2014 04:13 PM, Bartlomiej Zolnierkiewicz wrote:
> >
> 
> Hi Bartlomiej,
> 
> [ cut ]
> 
> >>> - using arch_send_wakeup_ipi_mask() instead of dsb_sev()
> >>>     (this matches CPU hotplug code in arch/arm/mach-exynos/platsmp.c)
> >>
> >> I am curious. You experienced very rare hangs after running the tests a
> >> few hours, right ? Is the SEV replaced by the IPI solving the issue ? If
> >> yes, how did you catch it ?
> >
> > Rare hangs showed up after about 30-40 minutes of testing with the attached
> > app and script (running of "./cpuidle_state1_test.sh script 2 500" has never
> > completed on the umodified driver).
> >
> > The problem turned out to be in the following loop waiting for CPU1 to get
> > stuck in the BOOT ROM:
> >
> > 		/*
> > 		 * Wait for cpu1 to get stuck in the boot rom
> > 		 */
> > 		while ((__raw_readl(BOOT_VECTOR) != 0) &&
> > 		       !atomic_read(&cpu1_wakeup))
> > 			cpu_relax();
> >
> > [ Removal of the loop fixed the problem. ]
> 
> Just for my personal information, do you know why ?

Unfortunately no.  I just suspect that sometimes the BOOT_VECTOR register
is not zeroed (or is zeroed and then overwritten) because of the bug in
the firmware.

> [ cut ]
> 
> >>> +#ifdef CONFIG_ARM_EXYNOS_CPUIDLE
> >>> +	if (of_machine_is_compatible("samsung,exynos4210"))
> >>> +		exynos_cpuidle.dev.platform_data = &cpuidle_coupled_exynos_data;
> >>> +#endif
> >>
> >> You should not add those #ifdef.
> >
> > Without those #ifdef I get:
> >
> >    LD      init/built-in.o
> > arch/arm/mach-exynos/built-in.o: In function `exynos_dt_machine_init':
> > /home/bzolnier/sam/linux-sprc/arch/arm/mach-exynos/exynos.c:334: undefined reference to `cpuidle_coupled_exynos_data'
> > make: *** [vmlinux] Error 1
> >
> > when CONFIG_EXYNOS_CPU_SUSPEND is disabled.
> 
> Here, we are introducing some dependencies I tried to drop in the 
> different drivers.
> 
> I looked more closely at the code and especially the 
> 'cpuidle_coupled_exynos_data'. I don't think it is worth to have it 
> because it adds more complexity and you have to define this structure to 
> be visible from the drivers/cpuidle files.
> 
> I suggest you create an simple function in "pm.c"
> 
> int exynos_coupled_aftr(int cpu)
> {
> 	pre_enter...
> 
> 	if (!cpu)
> 		cpu0_enter_aftr()
> 	else
> 		cpu1_powerdown()
> 
> 	post_enter...
> }
> 
> and in the cpuidle driver itself, you just use the already existing 
> anonymous callback 'exynos_enter_aftr' (and mutate it to conform the 
> parameters).
> 
> You won't have to share any structure between the arch code and the 
> cpuidle driver.

The reason why the separate callbacks are needed is that the cpuidle
driver code uses coupled cpuidle barriers (I cannot move them to pm.c):

+static int exynos_enter_coupled_lowpower(struct cpuidle_device *dev,
+					 struct cpuidle_driver *drv,
+					 int index)
+{
+	int ret;
+
+	exynos_cpuidle_pdata->pre_enter_aftr();
+
+	/*
+	 * Waiting all cpus to reach this point at the same moment
+	 */
+	cpuidle_coupled_parallel_barrier(dev, &exynos_idle_barrier);
+
+	/*
+	 * Both cpus will reach this point at the same time
+	 */
+	ret = dev->cpu ? exynos_cpuidle_pdata->cpu1_powerdown()
+		       : exynos_cpuidle_pdata->cpu0_enter_aftr();
+	if (ret)
+		index = ret;
+
+	/*
+	 * Waiting all cpus to finish the power sequence before going further
+	 */
+	cpuidle_coupled_parallel_barrier(dev, &exynos_idle_barrier);
+
+	exynos_cpuidle_pdata->post_enter_aftr();
+
+	return index;
+}

Could you please explain how the proposed pm.c::exynos_coupled_aftr()
would operate without these barriers?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

