Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3HWDRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 23:17:06 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:59739
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312Ab3HWDRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 23:17:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z1039mz1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Wang Dongsheng-B40534 <B40534@freescale.com>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: "michael@ellerman.id.au" <michael@ellerman.id.au>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Subject: RE: [PATCH V5 3/5] POWER/cpuidle: Generic IBM-POWER backend cpuidle
 driver.
Thread-Topic: [PATCH V5 3/5] POWER/cpuidle: Generic IBM-POWER backend
 cpuidle driver.
Thread-Index: AQHOnx2tLjlTSmMESEuhCDFLlvsjY5miGchg
Date: Fri, 23 Aug 2013 03:16:59 +0000
Message-ID: <ABB05CD9C9F68C46A5CEDC7F154392590102822A@039-SN2MPN1-021.039d.mgd.msft.net>
References: <20130822095323.27416.79369.stgit@deepthi.in.ibm.com>
 <20130822095357.27416.48110.stgit@deepthi.in.ibm.com>
In-Reply-To: <20130822095357.27416.48110.stgit@deepthi.in.ibm.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.117]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7N3HCKR003275


> diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
> index 0e2cd5c..e805dcd 100644
> --- a/drivers/cpuidle/Kconfig
> +++ b/drivers/cpuidle/Kconfig

Maybe drivers/cpuidle/Kconfig.powerpc is better? Like arm.

> +obj-$(CONFIG_CPU_IDLE_IBM_POWER) += cpuidle-ibm-power.o
> diff --git a/drivers/cpuidle/cpuidle-ibm-power.c
> b/drivers/cpuidle/cpuidle-ibm-power.c
> new file mode 100644
> index 0000000..4ee5a94
> --- /dev/null
> +++ b/drivers/cpuidle/cpuidle-ibm-power.c
> @@ -0,0 +1,304 @@
> +/*
> + *  cpuidle-ibm-power - idle state cpuidle driver.
> + *  Adapted from drivers/idle/intel_idle.c and
> + *  drivers/acpi/processor_idle.c
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/moduleparam.h>
> +#include <linux/cpuidle.h>
> +#include <linux/cpu.h>
> +#include <linux/notifier.h>
> +
> +#include <asm/paca.h>
> +#include <asm/reg.h>
> +#include <asm/machdep.h>
> +#include <asm/firmware.h>
> +#include <asm/runlatch.h>
> +#include <asm/plpar_wrappers.h>
> +
> +struct cpuidle_driver power_idle_driver = {
> +	.name             = "IBM-POWER-Idle",
> +	.owner            = THIS_MODULE,
> +};
> +
> +#define MAX_IDLE_STATE_COUNT	2
> +
> +static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;

Again, do not use the macro.

> +static struct cpuidle_state *cpuidle_state_table;
> +
> +static inline void idle_loop_prolog(unsigned long *in_purr)
> +{
> +	*in_purr = mfspr(SPRN_PURR);
> +	/*
> +	 * Indicate to the HV that we are idle. Now would be
> +	 * a good time to find other work to dispatch.
> +	 */
> +	get_lppaca()->idle = 1;
> +}
> +
> +static inline void idle_loop_epilog(unsigned long in_purr)
> +{
> +	get_lppaca()->wait_state_cycles += mfspr(SPRN_PURR) - in_purr;
> +	get_lppaca()->idle = 0;
> +}
> +
> +static int snooze_loop(struct cpuidle_device *dev,
> +			struct cpuidle_driver *drv,
> +			int index)
> +{
> +	unsigned long in_purr;
> +
> +	idle_loop_prolog(&in_purr);
> +	local_irq_enable();

snooze_loop has already registered in cpuidle framework to handle snooze state.
where disable the irq? Why do "enable" here?

> +/*
> + * States for dedicated partition case.
> + */
> +static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
> +	{ /* Snooze */
> +		.name = "snooze",
> +		.desc = "snooze",
> +		.flags = CPUIDLE_FLAG_TIME_VALID,
> +		.exit_latency = 0,
> +		.target_residency = 0,
> +		.enter = &snooze_loop },
> +	{ /* CEDE */
> +		.name = "CEDE",
> +		.desc = "CEDE",
> +		.flags = CPUIDLE_FLAG_TIME_VALID,
> +		.exit_latency = 10,
> +		.target_residency = 100,
> +		.enter = &dedicated_cede_loop },
> +};
> +
> +/*
> + * States for shared partition case.
> + */
> +static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
> +	{ /* Shared Cede */
> +		.name = "Shared Cede",
> +		.desc = "Shared Cede",
> +		.flags = CPUIDLE_FLAG_TIME_VALID,
> +		.exit_latency = 0,
> +		.target_residency = 0,
> +		.enter = &shared_cede_loop },
> +};
> +
> +static void __exit power_processor_idle_exit(void)
> +{
> +
> +	unregister_cpu_notifier(&setup_hotplug_notifier);

Remove a blank line.

> +	cpuidle_unregister(&power_idle_driver);
> +	return;
> +}
> +
> +module_init(power_processor_idle_init);
> +module_exit(power_processor_idle_exit);
> +

Did you have tested the module? If not tested, please don't use the module.

> +MODULE_AUTHOR("Deepthi Dharwar <deepthi@linux.vnet.ibm.com>");
> +MODULE_DESCRIPTION("Cpuidle driver for IBM POWER platforms");
> +MODULE_LICENSE("GPL");
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
