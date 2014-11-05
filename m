Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbaKEWl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:41:29 -0500
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:50926 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750796AbaKEWl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:41:28 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:966:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3874:4250:4321:4385:5007:6117:6119:6261:6630:7875:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12438:12517:12519:12555:12740:13019:13069:13095:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: order02_29a30bf8ce43e
X-Filterd-Recvd-Size: 2841
Message-ID: <1415227284.6634.26.camel@perches.com>
Subject: Re: [PATCH V3] x86, cpu: trivial printk formatting fixes
From: Joe Perches <joe@perches.com>
To: Steven Honeyman <stevenhoneyman@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Kosina <trivial@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Nov 2014 14:41:24 -0800
In-Reply-To: <1415226516-20637-1-git-send-email-stevenhoneyman@gmail.com>
References: <1415226516-20637-1-git-send-email-stevenhoneyman@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 22:28 +0000, Steven Honeyman wrote:
> dmesg (from util-linux) currently has two methods for reading the
> kernel message ring buffer: /dev/kmsg and syslog(2). Since kernel
> 3.5.0 kmsg has been the default, which escapes control characters
> (e.g. new lines) before they are shown.
> 
> This change means that when dmesg is using /dev/kmsg, a 2 line printk
> makes the output messy, because the second line does not get a
> timestamp.
> For example:
> 
> [    0.012863] CPU0: Thermal monitoring enabled (TM1)
> [    0.012869] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
> Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
> [    0.012958] Freeing SMP alternatives memory: 28K (ffffffff81d86000
> - ffffffff81d8d000)
> [    0.014961] dmar: Host address width 39
> 
> Because printk.c intentionally escapes control characters, they should
> not be there in the first place.
> This patch fixes two occurrences of this.
> 
> V2: Revert change to log level, only fix the newline formatting issue
> V3: Expand patch description

The log level change is back...

> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
[]
> @@ -487,10 +487,8 @@ static void init_intel(struct cpuinfo_x86 *c)
>  
>  		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
>  		if ((epb & 0xF) == ENERGY_PERF_BIAS_PERFORMANCE) {
> -			printk_once(KERN_WARNING "ENERGY_PERF_BIAS:"
> -				" Set to 'normal', was 'performance'\n"
> -				"ENERGY_PERF_BIAS: View and update with"
> -				" x86_energy_perf_policy(8)\n");
> +			pr_info_once("ENERGY_PERF_BIAS: Set to 'normal', was 'performance'\n");
> +			pr_info_once("ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)\n");
>  			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
>  			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
>  		}



