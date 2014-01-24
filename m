Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaAXVRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 16:17:07 -0500
Received: from [207.46.163.190] ([207.46.163.190]:38291 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752290AbaAXVRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 16:17:03 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Jason Wang <jasowang@redhat.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86, hyperv: bypass the timer_irq_works() check
Thread-Topic: [PATCH] x86, hyperv: bypass the timer_irq_works() check
Thread-Index: AQHPGMoFD1wcv5Djo0KfhW00Z+RuEpqUYJXA
Date: Fri, 24 Jan 2014 21:16:18 +0000
Message-ID: <29a02b00af824078acad392c537def36@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1390543371-10748-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1390543371-10748-1-git-send-email-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::3]
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(13464003)(377454003)(51704005)(85852003)(93136001)(19580395003)(83322001)(19580405001)(63696002)(87266001)(80976001)(65816001)(80022001)(93516002)(74706001)(90146001)(56816005)(83072002)(74876001)(54316002)(86362001)(33646001)(92566001)(47736001)(47446002)(2201001)(69226001)(46102001)(56776001)(74502001)(94316002)(51856001)(74662001)(4396001)(49866001)(81542001)(47976001)(50986001)(31966008)(81342001)(85306002)(77982001)(81816001)(74316001)(76482001)(81686001)(74366001)(2656002)(76576001)(79102001)(76796001)(76786001)(59766001)(1511001)(53806001)(87936001)(54356001)(3826001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:2001:4898:80e0:ee43::3;FPR:;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Thursday, January 23, 2014 10:03 PM
> To: KY Srinivasan; Haiyang Zhang; tglx@linutronix.de; mingo@redhat.com;
> hpa@zytor.com; x86@kernel.org; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Cc: Jason Wang
> Subject: [PATCH] x86, hyperv: bypass the timer_irq_works() check
> 
> This patch bypass the timer_irq_works() check for hyperv guest since:
> 
> - It was guaranteed to work.
> - timer_irq_works() may fail sometime due to the lpj calibration were inaccurate
>   in a hyperv guest or a buggy host.
> 
> In the future, we should get the tsc frequency from hypervisor and use preset
> lpj instead.
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Thanks Jason.
Acked-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  arch/x86/kernel/cpu/mshyperv.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index 9f7ca26..832d05a 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -26,6 +26,7 @@
>  #include <asm/irq_regs.h>
>  #include <asm/i8259.h>
>  #include <asm/apic.h>
> +#include <asm/timer.h>
> 
>  struct ms_hyperv_info ms_hyperv;
>  EXPORT_SYMBOL_GPL(ms_hyperv);
> @@ -105,6 +106,11 @@ static void __init ms_hyperv_init_platform(void)
> 
>  	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
>  		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> +
> +#ifdef CONFIG_X86_IO_APIC
> +	no_timer_check = 1;
> +#endif
> +
>  }
> 
>  const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
> --
> 1.8.3.2

