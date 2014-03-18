Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaCRMjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:39:37 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:11196
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753591AbaCRMjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:39:36 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jason Wang <jasowang@redhat.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH RESEND] x86, hyperv: bypass the timer_irq_works() check
Thread-Topic: [PATCH RESEND] x86, hyperv: bypass the timer_irq_works() check
Thread-Index: AQHPNDV/k4kL9P4zdkCvvNI6LyQFcJrm5Szw
Date: Tue, 18 Mar 2014 12:39:31 +0000
Message-ID: <f8c66e195f26493b84e0630cfe25d821@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1393558229-14755-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1393558229-14755-1-git-send-email-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:f944:351c:5371:c92]
x-forefront-prvs: 0154C61618
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(199002)(189002)(377454003)(51704005)(13464003)(20776003)(81542001)(63696002)(33646001)(85306002)(74706001)(94946001)(49866001)(47736001)(77982001)(59766001)(74876001)(76576001)(81686001)(97336001)(81816001)(79102001)(97186001)(74662001)(1511001)(31966008)(76482001)(83072002)(76786001)(56816005)(54316002)(90146001)(69226001)(74366001)(2201001)(92566001)(56776001)(74316001)(4396001)(80022001)(46102001)(93516002)(76796001)(81342001)(93136001)(95666003)(87266001)(94316002)(95416001)(47446002)(50986001)(65816001)(47976001)(74502001)(19580405001)(86612001)(87936001)(86362001)(51856001)(19580395003)(53806001)(80976001)(2656002)(54356001)(85852003)(83322001)(24736002)(3826001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB174;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:FCFCFAEE.2E36539C.D6E5AB00.44E1DAFD.202BB;MLV:ovrnspm;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Thursday, February 27, 2014 7:30 PM
> To: KY Srinivasan; Haiyang Zhang; tglx@linutronix.de; mingo@redhat.com;
> hpa@zytor.com; x86@kernel.org; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Cc: Jason Wang; stable@vger.kernel.org
> Subject: [PATCH RESEND] x86, hyperv: bypass the timer_irq_works() check
> 
> This patch bypass the timer_irq_works() check for hyperv guest since:
> 
> - It was guaranteed to work.
> - timer_irq_works() may fail sometime due to the lpj calibration were
> inaccurate
>   in a hyperv guest or a buggy host.
> 
> In the future, we should get the tsc frequency from hypervisor and use
> preset lpj instead.
> 
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: stable@vger.kernel.org
> Acked-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  arch/x86/kernel/cpu/mshyperv.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c
> b/arch/x86/kernel/cpu/mshyperv.c index 9f7ca26..832d05a 100644
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
>  	if (ms_hyperv.features &
> HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
>  		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
> +
> +#ifdef CONFIG_X86_IO_APIC
> +	no_timer_check = 1;
> +#endif
> +
>  }
> 
>  const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {

Peter,

Please let us know if you have any issues with this patch.

Regards,

K. Y
> --
> 1.8.3.2

