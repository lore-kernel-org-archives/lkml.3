Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3DHHmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:42:51 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55759 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3DHHmt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 8 Apr 2013 03:42:49 -0400
Message-Id: <5162911202000078000CB38E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 08 Apr 2013 08:42:42 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <zhenzhong.duan@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Feng Jin" <joe.jin@oracle.com>, "Tamon Shiose" <tamon.shiose@oracle.com>
Subject: Re: [Xen-devel] [PATCH-v2] xen: Don't call
 arch_trigger_all_cpu_backtrace in dom0(pvm)
References: <51610A25.4010301@oracle.com>
In-Reply-To: <51610A25.4010301@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.04.13 at 07:54, Zhenzhong Duan <zhenzhong.duan@oracle.com> wrote:
> nmi isn't supported in dom0, fallback to general all cpu backtrace code.

Since when is sending NMIs not supported, and since when is this
Dom0-specific? If you want to deal with this, you should do so
properly: Special case sending NMIs in the respective Xen specific
code (using VCPUOP_send_nmi), and carry this out in a way not
dependent upon running (un)privileged.

> Without fix, on xAPIC system, doing sysrq+l, no backtrace is showed,
> as xen_send_IPI_all is called and it doesn't support nmi vector.
> 
> On x2APIC enabled system, got NULL pointer dereference as below.
> 
>     SysRq : Show backtrace of all active CPUs
>     BUG: unable to handle kernel NULL pointer dereference at           (null)
>     IP: [<ffffffff8125e3cb>] memcpy+0xb/0x120
>     Call Trace:
>      [<ffffffff81039633>] ? __x2apic_send_IPI_mask+0x73/0x160
>      [<ffffffff8103973e>] x2apic_send_IPI_all+0x1e/0x20
>      [<ffffffff8103498c>] arch_trigger_all_cpu_backtrace+0x6c/0xb0
>      [<ffffffff81501be4>] ? _raw_spin_lock_irqsave+0x34/0x50
>      [<ffffffff8131654e>] sysrq_handle_showallcpus+0xe/0x10
>      [<ffffffff8131616d>] __handle_sysrq+0x7d/0x140
>      [<ffffffff81316230>] ? __handle_sysrq+0x140/0x140
>      [<ffffffff81316287>] write_sysrq_trigger+0x57/0x60
>      [<ffffffff811ca996>] proc_reg_write+0x86/0xc0
>      [<ffffffff8116dd8e>] vfs_write+0xce/0x190
>      [<ffffffff8116e3e5>] sys_write+0x55/0x90
>      [<ffffffff8150a242>] system_call_fastpath+0x16/0x1b
> 
> That's because apic points to apic_x2apic_cluster or apic_x2apic_phys
> but the basic element like cpumask isn't initialized.

That's of course a bug on its own, fixing of which would go under
a suitable subject/title.

> -v2: Mask x2APIC feature in pvm to avoid overwrite of apic pointer,
>      update commit message per Konrad's suggestion.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Tested-by: Tamon Shiose <tamon.shiose@oracle.com>
> ---
>  arch/x86/xen/enlighten.c |    3 +++
>  include/linux/nmi.h      |    2 ++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index c8e1c7b..12b0718 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -386,6 +386,9 @@ static void __init xen_init_cpuid_mask(void)
>  		cpuid_leaf1_edx_mask &=
>  			~((1 << X86_FEATURE_APIC) |  /* disable local APIC */
>  			  (1 << X86_FEATURE_ACPI));  /* disable ACPI */
> +
> +	cpuid_leaf1_ecx_mask &= ~(1 << (X86_FEATURE_X2APIC % 32));
> +

Bottom line - while this part may be fine (under a different title), ...

>  	ax = 1;
>  	cx = 0;
>  	xen_cpuid(&ax, &bx, &cx, &dx);
> diff --git a/include/linux/nmi.h b/include/linux/nmi.h
> index db50840..b845757 100644
> --- a/include/linux/nmi.h
> +++ b/include/linux/nmi.h
> @@ -32,6 +32,8 @@ static inline void touch_nmi_watchdog(void)
>  #ifdef arch_trigger_all_cpu_backtrace
>  static inline bool trigger_all_cpu_backtrace(void)
>  {
> +	if (xen_domain())
> +		return false;

... this part clearly isn't.

Jan

>  	arch_trigger_all_cpu_backtrace();
>  
>  	return true;


