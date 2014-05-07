Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaEGTwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:52:12 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:35117 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaEGTwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:52:10 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/5] x86, nmi: Add better NMI stats to /proc/interrupts
 and show handlers
Thread-Topic: [PATCH 5/5] x86, nmi: Add better NMI stats to /proc/interrupts
 and show handlers
Thread-Index: AQHPagofs5SRBgO4bEWfgqloigABk5s1aRGQ
Date: Wed, 7 May 2014 19:50:48 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402956F047E7@G4W3202.americas.hpqcorp.net>
References: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
 <1399476883-98970-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1399476883-98970-6-git-send-email-dzickus@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> wrote:
> The main reason for this patch is because I have a hard time knowing
> what NMI handlers are registered on the system when debugging NMI issues.
> 
> This info is provided in /proc/interrupts for interrupt handlers, so I
> added support for NMI stuff too.  As a bonus it provides stat breakdowns
> much like the interrupts.

/proc/interrupts only shows online CPUs, while /proc/softirqs shows 
all possible CPUs.  Is there any value in this information for all 
possible CPUs? Perhaps a /proc/hardirqs could be created alongside.

> The only ugly issue is how to label NMI subtypes using only 3 letters
> and still make it obvious it is part of the NMI.  Adding a /proc/nmi
> seemed overkill, so I choose to indent things by one space.  

The list only shows the currently registered handlers, which may
differ from the ones that were registered when the NMIs whose counts 
are being displayed occurred. You might want to describe these new 
rows and mention that in Documentation/filesystems/proc.txt and 
the proc(5) manpage.

> Sample output is below:
> 
> [root@dhcp71-248 ~]# cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   0:         29          0          0          0  IR-IO-APIC-edge      timer
> <snip>
> NMI:         20        774      10986       4227   Non-maskable interrupts
>  LOC:         21        775      10987       4228  Local     PMI, arch_bt
>  EXT:          0          0          0          0  External  plat
>  UNK:          0          0          0          0  Unknown
>  SWA:          0          0          0          0  Swallowed

Adding the list of NMI handlers in /proc/interrupts is a bit 
inconsistent with the other interrupts, which don't describe their 
handlers. It would be helpful to distinguish between a handler 
list being present, being present but empty, or not being present.

Maybe use parenthesis like this (using Ingo's suggested format):
 NMI:         20        774      10986       4227   Non-maskable interrupts
 NLC:         21        775      10987       4228   NMI: Local (PMI, arch_bt)
 NXT:          0          0          0          0   NMI: External (plat)
 NUN:          0          0          0          0   NMI: Unknown ()
 NSW:          0          0          0          0   NMI: Swallowed
 LOC:      30374      24749      20795      15095   Local timer interrupts

> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index d99f31d..520359c 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
...
> +void nmi_show_interrupts(struct seq_file *p, int prec)
> +{
> +	int j;
> +	int indent = prec + 1;
> +
> +#define get_nmi_stats(j)	(&per_cpu(nmi_stats, j))
> +
> +	seq_printf(p, "%*s: ", indent, "LOC");
> +	for_each_online_cpu(j)
> +		seq_printf(p, "%10u ", get_nmi_stats(j)->normal);
> +	seq_printf(p, " %-8s", "Local");
> +
> +	print_nmi_action_name(p, NMI_LOCAL);
> +
> +	seq_printf(p, "%*s: ", indent, "EXT");
> +	for_each_online_cpu(j)
> +		seq_printf(p, "%10u ", get_nmi_stats(j)->external);
> +	seq_printf(p, " %-8s", "External");
> +
> +	print_nmi_action_name(p, NMI_EXT);
> +
> +	seq_printf(p, "%*s: ", indent, "UNK");
> +	for_each_online_cpu(j)
> +		seq_printf(p, "%10u ", get_nmi_stats(j)->unknown);
> +	seq_printf(p, " %-8s", "Unknown");
> +
> +	print_nmi_action_name(p, NMI_UNKNOWN);
> +

The NMI handler types are in arch/c86/include/asm/nmi.h:
enum {
        NMI_LOCAL=0,
        NMI_UNKNOWN,
        NMI_SERR,
        NMI_IO_CHECK,
        NMI_MAX
};

The new code only prints the registered handlers for NMI_LOCAL, 
NMI_UNKNOWN, and the new NMI_EXT.  Consider adding counters 
for NMI_SERR and NMI_IO_CHECK and printing their handlers too.

drivers/watchdog/hpwdt.c is the only code currently in 
the kernel registering handlers for them.

---
Rob Elliott    HP Server Storage



