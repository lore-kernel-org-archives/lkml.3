Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbbAWS5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:57:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbbAWS5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:57:15 -0500
Date: Fri, 23 Jan 2015 19:57:11 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        Borislav Petkov <bp@suse.de>, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, paulmck@linux.vnet.ibm.com
Subject: Re: [Xen-devel] [RFC v4 1/2] x86/xen: add
	xen_is_preemptible_hypercall()
Message-ID: <20150123185711.GW17887@wotan.suse.de>
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com> <1421972951-3940-2-git-send-email-mcgrof@do-not-panic.com> <54C230C8.4000207@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C230C8.4000207@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 11:30:16AM +0000, David Vrabel wrote:
> On 23/01/15 00:29, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > On kernels with voluntary or no preemption we can run
> > into situations where a hypercall issued through userspace
> > will linger around as it addresses sub-operatiosn in kernel
> > context (multicalls). Such operations can trigger soft lockup
> > detection.
> > 
> > We want to address a way to let the kernel voluntarily preempt
> > such calls even on non preempt kernels, to address this we first
> > need to distinguish which hypercalls fall under this category.
> > This implements xen_is_preemptible_hypercall() which lets us do
> > just that by adding a secondary hypercall page, calls made via
> > the new page may be preempted.
> [...]
> > --- a/arch/x86/include/asm/xen/hypercall.h
> > +++ b/arch/x86/include/asm/xen/hypercall.h
> > @@ -84,6 +84,22 @@
> >  
> >  extern struct { char _entry[32]; } hypercall_page[];
> >  
> > +#ifndef CONFIG_PREEMPT
> > +extern struct { char _entry[32]; } preemptible_hypercall_page[];
> > +
> > +static inline bool xen_is_preemptible_hypercall(struct pt_regs *regs)
> > +{
> > +	return !user_mode_vm(regs) &&
> > +		regs->ip >= (unsigned long)preemptible_hypercall_page &&
> > +		regs->ip < (unsigned long)preemptible_hypercall_page + PAGE_SIZE;
> 
> I think you can optimize this to:
> 
>     return (regs->ip >> PAGE_SHIFT) == preemptible_hypercall_pfn

I take it you meant preemptible_hypercall_page ?

> 	&& !user_mode_vm(regs);

If so I don't see how this can work as an identical replacement.
Consider a PAGE_SIZE is 16, so PAGE_SHIFT would be 4, and lets
say we are checking for byte 2 which should be in the page:

; 0b0010 >>4
	0

Can you elaborate more on this, or can we perhaps leave such
optimization as an evolution to avoid regressions if you are
not 100% certain?

  Luis
