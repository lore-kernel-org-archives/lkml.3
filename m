Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab3C2Nqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:46:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33137 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab3C2Nqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:46:43 -0400
Date: Fri, 29 Mar 2013 09:46:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Feng Jin <joe.jin@oracle.com>, Tamon Shiose <tamon.shiose@oracle.com>
Subject: Re: [PATCH] xen: Don't call arch_trigger_all_cpu_backtrace in
 dom0(pvm)
Message-ID: <20130329134640.GG31356@phenom.dumpdata.com>
References: <5155413E.6090002@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5155413E.6090002@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 03:22:38PM +0800, Zhenzhong Duan wrote:
> nmi isn't supported in dom0, fallback to general all cpu backtrace code.
> 
> Without fix, on xapic system, sysrq+l, no backtrace is showed.
> On x2apic enabled system, got NULL pointer dereference as below.

Why would the x2APIC or xAPIC make a difference here? The Linux dom0
is not fiddling with the APIC - that is the hypervisor job.

Can you explain to me why x2apic_send_IPI_mask is even set? Wouldn't
the Xen version of send_IPI be present? (See xen_smp_ops)

Perhaps it is missing an over-write for the send_IPI_all?

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
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Tested-by: Tamon Shiose <tamon.shiose@oracle.com>
> ---
>  include/linux/nmi.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
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
>  	arch_trigger_all_cpu_backtrace();
>  
>  	return true;
> -- 
> 1.7.3
> 
