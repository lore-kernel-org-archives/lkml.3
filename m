Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaAFPEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:04:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16840 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaAFPEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:04:21 -0500
Date: Mon, 6 Jan 2014 10:03:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        hpa@zytor.com, Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v13 11/19] xen/pvh: Secondary VCPU bringup (non-bootup
 CPUs)
Message-ID: <20140106150313.GA15684@phenom.dumpdata.com>
References: <1388777916-1328-1-git-send-email-konrad.wilk@oracle.com>
 <1388777916-1328-12-git-send-email-konrad.wilk@oracle.com>
 <52CA8AF7.9040305@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CA8AF7.9040305@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 10:52:39AM +0000, David Vrabel wrote:
> On 03/01/14 19:38, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > The VCPU bringup protocol follows the PV with certain twists.
> > From xen/include/public/arch-x86/xen.h:
> > 
> > Also note that when calling DOMCTL_setvcpucontext and VCPU_initialise
> > for HVM and PVH guests, not all information in this structure is updated:
> > 
> >  - For HVM guests, the structures read include: fpu_ctxt (if
> >  VGCT_I387_VALID is set), flags, user_regs, debugreg[*]
> > 
> >  - PVH guests are the same as HVM guests, but additionally use ctrlreg[3] to
> >  set cr3. All other fields not used should be set to 0.
> > 
> > This is what we do. We piggyback on the 'xen_setup_gdt' - but modify
> > a bit - we need to call 'load_percpu_segment' so that 'switch_to_new_gdt'
> > can load per-cpu data-structures. It has no effect on the VCPU0.
> > 
> > We also piggyback on the %rdi register to pass in the CPU number - so
> > that when we bootup a new CPU, the cpu_bringup_and_idle will have
> > passed as the first parameter the CPU number (via %rdi for 64-bit).
> [...]
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -1409,14 +1409,19 @@ static void __init xen_boot_params_init_edd(void)
> >   * Set up the GDT and segment registers for -fstack-protector.  Until
> >   * we do this, we have to be careful not to call any stack-protected
> >   * function, which is most of the kernel.
> > + *
> > + * Note, that it is refok - because the only caller of this after init
> 
> "Note, this is __ref because..."

Fixed.

Thank you.
> 
> David
