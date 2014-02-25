Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaBYMZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:25:47 -0500
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:20817
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbaBYMZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:25:17 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: RE: [patch 24/26] genirq: Provide handle_percpu_simple_irq()
Thread-Topic: [patch 24/26] genirq: Provide handle_percpu_simple_irq()
Thread-Index: AQHPMN/Ze+fO7ysc9kapSs010cviPprFM6Tg
Date: Tue, 25 Feb 2014 12:25:00 +0000
Message-ID: <a544b6ed20a9469a93047bcd23c3f0e3@BY2PR03MB299.namprd03.prod.outlook.com>
References: <20140223212703.511977310@linutronix.de>
 <20140223212738.929676976@linutronix.de>
In-Reply-To: <20140223212738.929676976@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [210.188.139.189]
x-forefront-prvs: 01334458E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(13464003)(199002)(189002)(377454003)(51704005)(63696002)(95666003)(47446002)(80022001)(65816001)(66066001)(85306002)(74502001)(19580395003)(47976001)(50986001)(79102001)(93136001)(19580405001)(83322001)(80976001)(77982001)(59766001)(51856001)(53806001)(56776001)(54316002)(74662001)(31966008)(54356001)(4396001)(49866001)(47736001)(46102001)(76482001)(76576001)(76786001)(76796001)(81342001)(86362001)(93516002)(33646001)(95416001)(81816001)(81686001)(74366001)(94316002)(81542001)(69226001)(94946001)(86612001)(74706001)(85852003)(83072002)(74876001)(2656002)(56816005)(74316001)(90146001)(92566001)(87266001)(87936001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB597;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:210.188.139.189;FPR:74CA7AD5.1CF2EB93.CB676BBC.40E5C17D.20270;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
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
> Cc: Ingo Molnar; Peter Zijlstra; KY Srinivasan; Greg Kroah-Hartman
> Subject: [patch 24/26] genirq: Provide handle_percpu_simple_irq()
> 
> Special case for vmbus to replace their homegrown flow handler.
> 
> Not sure whether we need it at all. I can't see a reason why that needs
> special handling at all if CONFIG_HYPERV=n

Thomas,

Thank you for cleaning up this code. All of the VMBUS code is active only if CONFIG_HYPERV is set.

Regards,

K. Y

> 
> Not-Yet-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  include/linux/irq.h |    1 +
>  kernel/irq/chip.c   |   15 +++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> Index: tip/include/linux/irq.h
> ==========================================================
> =========
> --- tip.orig/include/linux/irq.h
> +++ tip/include/linux/irq.h
> @@ -423,6 +423,7 @@ extern void handle_edge_irq(unsigned int  extern
> void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc);  extern
> void handle_simple_irq(unsigned int irq, struct irq_desc *desc);  extern void
> handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
> +extern void handle_percpu_simple_irq(unsigned int irq, struct irq_desc
> +*desc);
>  extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc
> *desc);  extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
> extern void handle_nested_irq(unsigned int irq);
> Index: tip/kernel/irq/chip.c
> ==========================================================
> =========
> --- tip.orig/kernel/irq/chip.c
> +++ tip/kernel/irq/chip.c
> @@ -623,6 +623,21 @@ handle_percpu_irq(unsigned int irq, stru  }
> 
>  /**
> + *	handle_percpu_simple_irq - Per CPU local irq handler
> + *	@irq:	the interrupt number
> + *	@desc:	the interrupt description structure for this irq
> + *
> + *	Per CPU interrupts on SMP machines without locking
> + *	requirements. No ack/eoi handling.
> + */
> +void
> +handle_percpu_simple_irq(unsigned int irq, struct irq_desc *desc) {
> +	kstat_incr_irqs_this_cpu(irq, desc);
> +	handle_irq_event_percpu(desc, desc->action); }
> +
> +/**
>   * handle_percpu_devid_irq - Per CPU local irq handler with per cpu dev ids
>   * @irq:	the interrupt number
>   * @desc:	the interrupt description structure for this irq
> 

