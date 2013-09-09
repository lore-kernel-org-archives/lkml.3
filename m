Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3IINLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:11:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36486 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3IINLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:11:24 -0400
Date: Mon, 9 Sep 2013 09:11:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        stefan.bader@canonical.com, stefano.stabellini@eu.citrix.com,
        jeremy@goop.org
Subject: Re: [PATCH 3/5] xen/smp: Update pv_lock_ops functions before
 alternative code starts under PVHVM
Message-ID: <20130909131109.GC21435@phenom.dumpdata.com>
References: <1378561605-18998-1-git-send-email-konrad.wilk@oracle.com>
 <1378561605-18998-4-git-send-email-konrad.wilk@oracle.com>
 <522DA394.1020305@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522DA394.1020305@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 11:31:48AM +0100, David Vrabel wrote:
> On 07/09/13 14:46, Konrad Rzeszutek Wilk wrote:
> > Before this patch we would patch all of the pv_lock_ops sites
> > using alternative assembler. Then later in the bootup cycle
> > change the unlock_kick and lock_spinning to the Xen specific -
> > without re patching.
> > 
> > That meant that for the core of the kernel we would be running
> > with the baremetal version of unlock_kick and lock_spinning while
> > for modules we would have the proper Xen specific slowpaths.
> > 
> > As most of the module uses some API from the core kernel that ended
> > up with slowpath lockers waiting forever to be kicked (b/c they
> > would be using the Xen specific slowpath logic). And the
> > kick never came b/c the unlock path that was taken was the
> > baremetal one.
> > 
> > On PV we do not have the problem as we initialise before the
> > alternative code kicks in.
> > 
> > The fix is to move the updating of the pv_lock_ops function
> > before the alternative code starts patching.
> 
> This comment seems odd.  The xen_spinlock_init() call is added not moved.

Ah, yes. The joy of rebasing and having the patches out of sync.
It was originally removed by git commit f10cd522c5fbfec9ae3cc01967868c9c2401ed23
(xen: disable PV spinlocks on HVM) which as part of the patch
series I had reverted. Then I dropped the revert :-)

> 
> > --- a/arch/x86/xen/smp.c
> > +++ b/arch/x86/xen/smp.c
> > @@ -731,4 +731,12 @@ void __init xen_hvm_smp_init(void)
> >  	smp_ops.cpu_die = xen_hvm_cpu_die;
> >  	smp_ops.send_call_func_ipi = xen_smp_send_call_function_ipi;
> >  	smp_ops.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi;
> > +
> > +	/*
> > +	 * The alternative logic (which patches the unlock/lock) runs before
> > +	 * the smp bootup up code is activated. That meant we would never patch
> > +	 * the core of the kernel with proper paravirt interfaces but would patch
> > +	 * modules.
> > +	 */
> > +	xen_init_spinlocks();
> 
> PV does this in xen_smp_prepare_boot_cpu.  It would be better if the
> PVHVM case followed this same pattern and provide a smp_prepare_boot_cpu
> implementation to do this?

Good eye. I can certainly try it out that way and see how it behaves. It would
make it more consistent.

> 
> David
