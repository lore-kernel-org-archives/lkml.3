Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3DYA3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 20:29:06 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:4485
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758069Ab3DYA3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 20:29:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
Date: Thu, 25 Apr 2013 08:28:18 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>
Subject: Re: [PATCH v2 12/15] powerpc/85xx: add time base sync support for
 e6500
Message-ID: <20130425002818.GE3172@localhost.localdomain>
References: <20130424112929.GC3172@localhost.localdomain>
 <1366843096.17465.17@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366843096.17465.17@snotra>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 05:38:16PM -0500, Scott Wood wrote:
> On 04/24/2013 06:29:29 AM, Zhao Chenhui wrote:
> >On Tue, Apr 23, 2013 at 07:04:06PM -0500, Scott Wood wrote:
> >> On 04/19/2013 05:47:45 AM, Zhao Chenhui wrote:
> >> >From: Chen-Hui Zhao <chenhui.zhao@freescale.com>
> >> >
> >> >For e6500, two threads in one core share one time base. Just need
> >> >to do time base sync on first thread of one core, and skip it on
> >> >the other thread.
> >> >
> >> >Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> >> >Signed-off-by: Li Yang <leoli@freescale.com>
> >> >Signed-off-by: Andy Fleming <afleming@freescale.com>
> >> >---
> >> > arch/powerpc/platforms/85xx/smp.c |   52
> >> >+++++++++++++++++++++++++++++++-----
> >> > 1 files changed, 44 insertions(+), 8 deletions(-)
> >> >
> >> >diff --git a/arch/powerpc/platforms/85xx/smp.c
> >> >b/arch/powerpc/platforms/85xx/smp.c
> >> >index 74d8cde..5f3eee3 100644
> >> >--- a/arch/powerpc/platforms/85xx/smp.c
> >> >+++ b/arch/powerpc/platforms/85xx/smp.c
> >> >@@ -53,26 +55,40 @@ static inline u32 get_phy_cpu_mask(void)
> >> > 	u32 mask;
> >> > 	int cpu;
> >> >
> >> >-	mask = 1 << cur_booting_core;
> >> >-	for_each_online_cpu(cpu)
> >> >-		mask |= 1 << get_hard_smp_processor_id(cpu);
> >> >+	if (smt_capable()) {
> >> >+		/* two threads in one core share one time base */
> >> >+		mask = 1 << cpu_core_index_of_thread(cur_booting_core);
> >> >+		for_each_online_cpu(cpu)
> >> >+			mask |= 1 << cpu_core_index_of_thread(
> >> >+					get_hard_smp_processor_id(cpu));
> >> >+	} else {
> >> >+		mask = 1 << cur_booting_core;
> >> >+		for_each_online_cpu(cpu)
> >> >+			mask |= 1 << get_hard_smp_processor_id(cpu);
> >> >+	}
> >>
> >> Where is smt_capable defined()?  I assume somewhere in the patchset
> >> but it's a pain to search 12 patches...
> >>
> >
> >It is defined in arch/powerpc/include/asm/topology.h.
> >	#define smt_capable()           (cpu_has_feature(CPU_FTR_SMT))
> >
> >Thanks for your review again.
> 
> We shouldn't base it on CPU_FTR_SMT.  For example, e6500 doesn't
> claim that feature yet, except in our SDK kernel.  That doesn't
> change the topology of CPU numbering.
> 

Then, where can I get the thread information? dts?
Or, wait for upstream of the thread suppport of e6500.

> >> Is this really about whether we're SMT-capable or whether we have
> >> rcpm v2?
> >>
> >> -Scott
> >
> >I think this "if" statement can be removed. The
> >cpu_core_index_of_thread()
> >can return the correct cpu number with thread or without thread.
> >
> >Like this:
> >static inline u32 get_phy_cpu_mask(void)
> >{
> >	u32 mask;
> >	int cpu;
> >
> >	mask = 1 << cpu_core_index_of_thread(cur_booting_core);
> >	for_each_online_cpu(cpu)
> >		mask |= 1 << cpu_core_index_of_thread(
> >				get_hard_smp_processor_id(cpu));
> >
> >	return mask;
> >}
> 
> Likewise, this will get it wrong if SMT is disabled or not yet
> implemented on a core.
> 
> -Scott

Let's look into cpu_core_index_of_thread() in arch/powerpc/kernel/smp.c.

  int cpu_core_index_of_thread(int cpu)                                          
  {                                                                              
      return cpu >> threads_shift;
  }

If no thread, the threads_shift is equal to 0. It can work with no
thread.

Perhaps, I should submit this patch after the thread patches for e6500.

-Chenhui

