Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaKCRv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:51:57 -0500
Received: from mail-by2on0138.outbound.protection.outlook.com ([207.46.100.138]:49166
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752615AbaKCRvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:51:55 -0500
X-WSS-ID: 0NEH5MB-07-HQG-02
X-M-MSG: 
Message-ID: <5457C0B3.30007@amd.com>
Date: Mon, 3 Nov 2014 11:51:47 -0600
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Chen Yucong <slaoub@gmail.com>
CC: <tony.luck@intel.com>, <ak@linux.intel.com>, <gong.chen@linux.intel.com>,
        <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, mce, amd: extend mce-inject for support threshold
 interrupt event injection on AMD platform
References: <1414718648-7766-1-git-send-email-slaoub@gmail.com>
	<1414718648-7766-3-git-send-email-slaoub@gmail.com>
 <CAOjmkp9Aec9Ec-93YvT5S_mMaxrOoZSYCDbjyWaxGV_dac6qog@mail.gmail.com>
In-Reply-To: <CAOjmkp9Aec9Ec-93YvT5S_mMaxrOoZSYCDbjyWaxGV_dac6qog@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(377454003)(479174003)(51704005)(24454002)(50986999)(65816999)(54356999)(76176999)(47776003)(20776003)(4396001)(86362001)(77156002)(87936001)(36756003)(65956001)(65806001)(97736003)(23676002)(50466002)(84676001)(44976005)(83506001)(19580405001)(19580395003)(21056001)(102836001)(95666004)(106466001)(64126003)(105586002)(64706001)(107046002)(31966008)(92726001)(99396003)(120916001)(120886001)(92566001)(46102003)(33656002)(62966003)(101416001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/2014 11:05 AM, Aravind Gopalakrishnan wrote:
>
> There are three ways that have been used to report machine check event.
> And they are MCE, CMCI/Threshold Interrupt, and POLL. On the Intel
> platform, CMCI/Threshold Interrupt and POLL share the same event handler
> - machine_check_poll(). However, on the AMD platform, they have a
> separate event handler. amd_threshold_interrupt() is used for handling
> Threshold Interrupt event. And machine_check_poll() has been used for
> polling other events.
>
> This patch introduces a new flag MCJ_INTERRUPT that will be used to
> separate CMCI/Threshold Interrupt and POLL handler in mce-inject.
>
> Signed-off-by: Chen Yucong <slaoub@gmail.com <mailto:slaoub@gmail.com>>
> ---
>  arch/x86/include/asm/mce.h              |    5 +++--
>  arch/x86/kernel/cpu/mcheck/mce-inject.c |   16 ++++++++++++++++
>  arch/x86/kernel/cpu/mcheck/threshold.c  |    1 +
>  3 files changed, 20 insertions(+), 2 deletions(-)
>


We currently test decoding logic on AMD by performing mce injections 
using edac/mce_amd_inj.c,
So instead of modifying mce-inject just for testing 
amd_threshold_interrupt(),
Why not put it under mce_amd_inj? (It's AMD specific code anyway)


> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index 3a430ad..cf25839 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -70,8 +70,9 @@
>  #define MCJ_CTX_PROCESS                0x1  /* inject context: process */
>  #define MCJ_CTX_IRQ            0x2  /* inject context: IRQ */
>  #define MCJ_NMI_BROADCAST      0x4  /* do NMI broadcasting */
> -#define MCJ_EXCEPTION          0x8  /* raise as exception */
> -#define MCJ_IRQ_BROADCAST      0x10 /* do IRQ broadcasting */
> +#define MCJ_IRQ_BROADCAST      0x8  /* do IRQ broadcasting */
> +#define MCJ_EXCEPTION          0x10  /* raise as exception */
> +#define MCJ_INTERRUPT          0x20  /* raise as interruption */
>
>  #define MCE_OVERFLOW 0         /* bit 0 in flags means overflow */
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c 
> b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> index 4cfba43..8428746 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
> @@ -59,6 +59,16 @@ static void raise_poll(struct mce *m)
>         m->finished = 0;
>  }
>
> +static void raise_interrupt(struct mce *m)
> +{
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       mce_threshold_vector();
> +       local_irq_restore(flags);
> +       m->finished = 0;
> +}
> +
>  static void raise_exception(struct mce *m, struct pt_regs *pregs)
>  {
>         struct pt_regs regs;
> @@ -89,6 +99,8 @@ static int mce_raise_notify(unsigned int cmd, struct 
> pt_regs *regs)
>         cpumask_clear_cpu(cpu, mce_inject_cpumask);
>         if (m->inject_flags & MCJ_EXCEPTION)
>                 raise_exception(m, regs);
> +       else if (m->inject_flags & MCJ_INTERRUPT)
> +               raise_interrupt(m);
>         else if (m->status)
>                 raise_poll(m);
>         return NMI_HANDLED;
> @@ -132,6 +144,10 @@ static int raise_local(void)
>                         ret = -EINVAL;
>                 }
>                 printk(KERN_INFO "MCE exception done on CPU %d\n", cpu);
> +       } else if (m->inject_flags & MCJ_INTERRUPT) {
> +               printk(KERN_INFO "Raising threshold interrupt on CPU 
> %d\n", cpu);
> +               raise_interrupt(m);
> +               printk(KERN_INFO "Threshold interrupt done on CPU 
> %d\n", cpu);
>         } else if (m->status) {
>                 printk(KERN_INFO "Starting machine check poll CPU 
> %d\n", cpu);
>                 raise_poll(m);
> diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c 
> b/arch/x86/kernel/cpu/mcheck/threshold.c
> index 7245980..e324bf9 100644
> --- a/arch/x86/kernel/cpu/mcheck/threshold.c
> +++ b/arch/x86/kernel/cpu/mcheck/threshold.c
> @@ -17,6 +17,7 @@ static void default_threshold_interrupt(void)
>  }
>
>  void (*mce_threshold_vector)(void) = default_threshold_interrupt;
> +EXPORT_SYMBOL_GPL(mce_threshold_vector);
>
>  static inline void __smp_threshold_interrupt(void)
>  {
> --
> 1.7.10.4
>

