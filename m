Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaBYMZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:25:14 -0500
Received: from mail-bn1lp0154.outbound.protection.outlook.com ([207.46.163.154]:14854
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbaBYMZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:25:08 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        x86 <x86@kernel.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: RE: [patch 22/26] x86: Add proper vector accounting for HyperV
Thread-Topic: [patch 22/26] x86: Add proper vector accounting for HyperV
Thread-Index: AQHPMN/a+m85yqdrzUWUByp1sVomYZrF3TYg
Date: Tue, 25 Feb 2014 12:24:58 +0000
Message-ID: <c2fd31b7434f4510a5424aa0ac701f72@BY2PR03MB299.namprd03.prod.outlook.com>
References: <20140223212703.511977310@linutronix.de>
 <20140223212738.681855582@linutronix.de>
In-Reply-To: <20140223212738.681855582@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [210.188.139.189]
x-forefront-prvs: 01334458E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(13464003)(199002)(189002)(377454003)(51704005)(63696002)(95666003)(47446002)(80022001)(65816001)(66066001)(85306002)(74502001)(19580395003)(47976001)(50986001)(79102001)(93136001)(19580405001)(83322001)(80976001)(77982001)(59766001)(51856001)(53806001)(56776001)(54316002)(74662001)(31966008)(54356001)(4396001)(49866001)(47736001)(46102001)(76482001)(76576001)(76786001)(76796001)(81342001)(86362001)(93516002)(33646001)(95416001)(81816001)(81686001)(74366001)(94316002)(81542001)(69226001)(94946001)(86612001)(74706001)(85852003)(83072002)(74876001)(2656002)(56816005)(74316001)(90146001)(92566001)(87266001)(87936001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB597;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:210.188.139.189;FPR:84F8F9DD.3CF2A722.2AE3ABBC.40ADF9ED.20272;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Sunday, February 23, 2014 1:40 PM
> To: LKML
> Cc: Ingo Molnar; Peter Zijlstra; x86; Konrad Rzeszutek Wilk; KY Srinivasan
> Subject: [patch 22/26] x86: Add proper vector accounting for HyperV
> 
> HyperV abuses a device interrupt to account for the
> HYPERVISOR_CALLBACK_VECTOR.
> 
> Provide proper accounting as we have for the other vectors as well.

Thomas,

Thank you for cleaning up this code.

Regards,

K. Y
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86 <x86@kernel.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> ---
>  arch/x86/include/asm/hardirq.h |    3 +++
>  arch/x86/kernel/irq.c          |    6 ++++++
>  2 files changed, 9 insertions(+)
> 
> Index: tip/arch/x86/include/asm/hardirq.h
> ==========================================================
> =========
> --- tip.orig/arch/x86/include/asm/hardirq.h
> +++ tip/arch/x86/include/asm/hardirq.h
> @@ -33,6 +33,9 @@ typedef struct {
>  #ifdef CONFIG_X86_MCE_THRESHOLD
>  	unsigned int irq_threshold_count;
>  #endif
> +#if defined(CONFIG_HYPERV) || defined(CONFIG_XEN)
> +	unsigned int irq_hv_callback_count;
> +#endif
>  } ____cacheline_aligned irq_cpustat_t;
> 
>  DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
> Index: tip/arch/x86/kernel/irq.c
> ==========================================================
> =========
> --- tip.orig/arch/x86/kernel/irq.c
> +++ tip/arch/x86/kernel/irq.c
> @@ -125,6 +125,12 @@ int arch_show_interrupts(struct seq_file
>  		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
>  	seq_printf(p, "  Machine check polls\n");  #endif
> +#if defined(CONFIG_HYPERV) || defined(CONFIG_XEN)
> +	seq_printf(p, "%*s: ", prec, "THR");
> +	for_each_online_cpu(j)
> +		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
> +	seq_printf(p, "  Hypervisor callback interrupts\n"); #endif
>  	seq_printf(p, "%*s: %10u\n", prec, "ERR",
> atomic_read(&irq_err_count));  #if defined(CONFIG_X86_IO_APIC)
>  	seq_printf(p, "%*s: %10u\n", prec, "MIS",
> atomic_read(&irq_mis_count));
> 

