Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3IIKcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:32:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:22627 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3IIKcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:32:10 -0400
X-IronPort-AV: E=Sophos;i="4.90,866,1371081600"; 
   d="scan'208";a="49544493"
Message-ID: <522DA394.1020305@citrix.com>
Date: Mon, 9 Sep 2013 11:31:48 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefan.bader@canonical.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3/5] xen/smp: Update pv_lock_ops functions before alternative
 code starts under PVHVM
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com> <1378561605-18998-4-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1378561605-18998-4-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/13 14:46, Konrad Rzeszutek Wilk wrote:
> Before this patch we would patch all of the pv_lock_ops sites
> using alternative assembler. Then later in the bootup cycle
> change the unlock_kick and lock_spinning to the Xen specific -
> without re patching.
> 
> That meant that for the core of the kernel we would be running
> with the baremetal version of unlock_kick and lock_spinning while
> for modules we would have the proper Xen specific slowpaths.
> 
> As most of the module uses some API from the core kernel that ended
> up with slowpath lockers waiting forever to be kicked (b/c they
> would be using the Xen specific slowpath logic). And the
> kick never came b/c the unlock path that was taken was the
> baremetal one.
> 
> On PV we do not have the problem as we initialise before the
> alternative code kicks in.
> 
> The fix is to move the updating of the pv_lock_ops function
> before the alternative code starts patching.

This comment seems odd.  The xen_spinlock_init() call is added not moved.

> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -731,4 +731,12 @@ void __init xen_hvm_smp_init(void)
>  	smp_ops.cpu_die = xen_hvm_cpu_die;
>  	smp_ops.send_call_func_ipi = xen_smp_send_call_function_ipi;
>  	smp_ops.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi;
> +
> +	/*
> +	 * The alternative logic (which patches the unlock/lock) runs before
> +	 * the smp bootup up code is activated. That meant we would never patch
> +	 * the core of the kernel with proper paravirt interfaces but would patch
> +	 * modules.
> +	 */
> +	xen_init_spinlocks();

PV does this in xen_smp_prepare_boot_cpu.  It would be better if the
PVHVM case followed this same pattern and provide a smp_prepare_boot_cpu
implementation to do this?

David
