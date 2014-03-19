Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbaCSWG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:06:58 -0400
Received: from [207.46.163.142] ([207.46.163.142]:14951 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752737AbaCSWG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:06:57 -0400
Message-ID: <1395266717.12479.293.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc 32: Provides VIRT_CPU_ACCOUNTING
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Date: Wed, 19 Mar 2014 17:05:17 -0500
In-Reply-To: <20140319215241.236B21A4BDE@localhost.localdomain>
References: <20140319215241.236B21A4BDE@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR02CA009.namprd02.prod.outlook.com (10.141.66.19) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 01559F388D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(189002)(199002)(377424004)(51704005)(69226001)(76796001)(81342001)(77096001)(77156001)(31966008)(79102001)(59766001)(77982001)(23676002)(20776003)(63696002)(47776003)(65816001)(81542001)(47446002)(80022001)(74502001)(62966002)(49866001)(74706001)(56816005)(93916002)(95416001)(97336001)(81686001)(50226001)(87266001)(89996001)(87286001)(74876001)(93136001)(90146001)(4396001)(85306002)(95666003)(50466002)(97186001)(86362001)(87976001)(92566001)(92726001)(88136002)(94946001)(85852003)(81816001)(54316002)(56776001)(76482001)(93516002)(80976001)(50986001)(47736001)(74662001)(47976001)(46102001)(83072002)(53806001)(51856001)(33646001)(83322001)(74366001)(42186004)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:B254F1C6.AE9B8B52.72D3937E.48E5112A.202C0;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 22:52 +0100, Christophe Leroy wrote:
> This patch provides VIRT_CPU_ACCOUTING to PPC32 architecture.
> Unlike PPC64, PPC32 doesn't provide the PACA register. Therefore the
> implementation is similar to the one done in the IA64 architecture.
> It is based on additional information added to the Task Info structure.

PACA isn't a register -- just a convention for how Linux uses a GPR.
Maybe it's time to use it on PPC32 as well?

> Index: b/arch/powerpc/kernel/asm-offsets.c
> ===================================================================
> --- b/arch/powerpc/kernel/asm-offsets.c	(revision 5607)
> +++ b/arch/powerpc/kernel/asm-offsets.c	(revision 5608)
> @@ -167,6 +167,10 @@
>  	DEFINE(TI_PREEMPT, offsetof(struct thread_info, preempt_count));
>  	DEFINE(TI_TASK, offsetof(struct thread_info, task));
>  	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
> +	DEFINE(TI_AC_STAMP, offsetof(struct thread_info, ac_stamp));
> +	DEFINE(TI_AC_LEAVE, offsetof(struct thread_info, ac_leave));
> +	DEFINE(TI_AC_STIME, offsetof(struct thread_info, ac_stime));
> +	DEFINE(TI_AC_UTIME, offsetof(struct thread_info, ac_utime));

Doesn't this need to be protected by #ifdef
CONFIG_VIRT_CPU_ACCOUNTING_NATIVE?

>  
>  #ifdef CONFIG_PPC64
>  	DEFINE(DCACHEL1LINESIZE, offsetof(struct ppc64_caches, dline_size));
> Index: b/arch/powerpc/include/asm/thread_info.h
> ===================================================================
> --- b/arch/powerpc/include/asm/thread_info.h	(revision 5607)
> +++ b/arch/powerpc/include/asm/thread_info.h	(revision 5608)
> @@ -43,6 +43,12 @@
>  	int		cpu;			/* cpu we're on */
>  	int		preempt_count;		/* 0 => preemptable,
>  						   <0 => BUG */
> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
> +	__u32 ac_stamp;
> +	__u32 ac_leave;
> +	__u32 ac_stime;
> +	__u32 ac_utime;
> +#endif

This isn't uapi; why not use "u32"?

Plus, it should be made clear that this is only used on 32-bit.

>  	struct restart_block restart_block;
>  	unsigned long	local_flags;		/* private flags for thread */
>  
> @@ -58,6 +64,8 @@
>  	.task =		&tsk,			\
>  	.exec_domain =	&default_exec_domain,	\
>  	.cpu =		0,			\
> +	.ac_stime =	0,			\
> +	.ac_utime =	0,			\

Also needs to be ifdeffed -- which isn't going to work in a macro, so
maybe remove the ifdef from the variable declarations, or just let the
fields be initialized to zero by default.  Or add PACA to 32-bit. :-)

-Scott


